#!/usr/bin/python
#-*- coding: utf-8 -*-

'''
此文件用于从数据集中抽取可能包含或可以注入的
浪费的合约bug
的合约
'''

'''
抽取标准：
1. 可能考虑多态
2. 最终的函数要有转钱出去的语句，必须是外部可以调用的　
3. 记录使用的身份验证或者直接把(require/assert或者牵扯到msg.sender/tx.origin)这些语句的位置记录下来
换个思路－是不是插入语句更稳妥
'''

'''
bug标记在转出钱的语句位置
'''

import sys
import os
from random import randint
import re
import subprocess	#使用subprocess的popen，该popen是同步IO的
from colorPrint import *	#该头文件中定义了色彩显示的信息
from judgeAst import judgeAst #该头文件用于判断合约的ast中是否存在所需特征
import json
from shutil import rmtree
import time #计时模块


#源代码数据存储位置
SOURCE_CODE_PATH = "../../contractSpider/contractCodeGetter/sourceCode"
SOURCE_CODE_PREFIX_PATH = "../../contractSpider/contractCodeGetter/sourceCode"
#测试时源代码存储位置
TESTCASE_PATH = "./testCase/"
#结果存储位置
RESULT_PATH = "./result/"
#缓存路径
CACHE_PATH = "./cache/"

class wastefulContractsExtractor:
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
		self.maxIndex = 100	#数据集合约数量
		try:
			os.mkdir(CACHE_PATH)	#建立缓存文件夹
		except:
			#print("The cache folder already exists.")
			pass

	def preFilter(self, _sourceCode):
		#因为数据集中大部分合约都是0.4版本的，不支持，为了加快抽取效率，添加前置过滤器
		unsupportedPattern = re.compile(r"(\b)pragma(\s)+solidity(\s)+0(\.)4(\.)")
		if unsupportedPattern.search(self.cleanComment(_sourceCode)):
			#如果合约中包含使用0.4版本的solidity，就直接不抽取
			return False
		return True

	def inStandardVersion(self, _nowVersion):
		standardList = ["0.5.0", "0.5.1", "0.5.2", "0.5.3", "0.5.4", "0.5.5", "0.5.6", "0.5.7", "0.5.8", "0.5.9", "0.5.10", "0.5.11", "0.5.12", "0.5.13", "0.5.14", "0.5.15", "0.5.16", "0.5.17" \
		               "0.6.0", "0.6.1", "0.6.2", "0.6.3", "0.6.4", "0.6.5", "0.6.6", "0.6.7", "0.6.8", "0.6.9", "0.6.10", "0.6.11", "0.6.12"]
		return _nowVersion in standardList


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

	def extractContracts(self):
		startTime = time.time()
		contractNum = 0
		#当符合条件的合约数量不满足需求时，继续抽取
		while self.nowNum < self.needs and  contractNum < self.maxIndex:
			contractNum += 1
			try:
				#拿到一个合约及其源代码
				(sourceCode, prevFileName) = self.getSourceCode()
				if not self.preFilter(sourceCode):
					#前置过滤器
					continue
				print("\r\t   Extracting contract: ", prevFileName, end = "")
				#将当前合约暂存
				self.cacheContract(sourceCode)
				#调整本地编译器版本
				self.changeSolcVersion(sourceCode)			
				#编译生成当前合约的抽象语法树(以json_ast形式给出)
				jsonAst = self.compile2Json()
				#根据合约文件本身、抽象语法树来判断该合约是否符合标准
				if self.judgeContract(os.path.join(self.cacheContractPath), jsonAst, sourceCode, prevFileName) == True:
					#符合标准，加１，写入数据文件
					self.nowNum += 1 
					#将暂存文件及其JsonAst文件转移到结果保存文件中
					self.storeResult(prevFileName)
					#显示进度　
					#print("\r%s当前抽取进度: %.2f%s" % (blue, self.nowNum / self.needs, end))
					#清空缓存数据
					rmtree(CACHE_PATH)
					#重新建立文件夹
					os.mkdir(CACHE_PATH)
				else:
					#self.nowNum += 1
					continue
			except Exception as e:
				#self.nowNum += 1
				#print("%s %s %s" % (bad, e, end))
				continue
		print()
		endTime = time.time()
		#print(endTime - startTime)
		#print(contractNum)
		'''
		if self.nowNum >= self.needs:
			print("Complete the extraction.")
		if self.index >= self.maxIndex:
			print("The data set lacks a sufficient number of contracts that meet the extraction criteria.")
		return
		'''

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
		if self.maxIndex == 100:
			self.maxIndex = len(solList)
		index = randint(0, len(solList) - 1)
		#index = self.index
		try:
			#拼接绝对路径
			sourceCode = open(os.path.join(SOURCE_CODE_PREFIX_PATH, solList[index]), "r", encoding = "utf-8").read()
			#sourceCode = open(os.path.join(TESTCASE_PATH, "assertMIss.sol"), "r", encoding = "utf-8").read()
			#[bug fix]清洗合约中的多字节字符，保证编译结果不错误
			sourceCode = self.cleanMultibyte(sourceCode)
			#sourceCode = open(os.path.join(RESULT_PATH, solList[index]), "r", encoding = "utf-8").read()
			return sourceCode, solList[index]   #"assertMIss.sol" 
		except:
			#无法获取源代码，则引发异常
			raise Exception("Unable to obtain source code " + solList[index])

	#清洗合约源代码中的多字节字符
	def cleanMultibyte(self, _sourceCode):
		result = str()
		for char in _sourceCode:
			if len(char) == len(char.encode()):
				result += char 
			else:
				result += "1"
		return result
		

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
			if self.inStandardVersion(self.defaultSolc):
				#self.defaultSolc >= self.minSolc and self.defaultSolc <= self.maxSolc:
				#在本机支持的solc版本范围内
				compileResult = subprocess.run("solc use " + self.defaultSolc, check = True, shell = True, stdout = subprocess.PIPE, stderr = subprocess.PIPE)	#切换版本				
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
			subprocess.run("solc --ast-json --overwrite " + self.cacheContractPath + " -o " + self.cacheJsonAstPath, check = True, shell = True, stdout = subprocess.PIPE, stderr = subprocess.PIPE)
			with open(self.cacheJsonAstPath + self.cacheJsonAstName, "r", encoding = "utf-8") as f:
				compileResult = f.read()
			return json.loads(compileResult)
		except:
			raise Exception("Failed to compile the contract.")

	#已经实现
	def judgeContract(self, _contractPath, _jsonAst, _sourceCode, _filename):
		simpleJudge = judgeAst(_jsonAst, _sourceCode, _filename)
		if not simpleJudge.run():
			#如果不符合标准（简单标准），则返回False
			return False
		return True

	def storeResult(self, _filename):
		try:
			#使用cp命令拷贝两份结果
			desCode = os.path.join(RESULT_PATH, _filename)
			#若文件存在，则不覆盖　
			if os.path.exists(os.path.join(desCode)):
				raise Exception("The result already exists.")
			desJsonAst = os.path.join(RESULT_PATH, _filename + "_json.ast")
			#执行拷贝，显示详细信息
			codeExecuteResult = subprocess.run("cp " + self.cacheContractPath + " " + desCode, check = True, shell = True, stdout = subprocess.PIPE, stderr = subprocess.PIPE)
			astExecuteResult = subprocess.run("cp " + self.cacheJsonAstPath + self.cacheJsonAstName + " " + desJsonAst, check = True, shell = True, stdout = subprocess.PIPE, stderr = subprocess.PIPE)
			return
		except:
			raise Exception("Failed to store the result.")


#单元测试
if __name__ == "__main__":
	#从命令行参数处接收需求数量
	userNeed = sys.argv[1]
	wce = wastefulContractsExtractor(int(userNeed))
	wce.extractContracts()