#!/usr/bin/python
#-*- coding: utf-8 -*-

import json
import re
import copy
import os
import random

#转出语句
CALL_VALUE_STATEMENT = ".call.value(1)(\"\");	//injected REENTRANCY\n"
#0.7.0的转出语句
CALL_070_VALUE_STATEMENT = ".call{value:1}(\"\");	//injected REENTRANCY\n"
#标记语句
LABEL_STATEMENT = "line_number: "
#合约结果命名后缀
INJECTED_CONTRACT_SUFFIX = "_reentrancy.sol"
#标记文件命名后缀
INJECTED_INFO_SUFFIX = "_reentrancyInfo.txt"
#结果保存路径
DATASET_PATH = "./dataset/"
#屏蔽信息保存位置
SHIELD_INFO_PATH = "../../contractExtractor/reentrancyExtractor/result"
#键值
SRC_LIST_KEY = "srcList"
#真值
#bool真值字符串
BOOL_TRUE_STR = "true"
#替换为真值flag
BOOL_TRUE_FLAG = 0
#永真表达式集合文件
EVERTRUEEXPRESSIONS_JSON_FILE_PATH = "./ever_true.json"
EVERTRUEEXPRESSIONS_KEY = "exertrueExpressions"

#记录结构体
class statementInfo:
	def __init__(self):
		deductIndex = list()	#记录扣减语句的源代码位置
		deductState = str()		#扣款语句
		transferIndex = list()	#转出语句的源代码位置
		transferState = str()	#转账语句

class reentrancyInjector:
	def __init__(self, _contractPath, _infoPath, _shieldInfoPath, _originalContractName):
		self.contractPath = _contractPath
		self.infoPath = _infoPath
		self.info = self.getInfoJson(self.infoPath)
		self.shieldInfo = self.getInfoJson(_shieldInfoPath)
		self.sourceCode = self.getSourceCode(self.contractPath)
		self.preName = _originalContractName
		try:
			os.mkdir(DATASET_PATH)
		except:
			#print("The dataset folder already exists.")
			pass

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

	def getEverTrueExpressions(self):
		#该函数随机返回一个永真表达式字符串
		everTrueStr = str()
		#打开文件
		with open(EVERTRUEEXPRESSIONS_JSON_FILE_PATH, "r", encoding = "utf-8") as f:
			temp = json.loads(f.read())	#
			expList = temp[EVERTRUEEXPRESSIONS_KEY]	#返回的这是一个列表了
			everTrueStr = random.choice(expList)
		return everTrueStr	#done

	def initDict(self):
		srcAndItsStr = dict()
		#print(self.shieldInfo)
		for item in self.shieldInfo[SRC_LIST_KEY]:
			#print(item)
			if item[2] == BOOL_TRUE_FLAG:
				#布尔真值，执行替换
				srcAndItsStr[item[0]] = [item[1], self.getEverTrueExpressions()]
		return srcAndItsStr

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
		#[bug fix] 添加屏蔽路径上require和assert语句
		#[bug fix] 使路径上的if语句的条件表达式部分永真
		#print(infoDict, type(infoDict))
		#injectInfo = dict()
		injectInfo = self.initDict()
		#print(injectInfo)
		#使用正则表达式，截取接收地址
		addressPattern = re.compile(r"(\[)((\w)|(\.))+(\])")	#用于匹配接收转账的地址
		for key in infoDict:
			tempStr = infoDict[key].deductState
			address = addressPattern.search(tempStr).group()[1:-1]	#截取头尾的方括号=
			#拼接插入语句
			#额外的发币出去会有什么隐患？最影响的应该就是address.balance, address.balance并不能执行+-操作
			sendEtherState = self.getSendEtherState(address)
			injectInfo[key] = [key, sendEtherState]
		#print(injectInfo)
		#3. 根据源代码和插入位置，插入语句，并更新index
		newSourceCode, newInjectInfo = self.insertStatement(injectInfo)
		'''
		#分不同种类的语句标注
		for item in self.info[SRCLIST_KEY]:
			if item[2] == BOOL_TRUE_FLAG:
				#布尔真值，执行替换
				srcAndItsStr[item[0]] = [item[1], BOOL_TRUE_STR]
		newSourceCode, newInjectInfo = self.insertStatement(srcAndItsStr)
		'''
		#4. 输出并保存结果，然后产生自动标记
		self.storeFinalResult(newSourceCode, self.preName)
		#print(newSourceCode)
		self.storeLabel(newSourceCode, newInjectInfo.keys(), self.preName)

	def storeFinalResult(self, _sourceCode, _preName):
		with open(os.path.join(DATASET_PATH, _preName + INJECTED_CONTRACT_SUFFIX), "w+",  encoding = "utf-8") as f:
			f.write(_sourceCode)
		return

	#获取当前源代码使用的编译器版本
	def getSolcVersion(self, _sourceCode):
		pragmaPattern = re.compile(r"(\b)pragma(\s)+(solidity)(\s)*(.)+?(;)")
		lowVersionPattern = re.compile(r"(\b)(\d)(\.)(\d)(.)(\d)+(\b)")
		pragmaStatement_mulLine = pragmaPattern.search(_sourceCode, re.S)	#匹配多行
		pragmaStatement_sinLine = pragmaPattern.search(_sourceCode)	#匹配多行 
		pragmaStatement = pragmaStatement_sinLine if pragmaStatement_sinLine else pragmaStatement_mulLine #优先使用单行匹配
		#如果存在声明
		if pragmaStatement:
			#抽取出最低版本
			solcVersion = lowVersionPattern.search(pragmaStatement.group())
			#print("solcVersion", solcVersion)
			if solcVersion:
				return solcVersion.group()
		#否则使用默认声明
		return "0.6.0"

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
			tempCode += self.sourceCode[startIndex: index] + _insertInfo[index][1]
			startIndex = _insertInfo[index][0]
			offset.append(len(_insertInfo[index][1]) + (_insertInfo[index][0] - index))
			newIndex = index + sum(offset)
			tempDict[newIndex] = tempDict.pop(index)
		tempCode += self.sourceCode[startIndex:]
		return tempCode, tempDict

	'''
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
	'''

	def getSendEtherState(self, _address):
		if self.getSolcVersion(self.sourceCode) >= "0.7.0":
			#0.7.0版本的call.value语句出现变化与0.5.0、0.6.0的不同
			return str(_address) + CALL_070_VALUE_STATEMENT
		else:
			return str(_address) + CALL_VALUE_STATEMENT


	def getAllState(self, _startIndex):
		result = _startIndex
		while self.sourceCode[result] != ";" and result < len(self.sourceCode):
			result += 1
		return result


	def output(self):
		pass
