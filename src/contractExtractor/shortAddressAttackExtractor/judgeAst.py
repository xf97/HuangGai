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
#外部可见性标志
EXTERNAL_FLAG = "external"
#公共可见性标志
PUBLIC_FLAG = "public"
#transfer标志
TRANSFER_FLAG = "transfer"
#transfer函数类型
TRANSFER_TYPE_FLAG = "function (uint256)"
#send标志
SEND_FLAG = "send"
#send函数类型
SEND_TYPE_FLAG = "function (uint256) returns (bool)"
#UINT256标志
UINT256_FLAG = "uint256"
#收款地址标志
ADDRESS_PAYABLE_FLAG = "address payable"
#value标志
VALUE_FLAG = "value"
#call标志
CALL_FLAG = "call"
#value函数类型
VALUE_TYPE_FLAG = "function (uint256) pure returns (function (bytes memory) payable returns (bool,bytes memory))"


class judgeAst:
	def __init__(self, _json, _sourceCode, _filename):
		self.cacheContractPath = "./cache/temp.sol"
		self.cacheFolder = "./cache/"
		self.json =  _json
		self.filename = _filename
		self.sourceCode = _sourceCode

	def run(self):
		injectInfo = dict()	#存储注入信息的字典
		#1. 获取所有的public/external函数
		funcAstList = list()
		for func in self.findASTNode(self.json, "name", "FunctionDefinition"):
			if func["attributes"]["visibility"] == EXTERNAL_FLAG or func["attributes"]["visibility"] == PUBLIC_FLAG:
				funcAstList.append(func)
		modifierIdList = list()
		for modifier in self.findASTNode(self.json, "name", "ModifierDefinition"):
			modifierIdList.append(modifier["id"])
		#2. 在这些函数中寻找transfer/send/call.value语句
		etherOutList = list()
		for func in funcAstList:
			'''
			statementList的每个元素结构如下-[收款地址的id, 转账数量的id, 语句起始位置，语句终结位置]
			'''
			statementList = list()
			accessStatement = self.findASTNode(func, "name", "MemberAccess")
			statementList.extend(self.getStatement_transfer(accessStatement))	
			statementList.extend(self.getStatement_send(accessStatement))
			statementList.extend(self.getStatement_callValue(accessStatement))
			#注意，在solidity 0.5.0之后，所有接收转账的地址都必须是address payable
			#3. 针对每条语句，确认收款地址和付款数量都由外部的参数给定
			addressPayableIdList = list(set([item[0] for item in statementList]))
			uintIdList = list(set([item[1] for item in statementList]))
			paraList = self.findASTNode(func, "name", "ParameterList")
			#3.1 获取所有目标类型参数的id
			paraIdList = list()
			for paras in paraList:
				try:
					for para in paras["children"]:
						if para["attributes"]["type"] == UINT256_FLAG or para["attributes"]["type"] == ADDRESS_PAYABLE_FLAG:
							#记录参数中的address payable和uint256型参数的id
							paraIdList.append(para["id"])
						else:
							continue
				except:
					continue
			#3.2 获取本函数内的require和assert语句
			funcSourceCode = self.sourceCode[self.srcToPos(func["src"])[0]: self.srcToPos(func["src"])[1]]
			requireAndAssertList = self.getRequireOrAssert(funcSourceCode)
			#3.3 再捕获本函数使用的所有修改器和本函数源代码中的require和assert语句
			usedModifierAstList = list()
			usedModifierAstList = self.getModifier(func, modifierIdList)
			#根据使用过的函数修改器ast，获得修改器的源代码
			modifierCodeList = self.getModifierCode(usedModifierAstList)
			#再根据修改器源代码，捕获其中使用的require或者assert语句
			for modifierCode in modifierCodeList:
				requireAndAssertList.extend(self.getRequireOrAssert(modifierCode))
			#3.4 判断所有使用过的require和assert语句中，是否存在对msg.data.length的校验
			#如果，则不注入此合约
			injectFlag = True
			msgDataLengthPattern = re.compile(r"(msg)(\s)*(\.)(\s)*(data)(\s)*(\.)(\s)*(length)")
			for statement in requireAndAssertList:
				if msgDataLengthPattern.search(statement):
					#存在校验语句，不注入
					injectFlag = False
				else:
					continue
			if not injectFlag:
				#已经校验过msg.data.length，则放弃对本函数中所有语句的考察结果
				continue
			#3.5 检查每条语句，确认每条语句的id都由外部给定
			for state in statementList:
				if state[0] in paraIdList and state[1] in paraIdList:
					#3.6 记录目标语句，键值是语句的起始位置
					injectInfo[state[2]] = state
		#4. 存储注入信息
		if not injectInfo:
			#print("mei de han shu.")
			return False
		else:
			self.storeInjectInfo(injectInfo)
			return True

	#根据源码和src位置，返回源代码列表
	def getModifierCode(self, _astList):
		codeList = list()
		for ast in _astList:
			sPos, ePos = self.srcToPos(ast["src"])
			codeList.append(self.sourceCode[sPos: ePos])
		#保险起见，记得去重
		codeList = list(set(codeList))
		return codeList

	def getModifier(self, _funcAst, _idList):
		astList = list()
		for _id in _idList:
			if self.findASTNode(_funcAst, "referencedDeclaration", _id):
				#如果本函数使用了某个修改器，那么将这个修改器的ast加入结果
				astList.append(self.findASTNode(self.json, "id", _id)[0])
			else:
				#否则本函数没有使用这个修改器，继续检索
				continue
		return astList

	#从函数源代码中截取require和assert语句
	def getRequireOrAssert(self, _funcSourceCode):
		#1. 捕获所有的assert和require语句
		#1.1 清洗函数源代码中的注释部分
		funcSourceCode = self.cleanComment(_funcSourceCode)
		#1.2 在sourceCode中捕捉require和assert语句
		#通过查看ast，获知无法通过ast来准确快速地获取整句require或assert语句，故采用正则表达式
		requirePattern = re.compile(r"require(\()(.)+?(\))(\s)*(;)")	#可能会有换行，采用非贪婪模式匹配
		assertPattern = re.compile(r"assert(\()(.)+?(\))(\s)*(;)")
		requireAndAssertList = list()
		for item in requirePattern.finditer(funcSourceCode):
			requireAndAssertList.append(item.group())
		for item in assertPattern.finditer(funcSourceCode):
			requireAndAssertList.append(item.group())
		#1.3 最后判断，两个操作数是否在require或者assert语句中检查过
		#如果检查过，返回true; 如果没有，返回false
		return requireAndAssertList

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

	def getCorrFuncCallAst(self, _startPos, _endPos):
		funcCallList = self.findASTNode(self.json, "name", "FunctionCall")
		for call in funcCallList:
			sPos = self.srcToPos(call["src"])[0]
			if sPos == _startPos:
				#找到包含该语句的函数调用语句
				return call
			else:
				continue
		#正常情况下不应该执行到这里，引发异常
		raise Exception("Failed to find the corresponding function call statement.")

	def getCorrFuncCallAst_byId(self, _id):
		return self.findASTNode(self.json, "id", _id + 2)[0]

	#补足常量，适配代码
	def getStatement_transfer(self, _astList):
		result = list()
		for _ast in _astList:
			try:
				if _ast["attributes"]["member_name"] == TRANSFER_FLAG and _ast["attributes"]["referencedDeclaration"] == None \
				   and _ast["attributes"]["type"] == TRANSFER_TYPE_FLAG:
					if _ast["children"][0]["attributes"]["type"] == ADDRESS_PAYABLE_FLAG:
						#找到在memberAccess语句中找到使用.transfer语句
						addressPayableId = _ast["children"][0]["attributes"]["referencedDeclaration"]
						startPos, endPos = self.srcToPos(_ast["src"])
						#uintId = self.getCorrFuncCallAst(startPos, endPos)["children"][1]["attributes"]["referencedDeclaration"]
						uintId = self.getCorrFuncCallAst_byId(_ast["id"])["children"][1]["attributes"]["referencedDeclaration"]
						result.append([addressPayableId, uintId, startPos, endPos])
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
				if _ast["attributes"]["member_name"] == SEND_FLAG and _ast["attributes"]["referencedDeclaration"] == None \
				   and _ast["attributes"]["type"] == SEND_TYPE_FLAG:
					if _ast["children"][0]["attributes"]["type"] == ADDRESS_PAYABLE_FLAG:
						#找到在memberAccess语句中找到使用.send语句
						addressPayableId = _ast["children"][0]["attributes"]["referencedDeclaration"]
						startPos, endPos = self.srcToPos(_ast["src"])
						#uintId = self.getCorrFuncCallAst(startPos, endPos)["children"][1]["attributes"]["referencedDeclaration"]
						uintId = self.getCorrFuncCallAst_byId(_ast["id"])["children"][1]["attributes"]["referencedDeclaration"]
						result.append([addressPayableId, uintId, startPos, endPos])
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
				if _ast["attributes"]["member_name"] == VALUE_FLAG and _ast["attributes"]["referencedDeclaration"] == None \
				   and _ast["attributes"]["type"] == VALUE_TYPE_FLAG:
					member = _ast["children"][0]
					if member["attributes"]["member_name"] == CALL_FLAG and member["attributes"]["referencedDeclaration"] == None:
						addressMember = member["children"][0]
						if addressMember["attributes"]["type"] == ADDRESS_PAYABLE_FLAG:
							#找到在memberAccess语句中找到使用.call.value语句
							addressPayableId = addressMember["attributes"]["referencedDeclaration"]
							startPos, endPos = self.srcToPos(_ast["src"])
							#uintId = self.getCorrFuncCallAst(startPos, endPos)["children"][1]
							uintId = self.getCorrFuncCallAst_byId(_ast["id"])["children"][1]["attributes"]["referencedDeclaration"]
							result.append([addressPayableId, uintId, startPos, endPos])
						else:
							continue
					else:
						continue
				else:
					continue
			except:
				continue
		return result

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