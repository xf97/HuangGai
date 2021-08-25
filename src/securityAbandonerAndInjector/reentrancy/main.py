#!/usr/bin/python
#-*- coding: utf-8 -*-

#cache路径
CACHE_PATH = "./cache/"
#缓存合约路径
CACHE_CONTRACT_PATH = "./cache/temp.sol"
#缓存路径信息文件
CACHE_PATHINFO_PATH = "./cache/temp_sol.json"
#缓存屏蔽信息文件
CACHE_SHIELD_INFO_PATH = "./cache/tempShield_sol.json"
#中间合约路径
IR_CONTRACT_PATH = "./tempStorage/temp.sol"
#中间路径信息
IR_PATHINFO_PATH = "./tempStorage/temp_sol.json"
#路径信息保存路径
PATH_INFO_PATH = "../../contractExtractor/reentrancyExtractor/pathInfo"
#源代码保存路径
CONTRACT_PATH = "../../contractExtractor/reentrancyExtractor/result"
#sol文件后缀
SOL_SUFFIX = ".sol"
#json文件后缀
JSON_SUFFIX = ".json"
#屏蔽完成后文件保存路径
TEMP_STORAGE_PATH = "./tempStorage/"


from reentrancyAbandoner import reentrancyAbandoner	#屏蔽器
from reentrancyInjector import reentrancyInjector	#注入器
import os
import time

class reentrancy:
	def __init__(self, _infoPath, _contractPath):
		self.pathInfo = _infoPath	#所有文件的路径信息情况
		self.targetInfoFile = self.targetPathInfo(self.pathInfo)
		self.targetContract = self.targetContractList(self.targetInfoFile, _contractPath)	#路径保存信息
		self.targetShieldFile = self.targetShieldInfo(self.targetContract, _contractPath)
		self.nowNum = 0
		try:
			os.mkdir(CACHE_PATH)	#建立缓存文件夹
		except:
			#print("The cache folder already exists.")
			pass
		try:
			os.mkdir(TEMP_STORAGE_PATH)
		except:
			#print("The IR folder already exists.")
			pass

	def targetShieldInfo(self, _fileList, _contractPath):
		result = list()
		for filename in _fileList:
			infoFileName = os.path.splitext(os.path.split(filename)[1])[0] + JSON_SUFFIX
			result.append(os.path.join(_contractPath, infoFileName))
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

	def cacheFile(self, _contract, _pathInfo, _shieldPathInfo):
		try:
			with open(CACHE_CONTRACT_PATH, "w+", encoding = "utf-8") as f:
				f.write(open(_contract).read())
			with open(CACHE_PATHINFO_PATH, "w+",  encoding = "utf-8") as f:
				f.write(open(_pathInfo).read())
			with open(CACHE_SHIELD_INFO_PATH, "w+",  encoding = "utf-8") as f:
				f.write(open(_pathInfo).read())
			return
		except:
			raise Exception("Failed to cache contract.")

	def getShieldInfoFile(self, _contractName, _infoFileList):
		contractAddr = os.path.splitext(os.path.split(_contractName)[1])[0]
		for file in _infoFileList:
			if contractAddr in file:
				return file
			else:
				continue
		return str()

	def run(self):
		stime = time.time()
		contractNum = 0
		#1. 根据路径信息，提取路径信息文件和合约到缓存文件夹
		for contractFile in self.targetContract:
			contractNum += 1
			try:
				#contractFile = os.path.join(CONTRACT_PATH, "0x9bdf81e6066d32764b7e75a1b5577237e06d9364.sol")
				pathInfoFile = self.getInfoFile(contractFile, self.targetInfoFile)
				shieldInfoFile = self.getShieldInfoFile(contractFile, self.targetShieldFile)
				print("\r\t   Injecting contract: ", os.path.split(contractFile)[1], end = "")
				self.cacheFile(contractFile, pathInfoFile, shieldInfoFile)
				#2. 屏蔽目标语句
				RA = reentrancyAbandoner(CACHE_CONTRACT_PATH, CACHE_PATHINFO_PATH)
				RA.shield()
				RA.output()	
				#3. 根据目标路径，插入语句 
				RI = reentrancyInjector(IR_CONTRACT_PATH, IR_PATHINFO_PATH, shieldInfoFile, self.getOriginalContractName(contractFile))
				RI.inject()
				RI.output()
				#4. 输出进度
				self.nowNum += 1
				#print("\r当前注入进度: %.2f" % (self.nowNum / len(self.targetContract)))
			except Exception as e:
				self.nowNum += 1
				#print(bad, e, end)
				continue
			print()
			#print(time.time() - stime)
			#print(contractNum)

	def getOriginalContractName(self, _contractPath):
		return os.path.splitext(os.path.split(_contractPath)[1])[0]

		

#单元测试
if __name__ == "__main__":
	re = reentrancy(PATH_INFO_PATH, CONTRACT_PATH)
	re.run()

