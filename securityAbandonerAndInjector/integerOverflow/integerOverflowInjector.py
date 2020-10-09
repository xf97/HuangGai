#!/usr/bin/python
#-*- coding: utf-8 -*-

import json
import copy
import os

#标记语句
LABEL_STATEMENT = "line_number: "
#合约结果命名后缀
INJECTED_CONTRACT_SUFFIX = "_integerOverflow.sol"
#标记文件命名后缀
INJECTED_INFO_SUFFIX = "_integerOverflowInfo.txt"
#结果保存路径
DATASET_PATH = "./dataset/"
#元组标志
TUPLE_FLAG = "tuple()"
#require和assert函数类型标志
REQUIRE_FUNC_TYPE_FLAG = "function (bool) pure"
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
#注释字符串
COMMENT_FLAG = "//"
#插入标记字符串
INJECTED_FLAG = "\t//injected INTEGER OVERFLOW OR UNDERFLOW\n"

class integerOverflowInjector:
	def __init__(self, _contractPath, _infoPath, _astPath, _originalContractName):
		self.contractPath = _contractPath
		self.infoPath = _infoPath
		self.info = self.getInfoJson(self.infoPath)
		self.sourceCode = self.getSourceCode(self.contractPath)
		self.ast = self.getJsonAst(_astPath)
		self.preName = _originalContractName
		try:
			os.mkdir(DATASET_PATH)
		except:
			print("The dataset folder already exists.")

	def getJsonAst(self, _astPath):
		with open(_astPath, "r", encoding = "utf-8") as f:
			temp = json.loads(f.read())
		return temp


	def getInfoJson(self, _path):
		with open(_path, "r", encoding = "utf-8") as f:
			temp = json.loads(f.read())
		return temp

	def getSourceCode(self, _path):
		try:
			with open(_path, "r", encoding = "utf-8") as f:
				return f.read()
		except:
			raise Exception("Failed to get source code when injecting.")
			return str()

	def inject(self):
		#下述数据结构保存不同字符串和对应插入位置的关系
		#字典，Key插入位置，元素值插入语句
		srcAndItsStr = dict()
		#1. 根据self.info和self.ast找出指定函数中的目标require和assert语句
		for funcId in self.info["idList"]:
			funcAstList = self.findASTNode(self.ast, "id", funcId)
			for func in funcAstList:
				srcList = self.getRequireStatement(func)
				print(srcList)
				srcList.extend(self.getAssertStatement(func))
				print(srcList)
				if not srcList:
					#如果函数中没有require和assert语句，很奇怪，异常情况
					#保守起见，不注入这一个
					return False
				for src in srcList:
					srcAndItsStr[src[0]] = COMMENT_FLAG
		#2.根据找到的整数运算语句位置，标记整数溢出bug
		for src in self.info["srcList"]:
			#注意，这里的src是语句的结束位置，而不是该语句结束的分号位置，为了能够准确地标记bug，那么应该寻找分号位置
			endPos = src[1]
			while self.sourceCode[endPos] != ";":
				endPos += 1
			#再加一个，指向分号后一个
			endPos += 1
			#记录位置
			srcAndItsStr[endPos] = INJECTED_FLAG
		#3. 然后，在self.sourceCode中插入语句
		newSourceCode, newInjectInfo = self.insertStatement(srcAndItsStr)
		#4. 输出并保存结果，然后产生自动标记
		self.storeFinalResult(newSourceCode, self.preName)
		#print(newSourceCode)
		self.storeLabel(newSourceCode, newInjectInfo.keys(), self.preName)
		return True

	def storeFinalResult(self, _sourceCode, _preName):
		with open(os.path.join(DATASET_PATH, _preName + INJECTED_CONTRACT_SUFFIX), "w+",  encoding = "utf-8") as f:
			f.write(_sourceCode)
		return
	
	def storeLabel(self, _sourceCode, _indexList, _preName):
		lineBreak = "\n"
		labelLineList = list()
		for index in _indexList:
			num = _sourceCode[:index].count(lineBreak)
			labelLineList.append(LABEL_STATEMENT + str(num) + lineBreak)
		with open(os.path.join(DATASET_PATH, _preName + INJECTED_INFO_SUFFIX), "w+",  encoding = "utf-8") as f:
			f.writelines(labelLineList)
		return

	def insertStatement(self, _insertInfo):
		tempCode = str()	
		tempDict = copy.deepcopy(_insertInfo) #使用副本
		startIndex = 0
		indexList = sorted(_insertInfo.keys())
		offset = list()
		for index in indexList:
			tempCode += self.sourceCode[startIndex: index] + _insertInfo[index]
			startIndex = index
			offset.append(len(_insertInfo[index]))
			newIndex = index + sum(offset)
			tempDict[newIndex] = tempDict.pop(index)
		tempCode += self.sourceCode[startIndex:]
		return tempCode, tempDict

	def getAssertStatement(self, _ast):
		funcCall = self.findASTNode(_ast, "name", "FunctionCall")
		srcList = list()
		for call in funcCall:
			if call["attributes"]["type"] == TUPLE_FLAG:
				children0 = call["children"][0]
				children1 = call["children"][1]
				if children0["attributes"]["type"] == REQUIRE_FUNC_TYPE_FLAG and \
				   children0["attributes"]["value"] == ASSERT_FLAG and \
				   children1["name"] == BINARY_OPERATION_FLAG and \
				   children1["attributes"]["type"] == BOOL_FLAG and \
				   children1["attributes"]["commonType"]["typeString"] == COMMON_TYPE_STRING:
				   #找到require语句
				   srcList.append(self.srcToPos(call["src"]))
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
				if children0["attributes"]["type"] == REQUIRE_FUNC_TYPE_FLAG and \
				   children0["attributes"]["value"] == REQUIRE_FLAG and \
				   children1["name"] == BINARY_OPERATION_FLAG and \
				   children1["attributes"]["type"] == BOOL_FLAG and \
				   children1["attributes"]["commonType"]["typeString"] == COMMON_TYPE_STRING:
				   #to do 调试bug，然后尝试增加抽取语句
				   #找到require语句
				   srcList.append(self.srcToPos(call["src"]))
				else:
					continue
			else:
				continue
		return srcList
		
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


	def output(self):
		pass