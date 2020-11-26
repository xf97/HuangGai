#!/usr/bin/python
#-*- coding: utf-8 -*-

import json
import copy
import os
import subprocess

#标记语句
LABEL_STATEMENT = "line_number: "
#合约结果命名后缀
INJECTED_CONTRACT_SUFFIX = "_dosByComplexFallback.sol"
#标记文件命名后缀
INJECTED_INFO_SUFFIX = "_dosByComplexFallbackInfo.txt"
#结果保存路径
DATASET_PATH = "./dataset/"
#插入标记字符串
INJECTED_FLAG = "\t//inject DOS BY COMPLEX FALLBACK"
#保存注入信息的字典键值
SRC_KEY = "srcPos"
#fallback标志
FALLBACK_FLAG = "fallback"



class DosByComplexFallbackInjector:
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
			#print("The dataset folder already exists.")
			pass

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
		#键是开始拼接语句的位置，值是一个列表，第一个元素是结束拼接语句的位置，第二个元素是插入的元素
		srcAndItsStr = dict()
		#获得所有fallback函数源代码位置
		fallbackFuncPosList = self.getFallbackFuncPos()
		#执行的是替换任务
		#首先是把其中的内容替换成keccak语句
		#然后是在该行的末尾添加标注符号
		for item in self.info[SRC_KEY]:
			srcAndItsStr[item[0]] = [item[1], item[2]]
			#然后在尾部添加标记语句
			endPos = item[1]
			#找到标记位置
			for func in fallbackFuncPosList:
				if func[0] <= item[0] and func[1] >= item[1]:
					#找到包含的fallback函数
					sPos = func[0]
					while self.sourceCode[sPos] != "\n":
						sPos += 1
					#找到函数起始行数，记录
					if not sPos in srcAndItsStr.keys():
						srcAndItsStr[sPos] = [sPos, INJECTED_FLAG]
					else:
						continue
				else:
					continue
		#插入语句
		newSourceCode, newInjectInfo = self.insertStatement(srcAndItsStr)
		#保存结果
		self.storeFinalResult(newSourceCode, self.preName)
		self.storeLabel(newSourceCode, newInjectInfo, self.preName)

	def getFallbackFuncPos(self):
		posList = list()
		for func in self.findASTNode(self.ast, "name",  "FunctionDefinition"):
			#要求函数实现
			if func["attributes"]["implemented"] == True and func["attributes"]["kind"] == FALLBACK_FLAG:
				#捕获fallback函数
				sPos, ePos = self.srcToPos(func["src"])
				posList.append([sPos, ePos])
			else:
				continue
		return posList

	def insertStatement(self, _insertInfo):
		tempCode = str()	
		tempDict = copy.deepcopy(_insertInfo) #使用副本
		startIndex = 0
		indexList = sorted(_insertInfo.keys())
		offset = list()
		for index in indexList:
			tempCode += self.sourceCode[startIndex: index] + _insertInfo[index][1]
			startIndex = _insertInfo[index][0]
			offset.append(len(_insertInfo[index][1]) + (_insertInfo[index][0] - index))
			newIndex = index + sum(offset)
			tempDict[newIndex] = tempDict.pop(index)
		tempCode += self.sourceCode[startIndex:]
		return tempCode, tempDict


	def storeFinalResult(self, _sourceCode, _preName):
		with open(os.path.join(DATASET_PATH, _preName + INJECTED_CONTRACT_SUFFIX), "w+",  encoding = "utf-8") as f:
			f.write(_sourceCode)
		return
	
	def storeLabel(self, _sourceCode, _dict, _preName):
		startIndex = _sourceCode.find(INJECTED_FLAG)
		lineBreak = "\n"
		labelLineList = list()
		while startIndex != -1:
			num = _sourceCode[:startIndex].count(lineBreak) + 1
			labelLineList.append(LABEL_STATEMENT + str(num) + lineBreak)
			startIndex = _sourceCode.find(INJECTED_FLAG, startIndex + len(INJECTED_FLAG))
		with open(os.path.join(DATASET_PATH, _preName + INJECTED_INFO_SUFFIX), "w+",  encoding = "utf-8") as f:
			f.writelines(labelLineList)
		return
		
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