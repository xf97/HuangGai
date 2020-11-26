#!/usr/bin/python
#-*- coding: utf-8 -*-

import json
import copy
import os
import subprocess
from random import randint

#标记语句
LABEL_STATEMENT = "line_number: "
#合约结果命名后缀
INJECTED_CONTRACT_SUFFIX = "_affectedByMiners.sol"
#标记文件命名后缀
INJECTED_INFO_SUFFIX = "_affectedByMinersInfo.txt"
#结果保存路径
DATASET_PATH = "./dataset/"
#插入标记字符串
INJECTED_FLAG = "\t//injected CONTRACT AFFECTED BY MINERS\n"

class contractAffectedByMinersInjector:
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
			#print("The dataset folder already exists.")
			pass

	def initDict(self):
		temp = dict()
		temp["address"] = ["block.coinbase"]
		temp["address payable"] = ["block.coinbase"]
		temp["uint256"] = ["block.gaslimit", "block.number", "block.timestamp"]
		temp["bytes32"] = ["blockhash(block.number)"]
		return temp

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
		#注入对象，已经确定注入信息的合约
		#该列表每个元素的数据结构为-[替换起始位置，替换终止位置，插入字符串]
		#1. 填充该列表
		srcAndItsStr = list()
		for statement in self.info.values():
			#随机选择一个匹配类型的、受矿工控制的属性
			subStr = self.replacementDict[statement[2]][randint(0, len(self.replacementDict[statement[2]]) - 1)]
			srcAndItsStr.append([statement[0], statement[1], subStr])
			#print(statement[2], subStr)
		#2. 替换源代码, 注入。并更新起始和终止位置
		newSourceCode, newPosList = self.replaceStatement(srcAndItsStr)
		#3. 插入bug存在注释，使用终止位置
		newSourceCode = self.insertInjectComment(newSourceCode, [item[1] for item in newPosList])
		#4. 输出并保存结果，然后产生自动标记
		self.storeFinalResult(newSourceCode, self.preName)
		self.storeLabel(newSourceCode, self.preName)

	def insertInjectComment(self, _sourceCode, _endPosList):
		tempCode = str()
		tempList = list()
		#首先，更新终止位置，以使写入注释准确
		for index in _endPosList:
			while _sourceCode[index] != "\n":
				index += 1
			#终止时指向换行符
			tempList.append(index)
		#排序
		tempList.sort()
		#然后插入注释
		startIndex = 0
		for item in tempList:
			tempCode += _sourceCode[startIndex: item]	#拼接前序代码 
			tempCode += INJECTED_FLAG	#插入注释
			startIndex = item  #更新起始位置
			startIndex += 1	#越过这个换行符
		tempCode += _sourceCode[startIndex:]	#拼接剩下的代码
		return tempCode

	def replaceStatement(self, _insertList):
		#为防止出现问题，先对insertList排序
		#按起始位置升序
		indexList = sorted(_insertList, key = lambda x: x[0])
		newIndexList = list()
		offset = list()
		tempCode = str()
		startIndex = 0
		#然后，替换
		for item in indexList:
			tempCode += self.sourceCode[startIndex: item[0]]	#拼接前序代码 
			tempCode += item[2]	#拼接受矿工操控的属性
			startIndex = item[1] #更新起始位置，方便下一次拼接后续代码
			offset.append(len(item[2]) - (item[1] - item[0]))
			newIndexList.append([item[0] + sum(offset[:-1]), item[1] + sum(offset)])	#更新每个元素的初始和终止位置
		tempCode += self.sourceCode[startIndex:]	#拼接剩下的代码
		return tempCode, newIndexList

	def storeFinalResult(self, _sourceCode, _preName):
		with open(os.path.join(DATASET_PATH, _preName + INJECTED_CONTRACT_SUFFIX), "w+",  encoding = "utf-8") as f:
			f.write(_sourceCode)
		return
	
	def storeLabel(self, _sourceCode, _preName):
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