#!/usr/bin/python
#-*- coding: utf-8 -*-

import sys
import os
from random import randint
import re

#源代码数据存储位置
SOURCE_CODE_PATH = "../../contractSpider/contractCodeGetter/sourceCode"
SOURCE_CODE_PREFIX_PATH = "../../contractSpider/contractCodeGetter/sourceCode"
#结果存储位置
RESULT_PATH = "./result/"

'''
本机支持的
'''


class reentrancyExtractor:
	#默认每次的抽取输出是100
	def __init__(self, _needsNum = 100):
		self.needs = _needsNum
		self.nowNum = 0
		self.cacheContractPath = "./cache/temp.sol" 
		self.cacheJsonAstPath = "./cache/temp.sol_json.ast"
		self.defaultSolc = "0.6.0"	#默认使用的solc编译版本
		self.maxSolc = "0.7.1" #最高被支持的solc版本，合约使用的solc版本高于此版本时，引发异常
		self.minSolc = "0.4.21"	#最低被支持的solc版本

	def extractContracts(self):
		#当符合条件的合约数量不满足需求时，继续抽取
		while self.nowNum < needs:
			#拿到一个合约及其源代码
			(sourceCode, prevFileName) = self.getSourceCode()
			#将当前合约暂存
			self.cacheContract(sourceCode)
			#调整本地编译器版本
			self.changeSolcVersion(sourceCode)
			#编译生成当前合约的抽象语法树(以json_ast形式给出)
			jsonAst = self.compile2Json()
			#根据合约文件本身、源代码、抽象语法树来判断该合约是否符合标准
			if self.judgeContract(sourceCode, jsonAst) == True:
				#符合标准，加１，写入数据文件
				self.nowNum += 1 
				#将暂存文件及其JsonAst文件转移到结果保存文件中
				self.storeResult(prevFileName)
				#显示进度　
				print("\r当前抽取进度: %.2f" % (self.nowNum / self.needs) )
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
				solList.append(i)
			else:
				continue
		#读取文件内容
		index = randint(0, len(solList))
		try:
			#拼接绝对路径
			sourceCode = open(os.path.join(SOURCE_CODE_PREFIX_PATH, solList[index]), "r", encoding = "utf-8").read()
		except:
			#无法获取源代码，则终止运行
			sys.exit(0)
		return sourceCode, solList[index]

	def changeSolcVersion(self, _sourceCode):
		#首先明确－如果合约内存在多个solc版本语句，则只考虑第一个声明语句
		#要考虑多种情况，1-pragma solidity 0.5.0
		#2-pragma solidity ^0.5.0
		#3-pragma solidity >=0.5.0 <0.6.0
		#考虑的思路是-使用正则表达式从pragma solidity直接提取到;
		#然后再取第一个的数字
		pragmaPattern = re.compile(r"(\b)pragma(\s)+(solidity)(.)+?(;)")
		lowVersionPattern = re.compile(r"(\b)(\d)(\.)(\d)(.)(\d)+(\b)")
		#再考虑，万一没有声明呢？则默认，考虑使用0.6.0作为默认值吧
		pragmaStatement = pragmaPattern.search(_sourceCode, re.S)	#允许匹配多行
		#如果存在声明
		if pragmaStatement:
			#抽取出最低版本
			solcVersion = lowVersionPattern.search(pragmaStatement.group())
			if solcVersion:
				self.defaultSolc = solcVersion.group()
		#否则使用默认声明
		try:
			if self.defaultSolc >= self.minSolc and self.defaultSolc <= self.maxSolc:
				#在本机支持的solc版本范围内
				print(_sourceCode)
				compileResult = os.popen("solc use " + self.defaultSolc)	#切换版本
				print(compileResult.read())
			else:
				#如果超出本机支持的solc范围，则引发异常
				raise Exception("Use unsupported solc version.")
		except:
			#切换编译器失败，则终止运行
			sys.exit(0)

	def cacheContract(self, _sourceCode):
		with open(self.cacheContractPath, "w+", encoding = "utf-8") as f:
			f.write(_sourceCode)
		return

	def compile2Json(self):
		compileResult = os.popen("solc --ast-json --pretty-json --overwrite " + self.cacheContractPath + " -o .")
		print(compileResult.read())

	def judgeContract(self, _sourceCode, _jsonAst):
		#关键函数，待实现
		return True

	def storeResult(self, _filename):
		#使用cp命令拷贝两份问卷
		desCode = os.path.join(RESULT_PATH, _filename)
		desJsonAst = os.path.join(RESULT_PATH, _filename + "_json.ast")
		#执行拷贝，显示详细信息
		codeExecuteResult = os.popen("cp -v " + self.cacheContractPath + " " + desCode)
		astExecuteResult = os.popen("cp -v " + self.cacheJsonAstPath + " " +desJsonAst)
		return


#单元测试
if __name__ == "__main__":
	ree = reentrancyExtractor()
	filename, sourceCode = ree.getSourceCode()
	ree.cacheContract(sourceCode)
	ree.changeSolcVersion(sourceCode)
	#re.compile2Json()
		