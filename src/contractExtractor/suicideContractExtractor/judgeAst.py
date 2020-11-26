#!/usr/bin/pythin
#-*- coding: utf-8 -*-

import json
import os
from colorPrint import *	#该头文件中定义了色彩显示的信息
import re

#缓存路径
CACHE_PATH = "./cache/"
#注入所需信息存储路径
INJECT_INFO_PATH = "./injectInfo/"
#自毁语句键值
SUICIDE_KEY = "suicideStatement"
#身份验证键值
AUTH_KEY = "authStatement"
#元组flag
TUPLE_FLAG = "tuple()"
#自毁函数类型
SUICIDE_FUNC_TYPE = "function (address payable)"
#自毁函数名
SUICIDE_FUNC_NAME = "selfdestruct"
#外部可见性标志
EXTERNAL_FLAG = "external"
#公共可见性标志
PUBLIC_FLAG = "public"
#相等标志
EQUAL_FLAG = "=="
#布尔标志
BOOL_FLAG = "bool"
#成员访问标志
MEMBER_ACCESS_FLAG = "MemberAccess"
#msg.sender类型
MSG_SENDER_TYPE = "address payable"
#sender标志
SENDER_FLAG = "sender"
#msg标志
MSG_FLAG = "msg"
#还有tx.origin的
#origin标志
ORIGIN_FLAG = "origin"
#tx标志
TX_FLAG = "tx"
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

class judgeAst:
	def __init__(self, _json, _sourceCode, _filename):
		self.cacheContractPath = "./cache/temp.sol"
		self.cacheFolder = "./cache/"
		self.json =  _json
		self.filename = _filename
		self.sourceCode = _sourceCode

	def getSourceCode(self, _contractPath):
		try:
			with open(_contractPath, "r", encoding = "utf-8") as f:
				return f.read()
		except:
			raise Exception("Failed to read cache source code.")

	def run(self):
		#初始化注入信息存储列表
		injectInfo = dict()
		injectInfo[SUICIDE_KEY] = list()
		injectInfo[AUTH_KEY] = list()
		#1. 寻找目标语句-自毁语句
		suicideStateList = list()
		for func in self.findASTNode(self.json, "name", "FunctionCall"):
			if func["attributes"]["type"] == TUPLE_FLAG:
				calledFunc = func["children"][0]	#被调用的函数
				#处理异常情况
				if calledFunc["attributes"].get("referencedDeclaration") == None:
					continue
				if calledFunc["attributes"]["referencedDeclaration"] < 0 and calledFunc["attributes"]["type"] == SUICIDE_FUNC_TYPE and calledFunc["attributes"]["value"] == SUICIDE_FUNC_NAME:
					#找到selfdestruct语句
					suicideStateList.append(func)
		#2. 寻找外部可以直接调用的函数
		funcList = list()
		for func in self.findASTNode(self.json, "name", "FunctionDefinition"):
			if func["attributes"]["visibility"] == EXTERNAL_FLAG or func["attributes"]["visibility"] == PUBLIC_FLAG:
				funcList.append(func)
		#3.　挑选在外部可见函数中的自毁语句和函数
		#3.1　过滤一下
		if len(suicideStateList) == 0 or len(funcList) == 0:
			return False
		targetSuicideList, targetFuncList = self.findTarget(suicideStateList, funcList)
		#4. 可以先行记录自毁语句的位置
		for state in targetSuicideList:
			sPos, ePos = self.srcToPos(state["src"])
			injectInfo[SUICIDE_KEY].append([sPos, ePos])
		#5. 然后逐个搜索函数，增补函数使用的修改器到目标函数列表中
		targetModifierList = list()
		for func in targetFuncList:
			#此时的func是ast形式
			usedModifierIdList = [item["children"][0]["attributes"]["referencedDeclaration"] for item in self.findASTNode(func, "name", "ModifierInvocation")]
			if not usedModifierIdList:
				continue
			else:
				#根据id找到修改器
				for _id in usedModifierIdList:
					targetModifierList.append(self.findASTNode(self.json, "id", _id)[0])
		#6. 进入到函数及修改器中，寻找身份验证语句(根据slither的做法，将msg.sender认定为身份验证标志)
		#我扩展一下，将对msg.sender或tx.origin进行相等检验的语句认定为身份验证语句-把BinaryOperation中的部分换成true
		#就可以报废了身份验证语句
		#slither这个方法并不好，造成大量漏报，考虑增补，将所有的require和assert语句都替换
		injectInfo[AUTH_KEY].extend(self.getAuthStateSrc(targetFuncList))
		injectInfo[AUTH_KEY].extend(self.getAuthStateSrc(targetModifierList))
		#[bug fix and feature enhance] 增加对require和assert语句的捕捉
		#targetFuncList和targetModifierList是ast的list
		for ast in targetFuncList:
			injectInfo[AUTH_KEY].extend(self.getRequireStatement(ast))
			injectInfo[AUTH_KEY].extend(self.getAssertStatement(ast))
		for ast in targetModifierList:
			injectInfo[AUTH_KEY].extend(self.getRequireStatement(ast))
			injectInfo[AUTH_KEY].extend(self.getAssertStatement(ast))
		#7. 存储信息
		if not injectInfo[SUICIDE_KEY]:
			#没有包含自毁语句，返回false
			return False
		else:
			self.storeInjectInfo(injectInfo)
			return True

	def getAssertStatement(self, _ast):
		funcCall = self.findASTNode(_ast, "name", "FunctionCall")
		srcList = list()	#assert语句中BinaryOperation的源代码位置
		for call in funcCall:
			if call["attributes"]["type"] == TUPLE_FLAG:
				children0 = call["children"][0]	#children[0]是运算符
				children1 = call["children"][1]	#children[1]是第一个参数－也只有一个
				if children0["attributes"]["type"] == REQUIRE_FUNC_TYPE_FLAG and \
				   children0["attributes"]["value"] == ASSERT_FLAG:
				   	sPos, ePos = self.srcToPos(children1["src"])
				   	srcList.append([sPos, ePos])
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
				   children0["attributes"]["value"] == REQUIRE_FLAG:
				   	sPos, ePos = self.srcToPos(children1["src"])
				   	srcList.append([sPos, ePos])
				else:
					continue
			else:
				continue
		return srcList

	def getAuthStateSrc(self, _astList):
		srcList = list()
		for func in _astList:
			for ope in self.findASTNode(func, "name", "BinaryOperation"):
				#首先确定符号
				if ope["attributes"]["operator"] == EQUAL_FLAG and ope["attributes"]["type"] == BOOL_FLAG:
					#获取参与比较运算的参数
					eleList = ope["children"]
					if len(eleList) != 2:
						continue
					else:
						#如果任一一个元素是msg.sender就记录BinaryOperation的位置
						for ele in eleList:
							#这是对msg.sender的
							if ele["name"] == MEMBER_ACCESS_FLAG and ele["attributes"]["type"] == MSG_SENDER_TYPE and ele["attributes"]["member_name"] == SENDER_FLAG and ele["attributes"]["referencedDeclaration"] == None:
								#通过属性校验
								msgEle = ele["children"][0]
								if msgEle["attributes"]["referencedDeclaration"] < 0 and msgEle["attributes"]["type"] == MSG_FLAG and msgEle["attributes"]["value"] == MSG_FLAG:
									#找到msg.sender
									sPos, ePos = self.srcToPos(ope["src"])	#加入的是整个BinaryOperation的src位置
									srcList.append([sPos, ePos])
								else:
									continue
							#这是对tx.origin
							elif ele["name"] == MEMBER_ACCESS_FLAG and ele["attributes"]["type"] == MSG_SENDER_TYPE and ele["attributes"]["member_name"] == ORIGIN_FLAG and ele["attributes"]["referencedDeclaration"] == None:
								#通过属性校验
								txEle = ele["children"][0]
								if txEle["attributes"]["referencedDeclaration"] < 0 and txEle["attributes"]["type"] == TX_FLAG and txEle["attributes"]["value"] == TX_FLAG:
									#找到tx.origin
									sPos, ePos = self.srcToPos(ope["src"])
									srcList.append([sPos, ePos])
								else:
									continue
							else:
								continue
		return srcList


	#如果存在包含自毁语句的外部函数，那么就返回他们
	#待完成－已经完成
	def findTarget(self, _suicideList, _funcList):
		targetSuicideList = list()
		targetFuncList = list()
		for suicideState in _suicideList:
			stateSPos, stateEPos = self.srcToPos(suicideState["src"])
			for funcState in _funcList:
				funcSPos, funcEPos = self.srcToPos(funcState["src"])
				if stateSPos > funcSPos and stateEPos < funcEPos:
					#找到包含关系
					targetSuicideList.append(suicideState)
					targetFuncList.append(funcState)
					break
				else:
					continue
		return targetSuicideList, targetFuncList


	def storeInjectInfo(self, _injectInfo):
		try:
			#在这一步完成去重
			tempList = list()
			for item in _injectInfo[SUICIDE_KEY]:
				if item not in tempList:
					tempList.append(item)
			_injectInfo[SUICIDE_KEY] = tempList
			tempList1  = list()
			for item in _injectInfo[AUTH_KEY]:
				if item not in tempList1:
					tempList1.append(item)
			_injectInfo[AUTH_KEY] = tempList1
			#_injectInfo[AUTH_KEY] = list(set(_injectInfo[AUTH_KEY]))			
			#保存信息
			with open(os.path.join(INJECT_INFO_PATH, self.filename.split(".")[0] + ".json"), "w", encoding = "utf-8") as f:
				json.dump(_injectInfo, f, indent = 1)
			#print("%s %s %s" % (info, self.filename + " target injected information...saved", end))
		except:
			#print("%s %s %s" % (bad, self.filename + " target injected information...failed", end))
			pass

	def srcToPos(self, _src):
		temp = _src.split(":")
		return int(temp[0]), int(temp[0]) + int(temp[1])


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