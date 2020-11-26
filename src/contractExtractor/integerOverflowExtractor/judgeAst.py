#!/usr/bin/pythin
#-*- coding: utf-8 -*-

import json
import os
from colorPrint import *	#该头文件中定义了色彩显示的信息
from dataDependency import dataDependency #该文件将产生一个由外部传参(public或external函数参数)影响的本次变量的id列表
import re

#缓存路径
CACHE_PATH = "./cache/"
#注入所需信息存储路径
INJECT_INFO_PATH = "./injectInfo/"
#等于符号
EQU_FLAG = "="
#uint256标志
UINT256_FLAG = "uint256"
#SafeMath标志
SAFEMATH_FLAG = "SAFEMATH"
#库类型标志
LIBRARY_FLAG = "library"
#add函数名标志
ADD_STR_FLAG = "add"
#sub函数名标志
SUB_STR_FLAG = "sub"

class judgeAst:
	def __init__(self, _json, _sourceCode, _filename):
		self.cacheContractPath = "./cache/temp.sol"
		self.cacheFolder = "./cache/"
		self.json =  _json
		self.filename = _filename
		self.DD = dataDependency(self.cacheContractPath, self.json)
		self.sourceCode = _sourceCode

	def getSourceCode(self, _contractPath):
		try:
			with open(_contractPath, "r", encoding = "utf-8") as f:
				return f.read()
		except:
			raise Exception("Failed to read cache source code.")

	def run(self):
		assignmentAst = self.findASTNode(self.json, "name", "Assignment")
		funcAstList = self.findASTNode(self.json, "name", "FunctionDefinition")
		weNeedAst = list()
		safeMathFuncIdList = self.getSafeMath()
		useIdList = list()
		if len(safeMathFuncIdList) == 0:
			#没有使用safemath, 不通过筛选
			return False
		for ast in assignmentAst:
			try:
				if ast["attributes"]["operator"] == EQU_FLAG and ast["attributes"]["type"] == UINT256_FLAG:
					children0 = ast["children"][0]
					children1 = ast["children"][1]
					if children0["attributes"]["type"] != UINT256_FLAG or children1["attributes"]["type"] != UINT256_FLAG:
						continue
					else:
						subChildren0 = children1["children"][0]
						subChildren1 = children1["children"][1]
						if subChildren1["attributes"]["type"] == UINT256_FLAG and subChildren0["attributes"]["referencedDeclaration"] in safeMathFuncIdList:
							#找到了使用safemath的add/sub进行操作的，三个操作数都是uint256的ast
							_id = subChildren1["attributes"]["referencedDeclaration"]
							if _id in self.DD.getIdList():
								funcSourceCode = self.getFuncSourceCode(ast, funcAstList)
								assignmentSourceCode = self.sourceCode[self.srcToPos(ast["src"])[0]: self.srcToPos(ast["src"])[1]]
								if self.varInRequireOrAssert(assignmentSourceCode, funcSourceCode):
									#此函数用于判断赋值语句的双方是否在本函数中被“过分”地检查过，，没有的话，才认定为被注入
									useIdList.append(subChildren0["attributes"]["referencedDeclaration"])
									weNeedAst.append(ast)
							else:
								continue
						else:
							continue
				else:
					continue
			except Exception as e:
				#print(e)
				continue
		if len(weNeedAst) > 0:
			#存储注入bug时需要的信息
			self.storeInjectInfo(weNeedAst, useIdList)
			return True
		else:
			return False

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


	#给定赋值语句，和函数源代码
	#首先从函数源代码中截取require和assert语句
	#然后通过截取赋值语句中接收数据的变量
	#再去require和assert语句中查找接收数据的变量是否存在
	#如果存在，就返回false; 不存在，就返回true
	def varInRequireOrAssert(self, _assignmentState, _funcSourceCode):
		#指定正则表达式，以捕获目标语句
		#1. 捕获safemath的两个操作数
		sumNum = _assignmentState.split("=")[0].strip()	#接收结果的字符串
		addendPattern = re.compile(r"(\.)add(\s)*(\()(.)+?(\))")
		subendPattern = re.compile(r"(\.)sub(\s)*(\()(.)+?(\))")
		operand = str()
		if ADD_STR_FLAG in _assignmentState:
			operand = addendPattern.search(_assignmentState).group()
		elif SUB_STR_FLAG in _assignmentState:
			operand = subendPattern.search(_assignmentState).group()
		#切分字符串，以获取操作数
		operand = operand.split("(", 1)[1]
		operand = operand.rsplit(")", 1)[0]	#从后向前切分
		#2. 捕获所有的assert和require语句
		#2.1 清洗函数源代码中的注释部分
		funcSourceCode = self.cleanComment(_funcSourceCode)
		#2.2 在sourceCode中捕捉require和assert语句
		#通过查看ast，获知无法通过ast来准确快速地获取整句require或assert语句，故采用正则表达式
		requirePattern = re.compile(r"require(\()(.)+?(\))(\s)*(;)")	#可能会有换行，采用非贪婪模式匹配
		assertPattern = re.compile(r"assert(\()(.)+?(\))(\s)*(;)")
		requireAndAssertList = list()
		for item in requirePattern.finditer(funcSourceCode):
			requireAndAssertList.append(item.group())
		for item in assertPattern.finditer(funcSourceCode):
			requireAndAssertList.append(item.group())
		#3. 最后判断，两个操作数是否在require或者assert语句中检查过
		#如果检查过，返回true; 如果没有，返回false
		for statement in requireAndAssertList:
			if sumNum in statement and operand in statement:
				return False
			else:
				continue
		return True

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

	#该函数用于判断给定的assignment的ast中的一个参数有外部给定
	#未使用
	def aNumProvideByExter(self, _ast):
		if not _ast:
			return False
		return True

	def storeInjectInfo(self, _astList, _idList):
		try:
			srcList = list()
			for ast in _astList:
				srcList.append(self.srcToPos(ast["src"]))
			#去重
			srcList	= list(set(srcList))
			idList = list(set(_idList))
			resultDict = dict()
			resultDict["idList"] = idList
			resultDict["srcList"] = srcList
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


	def getSafeMath(self):
		safeMathAst = dict()
		for ast in self.findASTNode(self.json, "name", "ContractDefinition"):
			if ast["attributes"]["name"].upper() == SAFEMATH_FLAG and ast["attributes"]["contractKind"] == LIBRARY_FLAG:
				safeMathAst = ast
				break
			else:
				continue
		subId = list()
		if len(safeMathAst.keys()) == 0:
			return list()
		#用id来指明函数调用
		for func in self.findASTNode(safeMathAst, "name", "FunctionDefinition"):
			if func["attributes"]["name"].lower() == SUB_STR_FLAG or func["attributes"]["name"].lower() == ADD_STR_FLAG:
				subId.append(func["id"])
			else:
				continue
		return subId

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