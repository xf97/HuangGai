#!/usr/bin/python
#-*- coding: utf-8 -*-

import subprocess

#外部可见性标志
EXTERNAL_FLAG = "external"
#公共可见性标志
PUBLIC_FLAG = "public"
#uint256标志
UINT256_FLAG = "uint256"
#等于号标志
EQU_FLAG = "="

class dataDependency:
	def __init__(self, _contractPath, _jsonAst):
		self.contractPath = _contractPath
		self.jsonAst = _jsonAst
		self.idDict = dict()

	def getIdList(self):
		#1. 找到所有的public/external函数
		#初始化函数集合
		initFuncList = list()
		for func in self.findASTNode(self.jsonAst, "name", "FunctionDefinition"):
			if func["attributes"]["visibility"] == EXTERNAL_FLAG or func["attributes"]["visibility"] == PUBLIC_FLAG:
				initFuncList.append(func)
		#2. 找到这些函数的参数中的uint256型参数，将它们加入到idList中
		for func in initFuncList:
			paraList = self.findASTNode(func, "name", "ParameterList")
			newIdList = list()
			for paras in paraList:
				try:
					for para in paras["children"]:
						if para["attributes"]["type"] == UINT256_FLAG:
							self.idDict[para["id"]] = para["attributes"]["name"]
							newIdList.append(para["id"])
						else:
							continue
				except:
					continue
			'''
			assignList = list()
			for assign in self.findASTNode(func, "name", "Assignment"):
				if assign["attributes"]["operator"] == EQU_FLAG and assign["attributes"]["type"] == UINT256_FLAG:
			'''
		#print(self.idDict)
		return self.idDict.keys()
		#3. 在本函数中寻找所有与这些参数有关的uint256变量，然后将它们加入到idList中
		#4. 根据生成的函数调用流图，在本函数及函数后续调用的函数中，寻找受本函数这些变量影响的变量，并将它们加入到idList中
		#self.getAllFuncCallGraph()
		#5. 返回idList

	def getAllFuncCFG(self):
		#打印的输出地点在本地
		try:
			subprocess.run("slither  " + self.contractPath + " --print cfg", check = True, shell = True)
		except:
			print("Failed to generate control flow graph.")

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

