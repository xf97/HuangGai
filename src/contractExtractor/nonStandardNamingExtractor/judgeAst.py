#!/usr/bin/pythin
#-*- coding: utf-8 -*-

import json
import os
from colorPrint import *	#该头文件中定义了色彩显示的信息
import re
import subprocess
import copy
from random import randint

#缓存路径
CACHE_PATH = "./cache/"
#注入所需信息存储路径
INJECT_INFO_PATH = "./injectInfo/"
#注入信息源代码键值
SRC_KEY = "srcPos"
#bug记录标志（执行后续标记）
LABEL_BUG_FLAG = "labelBug"
#随机数最大值
MAX_RANDOM = 1000
#随机数最小值
MIN_RANDOM = 0
#构造函数标志
CONSTRUCTOR_FLAG = "constructor"
#回退函数标志
FALLBACK_FLAG = "fallback"
#接收函数标志
RECEIVER_FLAG = "receive"
#合约标志
CONTRACT_FLAG = "contract_"
#函数名
FUNCTION_FLAG = "function_"
#事件标志
EVENT_FLAG = "event_"
#变量标志
VARIABLE_FLAG = "variable_"
#修改器标志
MODIFIER_FLAG = "modifier_"
#常量标志
CONSTANT_FLAG = "constant_"

'''
总的想法是捕捉所有的命名，然后准备好对应的非法命名
此时应该记录下原本的命名位置（用于换名）和最后的换行符位置（用于标记）
最后为了能够通过编译，替换所有的变量名
'''

class judgeAst:
	def __init__(self, _json, _sourceCode, _filename):
		self.cacheContractPath = "./cache/temp.sol"
		self.cacheFolder = "./cache/"
		self.json =  _json
		self.filename = _filename
		self.sourceCode = _sourceCode

	def run(self):
		injectInfo = dict()
		injectInfo[SRC_KEY] =  list()
		#秉承思想，能做一种算一种，不要贪大求全
		#该数据结构记录id与替换后命名的对应关系
		#键是id，值是命名
		idAndItsName = dict()
		#没名字的不处理
		#[bug fix]　要保证注入前同名的在注入后依然同名
		#该字典的键是非法名，值是使用的随机数
		nameAndItsRandom = dict()
		'''
		#1. 合约和库名
		for contract in self.findASTNode(self.json, "name", "ContractDefinition"):
			#拿到名字
			contractName = contract["attributes"]["name"]
			if not contractName:
				continue
			#拿到起始位置
			sPos, ePos = self.srcToPos(contract["src"])
			#根据名字和种类产生非法命名
			illegalName = contractName.lower() 
			nameKey = CONTRACT_FLAG + illegalName
			if nameKey in nameAndItsRandom:
				illegalName += nameAndItsRandom[nameKey]
			else:
				#新名字
				randomStr = str(randint(MIN_RANDOM, MAX_RANDOM))
				nameAndItsRandom[nameKey] = randomStr
				illegalName += randomStr
			contractSourceCode = self.sourceCode[sPos: ePos]
			#记录
			#首先是标记
			temp = sPos
			while self.sourceCode[temp] != "\n":
				temp += 1
			injectInfo[SRC_KEY].append([temp, temp, LABEL_BUG_FLAG])
			#解决如何找到变量名准确的源代码位置的问题,　得用正则表达式
			#第一个匹配的字符串位置就是变量名
			namePattern  = r"(\b)(" + contractName + r")(\b)"
			startOffset, endOffset = re.search(namePattern, contractSourceCode).span()
			#记录位置
			injectInfo[SRC_KEY].append([sPos + startOffset, sPos + endOffset, illegalName])
			#为之后的换名做准备
			idAndItsName[contract["id"]] = [namePattern, illegalName]
		'''
		#2. 函数名
		for func in self.findASTNode(self.json, "name", "FunctionDefinition"):
			#过滤一些特殊函数
			if func["attributes"]["kind"] == CONSTRUCTOR_FLAG:
				continue
			if func["attributes"]["kind"] == FALLBACK_FLAG:
				continue
			if func["attributes"]["kind"] == RECEIVER_FLAG:
				continue
			#拿到名字
			funcName = func["attributes"]["name"]
			if not funcName:
				continue
			#拿到起始位置
			sPos, ePos = self.srcToPos(func["src"])
			#根据名字和种类产生非法命名
			illegalName = funcName.upper()
			nameKey = FUNCTION_FLAG + illegalName
			if nameKey in nameAndItsRandom:
				illegalName += nameAndItsRandom[nameKey]
			else:
				#新名字
				randomStr = str(randint(MIN_RANDOM, MAX_RANDOM))
				nameAndItsRandom[nameKey] = randomStr
				illegalName += randomStr
			funcSourceCode = self.sourceCode[sPos: ePos]
			#记录
			#首先是标记
			temp = sPos
			while self.sourceCode[temp] != "\n":
				temp += 1
			injectInfo[SRC_KEY].append([temp, temp, LABEL_BUG_FLAG])
			#解决如何找到变量名准确的源代码位置的问题,　得用正则表达式
			#第一个匹配的字符串位置就是变量名
			namePattern  = r"(\b)(" + funcName + r")(\b)"
			startOffset, endOffset = re.search(namePattern, funcSourceCode).span()
			#记录位置
			injectInfo[SRC_KEY].append([sPos + startOffset, sPos + endOffset, illegalName])
			#为之后的换名做准备
			idAndItsName[func["id"]] = [namePattern, illegalName]
		#3. 事件名
		for func in self.findASTNode(self.json, "name", "EventDefinition"):
			#拿到名字
			funcName = func["attributes"]["name"]
			if not funcName:
				continue
			#拿到起始位置
			sPos, ePos = self.srcToPos(func["src"]) 
			#根据名字和种类产生非法命名
			illegalName = funcName.upper()
			nameKey = EVENT_FLAG + illegalName
			if nameKey in nameAndItsRandom:
				illegalName += nameAndItsRandom[nameKey]
			else:
				#新名字
				randomStr = str(randint(MIN_RANDOM, MAX_RANDOM))
				nameAndItsRandom[nameKey] = randomStr
				illegalName += randomStr
			funcSourceCode = self.sourceCode[sPos: ePos]
			#记录
			#首先是标记
			temp = sPos
			while self.sourceCode[temp] != "\n":
				temp += 1
			injectInfo[SRC_KEY].append([temp, temp, LABEL_BUG_FLAG])
			#解决如何找到变量名准确的源代码位置的问题,　得用正则表达式
			#第一个匹配的字符串位置就是变量名
			namePattern  = r"(\b)(" + funcName + r")(\b)"
			startOffset, endOffset = re.search(namePattern, funcSourceCode).span()
			#记录位置
			injectInfo[SRC_KEY].append([sPos + startOffset, sPos + endOffset, illegalName])
			#为之后的换名做准备
			idAndItsName[func["id"]] = [namePattern, illegalName]
		'''
		#4. 函数变量和参数命名(非常数)
		#处理函数参数的文档化缺失问题
		for func in self.findASTNode(self.json, "name", "VariableDeclaration"):
			#拿到名字
			funcName = func["attributes"]["name"]
			if func["attributes"]["constant"] ==  True:
				continue
			if not funcName:
				continue
			#拿到起始位置
			sPos, ePos = self.srcToPos(func["src"]) 
			#根据名字和种类产生非法命名
			illegalName = funcName.upper()
			nameKey = VARIABLE_FLAG + illegalName
			if nameKey in nameAndItsRandom:
				illegalName += nameAndItsRandom[nameKey]
			else:
				#新名字
				randomStr = str(randint(MIN_RANDOM, MAX_RANDOM))
				nameAndItsRandom[nameKey] = randomStr
				illegalName += randomStr
			funcSourceCode = self.sourceCode[sPos: ePos]
			#记录
			#首先是标记
			temp = sPos
			while self.sourceCode[temp] != "\n":
				temp += 1
			injectInfo[SRC_KEY].append([temp, temp, LABEL_BUG_FLAG])
			#解决如何找到变量名准确的源代码位置的问题,　得用正则表达式
			#第一个匹配的字符串位置就是变量名
			namePattern  = r"(\b)(" + funcName + r")(\b)"
			startOffset, endOffset = re.search(namePattern, funcSourceCode).span()
			#记录位置
			injectInfo[SRC_KEY].append([sPos + startOffset, sPos + endOffset, illegalName])
			#为之后的换名做准备
			idAndItsName[func["id"]] = [namePattern, illegalName]
		'''
		#5. 函数修改器命名
		for func in self.findASTNode(self.json, "name", "ModifierDefinition"):
			#拿到名字
			funcName = func["attributes"]["name"]
			if not funcName:
				continue
			#拿到起始位置
			sPos, ePos = self.srcToPos(func["src"]) 
			#根据名字和种类产生非法命名
			illegalName = funcName.upper()
			nameKey = MODIFIER_FLAG + illegalName
			if nameKey in nameAndItsRandom:
				illegalName += nameAndItsRandom[nameKey]
			else:
				#新名字
				randomStr = str(randint(MIN_RANDOM, MAX_RANDOM))
				nameAndItsRandom[nameKey] = randomStr
				illegalName += randomStr
			funcSourceCode = self.sourceCode[sPos: ePos]
			#记录
			#首先是标记
			temp = sPos
			while self.sourceCode[temp] != "\n":
				temp += 1
			injectInfo[SRC_KEY].append([temp, temp, LABEL_BUG_FLAG])
			#解决如何找到变量名准确的源代码位置的问题,　得用正则表达式
			#第一个匹配的字符串位置就是变量名
			namePattern  = r"(\b)(" + funcName + r")(\b)"
			startOffset, endOffset = re.search(namePattern, funcSourceCode).span()
			#记录位置
			injectInfo[SRC_KEY].append([sPos + startOffset, sPos + endOffset, illegalName])
			#为之后的换名做准备
			idAndItsName[func["id"]] = [namePattern, illegalName]
		#6. 对常量型变量的
		for func in self.findASTNode(self.json, "name", "VariableDeclaration"):
			#拿到名字
			funcName = func["attributes"]["name"]
			if func["attributes"]["constant"] == False:
				continue
			if not funcName:
				continue
			#拿到起始位置
			sPos, ePos = self.srcToPos(func["src"]) 
			#根据名字和种类产生非法命名
			illegalName = funcName.lower()
			nameKey = CONSTANT_FLAG + illegalName
			if nameKey in nameAndItsRandom:
				illegalName += nameAndItsRandom[nameKey]
			else:
				#新名字
				randomStr = str(randint(MIN_RANDOM, MAX_RANDOM))
				nameAndItsRandom[nameKey] = randomStr
				illegalName += randomStr
			funcSourceCode = self.sourceCode[sPos: ePos]
			#记录
			#首先是标记
			temp = sPos
			while self.sourceCode[temp] != "\n":
				temp += 1
			injectInfo[SRC_KEY].append([temp, temp, LABEL_BUG_FLAG])
			#解决如何找到变量名准确的源代码位置的问题,　得用正则表达式
			#第一个匹配的字符串位置就是变量名
			namePattern  = r"(\b)(" + funcName + r")(\b)"
			startOffset, endOffset = re.search(namePattern, funcSourceCode).span()
			#记录位置
			injectInfo[SRC_KEY].append([sPos + startOffset, sPos + endOffset, illegalName])
			#为之后的换名做准备
			idAndItsName[func["id"]] = [namePattern, illegalName]
		#7. 根据之前的记录，执行换名
		for key, value in idAndItsName.items():
			#首先找到所有的引用
			for ast in self.findASTNodeAttr(self.json, "referencedDeclaration", key):
				#截取下来语句
				sPos, ePos = self.srcToPos(ast["src"])
				state = self.sourceCode[sPos: ePos]
				#惊了，一句话里面重复调用一个方法
				for item in re.finditer(value[0], state):
					startOffset, endOffset = item.span()
					#startOffset, endOffset = re.search(value[0], state).span()
					injectInfo[SRC_KEY].append([sPos + startOffset, sPos + endOffset, value[1]])
		#8. 补充，在内联汇编中的支持
		for key, value in idAndItsName.items():
			#首先找到所有的引用
			for ast in self.findASTNode(self.json, "declaration", key):
				#截取下来语句
				sPos, ePos = self.srcToPos(ast["src"])
				state = self.sourceCode[sPos: ePos]
				#惊了，一句话里面重复调用一个方法
				for item in re.finditer(value[0], state):
					startOffset, endOffset = item.span()
					#startOffset, endOffset = re.search(value[0], state).span()
					injectInfo[SRC_KEY].append([sPos + startOffset, sPos + endOffset, value[1]])
		#5. 存储结果
		if injectInfo[SRC_KEY]:
			self.storeInjectInfo(injectInfo)
			return True
		else:
			return False


	def cleanComment(self, _code):
		#使用正则表达式捕捉单行和多行注释
		singleLinePattern = re.compile(r"(//)(.)+")	#提前编译，以提高速度
		multipleLinePattern = re.compile(r"(/\*)(.)+?(\*/)")
		#记录注释的下标
		indexList = list()
		for item in singleLinePattern.finditer(_code):
			indexList.append(item.span())
		for item in multipleLinePattern.finditer(_code, re.S):
			#多行注释，要允许多行匹配
			indexList.append(item.span())
		#拼接新结果
		startIndedx = 0
		newCode = str()
		for item in indexList:
			newCode += _code[startIndedx: item[0]]	#不包括item[0]
			startIndedx = item[1] + 1 #加一的目的是不覆盖前序的尾巴
		newCode += _code[startIndedx:]
		return newCode


	def storeInjectInfo(self, _injectInfo):
		try:
			#保存信息
			with open(os.path.join(INJECT_INFO_PATH, self.filename.split(".")[0] + ".json"), "w", encoding = "utf-8") as f:
				json.dump(_injectInfo, f, indent = 1)
			#print("%s %s %s" % (info, self.filename + " target injected information...saved", end))
		except:
			#print("%s %s %s" % (bad, self.filename + " target injected information...failed", end))
			pass

	def findASTNode(self, _ast, _name, _value):
		if type(_ast) != list:
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

	def findASTNodeAttr(self, _ast, _attr, _value):
		if type(_ast) != list:
			queue = [_ast]
		result = list()
		literalList = list()
		while len(queue) > 0:
			data = queue.pop()
			for key in data:
				try:
					if key == "attributes" and data[key][_attr] == _value:
						result.append(data)
					elif type(data[key]) == dict:
						queue.append(data[key])
					elif type(data[key]) == list:
						for item in data[key]:
							if type(item) == dict:
								queue.append(item)
					else:
						continue
				except:
					continue
		return result

	#传入：657:17:0
	#传出：657, 674
	def srcToPos(self, _src):
		temp = _src.split(":")
		return int(temp[0]), int(temp[0]) + int(temp[1])