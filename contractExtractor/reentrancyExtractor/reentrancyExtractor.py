#!/usr/bin/python
#-*- coding: utf-8 -*-

import sys
import os
from random import randint

#源代码数据存储位置
SOURCE_CODE_PATH = "../../contractSpider/contractCodeGetter/sourceCode"
SOURCE_CODE_PREFIX_PATH = "../../contractSpider/contractCodeGetter/sourceCode"
#结果存储位置
RESULT_PATH = "./result/"


class reentrancyExtractor:
	#默认每次的抽取输出是100
	def __init__(self, _needsNum = 100):
		self.needs = _needsNum
		self.nowNum = 0
		self.cacheContractPath = "./cache/temp.sol" 
		self.cacheJsonAstPath = "./cache/temp.sol_json.ast"

	def extractContracts(self):
		#当符合条件的合约数量不满足需求时，继续抽取
		while self.nowNum < needs:
			#拿到一个合约及其源代码
			(filename, sourceCode) = self.getSourceCode()
			#将当前合约暂存
			self.cacheContract(sourceCode)
			#编译生成当前合约的抽象语法树(以json_ast形式给出)
			jsonAst = self.compile2Json()
			#根据合约文件本身、源代码、抽象语法树来判断该合约是否符合标准
			if self.judgeContract(sourceCode, jsonAst) == True:
				#符合标准，加１，写入数据文件
				self.nowNum += 1 
				#将暂存文件及其JsonAst文件转移到结果保存文件中
				self.storeResult()
			else:
				continue

	def getSourceCode(self):
		'''
		该函数从源代码数据存储位置提取
		合约的名称和源代码
		'''
		fileList = os.listdir(SOURCE_CODE_PATH)
		solList = list()
		#根据文件后缀判断文件类型
		for i in fileList:
			if i.split(".")[1] == "sol":
				#拼接绝对路径
				filePath = os.path.join(SOURCE_CODE_PREFIX_PATH, i)
				solList.append(filePath)
			else:
				continue
		#读取文件内容
		index = randint(0, len(solList))
		try:
			sourceCode = open(solList[index], "r", encoding = "utf-8").read()
		except:
			sourceCode = str()
		return solList[index], sourceCode

	def cacheContract(self, _sourceCode):
		pass


#单元测试
if __name__ == "__main__":
	re = reentrancyExtractor()
	re.getSourceCode()
		