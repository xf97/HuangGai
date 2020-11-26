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
#布尔真值
BOOL_TRUE_FLAG = True
#fallback标志
FALLBACK_FLAG = "fallback"
#预备替换语句
INJECT_STATE = ".call.gas(2301).value"
#触发调用语句
CALL_CALL_STATE = "(\"\")"



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
		#1. 捕捉所有的fallback函数
		fallbackFuncAstList =  list()
		for func in self.findASTNode(self.json, "name",  "FunctionDefinition"):
			#要求函数实现
			if func["attributes"]["implemented"] == BOOL_TRUE_FLAG and func["attributes"]["kind"] == FALLBACK_FLAG:
				#捕获fallback函数
				fallbackFuncAstList.append(func)
			else:
				continue
		#2. 进入每个fallback函数中，找到transfer/send/call.value语句
		expStatePosList = self.getExpStatePos()
		#拼接出插入语句，然后记录位置
		for func in fallbackFuncAstList:
			for item in self.findASTNode(func, "name", "MemberAccess"):
				if item["attributes"]["member_name"] == "transfer" and item["attributes"]["type"] == "function (uint256)" and item["attributes"]["referencedDeclaration"] == None:
					sPos, ePos = self.srcToPos(item["src"])
					#获得接收转账的地址
					receiver = item["children"][0]
					receiverSpos, receiverEpos = self.srcToPos(receiver["src"])
					injectInfo[SRC_KEY].append([sPos, ePos, self.sourceCode[receiverSpos: receiverEpos] + INJECT_STATE])
					#[bug fix] transfer语句需要在最后补充调用语句
					#确定transfer语句结束位置
					for exp in expStatePosList:
						if exp[0] <= sPos and exp[1] >= ePos:
							#找到了，记录位置和插入语句
							injectInfo[SRC_KEY].append([exp[1], exp[1], CALL_CALL_STATE])
						else:
							continue
				#[bug fix] send语句不捕捉
				'''
				if item["attributes"]["member_name"] == "send" and item["attributes"]["type"] == "function (uint256) returns (bool)" and item["attributes"]["referencedDeclaration"] == None:
					sPos, ePos = self.srcToPos(item["src"])
					receiver = item["children"][0]
					receiverSpos, receiverEpos = self.srcToPos(receiver["src"])
					injectInfo[SRC_KEY].append([sPos, ePos, self.sourceCode[receiverSpos: receiverEpos] + INJECT_STATE])
				'''
				if item["attributes"]["member_name"] == "value" and item["attributes"]["type"] == "function (uint256) pure returns (function (bytes memory) payable returns (bool,bytes memory))" and item["attributes"]["referencedDeclaration"] == None:
					if item["children"][0]["attributes"]["member_name"] == "call" and item["children"][0]["attributes"]["type"] == "function (bytes memory) payable returns (bool,bytes memory)":
						sPos, ePos = self.srcToPos(item["src"])
						receiver = item["children"][0]["children"][0]
						receiverSpos, receiverEpos = self.srcToPos(receiver["src"])
						injectInfo[SRC_KEY].append([sPos, ePos, self.sourceCode[receiverSpos: receiverEpos] + INJECT_STATE])
					else:
						continue
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