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
#无上限标志
UNLIMITED_FLAG = "^"
#结尾分号标志
FENHAO_FLAG = ";"


'''
要求捕捉到所有的版本指定语句
记录源代码位置，和替换版本语句
'''

class judgeAst:
	def __init__(self, _json, _sourceCode, _filename, _solcVersion):
		self.cacheContractPath = "./cache/temp.sol"
		self.cacheFolder = "./cache/"
		self.json =  _json
		self.filename = _filename
		self.sourceCode = _sourceCode
		self.solcVersion = _solcVersion

	def run(self):
		injectInfo = dict()
		injectInfo[SRC_KEY] =  list()
		#组合替换语句
		injectState = UNLIMITED_FLAG + self.solcVersion + FENHAO_FLAG
		#1. 捕捉所有的版本标识语句, 如果没有直接false
		pragmaFlag = False
		pragmaPattern = re.compile(r"(pragma)(\s)+(solidity)(\s)+")
		for pragma in self.findASTNode(self.json, "name", "PragmaDirective"):
			#有相关语句，先置位flag
			pragmaFlag = True
			#用正则表达式
			#[attention] 此处的ePos包含分号
			sPos, ePos = self.srcToPos(pragma["src"])
			#语句
			state = self.sourceCode[sPos: ePos]
			#拿出不需要的位置
			_, versionSpos = pragmaPattern.search(state).span()
			#记录替换位置
			injectInfo[SRC_KEY].append([sPos + versionSpos, ePos,injectState])
			#print(self.sourceCode[sPos + versionSpos:ePos])
		#没有版本指定语句直接再见
		if not pragmaFlag:
			return False
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