#!/usr/bin/pythin
#-*- coding: utf-8 -*-

import json
import os
from colorPrint import *	#该头文件中定义了色彩显示的信息
import re
import subprocess

#缓存路径
CACHE_PATH = "./cache/"
#注入所需信息存储路径
INJECT_INFO_PATH = "./injectInfo/"
#注入信息源代码键值
SRC_KEY = "srcPos"
#外部可见性标志
EXTERNAL_FLAG = "external"
#fallback函数标志
FALLBACK_FLAG = "fallback"
#receive函数标志
RECEIVE_FLAG = "receive"

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
		#1. 捕捉所有的external函数，但是不要fallback函数
		externalFuncAstList = list()
		for func in self.findASTNode(self.json, "name", "FunctionDefinition"):
			if func["attributes"]["visibility"] == EXTERNAL_FLAG and func["attributes"]["implemented"] ==  True and func["attributes"]["kind"] != FALLBACK_FLAG and func["attributes"]["kind"] != RECEIVE_FLAG:
				#找到，外部函数
				#[bug fix] 有calldata类型参数的函数不加入
				#[bug fix] func["children"][0]也不一定是参数列表
				#由于calldata只能用于修饰参数，所以在整个函数ast内搜索也是可以的
				#paraList = func["children"][0]
				#判断有无callData类型的参数
				if not self.findASTNode(func, "storageLocation", "calldata"):
					#只有不包含calldata类型参数，才加入
					externalFuncAstList.append(func)
				else:
					continue
			else:
				continue
		#2. 确定external关键字的位置，利用external是保留字的特性(不允许出现(\b)external(\b)的变量命名)
		externalPattern = re.compile(r"(\b)(external)(\b)")
		for func in externalFuncAstList:
			startPos, endPos = self.srcToPos(func["src"])
			funcSourceCode = self.sourceCode[startPos: endPos]
			startOffset, endOffset = externalPattern.search(funcSourceCode).span()
			#找到位置，记录
			injectInfo[SRC_KEY].append([startPos + startOffset, startPos + endOffset])
		#3. 存储结果
		if injectInfo[SRC_KEY]:
			self.storeInjectInfo(injectInfo)
			return True
		else:
			return False

	def getExpStatePos(self):
		expPosList = list()
		for exp in self.findASTNode(self.json, "name", "ExpressionStatement"):
			sPos, ePos = self.srcToPos(exp["src"])
			expPosList.append([sPos, ePos])
		return expPosList

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

	#传入：657:17:0
	#传出：657, 674
	def srcToPos(self, _src):
		temp = _src.split(":")
		return int(temp[0]), int(temp[0]) + int(temp[1])