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
COMMON_TYPE_STRING = "uint256"
#函数调用标志
FUNC_CALL_FLAG = "FunctionCall"


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
		for state in self.getRequireStatement(self.json):
			conditionState = state["children"][1]
			newList = list()
			newList.append(self.srcToPos(state["src"]))
			newList.extend(self.srcToPos(conditionState["src"]))
			statementList.append(newList)
		for state in self.getAssertStatement(self.json):
			conditionState = state["children"][1]
			newList = list()
			newList.append(self.srcToPos(state["src"]))
			newList.extend(self.srcToPos(conditionState["src"]))
			statementList.append(newList)
		#2.2 过滤一下，如果有两个语句存在嵌套，那么只返回小的
		statementList = self.stateFilter(statementList)
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
			self.storeInjectInfo(injectInfo)
			return True

	def stateFilter(self, _stateList):
		result = list()
		temp = _stateList[:]	#使用副本防止出现问题
		for state in temp:
			#应该是，你包含其他语句，就不要你
			flag = False
			for item in _stateList:
				if state[1] < item[1] and state[2] > item[2]:
					#state被item包含（等于不会被捕捉）
					flag = True
					break
				else:
					continue
			if not flag:
				#你没有包含任何语句，就要你
				result.append(state)
			else:
				#否则就不要你
				continue
		return result

	def getAssertStatement(self, _ast):
		funcCall = self.findASTNode(_ast, "name", "FunctionCall")
		srcList = list()
		for call in funcCall:
			if call["attributes"]["type"] == TUPLE_FLAG:
				children0 = call["children"][0]
				children1 = call["children"][1]
				if children0["attributes"]["type"] == REQUIRE_FUNC_TYPE_FLAG and \
				   children0["attributes"]["value"] == ASSERT_FLAG and \
				   children1["name"] == FUNC_CALL_FLAG and \
				   children1["attributes"]["type"] == BOOL_FLAG:
				   #找到require语句
				   srcList.append(call)
				else:
					continue
			else:
				continue
		return srcList

	def getRequireStatement(self, _ast):
		funcCall = self.findASTNode(_ast, "name", "FunctionCall")
		srcList = list()
		for call in funcCall:
			if call["attributes"]["type"] == TUPLE_FLAG:
				children0 = call["children"][0]
				children1 = call["children"][1]
				if (children0["attributes"]["type"] == REQUIRE_FUNC_TYPE_FLAG or \
					children0["attributes"]["type"] == REQUIRE_FUNC_STRING_TYPE_FLAG) and \
				   children0["attributes"]["value"] == REQUIRE_FLAG and \
				   children1["name"] == FUNC_CALL_FLAG and \
				   children1["attributes"]["type"] == BOOL_FLAG:
				   #然后尝试增加抽取语句
				   #找到require语句
				   srcList.append(call)
				else:
					continue
			else:
				continue
		return srcList

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