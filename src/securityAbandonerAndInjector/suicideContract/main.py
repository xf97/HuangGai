#!/usr/bin/python
#-*- coding: utf-8 -*-

#cache路径
CACHE_PATH = "./cache/"
#缓存合约路径
CACHE_CONTRACT_PATH = "./cache/temp.sol"
#缓存路径信息文件
CACHE_PATHINFO_PATH = "./cache/temp_sol.json"
#缓存抽象语法树文件
CACHE_AST_PATH = "./cache/temp.sol_json.ast"
#源代码保存路径
CONTRACT_PATH = "../../contractExtractor/suicideContractExtractor/result"
#注入信息保存路径
INJECT_INFO_PATH = "../../contractExtractor/suicideContractExtractor/injectInfo"
#sol文件后缀
SOL_SUFFIX = ".sol"
#json.ast文件后缀
JSON_AST_SUFFIX = "_json.ast"

from suicideContractInjector import suicideContractInjector	#注入器
import os
import time

class suicideContract:
	def __init__(self, _injectInfo, _contractPath):
		self.injectInfo = _injectInfo	#所有文件的路径信息情况
		self.targetInfoFile = self.targetPathInfo(self.injectInfo)
		self.targetContract = self.targetContractList(self.targetInfoFile, _contractPath)	#合约列表
		self.targetAstFile = self.targetAstList(self.targetInfoFile, _contractPath)	#ast列表
		self.nowNum = 0
		try:
			os.mkdir(CACHE_PATH)	#建立缓存文件夹
		except:
			#print("The cache folder already exists.")
			pass

	def targetAstList(self, _fileList, _contractPath):
		result = list()
		for filename in _fileList:
			jsonAstName = os.path.splitext(os.path.split(filename)[1])[0] + SOL_SUFFIX + JSON_AST_SUFFIX
			result.append(os.path.join(_contractPath, jsonAstName))
		return result

	def targetContractList(self, _fileList, _contractPath):
		result = list()
		for filename in _fileList:
			contractName = os.path.splitext(os.path.split(filename)[1])[0] + SOL_SUFFIX
			result.append(os.path.join(_contractPath, contractName))
		return result

	def targetPathInfo(self, _pathInfo):
		fileList = os.listdir(_pathInfo)
		result = list()
		for item in fileList:
			result.append(os.path.join(_pathInfo, item))
		return result

	def getInfoFile(self, _contractName, _infoFileList):
		preName = os.path.splitext(os.path.split(_contractName)[1])[0]
		for file in _infoFileList:
			if preName in file:
				return file
			else:
				continue
		return str()

	def getAstFile(self, _contractName, _astFileList):
		preName = os.path.splitext(os.path.split(_contractName)[1])[0]
		for file in _astFileList:
			if preName in file:
				return file
			else:
				continue
		return str()

	def cacheFile(self, _contract, _pathInfo, _astPath):
		try:
			with open(CACHE_CONTRACT_PATH, "w+", encoding = "utf-8") as f:
				f.write(open(_contract).read())
			with open(CACHE_PATHINFO_PATH, "w+",  encoding = "utf-8") as f:
				f.write(open(_pathInfo).read())
			with open(CACHE_AST_PATH, "w+",  encoding = "utf-8") as f:
				f.write(open(_astPath).read())
			return
		except:
			raise Exception("Failed to cache contract.")

	#修改合约，注意对msg.data.length的审核
	def run(self):
		sTime = time.time()
		contractNum = 0
		for contractFile in self.targetContract:
			contractNum += 1
			try:
				#1. 获取每个合约的源代码, ast和注入信息
				#contractFile = os.path.join(CONTRACT_PATH, "testCase.sol")
				pathInfoFile = self.getInfoFile(contractFile, self.targetInfoFile)
				astFile = self.getAstFile(contractFile, self.targetAstFile)
				print("\r\t   Injecting contract: ", os.path.split(contractFile)[1], end = "")
				#2. 缓存当前文件
				self.cacheFile(contractFile, pathInfoFile, astFile)
				#3. 根据目标路径和源代码注入bug
				SI = suicideContractInjector(CACHE_CONTRACT_PATH, CACHE_PATHINFO_PATH, astFile, self.getOriginalContractName(contractFile))
				SI.inject()
				SI.output()
				#4. 输出进度
				self.nowNum += 1
				#print("\r当前注入进度: %.2f" % (self.nowNum / len(self.targetContract)))
			except Exception as e:
				self.nowNum += 1
				#print(e)
				continue
		print()
		#print(time.time() - sTime)
		#print(contractNum)

	def getOriginalContractName(self, _contractPath):
		return os.path.splitext(os.path.split(_contractPath)[1])[0]

#单元测试
if __name__ == "__main__":
	sc = suicideContract(INJECT_INFO_PATH, CONTRACT_PATH)
	sc.run()

