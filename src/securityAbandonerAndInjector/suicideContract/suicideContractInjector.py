#!/usr/bin/python
#-*- coding: utf-8 -*-

import json
import copy
import os
import subprocess
import time

#标记语句
LABEL_STATEMENT = "line_number: "
#合约结果命名后缀
INJECTED_CONTRACT_SUFFIX = "_suicideContract.sol"
#标记文件命名后缀
INJECTED_INFO_SUFFIX = "_suicideContractInfo.txt"
#结果保存路径
DATASET_PATH = "./dataset/"
#插入标记字符串
INJECTED_FLAG = "\t//injected SUICIDE CONTRACT"
#bool真值字符串
BOOL_TRUE_STR = "true"
#自毁语句键值
SUICIDE_KEY = "suicideStatement"
#身份验证键值
AUTHEN_KEY = "authStatement"

class suicideContractInjector:
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
		#有两个键值，对应两种插入类型，分开处理
		#对于自毁语句，是直接标注
		#对于身份验证语句，则是替换
		#键－开始替换的位置
		#值－[结束替换的位置，替换字符串]
		srcAndItsStr = dict()	#记录注入信息的数据结构
		#1. 先准备标注的
		for value in self.info[SUICIDE_KEY]:
			#先找到这一行的结尾
			endPos = value[1]
			while self.sourceCode[endPos] != "\n":
				endPos += 1
			#停下时指向换行符，记录位置
			srcAndItsStr[endPos] = [endPos, INJECTED_FLAG]
		#2. 再准备要替换的
		for value in self.info[AUTHEN_KEY]:
			#直接记录位置
			srcAndItsStr[value[0]] = [value[1], BOOL_TRUE_STR]
		#3. 替换语句就行
		newSourceCode, newInjectInfo = self.insertStatement(srcAndItsStr)
		#print(newSourceCode)
		#4. 保存结果自动标记
		self.storeFinalResult(newSourceCode, self.preName)
		self.storeLabel(newSourceCode, newInjectInfo, self.preName)

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