#!/usr/bin/python
#-*- coding: utf-8 -*-

import sys
import os
from random import randint
import re
import subprocess	#使用subprocess的popen，该popen是同步IO的
from colorPrint import *	#该头文件中定义了色彩显示的信息
from judgeAst import judgeAst #该头文件用于判断合约的ast中是否存在三个较为简单的特征

#源代码数据存储位置
SOURCE_CODE_PATH = "../../contractSpider/contractCodeGetter/sourceCode"
SOURCE_CODE_PREFIX_PATH = "../../contractSpider/contractCodeGetter/sourceCode"
#结果存储位置
RESULT_PATH = "./result/"

'''
本机支持的solc范围从: 0.4.0-0.7.1
'''


class reentrancyExtractor:
	#默认每次的抽取输出是100
	def __init__(self, _needsNum = 100):
		self.needs = _needsNum
		self.nowNum = 0
		self.cacheContractPath = "./cache/temp.sol" 
		self.cacheJsonAstPath = "./cache/"	#默认json_ast存储名: json_ast
		self.cacheJsonAstName = "temp.sol_json.ast"
		self.defaultSolc = "0.6.0"	#默认使用的solc编译版本
		self.maxSolc = "0.7.1" #最高被支持的solc版本，合约使用的solc版本高于此版本时，引发异常
		self.minSolc = "0.4.0"	#最低被支持的solc版本

	def extractContracts(self):
		#当符合条件的合约数量不满足需求时，继续抽取
		while self.nowNum < self.needs:
			try:
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
					print("\r%s当前抽取进度: %.2f%s" % (blue, self.nowNum / self.needs, end) )
				else:
					continue
			except Exception as e:
				print("%s %s %s" % (bad, e, end))
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
		#print(index, solList[index])
		#index = 2
		try:
			#拼接绝对路径
			sourceCode = open(os.path.join(SOURCE_CODE_PREFIX_PATH, solList[index]), "r", encoding = "utf-8").read()
			return sourceCode, solList[index]
		except:
			#无法获取源代码，则引发异常　
			#sys.exit(0)
			raise Exception("Unable to obtain source code " + solList[index])
		

	def changeSolcVersion(self, _sourceCode):
		#首先明确－如果合约内存在多个solc版本语句，则只不处理该合约
		#要考虑多种情况，1-pragma solidity 0.5.0
		#2-pragma solidity ^0.5.0
		#3-pragma solidity >=0.5.0 <0.6.0
		#考虑的思路是-使用正则表达式从pragma solidity直接提取到;
		#然后再取第一个的数字
		pragmaPattern = re.compile(r"(\b)pragma(\s)+(solidity)(.)+?(;)")
		lowVersionPattern = re.compile(r"(\b)(\d)(\.)(\d)(.)(\d)+(\b)")
		#print("2.1")
		#再考虑，万一没有声明呢？则默认，考虑使用0.6.0作为默认值吧
		if len(pragmaPattern.findall(_sourceCode)) > 1:
			raise Exception("Multiple pragma solidity statements.")
		#print(2.2)
		pragmaStatement = pragmaPattern.search(_sourceCode, re.S)	#允许匹配多行
		#print(2.3)
		#print("pragmaStatement", pragmaStatement)
		#如果存在声明
		if pragmaStatement:
			#抽取出最低版本
			solcVersion = lowVersionPattern.search(pragmaStatement.group())
			#print("solcVersion", solcVersion)
			if solcVersion:
				self.defaultSolc = solcVersion.group()
		#否则使用默认声明
		#print(self.defaultSolc)
		try:
			if self.defaultSolc >= self.minSolc and self.defaultSolc <= self.maxSolc:
				#print("xixixix")
				#在本机支持的solc版本范围内
				compileResult = subprocess.run("solc use " + self.defaultSolc, check = True, shell = True)	#切换版本
				#print("lalala")
				#print(compileResult.read())
			else:
				#如果超出本机支持的solc范围，则引发异常
				#print("Use unsupported solc version.")
				raise Exception("Use unsupported solc version.")
		except Exception as e:
			#切换编译器失败，则终止运行
			print(e)
			return
			#sys.exit(0)

	def cacheContract(self, _sourceCode):
		try:
			with open(self.cacheContractPath, "w+", encoding = "utf-8") as f:
				f.write(_sourceCode)
			return
		except:
			raise Exception("Failed to cache contract.")

	def compile2Json(self):
		try:
			compileResult = subprocess.run("solc --ast-json --overwrite " + self.cacheContractPath + " -o " + self.cacheJsonAstPath, check = True, shell = True)
		except:
			raise Exception("Failed to compile the contract.")

	def judgeContract(self, _sourceCode, _jsonAst):
		simpleJudge = judgeAst(_jsonAst)
		if not simpleJudge.run():
			#如果不符合标准（简单标准），则返回False
			return False
		#关键函数，正在实现
		return True

	def storeResult(self, _filename):
		try:
			#使用cp命令拷贝两份结果
			desCode = os.path.join(RESULT_PATH, _filename)
			desJsonAst = os.path.join(RESULT_PATH, _filename + "_json.ast")
			#执行拷贝，显示详细信息
			codeExecuteResult = subprocess.run("cp -v " + self.cacheContractPath + " " + desCode, check = True, shell = True)
			astExecuteResult = subprocess.run("cp -v " + self.cacheJsonAstPath + self.cacheJsonAstName + " " + desJsonAst, check = True, shell = True)
			return
		except:
			raise Exception("Failed to store the result.")


#单元测试
if __name__ == "__main__":
	ree = reentrancyExtractor(10)
	ree.extractContracts()