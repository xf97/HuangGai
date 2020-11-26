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
#公共可见性标志
PUBLIC_FLAG = "public"
#外部可见性标志
EXTERNAL_FLAG = "external"
#数组模式
ARRAY_PATTERN = r"(\[)(\d)*(\])"
#bytes32标志
BYTES32_FLAG = "bytes32"
#插入语句前缀
INSERT_STATE_PREFIX = " = keccak256(abi.encodePacked("
#插入语句后缀
INSERT_STATE_SUFFIX = "))"
#结构体标志
STRUCT_FLAG = "struct "

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
		#1. 捕捉所有public/external函数
		targetFuncAstList = list()
		for func in self.findASTNode(self.json, "name", "FunctionDefinition"):
			#精确要求－函数需要实现
			if func["attributes"]["visibility"] == PUBLIC_FLAG or func["attributes"]["visibility"] == EXTERNAL_FLAG:
				if func["attributes"]["implemented"] == True:
					#找到目标
					targetFuncAstList.append(func)
		#2. 查看这些函数是否包含多个array型参数
		#该正则表达式用来匹配数组类型
		arrayRe = re.compile(ARRAY_PATTERN)
		#以下列表的每个元素存储的信息是－函数ast，参数中数组的名字列表
		funcAndItsParaList = list()
		for func in targetFuncAstList:
			#获取参数列表
			paraList = func["children"][0]
			arrayNum = 0
			arrayNameList = list()
			#进入到每一个参数考察其类型
			for para in paraList["children"]:
				#[bug fix 2020/11/12] 不要用户自定义的类型数组
				if arrayRe.search(para["attributes"]["type"]) and para["attributes"]["type"].find(STRUCT_FLAG) == -1:
					#是数组，记录
					arrayNum += 1
					arrayNameList.append(para["attributes"]["name"])
				else:
					continue
			#如果有大于等于两个数组，那么记录
			if arrayNum >= 2:
				funcAndItsParaList.append([func, arrayNameList])
		#3. 然后进入到有外部给定数组参数的函数中，找对bytes32型变量的赋值语句
		#以下变量的每个元素的数据结构如下－开始位置，结束位置，插入的语句
		finalResultList = list()	#该变量保存最终结果
		for item in funcAndItsParaList:
			func = item[0]
			block = self.findASTNode(func, "name", "Block")[0]	#获得函数块
			#进入函数块中找对bytes32型变量的赋值语句
			for assignment in self.findASTNode(block, "name", "Assignment"):
				if assignment["attributes"]["type"] == BYTES32_FLAG:
					#找到赋值，构造插入语句
					#先确定插入位置
					sPos, ePos = self.getAssignmentPos(assignment)
					#然后构建插入语句
					insertState = INSERT_STATE_PREFIX + ", ".join(item[1]) + INSERT_STATE_SUFFIX
					#然后存储元素
					finalResultList.append([sPos, ePos, insertState])
				else:
					continue
		#要考虑增补变量声明语句
		for item in funcAndItsParaList:
			func = item[0]
			block = self.findASTNode(func, "name", "Block")[0]
			#进入函数块中找到对bytes32型变量的变量声明语句
			for varDeclaState in self.findASTNode(block, "name", "VariableDeclarationStatement"):
				try:
					#找到被声明的变量
					var = varDeclaState["children"][0]	#被赋值变量
					if var["attributes"]["type"] == BYTES32_FLAG:
						#找到赋值，构造插入语句
						#先确定插入位置
						sPos, ePos = self.getVarDeclaStatePos(varDeclaState)
						#然后构建插入语句
						insertState = INSERT_STATE_PREFIX + ", ".join(item[1]) + INSERT_STATE_SUFFIX
						#然后存储元素
						finalResultList.append([sPos, ePos, insertState])
					else:
						continue
				except Exception as e:
					#print(e)
					continue
		#print(finalResultList)
		#4. 然后存储结果
		injectInfo[SRC_KEY] = finalResultList
		#print(injectInfo[SRC_KEY])
		if injectInfo[SRC_KEY]:
			#非空就保存
			self.storeInjectInfo(injectInfo)
			return True
		else:
			return False

	def getVarDeclaStatePos(self, _declaAst):
		#1. 获取被赋值的变量，多变量不管
		if len(_declaAst["attributes"]["assignments"]) >= 2:
			raise Exception("Returns the tuple type.")
		varId = _declaAst["attributes"]["assignments"][0]
		#先得到它的源代码语句的位置
		stateSpos, stateEpos = self.srcToPos(_declaAst["src"])
		#然后去找赋值语句之后的位置
		varAst = self.findASTNode(self.json, "id", varId)[0]
		varSpos, varEpos = self.srcToPos(varAst["src"])
		return varEpos, stateEpos

	def getAssignmentPos(self, _assignAst):
		stateSpos, stateEpos = self.srcToPos(_assignAst["src"])
		varSpos, varEpos = self.srcToPos(_assignAst["children"][0]["src"])
		return varEpos, stateEpos


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