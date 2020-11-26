#!/usr/bin/python
#-*- coding: utf-8 -*-

'''
该部分程序通过解析合约编译产生的json_ast文件，
来判断合约是否满足以下三个标准:
#hiding
'''

#WARNING
'''
部分函数有“函数选择器”值，但部分函数没有，这些函数之间并没有明显地差异，这令人费解?
稳妥的解决方法，用命令"solc --hashes myContract.sol -o ."
'''

#缓存路径
CACHE_PATH = "./cache/"
#注入所需信息存储路径
INJECT_INFO_PATH = "./injectInfo/"
#布尔假值
BOOL_FALSE_FLAG = False
#布尔真值
BOOL_TRUE_FLAG = True
#要求变量存储位置为default
DEFAULT_FLAG = "default"
#字典键值
SRC_KEY = "srcPos"
#等于符号
EQU_FLAG = "="
#映射标志
MAPPING_FLAG = "mapping"
#映射的标志符号模式
MAPPING_PATTERN = r"=(\s)*>"

import json
import os
from colorPrint import *	#该头文件中定义了色彩显示的信息
import re

class judgeAst:
	def __init__(self, _json, _sourceCode, _filename):
		self.cacheContractPath = "./cache/temp.sol"
		self.cacheFolder = "./cache/"
		self.json =  _json
		self.filename = _filename
		self.sourceCode = _sourceCode

	def getSourceCode(self, _contractPath):
		try:
			with open(_contractPath, "r", encoding = "utf-8") as f:
				return f.read()
		except:
			raise Exception("Failed to read cache source code.")

	#判断这部分语句有没有等号
	def containEqu(self, _sPos, _ePos):
		mappingPattern = re.compile(MAPPING_PATTERN)
		state = self.sourceCode[_sPos: _ePos]
		if state.find(EQU_FLAG) == -1:
			return False
		else:
			#[bug fix 2020/11/11] 如果包含映射的标志符号，不处理
			if not mappingPattern.search(state):
				return True
			else:
				return False


	def run(self):
		injectInfo = dict()	#存储目标注入信息
		injectInfo[SRC_KEY] = list()
		#1. 先捕捉本地变量初始化语句
		localVarStateList = list()
		for state in self.findASTNode(self.json, "name", "VariableDeclarationStatement"):
			#[bug fix 2020/11/10] 不对一次性对多个值进行赋值的语句进行处理
			#获取被赋值的变量数量
			assignList = state["attributes"]["assignments"]
			if len(assignList) != 1:
				continue
			sPos, ePos = self.srcToPos(state["src"])
			if self.containEqu(sPos, ePos) == False:
				continue
			#取出被赋值的变量
			var = state["children"][0]
			#验证是否是我们要的本地变量
			#[bug fix 2020/11/10] 不对constant变量进行处理
			if var["attributes"]["stateVariable"] == BOOL_FALSE_FLAG and var["attributes"]["storageLocation"] == DEFAULT_FLAG and var["attributes"]["constant"] == BOOL_FALSE_FLAG:
				#是的，那么保存这句话
				localVarStateList.append(state)
			else:
				continue
		#2. 再捕捉状态变量初始化语句
		stateVarStateList = list()
		for state in self.findASTNode(self.json, "name", "VariableDeclaration"):
			sPos, ePos = self.srcToPos(state["src"])
			#[bug fix 2020/11/10] 不处理mapping变量
			if state["attributes"]["type"].find(MAPPING_FLAG) != -1:
				continue
			if self.containEqu(sPos, ePos) == False:
				continue
			#首先看是不是声明状态变量
			#[bug fix　2020/11/10] 不对constant变量进行处理，constant不初始化就报错
			if state["attributes"]["stateVariable"] ==  BOOL_TRUE_FLAG and state["attributes"]["storageLocation"] == DEFAULT_FLAG and state["attributes"]["constant"] == BOOL_FALSE_FLAG:
				#然后再看是不是赋值语句
				if len(state["children"]) == 2:
					stateVarStateList.append(state)
				else:
					continue
			else:
				continue
		#3. 然后记录下赋值部分的源代码位置
		#另外一个想法，除了被赋值的部分保留，其他都不要
		for state in localVarStateList:
			#被赋值部分的源代码位置
			'''
			var = state["children"][0]
			varsPos, varePos = self.srcToPos(var["src"])
			#偏移出末尾
			varePos += 1
			'''
			#获得语句的整体位置
			statesPos, stateePos = self.srcToPos(state["src"])
			statesPos, stateePos = self.getInitPart(statesPos, stateePos)
			#现在需要被抹去(反制初始化源代码)的位置是，变量后直到赋值语句完
			injectInfo[SRC_KEY].append([statesPos, stateePos])
		for state in stateVarStateList:
			'''
			#被赋值部分的源代码位置
			var = state["children"][0]
			varsPos, varePos = self.srcToPos(var["src"])
			#偏移出末尾
			varePos += 1
			'''
			#获得语句的整体位置
			statesPos, stateePos = self.srcToPos(state["src"])
			statesPos, stateePos = self.getInitPart(statesPos, stateePos)
			#现在需要被抹去(反制初始化源代码)的位置是，变量后直到赋值语句完
			injectInfo[SRC_KEY].append([statesPos, stateePos])
		#检验一下成果
		'''
		for item in injectInfo[SRC_KEY]:
			print(item)
			print(self.sourceCode[item[0]: item[1]])
		'''
		#可以，存储
		#4. 存储结果
		if not injectInfo[SRC_KEY]:
			#没有包含自毁语句，返回false
			return False
		else:
			self.storeInjectInfo(injectInfo)
			return True

	#不行，还是用模式匹配
	def getInitPart(self, _sPos, _ePos):
		offset = self.sourceCode[_sPos: _ePos].find(EQU_FLAG)
		sPos = _sPos + offset
		return sPos, _ePos

	def removeDuplicate(self, _list):
		result = list()
		for item in _list:
			if item not in result:
				result.append(item)
			else:
				continue
		return result


	def getFuncSourceCode(self, _ast, _funcList):
		try:
			startPos, endPos = self.srcToPos(_ast["src"])
			for func in _funcList:
				sPos, ePos = self.srcToPos(func["src"])
				if sPos < startPos and ePos > endPos:
					return self.sourceCode[sPos: ePos]
				else:
					continue
		except:
			raise Exception("The function containing the assignment statement could not be found.")

	def storeInjectInfo(self, _srcList):
		try:
			resultDict = _srcList
			#保存信息
			with open(os.path.join(INJECT_INFO_PATH, self.filename.split(".")[0] + ".json"), "w", encoding = "utf-8") as f:
				json.dump(resultDict, f, indent = 1)
			#print("%s %s %s" % (info, self.filename + " target injected information...saved", end))
		except:
			#print("%s %s %s" % (bad, self.filename + " target injected information...failed", end))
			pass
			#raise Exception()

	def srcToPos(self, _src):
		temp = _src.split(":")
		return int(temp[0]), int(temp[0]) + int(temp[1])


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