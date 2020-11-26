#!/usr/bin/python
#-*- coding: utf-8 -*-

import json
import copy
import os
import subprocess
import time
from random import randint

#标记语句
LABEL_STATEMENT = "line_number: "
#合约结果命名后缀
INJECTED_CONTRACT_SUFFIX = "_lockedEther.sol"
#标记文件命名后缀
INJECTED_INFO_SUFFIX = "_lockedEtherInfo.txt"
#结果保存路径
DATASET_PATH = "./dataset/"
#把转账金额置换为0
ZERO_FLAG = 2
ZERO_STR = "0"
#插入标记字符串
INJECTED_FLAG = "\t//injected LOCKED ETHER"
#注释语句字符串
COMMENT_STR = "//"
#另一种无效化安全措施的语句
BALANCE_EQU_0_STR = "\n\trequire(address(this).balance == 0);\n\t"
#插入语句列表
INJECTED_STATEMENT_LIST = [COMMENT_STR, BALANCE_EQU_0_STR, ZERO_STR]
#接收以太币函数键值
PAYABLE_FUNC_KEY = "payableFunc"
#转出以太币语句键值
ETHER_OUT_KEY = "etherOutStatement"



class lockedEtherInjector:
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
		#对于接收以太币函数语句，是直接标注
		#对于转出以太币语句，则是在无效化该语句-无效化语句考虑列表的第三个元素决定该使用哪个无效化语句
		#键－开始替换的位置
		#值－[结束替换的位置，替换字符串]
		srcAndItsStr = dict()	#记录注入信息的数据结构
		#1. 先准备标注的
		for value in self.info[PAYABLE_FUNC_KEY]:
			#先找到这一行的结尾
			#注意此处的value[1]指向的是整个函数的末尾，不合适
			#故使用value[0]
			endPos = value[0]
			while self.sourceCode[endPos] != "\n":
				endPos += 1
			#停下时指向换行符，记录位置
			srcAndItsStr[endPos] = [endPos, INJECTED_FLAG]
		#2. 再准备要无效化语句的
		for value in self.info[ETHER_OUT_KEY]:
			#在语句前端插入
			#随机选择插入语句
			#injectedState = INJECTED_STATEMENT_LIST[randint(0, 1)]	#左右都是闭区间
			if value[2] == ZERO_FLAG:
				#替换
				srcAndItsStr[value[0]] = [value[1], ZERO_STR]
			else:
				#加前缀
				srcAndItsStr[value[0]] = [value[0], COMMENT_STR]
			'''
			injectedState = INJECTED_STATEMENT_LIST[value[2]]
			srcAndItsStr[value[0]] = [value[0], injectedState]
			'''
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