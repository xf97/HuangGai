#!/usr/bin/python
#-*- coding: utf-8 -*-

import sys
import os
from random import randint
import re
import subprocess	#使用subprocess的popen，该popen是同步IO的
from colorPrint import *	#该头文件中定义了色彩显示的信息
from judgeAst import judgeAst #该头文件用于判断合约的ast中是否存在三个较为简单的特征
from judgePath import judgePath #该头文件用于判断合约中是否存在目标路径
import json
from shutil import rmtree

#源代码数据存储位置
SOURCE_CODE_PATH = "../../contractSpider/contractCodeGetter/sourceCode"
SOURCE_CODE_PREFIX_PATH = "../../contractSpider/contractCodeGetter/sourceCode"
#测试时源代码存储位置
TESTCASE_PATH = "./testCase/"
#结果存储位置
RESULT_PATH = "./result/"

#缓存路径
CACHE_PATH = "./cache/"

'''
本机支持的solc范围从: 0.4.0-0.7.1
'''

'''
新问题-导入合约如何编译？无法解决，本地化、大规模合约编译，根本不可能为每个合约准备它需要导入的合约
解决方案-编译出错，捕捉异常，处理下一个
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
		self.minSolc = "0.5.0"	#最低被支持的solc版本
		self.index = 0
		'''
		#try:
		compileResult = subprocess.run("ulimit -s 102400", check = True, shell = True)	#临时调整系统栈空间
		
		except:
			print("Change stack size..failed")
		'''
		try:
			os.mkdir(CACHE_PATH)	#建立缓存文件夹
		except:
			print("The cache folder already exists.")

	def extractContracts(self):
		#当符合条件的合约数量不满足需求时，继续抽取
		while self.nowNum < self.needs:
			try:
				#拿到一个合约及其源代码
				(sourceCode, prevFileName) = self.getSourceCode()
				#print(prevFileName)
				#将当前合约暂存
				self.cacheContract(sourceCode)
				#调整本地编译器版本
				self.changeSolcVersion(sourceCode)
				#编译生成当前合约的抽象语法树(以json_ast形式给出)
				jsonAst = self.compile2Json()
				#根据合约文件本身、抽象语法树来判断该合约是否符合标准
				if self.judgeContract(os.path.join(self.cacheContractPath), jsonAst, prevFileName) == True:
					#符合标准，加１，写入数据文件
					self.nowNum += 1 
					#将暂存文件及其JsonAst文件转移到结果保存文件中
					self.storeResult(prevFileName)
					#显示进度　
					print("\r%s当前抽取进度: %.2f%s" % (blue, self.nowNum / self.needs, end))
					#清空缓存数据
					rmtree(CACHE_PATH)
					#重新建立文件夹
					os.mkdir(CACHE_PATH)
				else:
					#self.nowNum += 1
					continue
			except Exception as e:
				#self.nowNum += 1
				print("%s %s %s" % (bad, e, end))
				continue

	def getSourceCode(self):
		'''
		该函数从源代码数据存储位置提取
		合约的名称和源代码
		'''
		fileList = os.listdir(SOURCE_CODE_PATH)
		#fileList = os.listdir(TESTCASE_PATH)
		#fileList  = os.listdir(RESULT_PATH)
		solList = list()
		#根据文件后缀判断文件类型
		for i in fileList:
			if i.split(".")[1] == "sol":
				solList.append(i)
			else:
				continue
		index = randint(0, len(solList) - 1)
		#index = self.index
		#print(index, solList[index])
		try:
			#拼接绝对路径
			sourceCode = open(os.path.join(SOURCE_CODE_PREFIX_PATH, solList[index]), "r", encoding = "utf-8").read()
			#sourceCode = open(os.path.join(RESULT_PATH, solList[index]), "r", encoding = "utf-8").read()
			return sourceCode, solList[index]
		except:
			#无法获取源代码，则引发异常
			self.index += 1
			raise Exception("Unable to obtain source code " + solList[index])
		

	def changeSolcVersion(self, _sourceCode):
		#首先明确－如果合约内存在多个solc版本语句，则只不处理该合约
		#变更，处理有多个solc语句的合约，使用第一个语句的版本
		#要考虑多种情况，1-pragma solidity 0.5.0
		#2-pragma solidity ^0.5.0
		#3-pragma solidity >=0.5.0 <0.6.0
		#考虑的思路是-使用正则表达式从pragma solidity直接提取到;
		#然后再取第一个的数字
		pragmaPattern = re.compile(r"(\b)pragma(\s)+(solidity)(\s)*(.)+?(;)")
		lowVersionPattern = re.compile(r"(\b)(\d)(\.)(\d)(.)(\d)+(\b)")
		pragmaStatement_mulLine = pragmaPattern.search(_sourceCode, re.S)	#匹配多行
		pragmaStatement_sinLine = pragmaPattern.search(_sourceCode)	#匹配多行 
		pragmaStatement = pragmaStatement_sinLine if pragmaStatement_sinLine else pragmaStatement_mulLine #优先使用单行匹配
		#如果存在声明
		if pragmaStatement:
			#抽取出最低版本
			solcVersion = lowVersionPattern.search(pragmaStatement.group())
			#print("solcVersion", solcVersion)
			if solcVersion:
				self.defaultSolc = solcVersion.group()
		#否则使用默认声明
		try:
			if self.defaultSolc >= self.minSolc and self.defaultSolc <= self.maxSolc:
				#在本机支持的solc版本范围内
				compileResult = subprocess.run("solc use " + self.defaultSolc, check = True, shell = True)	#切换版本				
				#print(compileResult.read())
			else:
				#如果超出本机支持的solc范围，则引发异常
				#print("Use unsupported solc version.")
				raise Exception("Use unsupported solc version.")
		except Exception as e:
			#切换编译器失败，则终止运行
			raise Exception("Failed to switch the solc version.")
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
			subprocess.run("solc --ast-json --overwrite " + self.cacheContractPath + " -o " + self.cacheJsonAstPath, check = True, shell = True)
			with open(self.cacheJsonAstPath + self.cacheJsonAstName, "r", encoding = "utf-8") as f:
				compileResult = f.read()
			return json.loads(compileResult)
		except:
			raise Exception("Failed to compile the contract.")

	#已经实现
	def judgeContract(self, _contractPath, _jsonAst, _filename):
		simpleJudge = judgeAst(_jsonAst)
		if not simpleJudge.run():
			#如果不符合标准（简单标准），则返回False
			return False
		pathJudge  = judgePath(_contractPath, _jsonAst, _filename)
		if not pathJudge.run():
			return False
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
	ree = reentrancyExtractor(40)
	ree.extractContracts()