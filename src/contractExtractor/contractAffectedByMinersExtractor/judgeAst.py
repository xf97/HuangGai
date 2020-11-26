#!/usr/bin/pythin
#-*- coding: utf-8 -*-

import json
import os
from colorPrint import *	#该头文件中定义了色彩显示的信息
import re

#缓存路径
CACHE_PATH = "./cache/"
#注入所需信息存储路径
INJECT_INFO_PATH = "./injectInfo/"
#目标类型列表
TARGET_TYPE_LIST = ["bytes32", "address payable", "uint256", "address"]	
#pure函数标志
PURE_FLAG = "pure"

class judgeAst:
	def __init__(self, _json, _sourceCode, _filename):
		self.cacheContractPath = "./cache/temp.sol"
		self.cacheFolder = "./cache/"
		self.json =  _json
		self.filename = _filename
		#self.DD = dataDependency(self.cacheContractPath, self.json)
		self.sourceCode = _sourceCode

	def getSourceCode(self, _contractPath):
		try:
			with open(_contractPath, "r", encoding = "utf-8") as f:
				return f.read()
		except:
			raise Exception("Failed to read cache source code.")

	#10-15 修复bug，pure函数不能读取状态，故不向pure函数中注入bug
	'''
	10-15 提高注入准确率-仔细考虑，返回uint类型的属性会返回0值吗
	会的话，跟0比较才有意义；否则，就没有
	block.difficulty-极端情况下，可能有
	block.gaslimit-极端情况下，可能有
	block.number-可能有
	block.timestamp-可能有
	所以，可以认定即使跟0比较也是准确注入
	'''
	def run(self):
		#首先，记录pure函数的src位置
		pureFuncSrcList = list()
		for func in self.findASTNode(self.json, "name", "FunctionDefinition"):
			if func["attributes"]["stateMutability"] == PURE_FLAG:
				startPos, endPos = self.srcToPos(func["src"])
				pureFuncSrcList.append([startPos, endPos])
		ifStatementList = list()
		#键-源代码起始位置
		#值-源代码起始位置、终止位置、类型
		injectInfo = dict()
		for ast in self.findASTNode(self.json, "name", "IfStatement"):
			try:
				if ast["children"][0]["attributes"]["commonType"]["typeString"] in TARGET_TYPE_LIST:
					#如果是目标类型，那么寻找第一个比较变量的源代码位置，并且记录类型
					_1stChild = ast["children"][0]["children"][0]
					_1stChildType = ast["children"][0]["attributes"]["commonType"]["typeString"]
					startPos, endPos = self.srcToPos(_1stChild["src"])
					#如果是pure函数中的目标语句，则不记录
					if self.isPureIfStatement(pureFuncSrcList, startPos, endPos):
						continue
					else:
						injectInfo[startPos] = [startPos, endPos, _1stChildType]
					#print(self.srcToPos(_1stChild["src"]))
				else:
					continue
			except:
				continue
		if not injectInfo:
			return False
		else:
			#保存注入信息
			self.storeInjectInfo(injectInfo)
			return True

	def isPureIfStatement(self, _funcList, _sPos, _ePos):
		for item in _funcList:
			if item[0] < _sPos and item[1] > _ePos:
				return True
			else:
				continue
		return False

	def storeInjectInfo(self, _injectAst):
		try:
			#保存信息
			with open(os.path.join(INJECT_INFO_PATH, self.filename.split(".")[0] + ".json"), "w", encoding = "utf-8") as f:
				json.dump(_injectAst, f, indent = 1)
			#print("%s %s %s" % (info, self.filename + " target injected information...saved", end))
		except:
			#print("%s %s %s" % (bad, self.filename + " target injected information...failed", end))
			pass


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

	#该函数用于判断给定的assignment的ast中的一个参数有外部给定
	#未使用
	def aNumProvideByExter(self, _ast):
		if not _ast:
			return False
		return True

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