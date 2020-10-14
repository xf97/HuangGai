#!/usr/bin/python
#-*- coding: utf-8 -*-

import json
import copy
import os
import subprocess

#标记语句
LABEL_STATEMENT = "line_number: "
#合约结果命名后缀
INJECTED_CONTRACT_SUFFIX = "_affectedByMiners.sol"
#标记文件命名后缀
INJECTED_INFO_SUFFIX = "_affectedByMinersInfo.txt"
#插入标记字符串
INJECTED_FLAG = "\t//injected CONTRACT AFFECTED BY MINERS\n"

class integerOverflowInjector:
	def __init__(self, _contractPath, _infoPath, _astPath, _originalContractName):
		self.contractPath = _contractPath
		self.infoPath = _infoPath
		self.info = self.getInfoJson(self.infoPath)
		self.sourceCode = self.getSourceCode(self.contractPath)
		self.ast = self.getJsonAst(_astPath)
		self.preName = _originalContractName
		self.replacementDict = self.initDict()
		try:
			os.mkdir(DATASET_PATH)
		except:
			print("The dataset folder already exists.")

	def initDict(self):
		temp = dict()
		'''
		to do
		'''

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
		#读取注入信息，直接注入就可以
		#1. 替换目标字符串
		srcAndItsStr = dict()
		#键-源代码起始位置
		#值-源代码起始位置、终止位置、类型
		endPosList = [item[1] for item in self.info.values()]	#结束位置
		for pos in endPosList:
			#注意，这里的src是语句的结束位置，而不是该语句结束的分号位置，为了能够准确地标记bug，那么应该寻找分号位置
			endPos = pos
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
		self.storeLabel(newSourceCode, newInjectInfo, self.preName)

	def getCalledId(self, _list):
		calleeIdList = list()
		for funcId in _list:
			funcAstList = self.findASTNode(self.ast, "id", funcId)	#这里找到的是函数的ast
			#从中抽取functionCall
			funcCallList = self.findASTNode(funcAstList[0], "name", "FunctionCall")
			if not funcCallList:
				continue
			else:
				for funcCall in funcCallList:
					if funcCall["children"][0]["attributes"]["referencedDeclaration"] > 0 and \
					   funcCall["children"][0]["attributes"]["value"] != REQUIRE_FLAG and \
					   funcCall["children"][0]["attributes"]["value"] != ASSERT_FLAG:
					   calleeIdList.append(funcCall["children"][0]["attributes"]["referencedDeclaration"]) 
					else:
						continue
		#print(calleeIdList)
		_list.extend(calleeIdList)


	def storeFinalResult(self, _sourceCode, _preName):
		with open(os.path.join(DATASET_PATH, _preName + INJECTED_CONTRACT_SUFFIX), "w+",  encoding = "utf-8") as f:
			f.write(_sourceCode)
		return
	
	def storeLabel(self, _sourceCode, _dict, _preName):
		lineBreak = "\n"
		labelLineList = list()
		for index, value in _dict.items():
			if value == COMMENT_FLAG:
				continue
			else:
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
				if (children0["attributes"]["type"] == REQUIRE_FUNC_TYPE_FLAG or \
					children0["attributes"]["type"] == REQUIRE_FUNC_STRING_TYPE_FLAG) and \
				   children0["attributes"]["value"] == REQUIRE_FLAG and \
				   children1["name"] == BINARY_OPERATION_FLAG and \
				   children1["attributes"]["type"] == BOOL_FLAG and \
				   children1["attributes"]["commonType"]["typeString"] == COMMON_TYPE_STRING:
				   #然后尝试增加抽取语句
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