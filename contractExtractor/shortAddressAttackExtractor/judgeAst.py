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
#外部可见性标志
EXTERNAL_FLAG = "external"
#公共可见性标志
PUBLIC_FLAG = "public"

class judgeAst:
	def __init__(self, _json, _sourceCode, _filename):
		self.cacheContractPath = "./cache/temp.sol"
		self.cacheFolder = "./cache/"
		self.json =  _json
		self.filename = _filename
		self.sourceCode = _sourceCode

	def run(self):
		#1. 获取所有的public/external函数
		funcAstList = list()
		for func in self.findASTNode(self.json, "name", "FunctionDefinition"):
			if func["attributes"]["visibility"] == EXTERNAL_FLAG or func["attributes"]["visibility"] == PUBLIC_FLAG:
				funcAstList.append(func)
		#2. 在这些函数中寻找transfer/send/call.value语句
		etherOutList = list()
		for func in funcAstList:
			statementList = list()
			accessStatement = self.findASTNode(func, "name", "MemberAccess")
			statementList.extend(self.getStatement_transfer(accessStatement))	
			statementList.extend(self.getStatement_send(accessStatement))
			statementList.extend(self.getStatement_callValue(accessStatement))

	#补足常量，适配代码
	def getStatement_transfer(self, _astList):
		result = list()
		for _ast in _astList:
			try:
				if _ast["attributes"]["member_name"] == TRANSFER_FLAG and _ast["attributes"]["referencedDeclaration"] == None:
					if _ast["children"][0]["attributes"]["type"] == ADDRESS_PAYABLE_FLAG:
						#找到在memberAccess语句中找到使用.transfer语句
						startPos, endPos = self.srcToPos(_ast["src"])
						result.append([startPos, endPos])
					else:
						continue
				else:
					continue
			except:
				continue
		return result

	def getStatement_send(self, _astList):		
		result = list()
		for _ast in _astList:
			try:
				if _ast["attributes"]["member_name"] == SEND_FLAG and _ast["attributes"]["referencedDeclaration"] == None:
					if _ast["children"][0]["attributes"]["type"] == ADDRESS_PAYABLE_FLAG:
						#找到在memberAccess语句中找到使用.send语句
						startPos, endPos = self.srcToPos(_ast["src"])
						result.append([startPos, endPos])
					else:
						continue
				else:
					continue
			except:
				continue
		return result

	def getStatement_callValue(self, _astList):
		result = list()
		for _ast in _astList:
			try:
				if _ast["attributes"]["member_name"] == VALUE_FLAG and _ast["attributes"]["referencedDeclaration"] == None:
					member = _ast["children"][0]
					if member["attributes"]["member_name"] == CALL_FLAG and member["attributes"]["referencedDeclaration"] == None:
						addressMember = member["children"][0]
						if addressMember["attributes"]["type"] == ADDRESS_PAYABLE_FLAG:
							#找到在memberAccess语句中找到使用.call.value语句
							startPos, endPos = self.srcToPos(_ast["src"])
							result.append([startPos, endPos])
						else:
							continue
					else:
						continue
				else:
					continue
			except:
				continue
		return result

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