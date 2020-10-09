#!/usr/bin/pythin
#-*- coding: utf-8 -*-

import json
import os
from colorPrint import *	#该头文件中定义了色彩显示的信息

#缓存路径
CACHE_PATH = "./cache/"
#注入所需信息存储路径
INJECT_INFO_PATH = "./injectInfo/"
#等于符号
EQU_FLAG = "="
#uint256标志
UINT256_FLAG = "uint256"
#SafeMath标志
SAFEMATH_FLAG = "SAFEMATH"
#库类型标志
LIBRARY_FLAG = "library"
#add函数名标志
ADD_STR_FLAG = "add"
#sub函数名标志
SUB_STR_FLAG = "sub"

class judgeAst:
	def __init__(self, _json, _filename):
		self.cacheContractPath = "./cache/temp.sol"
		self.cacheFolder = "./cache/"
		self.json =  _json
		self.filename = _filename

	def run(self):
		assignmentAst = self.findASTNode(self.json, "name", "Assignment")
		weNeedAst = list()
		safeMathFuncIdList = self.getSafeMath()
		useIdList = list()
		if len(safeMathFuncIdList) == 0:
			#没有使用safemath, 不通过筛选
			return False
		for ast in assignmentAst:
			try:
				if ast["attributes"]["operator"] == EQU_FLAG and ast["attributes"]["type"] == UINT256_FLAG:
					children0 = ast["children"][0]
					children1 = ast["children"][1]
					if children0["attributes"]["type"] != UINT256_FLAG or children1["attributes"]["type"] != UINT256_FLAG:
						continue
					else:
						subChildren0 = children1["children"][0]
						subChildren1 = children1["children"][1]
						if subChildren1["attributes"]["type"] == UINT256_FLAG and subChildren0["attributes"]["referencedDeclaration"] in safeMathFuncIdList:
							#找到了使用safemath的add/sub进行操作的，三个操作数都是uint256的ast
							useIdList.append(subChildren0["attributes"]["referencedDeclaration"])
							weNeedAst.append(ast)
						else:
							continue
				else:
					continue
			except:
				continue
		if len(weNeedAst) > 0:
			#存储注入bug时需要的信息
			self.storeInjectInfo(weNeedAst, useIdList)
			return True
		else:
			return False

	def storeInjectInfo(self, _astList, _idList):
		try:
			srcList = list()
			for ast in _astList:
				srcList.append(self.srcToPos(ast["src"]))
			#去重
			srcList	= list(set(srcList))
			idList = list(set(_idList))
			resultDict = dict()
			resultDict["idList"] = idList
			resultDict["srcList"] = srcList
			#保存信息
			with open(os.path.join(INJECT_INFO_PATH, self.filename.split(".")[0] + ".json"), "w", encoding = "utf-8") as f:
				json.dump(resultDict, f, indent = 1)
			print("%s %s %s" % (info, self.filename + " target injected information...saved", end))
		except:
			print("%s %s %s" % (bad, self.filename + " target injected information...failed", end))
			#raise Exception()

	def srcToPos(self, _src):
		temp = _src.split(":")
		return int(temp[0]), int(temp[0]) + int(temp[1])


	def getSafeMath(self):
		safeMathAst = dict()
		for ast in self.findASTNode(self.json, "name", "ContractDefinition"):
			if ast["attributes"]["name"].upper() == SAFEMATH_FLAG and ast["attributes"]["contractKind"] == LIBRARY_FLAG:
				safeMathAst = ast
				break
			else:
				continue
		subId = list()
		if len(safeMathAst.keys()) == 0:
			return list()
		#用id来指明函数调用
		for func in self.findASTNode(safeMathAst, "name", "FunctionDefinition"):
			if func["attributes"]["name"].lower() == SUB_STR_FLAG or func["attributes"]["name"].lower() == ADD_STR_FLAG:
				subId.append(func["id"])
			else:
				continue
		return subId

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