#!/usr/bin/pythin
#-*- coding: utf-8 -*-

import json
import os
from colorPrint import *	#该头文件中定义了色彩显示的信息
import re
import subprocess

#缓存路径
CACHE_PATH = "./cache/"
#注入所需信息存储路径
INJECT_INFO_PATH = "./injectInfo/"
#send标志
SEND_FLAG = "send"
#send函数类型
SEND_TYPE_FLAG = "function (uint256) returns (bool)"
#value标志
VALUE_FLAG = "value"
#call标志
CALL_FLAG = "call"
#call函数类型
CALL_TYPE_FLAG = "function (bytes memory) payable returns (bool,bytes memory)"
#delegatecall标志
DELEGATECALL_FLAG = "delegatecall"
#delegatecall函数类型
DELEGATECALL_TYPE_FLAG = "function (bytes memory) returns (bool,bytes memory)"


class judgeAst:
	def __init__(self, _json, _sourceCode, _filename):
		self.cacheContractPath = "./cache/temp.sol"
		self.cacheFolder = "./cache/"
		self.json =  _json
		self.filename = _filename
		self.sourceCode = _sourceCode

	def run(self):
		#1. 找到所有的低级调用语句，记录的信息是它们的源代码位置
		lowCallList = list()
		lowCallList.extend(self.getSendStatement())
		lowCallList.extend(self.getCallStatement())
		lowCallList.extend(self.getDelegatecallStatement())
		#如果没有使用低级调用语句，返回false
		if len(lowCallList) == 0:
			return False
		#2. 记录所有可能包含低级调用的语句类型和位置
		#每个元素的类型是[语句类型，开始位置，终止位置]
		statementList = list()
		for state in self.findASTNode(self.json, "name", "ExpressionStatement"):
			newList = list()
			newList.append("ExpressionStatement")
			newList.extend(self.srcToPos(state["src"]))
			statementList.append(newList)
		for state in self.findASTNode(self.json, "name", "Assignment"):
			newList = list()
			newList.append("Assignment")
			newList.extend(self.srcToPos(state["src"]))
			statementList.append(newList)
		for state in self.findASTNode(self.json, "name", "VariableDeclarationStatement"):
			newList = list()
			newList.append("VariableDeclarationStatement")
			newList.extend(self.srcToPos(state["src"]))
			statementList.append(newList)	
		for state in self.findASTNode(self.json, "name", "IfStatement"):
			conditionState = state["children"][0]	#条件语句
			newList = list()
			newList.append(self.srcToPos(state["src"]))
			newList.extend(self.srcToPos(conditionState["src"]))
			statementList.append(newList)	
		#3. 记录这些语句的信息，包括源代码位置（位置应该记录的是包含调用的语句的src）、属于什么类型的语句
		injectInfo = dict()
		for lowCall in lowCallList:
			for state in statementList:
				if lowCall[0] >= state[1] and lowCall[1] <= state[2]:
					#低级调用语句被包含在其中，构造键值
					#记录的位置应该是state的位置
					temp = state[:]
					temp.append(lowCall[2])
					injectInfo[state[1]] = temp 
				else:
					continue
		#4. 存储信息，返回结果
		if not injectInfo:
			return False
		else:
			#print(injectInfo)
			self.storeInjectInfo(injectInfo)
			return True

	def getSendStatement(self):
		sendList = list()
		for ast in self.findASTNode(self.json, "name", "MemberAccess"):
			if ast["attributes"]["member_name"] == SEND_FLAG and \
			   ast["attributes"]["referencedDeclaration"] == None and \
			   ast["attributes"]["type"] == SEND_TYPE_FLAG:	
			   #找到了send语句，记录位置
			   temp = list(self.srcToPos(ast["src"]))
			   temp.append(SEND_FLAG)
			   sendList.append(temp)
			   #sendList.append(SEND_FLAG)
			else:
				continue
		return sendList

	def getCallStatement(self):
		callList = list()
		for ast in self.findASTNode(self.json, "name", "MemberAccess"):
			if ast["attributes"]["member_name"] == CALL_FLAG and \
			   ast["attributes"]["referencedDeclaration"] == None and \
			   ast["attributes"]["type"] == CALL_TYPE_FLAG:	
			   #找到了send语句，记录位置
			   temp = list(self.srcToPos(ast["src"]))
			   temp.append(CALL_FLAG)
			   callList.append(temp)
			else:
				continue
		return callList

	def getDelegatecallStatement(self):
		delegatecallList = list()
		for ast in self.findASTNode(self.json, "name", "MemberAccess"):
			if ast["attributes"]["member_name"] == DELEGATECALL_FLAG and \
			   ast["attributes"]["referencedDeclaration"] == None and \
			   ast["attributes"]["type"] == DELEGATECALL_TYPE_FLAG:	
			   #找到了send语句，记录位置
			   temp = list(self.srcToPos(ast["src"]))
			   temp.append(DELEGATECALL_FLAG)
			   delegatecallList.append(temp)
			else:
				continue
		return delegatecallList

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
			print("%s %s %s" % (info, self.filename + " target injected information...saved", end))
		except:
			print("%s %s %s" % (bad, self.filename + " target injected information...failed", end))

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