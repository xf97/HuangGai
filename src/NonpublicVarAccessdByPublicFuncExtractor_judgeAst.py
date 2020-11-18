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
#公共可见性标志
PUBLIC_FLAG =  "public"
#变量声明标志（执行替换）
#to do
#bug记录标志（执行后续标记）
#to do

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
		#1. 捕捉所有的external和public函数
		targetFuncAstList = list()
		for func in self.findASTNode(self.json, "name", "FunctionDefinition"):
			if (func["attributes"]["visibility"] == EXTERNAL_FLAG or func["attributes"]["visibility"] == PUBLIC_FLAG) and func["attributes"]["implemented"] ==  True:
				#找到，外部可见性和公共可见性函数
				#进入到函数中，找到对函数变量的修改语句
				targetFuncAstList.append(func)
			else:
				continue
		#2. 收集所有的状态变量的id和声明位置
		stateVarList = list()
		for var in self.findASTNode(self.json, "name", "VariableDeclaration"):
			if var["attributes"]["stateVariable"] == True:
				startPos, endPos = self.srcToPos(var["src"])
				stateVarList.append([var["id"], startPos, endPos])
			else:
				continue
		#3. 收集所有的表达式语句和变量声明语句的位置
		stateExpSrcList = list()
		for state in self.findASTNode(self.json, "name", "ExpressionStatement"):
			sPos, ePos = self.srcToPos(state["src"])
			stateExpSrcList.append([sPos, ePos])
		for state in self.findASTNode(self.json, "name", "VariableDeclarationStatement"):
			sPos, ePos = self.srcToPos(state["src"])
			if [sPos, ePos] not in stateExpSrcList:
				stateExpSrcList.append([sPos, ePos])
			else:
				continue
		#4. 然后进入到每个函数中，找寻有无对状态变量的访问操作　
		for func in targetFuncAstList:
			for var in stateVarList:
				accessVarList = self.findASTNode(func, "referencedDeclaration", var[0])
				if not accessVarList:
					continue
				else:
					#找到了，分语句记录表达式位置　
					#首先记录变量声明的位置

		return True
		'''
		#3. 存储结果
		if injectInfo[SRC_KEY]:
			self.storeInjectInfo(injectInfo)
			return True
		else:
			return False
		'''

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
			print("%s %s %s" % (info, self.filename + " target injected information...saved", end))
		except:
			print("%s %s %s" % (bad, self.filename + " target injected information...failed", end))

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