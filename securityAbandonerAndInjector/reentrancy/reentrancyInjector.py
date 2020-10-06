#!/usr/bin/python
#-*- coding: utf-8 -*-

import json
import re
import copy
import os

#转出语句
CALL_VALUE_STATEMENT = ".call.value(1)(\"\");	//injected REENTRANCY\n"
#标记语句
LABEL_STATEMENT = "line_number: "
#合约结果命名后缀
INJECTED_CONTRACT_SUFFIX = "_reentrancy.sol"
#标记文件命名后缀
INJECTED_INFO_SUFFIX = "_reentrancyInfo.txt"
#结果保存路径
DATASET_PATH = "./dataset/"

#记录结构体
class statementInfo:
	def __init__(self):
		deductIndex = list()	#记录扣减语句的源代码位置
		deductState = str()		#扣款语句
		transferIndex = list()	#转出语句的源代码位置
		transferState = str()	#转账语句

class reentrancyInjector:
	def __init__(self, _contractPath, _infoPath, _originalContractName):
		self.contractPath = _contractPath
		self.infoPath = _infoPath
		self.info = self.getInfoJson(self.infoPath)
		self.sourceCode = self.getSourceCode(self.contractPath)
		self.preName = _originalContractName
		try:
			os.mkdir(DATASET_PATH)
		except:
			print("The dataset folder already exists.")

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
			#1. 获取一条路径下的最后一句转账语句，和扣款语句
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
		#2. 根据不同路径，构造匹配语句并记录插入位置
		injectInfo = dict()
		#使用正则表达式，截取接收地址
		addressPattern = re.compile(r"(\[)((\w)|(\.))+(\])")	#用于匹配接收转账的地址
		for key in infoDict:
			tempStr = infoDict[key].deductState
			address = addressPattern.search(tempStr).group()[1:-1]	#截取头尾的方括号
			#拼接插入语句
			#额外的发币出去会有什么隐患？最影响的应该就是address.balance, address.balance并不能执行+-操作
			sendEtherState = self.getSendEtherState(address)
			injectInfo[key] = sendEtherState
		#3. 根据源代码和插入位置，插入语句，并更新index
		newSourceCode, newInjectInfo = self.injectStatements(injectInfo, self.sourceCode)
		#4. 输出并保存结果，然后产生自动标记
		self.storeFinalResult(newSourceCode, self.preName)
		self.storeLabel(newSourceCode, newInjectInfo.keys(), self.preName)

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

	def injectStatements(self, _injectInfo, _sourceCode):
		tempCode = str()	
		tempDict = copy.deepcopy(_injectInfo) #使用副本
		startIndex = 0
		indexList = sorted(_injectInfo.keys())
		offset = list()
		for index in indexList:
			tempCode += _sourceCode[startIndex: index] + _injectInfo[index]
			startIndex = index
			offset.append(len(_injectInfo[index]))
			newIndex = index + sum(offset)
			tempDict[newIndex] = tempDict.pop(index)
		tempCode += _sourceCode[startIndex:]
		return tempCode, tempDict



	def getSendEtherState(self, _address):
		return str(_address) + CALL_VALUE_STATEMENT


	def getAllState(self, _startIndex):
		result = _startIndex
		while self.sourceCode[result] != ";" and result < len(self.sourceCode):
			result += 1
		return result


	def output(self):
		pass