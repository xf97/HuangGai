#!/usr/bin/python
#-*- coding: utf-8 -*-

'''
该部分程序用于判断目标合约是否包含转钱出去的语句
'''

'''
可用工具：slither真是个宝藏工具
slither可能可用的功能：
合约各个函数的调用图
文件中各个合约的继承关系
最子类合约的构造函数执行结果
function-summary里有每个函数读写、内外部调用的总结
human-summary里有对每个合约功能的概述->可以用来判断->不能用来判断，对于Receive ETH而言，只判断payable关键字而不判断合约是否真的可以接收以太币
require显示出每个合约的每个函数中用到的require和assert
最子类合约状态变量的内存情况　
对状态变量的写入及对应的auth操作
'''
import subprocess
import os
from inherGraph import inherGraph #该库用于返回主合约的合约名
from colorPrint import *	#该头文件中定义了色彩显示的信息
from pydot import io 	#该头文件用来读取.dot文件
import re
import json

#缓存路径
#进行抽取时，合约仍然存于cache文件夹中
CACHE_PATH = "./cache/"
#transfer标志
TRANSFER_FLAG = "transfer"
#send标志
SEND_FLAG = "send"
#收款地址标志
ADDRESS_PAYABLE_FLAG = "address payable"
#value标志
VALUE_FLAG = "value"
#call标志
CALL_FLAG = "call"
#元组标志
TUPLE_FLAG = "tuple()"
#自毁函数类型
SUICIDE_FUNC_TYPE = "function (address payable)"
#自毁函数名
SUICIDE_FUNC_NAME = "selfdestruct"
#使用注释符号进行无效化
COMMENT_FLAG = 0
#使用矛盾语句进行无效化
INVALID_FLAG = 1
#规定转出金额为0进行无效化
ZERO_FLAG = 2

'''
新无效化方法
transfer/send/call.value语句通过替换转出金额为0来构造bug
selfdestruct语句通过注释
探究下
transfer属于FuntionCall，children[0]就是msg.sender.transfer
'''

class judgePath:
	def __init__(self, _contractPath, _json, _filename):
		self.filename = _filename	#被处理的合约文件名
		self.contractPath = _contractPath
		self.json = _json

	def run(self):
		#不使用重入的－不符合需求
		#直接找到所有的转出以太币语句的src位置
		srcList = list()
		#1. 加入transfer语句的位置
		srcList.extend(self.getStatement_transfer(self.findASTNode(self.json, "name", "MemberAccess")))
		#2. 加入send语句的位置
		srcList.extend(self.getStatement_send(self.findASTNode(self.json, "name", "MemberAccess")))
		#3. 加入call.value语句的位置
		srcList.extend(self.getStatement_callValue(self.findASTNode(self.json, "name", "MemberAccess")))
		#4. 加入自毁语句的位置
		for func in self.findASTNode(self.json, "name", "FunctionCall"):
			if func["attributes"]["type"] == TUPLE_FLAG:
				calledFunc = func["children"][0]	#被调用的函数
				#处理异常情况
				if calledFunc["attributes"].get("referencedDeclaration") == None:
					continue
				if calledFunc["attributes"]["referencedDeclaration"] < 0 and calledFunc["attributes"]["type"] == SUICIDE_FUNC_TYPE and calledFunc["attributes"]["value"] == SUICIDE_FUNC_NAME:
					#找到selfdestruct语句
					sPos, ePos = self.srcToPos(func["src"])
					srcList.append([sPos, ePos, COMMENT_FLAG])
		if not srcList[0]:
			#没有找到转出以太币的语句
			return False, list()
		else:
			return True,srcList

	#通过给定的ast，返回转账数额的位置
	def getAmount(self, _ast):
		for call in self.findASTNode(self.json, "name", "FunctionCall"):
			if call["children"][0] == _ast:
				#金额在这里
				amountAst = call["children"][1]
				return self.srcToPos(amountAst["src"])
			else:
				continue
		return -1, -1


	#根据给定的开始和结束位置，返回包含这一部分的语句
	def getStatement(self, _startPos, _endPos):
		statementPattern = re.compile(r"Statement")
		srcList = list()
		#该findASTNode返回所有属性值符合statementPattern模式的元素
		for ast in self.findASTNodeByRegex(self.json, "name", statementPattern):
			#拿到开始和结束位置
			sPos, ePos = self.srcToPos(ast["src"])
			srcList.append([sPos, ePos])
		#然后排序
		srcList.sort(key = lambda x:x[0] ,reverse = True)	#根据起始位置，从高到低
		#然后找到最内层包含语句的语句
		for item in srcList:
			if item[0] <= _startPos and item[1] >= _endPos:
				return item
			else:
				continue
		#如果没找到，返回-1
		return [-1, -1]

	'''
	最终决定不用type作为判断依据，因为不同版本的Solidity这几个函数的type是不同的（会导致我们的可用性范围收窄）
	'''
	def getStatement_transfer(self, _astList):
		result = list()
		for _ast in _astList:
			try:
				if _ast["attributes"]["member_name"] == TRANSFER_FLAG and _ast["attributes"]["referencedDeclaration"] == None:
					if _ast["children"][0]["attributes"]["type"] == ADDRESS_PAYABLE_FLAG:
						#找到在memberAccess语句中找到使用.transfer语句
						#找到该语句的转账金额
						#startPos, endPos = self.srcToPos(_ast["src"])
						#找到转账金额的常量位置
						startPos, endPos = self.getAmount(_ast)
						#print(startPos, endPos)
						if startPos != -1 and endPos != -1:
							result.append([startPos, endPos, ZERO_FLAG])
					else:
						continue
				else:
					continue
			except:
				continue
		return result

	def getStatement_send(self, _astList):		
		result = list()
		for _ast in _astList:
			try:
				if _ast["attributes"]["member_name"] == SEND_FLAG and _ast["attributes"]["referencedDeclaration"] == None:
					if _ast["children"][0]["attributes"]["type"] == ADDRESS_PAYABLE_FLAG:
						#找到在memberAccess语句中找到使用.send语句
						startPos, endPos = self.srcToPos(_ast["src"])
						#然后找到最小的包含语句
						#startPos, endPos = self.getStatement(startPos, endPos)
						#找到转账金额的常量位置
						startPos, endPos = self.getAmount(_ast)
						#print(startPos, endPos)
						if startPos != -1 and endPos != -1:
							result.append([startPos, endPos, ZERO_FLAG])
					else:
						continue
				else:
					continue
			except:
				continue
		return result

	def getStatement_callValue(self, _astList):
		result = list()
		for _ast in _astList:
			try:
				if _ast["attributes"]["member_name"] == VALUE_FLAG and _ast["attributes"]["referencedDeclaration"] == None:
					member = _ast["children"][0]
					if member["attributes"]["member_name"] == CALL_FLAG and member["attributes"]["referencedDeclaration"] == None:
						addressMember = member["children"][0]
						if addressMember["attributes"]["type"] == ADDRESS_PAYABLE_FLAG:
							#找到在memberAccess语句中找到使用.call.value语句
							startPos, endPos = self.srcToPos(_ast["src"])
							#然后找到最小的包含语句
							#startPos, endPos = self.getStatement(startPos, endPos)
							#找到转账金额的常量位置
							startPos, endPos = self.getAmount(_ast)
							#print(startPos, endPos)
							if startPos != -1 and endPos != -1:
								result.append([startPos, endPos, ZERO_FLAG])
						else:
							continue
					else:
						continue
				else:
					continue
			except:
				continue
		return result


	#在给定的ast中返回包含键值对"_name": "_value"的字典列表
	def findASTNode(self, _ast, _name, _value):
		queue = [_ast]
		result = list()
		literalList = list()
		while len(queue) > 0:
			data = queue.pop()
			for key in data:
				if key == _name and  data[key] == _value:
					result.append(data)
				elif type(data[key]) == dict:
					queue.append(data[key])
				elif type(data[key]) == list:
					for item in data[key]:
						if type(item) == dict:
							queue.append(item)
		return result

	#self.findASTNode的value，根据regex的版本
	def findASTNodeByRegex(self, _ast, _name, _pattern):
		queue = [_ast]
		result = list()
		literalList = list()
		while len(queue) > 0:
			data = queue.pop()
			for key in data:
				if key == _name and  _pattern.search(str(data[key])):
					result.append(data)
				elif type(data[key]) == dict:
					queue.append(data[key])
				elif type(data[key]) == list:
					for item in data[key]:
						if type(item) == dict:
							queue.append(item)
		return result

	#传入：657:17:0
	#传出：657, 674
	def srcToPos(self, _src):
		temp = _src.split(":")
		return int(temp[0]), int(temp[0]) + int(temp[1])


		
