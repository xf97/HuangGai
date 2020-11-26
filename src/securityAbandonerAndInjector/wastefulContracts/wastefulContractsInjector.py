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
INJECTED_CONTRACT_SUFFIX = "_wastefulContract.sol"
#标记文件命名后缀
INJECTED_INFO_SUFFIX = "_wastefulContractInfo.txt"
#结果保存路径
DATASET_PATH = "./dataset/"
#插入标记字符串
INJECTED_STR = "\t//injected WASTEFUL CONTRACT"
#bool真值字符串
BOOL_TRUE_STR = "true"
#转出全部金额语句
ALL_MONEY_STR = "address(this).balance"
#源代码键值
SRCLIST_KEY = "srcList"
#替换为真值flag
BOOL_TRUE_FLAG = 0
#该标志指明在这个位置插入标记bug的语句
INJECTED_FLAG = 1
#规定转出金额为所有钱
ALL_MONEY_FLAG = 2
#[bug fix to improve precision]
TRANSFER_ALL_MONEY_FLAG = 3
#转出所有以太币的语句
TRANSFER_ALL_MONEY_STR = "\tmsg.sender.transfer(address(this).balance);\t"

class wastefulContractsInjector:
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
		#键－开始替换的位置
		#值－[结束替换的位置，替换字符串]
		srcAndItsStr = dict()	#记录注入信息的数据结构
		#分不同种类的语句标注
		for item in self.info[SRCLIST_KEY]:
			#如果是标注bug的
			if item[2] == INJECTED_FLAG:
				srcAndItsStr[item[0]] = [item[1], INJECTED_STR]
			elif item[2] == BOOL_TRUE_FLAG:
				#布尔真值，执行替换
				srcAndItsStr[item[0]] = [item[1], BOOL_TRUE_STR]
			elif item[2] == ALL_MONEY_FLAG:
				#所有金钱，执行替换
				srcAndItsStr[item[0]] = [item[1], ALL_MONEY_STR]
			elif item[2] == TRANSFER_ALL_MONEY_FLAG:
				#插入语句
				srcAndItsStr[item[0]] = [item[1], TRANSFER_ALL_MONEY_STR]
		#然后，插入代码
		newSourceCode, newInjectInfo = self.insertStatement(srcAndItsStr)
		#保存代码
		self.storeFinalResult(newSourceCode, self.preName)
		self.storeLabel(newSourceCode, newInjectInfo, self.preName)
		return

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
		startIndex = _sourceCode.find(INJECTED_STR)
		lineBreak = "\n"
		labelLineList = list()
		while startIndex != -1:
			num = _sourceCode[:startIndex].count(lineBreak) + 1
			labelLineList.append(LABEL_STATEMENT + str(num) + lineBreak)
			startIndex = _sourceCode.find(INJECTED_STR, startIndex + len(INJECTED_STR))
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