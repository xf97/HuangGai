#!/usr/bin/python
#-*- coding: utf-8 -*-

'''
该部分程序通过解析合约编译产生的json_ast文件，
来判断合约是否满足以下三个标准:
#hiding
'''

'''
关键问题：合约继承怎么处理
通过观察合约编译产生的jsonAst(eg., testCase/testInherance.sol)发现
编译后的jsonAst文件并不会将基类的代码体现在子类的编译结果中，因此当需要考虑
如果子类合约中不包含我们需要确定的语句，但基类中却包含怎么办
更进一步想，如果靠近子类的不带有需求语句的基类合约覆盖了带有需求语句的
基类合约那该如何处理？　
'''

'''
哪些东西会被继承？或者说，可以被子类使用的基类资源是哪些？
non-private资源，那么我们仅考虑搜查以下两类资源：
1.　状态变量
2.　函数定义(FunctionDefinition)
'''

'''
如果在一群继承合约中，存在一个“孤立”的合约（即，不参与继承的合约）；或在一个文件中存在多路互相独立的继承流，如何处理？
将继承基类合约最多的子类合约作为主合约
'''

'''
如何区分多态函数？
使用函数签名－即FunctionSelector区分函数
但后返回的合约中的同FunctionSelector函数中没有需求语句，但先返回的合约中的同FunctionSelector函数中有时
不计入统计
'''

#WARNING
'''
部分函数有“函数选择器”值，但部分函数没有，这些函数之间并没有明显地差异，这令人费解?
稳妥的解决方法，用命令"solc --hashes myContract.sol -o ."
'''

'''
裁剪原代码
'''

#缓存路径
CACHE_PATH = "./cache/"
#注入所需信息存储路径
INJECT_INFO_PATH = "./injectInfo/"
#签名文件后缀
SIG_SUFFIX = ".signatures"
#布尔真值常量
BOOL_TRUE_STR = True
#公共可见性常量
PUBLIC_FLAG = "public"
#外部可见性常量
EXTERNAL_FLAG = "external"
#内部可见性函数标志
INNER_FUNC_FLAG = "innerFunc"
#构造函数标志
CONSTRUCTOR_FLAG = "constructor"
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
#替换为真值flag
BOOL_TRUE_FLAG = 0
#该标志指明在这个位置插入标记bug的语句
INJECTED_FLAG = 1
#规定转出金额为所有钱
ALL_MONEY_FLAG = 2
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

#[bug fix to improve precision]
TRANSFER_ALL_MONEY_FLAG = 3

import json
import os
from colorPrint import *	#该头文件中定义了色彩显示的信息
import re


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
		#1. 拿到可见性为public或external的函数
		funcList = list()
		for func in self.findASTNode(self.json, "name", "FunctionDefinition"):
			if func["attributes"]["visibility"] == PUBLIC_FLAG or func["attributes"]["visibility"] == EXTERNAL_FLAG:
				#找到外部可以调用的函数
				if func["attributes"]["kind"] == CONSTRUCTOR_FLAG:
					#不要构造函数
					continue
				else:
					returnValue = func["children"][1] #获取返回值列表
					if len(returnValue["children"]) != 0:
						#print(func["attributes"]["name"], len(returnValue["children"]))
						continue	#不要有返回值的函数
					funcList.append(func)	#加入的是ast
		#2. 然后进入到每个函数中，查看其中是否有转出钱的语句
		srcList = list()	#该列表记录需要被屏蔽或替换的源代码位置
		targetFuncList = list()
		for funcAst in funcList:
			tempSrcList = list()
			#2.1. 加入transfer语句的位置
			tempSrcList.extend(self.getStatement_transfer(self.findASTNode(funcAst, "name", "MemberAccess")))
			#2.2. 加入send语句的位置
			tempSrcList.extend(self.getStatement_send(self.findASTNode(funcAst, "name", "MemberAccess")))
			#2.3. 加入call.value语句的位置
			tempSrcList.extend(self.getStatement_callValue(self.findASTNode(funcAst, "name", "MemberAccess")))
			#2.4. 加入自毁语句的位置
			for func in self.findASTNode(funcAst, "name", "FunctionCall"):
				if func["attributes"]["type"] == TUPLE_FLAG:
					calledFunc = func["children"][0]	#被调用的函数
					#处理异常情况
					if calledFunc["attributes"].get("referencedDeclaration") == None:
						continue
					if calledFunc["attributes"]["referencedDeclaration"] < 0 and calledFunc["attributes"]["type"] == SUICIDE_FUNC_TYPE and calledFunc["attributes"]["value"] == SUICIDE_FUNC_NAME:
						#找到selfdestruct语句
						sPos, ePos = self.srcToPos(func["src"])
						while self.sourceCode[ePos] != "\n":
							ePos += 1
						tempSrcList.append([ePos, ePos, INJECTED_FLAG])
			#3. 如果该函数能够向外部发送以太币
			if tempSrcList:
				#记录有价值的目标函数
				targetFuncList.append(funcAst)
				#找到函数中所有“可能阻止转账”的语句　
				#require和assert语句是最典型的　
				srcList.extend(self.getRequireStatement(funcAst))
				srcList.extend(self.getAssertStatement(funcAst))
				#然后在函数尾部，插入注入语句
				#一个函数只能有一个代码块吧
				funcsPos, funcePos = self.srcToPos(funcAst["src"])
				srcList.append([funcePos - 1, funcePos - 1, TRANSFER_ALL_MONEY_FLAG])
				while self.sourceCode[funcePos] != "\n":
					funcePos += 1
				srcList.append([funcePos, funcePos, INJECTED_FLAG])
			else:
				continue
		if not srcList:
			#至少要有一个函数内要有转出钱的语句
			return False
		#然后再增加函数修改器
		#增补，修改器值得注意
		#然后逐个搜索函数，增补函数使用的修改器到目标函数列表中
		modifierList = list()
		for func in targetFuncList:
			#此时的func是ast形式
			usedModifierIdList = [item["children"][0]["attributes"]["referencedDeclaration"] for item in self.findASTNode(func, "name", "ModifierInvocation")]
			if not usedModifierIdList:
				continue
			else:
				#根据id找到修改器
				for _id in usedModifierIdList:
					modifierList.append(self.findASTNode(self.json, "id", _id)[0])
		#print(modifierList)
		#3. 函数修改器也看一下
		for funcAst in modifierList:
			srcList.extend(self.getRequireStatement(funcAst))
			srcList.extend(self.getAssertStatement(funcAst))
		#最后再增补一下非require和assert的身份验证语句
		#造成误判，不使用该语句
		#去重
		srcList = self.removeDuplicate(srcList)
		#４. 存储信息
		if not srcList:
			#没有包含自毁语句，返回false
			return False
		else:
			self.storeInjectInfo(srcList)
			return True

	def removeDuplicate(self, _list):
		result = list()
		for item in _list:
			if item not in result:
				result.append(item)
			else:
				continue
		return result

	#返回assert语句中的条件值部分
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
				   	srcList.append([sPos, ePos, BOOL_TRUE_FLAG])
				else:
					continue
			else:
				continue
		#print(srcList, "****")
		return srcList

	#返回require语句中的条件值部分
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
				   	srcList.append([sPos, ePos, BOOL_TRUE_FLAG])
				else:
					continue
			else:
				continue
		return srcList


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
							result.append([startPos, endPos, ALL_MONEY_FLAG])
							#再加入换行那里的标记位置
							while self.sourceCode[endPos] != "\n":
								endPos += 1
							result.append([endPos, endPos, INJECTED_FLAG])
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
							result.append([startPos, endPos, ALL_MONEY_FLAG])
							#再加入换行那里的标记位置
							while self.sourceCode[endPos] != "\n":
								endPos += 1
							result.append([endPos, endPos, INJECTED_FLAG])
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
								result.append([startPos, endPos, ALL_MONEY_FLAG])
								#再加入换行那里的标记位置
								while self.sourceCode[endPos] != "\n":
									endPos += 1
								result.append([endPos, endPos, INJECTED_FLAG])
						else:
							continue
					else:
						continue
				else:
					continue
			except:
				continue
		return result


	def getFuncSourceCode(self, _ast, _funcList):
		try:
			startPos, endPos = self.srcToPos(_ast["src"])
			for func in _funcList:
				sPos, ePos = self.srcToPos(func["src"])
				if sPos < startPos and ePos > endPos:
					return self.sourceCode[sPos: ePos]
				else:
					continue
		except:
			raise Exception("The function containing the assignment statement could not be found.")

	def storeInjectInfo(self, _srcList):
		try:
			resultDict = dict()
			resultDict["srcList"] = _srcList
			#保存信息
			with open(os.path.join(INJECT_INFO_PATH, self.filename.split(".")[0] + ".json"), "w", encoding = "utf-8") as f:
				json.dump(resultDict, f, indent = 1)
			#print("%s %s %s" % (info, self.filename + " target injected information...saved", end))
		except:
			#print("%s %s %s" % (bad, self.filename + " target injected information...failed", end))
			pass
			#raise Exception()

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