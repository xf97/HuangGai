#!/usr/bin/pythin
#-*- coding: utf-8 -*-

import json
import os
from colorPrint import *	#该头文件中定义了色彩显示的信息
import re
import subprocess
import copy

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
REPLACE_VISIBILITY_FLAG = "replaceVisibility"
#bug记录标志（执行后续标记）
LABEL_BUG_FLAG = "labelBug"
#构造函数标志
CONSTRUCTOR_FLAG = "constructor"

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
				#要求函数不能是构造函数
				if func["attributes"]["kind"] != CONSTRUCTOR_FLAG:
					targetFuncAstList.append(func)
				else:
					continue
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
		#[bug fix]　查看所有的状态变量，如果该变量在任意时刻的类型是外部的，那么就应该剔除该变量
		externalPattern = re.compile(r"(\b)(external)(\b)")
		temp = copy.deepcopy(stateVarList)
		for item in temp:
			#首先获得所有的访问
			accessVarList = self.findASTNode(self.json, "referencedDeclaration", item[0])
			#然后进入到每个访问的类型中，查看有无external标志
			for accessVar in accessVarList:
				varType = accessVar["type"]
				if externalPattern.search(varType):
					#存在，移除本目标
					stateVarList.remove(item)
					break
				else:
					continue
		#3. 然后进入到每个函数中，找寻有无对状态变量的访问操作　
		for func in targetFuncAstList:
			for var in stateVarList:
				accessVarList = self.findASTNodeAttr(func, "referencedDeclaration", var[0])
				if not accessVarList:
					continue
				else:
					#print(var[0] == 2963)
					#找到了，分语句记录表达式位置　
					#首先记录变量声明的位置
					injectInfo[SRC_KEY].append([var[1], var[2], REPLACE_VISIBILITY_FLAG])
					#然后进入到每个变量访问位置，找到最后的换行福，标记bug
					for var in accessVarList:
						_, varEpos =  self.srcToPos(var["src"])
						#根据变量的访问位置，向后找到换行符号
						while self.sourceCode[varEpos] != "\n":
							varEpos += 1
						#记录
						injectInfo[SRC_KEY].append([varEpos, varEpos, LABEL_BUG_FLAG])
		#4. 去重，复合元素类型没办法set
		temp = copy.deepcopy(injectInfo[SRC_KEY])
		injectInfo[SRC_KEY].clear()
		for item in temp:
			if item not in injectInfo[SRC_KEY]:
				injectInfo[SRC_KEY].append(item)
			else:
				continue
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
		externalPattern = re.compile(r"(\b)(external)(\b)")
		if type(_ast) != list:
			queue = [_ast]
		result = list()
		literalList = list()
		while len(queue) > 0:
			data = queue.pop()
			for key in data:
				try:
					if key == "attributes" and data[key][_attr] == _value:
						#获得其类型
						varType = data[key]["type"]
						#其类型中不能有external属性
						if not externalPattern.search(varType):
							result.append(data)
						else:
							continue
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