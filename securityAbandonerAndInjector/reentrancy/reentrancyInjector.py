#!/usr/bin/python
#-*- coding: utf-8 -*-

import json

#记录结构体
class statementInfo:
	def __init__(self):
		deductIndex = list()	#记录扣减语句的源代码位置
		deductState = str()		#扣款语句
		transferIndex = list()	#转出语句的源代码位置
		transferState = str()	#转账语句

class reentrancyInjector:
	def __init__(self, _contractPath, _infoPath):
		self.contractPath = _contractPath
		self.infoPath = _infoPath
		self.info = self.getInfoJson(self.infoPath)
		self.sourceCode = self.getSourceCode(self.contractPath)

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
		infoDict = dict()
		for path in self.info.keys():
			#获取一条路径下的最后一句转账语句，和扣款语句
			deductIndex = -1
			deductState = str()
			transferIndex = -1
			transferState = str()
			item = statementInfo()
			for index in self.info[path]["ledgerList"]:
				if index[0] > deductIndex:
					deductIndex = index[0]
					deductState = self.sourceCode[index[0] : index[1]]
					item.deductIndex = [index[0], index[1]]
			for index in self.info[path]["statementList"]:
				if index[0] > transferIndex:
					transferIndex = index[0]
					transferState = self.sourceCode[index[0] : self.getAllState(index[0])]
					item.transferIndex = [index[0], self.getAllState(index[0])]
			item.deductState = deductState
			item.transferState = transferState
			infoDict[deductIndex] = item

	def getAllState(self, _startIndex):
		result = _startIndex
		while self.sourceCode[result] != ";" and result < len(self.sourceCode):
			result += 1
		return result


	def output(self):
		pass