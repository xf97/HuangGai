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
#字典键值
SRC_KEY = "srcPosAndStr"
#函数类型标志
FUNCTION_FLAG = r"(function)(\s)+(\()"
#赋值标志
ASSIGNMENT_FLAG = "="
#插入语句的前缀
INJECT_STATE_PREFIX = "\n\tassembly { mstore("
#插入语句的中缀
INJECT_STATE_MID = ", add(mload("
#插入语句的后缀
INJECT_STATE_SUFFIX = "), callvalue)) }"
#直接把插入语句的标志
INJECT_FLAG = "\t//inject SPECIFY FUNC VAR AS ANY TYPE\n"
#赋值语句的标志
ASSIGNMENT_STATE_FLAG = "Assignment"
#变量声明语句的标志
VARIABLE_DECLARATION_STATE_FLAG = "VariableDeclarationStatement"

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
		injectInfo = dict()
		injectInfo[SRC_KEY] = list()
		#以下正则表达式用来捕获函数型变量
		functionPattern = re.compile(FUNCTION_FLAG)
		#1. 捕捉所有的变量声明、初始化和变量赋值语句
		targetStateAstList = list()
		for assignment in self.findASTNode(self.json, "name", "Assignment"):
			if assignment["attributes"]["operator"] == ASSIGNMENT_FLAG and functionPattern.search(assignment["attributes"]["type"]):
				targetStateAstList.append(assignment)
			else:
				continue
		#不要状态变量！
		for varDeclarationState in self.findASTNode(self.json, "name", "VariableDeclarationStatement"):
			#拿到被初始化的变量
			var = varDeclarationState["children"][0]
			#判断是不是函数类型
			if functionPattern.search(var["attributes"]["type"]):
				targetStateAstList.append(varDeclarationState)
			else:
				continue
		#2. 截取出每个被赋值的变量的源代码，以及找到合适的插入位置
		for state in targetStateAstList:
			#先拼接语句
			#首先获得函数变量的名字
			#不同类型语句分开处理
			if state["name"] == ASSIGNMENT_STATE_FLAG:
				#获得被赋值的实体
				var = state["children"][0]
				varName = var["children"][0]["attributes"]["value"] #self.findASTNode(self.json, "id", assign2Id)[0]["attributes"]["name"]
			elif state["name"] == VARIABLE_DECLARATION_STATE_FLAG:
				varName = state["children"][0]["attributes"]["name"]
			#然后构造语句
			injectState = INJECT_STATE_PREFIX + varName + INJECT_STATE_MID + varName + INJECT_STATE_SUFFIX + INJECT_FLAG
			#然后找到插入的位置，应该在语句结束之后
			(sPos, endPos) = self.srcToPos(state["src"])
			#向后寻找分号的位置
			while self.sourceCode[endPos] != ";":
				endPos += 1
			#越过分号
			endPos += 1
			#记录位置
			injectInfo[SRC_KEY].append([endPos, endPos, injectState])
		#3. 存储结果
		if injectInfo[SRC_KEY]:
			self.storeInjectInfo(injectInfo)
			return True
		else:
			return False

	def getSourceCode(self, _ast):
		#获得源代码位置
		sPos, ePos = self.srcToPos(_ast["src"])
		return self.sourceCode[sPos: ePos]


	def storeInjectInfo(self, _srcList):
		try:
			#保存信息
			with open(os.path.join(INJECT_INFO_PATH, self.filename.split(".")[0] + ".json"), "w", encoding = "utf-8") as f:
				json.dump(_srcList, f, indent = 1)
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