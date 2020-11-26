#!/usr/bin/pythin
#-*- coding: utf-8 -*-

'''
思路，进到每一个构造函数中，找每一个给地址类型赋值的语句(还有变量声明语句)，确定这个地址型变量是哪一个(以id标识)
然后再去合约中找是否有msg.sender == 这样地址型变量的情况
如果有，返回真，并且记录msg.sender位置
'''

import json
import os
from colorPrint import *	#该头文件中定义了色彩显示的信息
import re
import subprocess


#缓存路径
CACHE_PATH = "./cache/"
#注入所需信息存储路径
INJECT_INFO_PATH = "./injectInfo/"
#构造函数标识
CONSTRUCOR_FLAG = "constructor"
#地址标志
ADDRESS_FLAG = "address"
#赋值符号
EQU_FLAG = "="
#元组标志
TUPLE_FLAG = "tuple()"
#require和assert函数类型标志
REQUIRE_FUNC_TYPE_FLAG = "function (bool) pure"
#require的另一种形式 的定义
REQUIRE_FUNC_STRING_TYPE_FLAG = "function (bool,string memory) pure"
#require标志
REQUIRE_FLAG = "require"
#assert标志
ASSERT_FLAG = "assert"
#二进制运算标志
BINARY_OPERATION_FLAG = "BinaryOperation"
#布尔类型标志
BOOL_FLAG = "bool"
#require或者assert参数类型
COMMON_TYPE_STRING = "address"
#不是赋值，是相等标志
EQU_EQU_FLAG = "=="


class judgeAst:
	def __init__(self, _json, _sourceCode, _filename):
		self.cacheContractPath = "./cache/temp.sol"
		self.cacheFolder = "./cache/"
		self.json =  _json
		self.filename = _filename
		self.sourceCode = _sourceCode

	def run(self):
		#1. 获得合约中构造函数的信息
		constructorList = list()	#构造函数AST列表
		for func in self.findASTNode(self.json, "name", "FunctionDefinition"):
			if func["attributes"]["kind"] == CONSTRUCOR_FLAG:
				constructorList.append(func)
		#2. 从每个构造函数中提取给地址型赋值语句
		idList = list()	#目标地址型变量id
		for cons in constructorList:
			#对赋值语句
			for state in self.findASTNode(cons, "name", "Assignment"):
				if state["attributes"]["type"] == ADDRESS_FLAG and state["attributes"]["operator"] == EQU_FLAG:
					#state的children[0]是接收赋值的类型
				    addressVar = state["children"][0]
				    idList.append(addressVar["attributes"]["referencedDeclaration"])
				else:
				 	continue
			#对变量声明语句
			#[策略改变]-在构造函数中声明的本地变量并不能在其他函数中使用-失去意义
			'''
			for state in self.findASTNode(cons, "name", "VariableDeclarationStatement"):
				if state["children"][0]["attributes"]["type"] == ADDRESS_FLAG:
					#声明并赋值的变量是address类型
					addressVar = state["children"][0]
					idList.append(addressVar["id"])
				else:
					continue
			'''
		#3. 进入合约中寻找目标语句
		#msg.sender == id词
		#找到require和assert语句
		msgSenderDict = dict()	#目标语句信息
		msgSenderPattern = re.compile(r"(\b)(msg)(\s)*(\.)(\s)*(sender)(\b)")
		requireAssertList = list()
		for ast in self.getRequireStatement(self.json):
			requireAssertList.append(ast)
		for ast in self.getAssertStatement(self.json):
			requireAssertList.append(ast)
		#3.1 在每个require和assert语句中，找到每一个BinaryOperation(对地址的比较操作在AST中显示为binaryOperation)
		for ast in requireAssertList:
			binaryOpe = list()
			for operation in self.findASTNode(ast, "name", "BinaryOperation"):
				#进行一个筛选
				attr = operation["attributes"]
				try:
					if attr["operator"] == EQU_EQU_FLAG and attr["commonType"]["typeString"] == ADDRESS_FLAG and attr["type"] == BOOL_FLAG:
						#只要我们目标的binaryOperation
						binaryOpe.append(operation)
					else:
						continue
				except:
					continue
			for ope in binaryOpe:
				#获得这个二进制操作的两个元素
				_1stEle = operation["children"][0]
				_2ndEle = operation["children"][1]
				#获取id和字段信息
				infoDict = dict()
				infoDict[self.sourceCode[self.srcToPos(_1stEle["src"])[0]: self.srcToPos(_1stEle["src"])[1]]] = _1stEle["attributes"]["referencedDeclaration"]
				infoDict[self.sourceCode[self.srcToPos(_2ndEle["src"])[0]: self.srcToPos(_2ndEle["src"])[1]]] = _2ndEle["attributes"]["referencedDeclaration"]
				#判断信息
				if (list(infoDict.values())[0] in idList or list(infoDict.values())[1] in idList) and (list(infoDict.values())[0] == None or list(infoDict.values())[1] == None):
					if msgSenderPattern.search(list(infoDict.keys())[0]) != None or  msgSenderPattern.search(list(infoDict.keys())[1]) != None:
						#找到了我们想要的东西
						#记录源代码位置
						msgSender = _1stEle if _1stEle["attributes"]["referencedDeclaration"] ==  None else _2ndEle
						sPos, ePos  = self.srcToPos(msgSender["src"])
						msgSenderDict[sPos] = [sPos, ePos] 
		#4. 保存注入信息
		if msgSenderDict:
			self.storeInjectInfo(msgSenderDict)
			return True
		else:
			return False
	
	def judgeIdList(self, _idList, _ast):
		msgSenderFlag, idFlag = False, False
		for operation in self.findASTNode(_ast, "name", "BinaryOperation"):
			attr = operation["attributes"]
			if attr["operator"] == EQU_EQU_FLAG and attr["commonType"]["typeString"] == ADDRESS_FLAG and attr["type"] == BOOL_FLAG:
				#在左右两个判别相等的元素中，确定是否是msg.sender或者是我们要的地址型
				referendId = list()
				_1stEle = operation["children"][0]
				_2ndEle = operation["children"][1]
				self.judgeElement(_1stEle, msgSenderFlag, idFlag)
				self.judgeElement(_2ndEle, msgSenderFlag, idFlag)
				if msgSenderFlag and idFlag:
					return True
				else:
					msgSenderFlag, idFlag = False, False  #如果一个式子不满足，就清空前序数据
			else:
				continue
		return False

	def getAssertStatement(self, _ast):
		funcCall = self.findASTNode(_ast, "name", "FunctionCall")
		astList = list()
		for call in funcCall:
			if call["attributes"]["type"] == TUPLE_FLAG:
				children0 = call["children"][0]	#children[0]是运算符
				children1 = call["children"][1]	#children[1]是参与比较的第一个数
				if children0["attributes"]["type"] == REQUIRE_FUNC_TYPE_FLAG and \
				   children0["attributes"]["value"] == ASSERT_FLAG and \
				   children1["name"] == BINARY_OPERATION_FLAG and \
				   children1["attributes"]["type"] == BOOL_FLAG and \
				   children1["attributes"]["commonType"]["typeString"] == COMMON_TYPE_STRING:
				   #找到assert语句
				   astList.append(call)
				else:
					continue
			else:
				continue
		return astList

	def getRequireStatement(self, _ast):
		funcCall = self.findASTNode(_ast, "name", "FunctionCall")
		astList = list()
		for call in funcCall:
			if call["attributes"]["type"] == TUPLE_FLAG:
				children0 = call["children"][0]
				children1 = call["children"][1]
				if (children0["attributes"]["type"] == REQUIRE_FUNC_TYPE_FLAG or \
					children0["attributes"]["type"] == REQUIRE_FUNC_STRING_TYPE_FLAG) and \
				   children0["attributes"]["value"] == REQUIRE_FLAG and \
				   children1["name"] == BINARY_OPERATION_FLAG and \
				   children1["attributes"]["type"] == BOOL_FLAG and \
				   children1["attributes"]["commonType"]["typeString"] == COMMON_TYPE_STRING:
				   #找到require语句
				   astList.append(call)
				else:
					continue
			else:
				continue
		return astList

	def cleanComment(self, _code):
		#使用正则表达式捕捉单行和多行注释
		singleLinePattern = re.compile(r"(//)(.)+")	#提前编译，以提高速度
		multipleLinePattern = re.compile(r"(/\*)(.)+?(\*/)")
		#记录注释的下标
		indexList = list()
		for item in singleLinePattern.finditer(_code):
			indexList.append(item.span())
		for item in multipleLinePattern.finditer(_code, re.S):
			#多行注释，要允许多行匹配
			indexList.append(item.span())
		#拼接新结果
		startIndedx = 0
		newCode = str()
		for item in indexList:
			newCode += _code[startIndedx: item[0]]	#不包括item[0]
			startIndedx = item[1] + 1 #加一的目的是不覆盖前序的尾巴
		newCode += _code[startIndedx:]
		return newCode

	def storeInjectInfo(self, _injectInfo):
		try:
			#保存信息
			with open(os.path.join(INJECT_INFO_PATH, self.filename.split(".")[0] + ".json"), "w", encoding = "utf-8") as f:
				json.dump(_injectInfo, f, indent = 1)
			#print("%s %s %s" % (info, self.filename + " target injected information...saved", end))
		except:
			#print("%s %s %s" % (bad, self.filename + " target injected information...failed", end))
			pass

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

	#传入：657:17:0
	#传出：657, 674
	def srcToPos(self, _src):
		temp = _src.split(":")
		return int(temp[0]), int(temp[0]) + int(temp[1])