#!/usr/bin/python
#-*- coding: utf-8 -*-

'''
此文件用于从数据集中抽取可能包含或者注入后可以包含
被复杂的fallback函数Dos
的合约
'''

'''
抽取标准：
１．合约中存在fallback函数
２．fallback函数中存在transfer/call.value语句
记录整个表达式语句的位置
'''

import sys
import os
from random import randint
import re
import subprocess	#使用subprocess的popen，该popen是同步IO的
from colorPrint import *	#该头文件中定义了色彩显示的信息
import json
from shutil import rmtree
from judgeAst import judgeAst	#用于判断合约是否符合抽取标准
import time

#源代码数据存储位置
SOURCE_CODE_PATH = "../../contractSpider/contractCodeGetter/sourceCode"
SOURCE_CODE_PREFIX_PATH = "../../contractSpider/contractCodeGetter/sourceCode"
#测试时源代码存储位置
TESTCASE_PATH = "./testCase/"
#结果存储位置
RESULT_PATH = "./result/"
#缓存路径
CACHE_PATH = "./cache/"

class DosByComplexFallbackExtractor:
	def __init__(self, _needsNum = 100):
		self.needs = _needsNum
		self.nowNum = 0
		self.defaultSolc = "0.6.0"	#默认使用的solc编译版本
		self.maxSolc = "0.6.12" #最高被支持的solc版本，合约使用的solc版本高于此版本时，引发异常
		self.minSolc = "0.5.0"	#最低被支持的solc版本
		self.cacheContractPath = "./cache/temp.sol" 
		self.cacheJsonAstPath = "./cache/"	#默认json_ast存储名: json_ast
		self.cacheJsonAstName = "temp.sol_json.ast"
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
		stime = time.time()
		contractNum = 0	
		#当符合条件的合约数量不满足需求时，继续抽取
		while self.nowNum < self.needs:
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
				if self.judgeContract(jsonAst, sourceCode, prevFileName) == True:
					#将暂存文件及其JsonAst文件转移到结果保存文件中
					self.storeResult(prevFileName)
					#符合标准，加１，写入数据文件
					self.nowNum += 1 
					#显示进度　
					#print("\r%s当前抽取进度: %.2f%s" % (blue, self.nowNum / self.needs, end))
					#清空缓存数据
					rmtree(CACHE_PATH)
					#重新建立文件夹
					os.mkdir(CACHE_PATH)
				else:
					continue
			except Exception as e:
				#print("%s %s %s" % (bad, e, end))
				continue
		print()
		#print(time.time() - stime)
		#print(contractNum)

	def getSourceCode(self):
		'''
		该函数从源代码数据存储位置提取le index out of range 
		合约的名称和源代码
		'''
		fileList = os.listdir(SOURCE_CODE_PATH)
		#fileList = os.listdir(TESTCASE_PATH)
		#fileList = os.listdir(RESULT_PATH)
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
			#sourceCode = open(os.path.join(TESTCASE_PATH, "testCase.sol"), "r", encoding = "utf-8").read()
			#[bug fix]清洗合约中的多字节字符，保证编译结果不错误
			sourceCode = self.cleanMultibyte(sourceCode)
			#self.index += 1
			return sourceCode, solList[index]  
		except:
			#无法获取源代码，则引发异常
			#self.index += 1
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
				#在本机支持的solc版本范围内
				compileResult = subprocess.run("solc use " + self.defaultSolc, check = True, shell = True, stdout = subprocess.PIPE, stderr = subprocess.PIPE)	#切换版本				
				#print(compileResult.read())
			else:
				#如果超出本机支持的solc范围，则引发异常
				#print("Use unsupported solc version.")
				raise Exception("Use unsupported solc version.")
		except Exception as e:
			#切换编译器失败，则终止运行
			#print(e)
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

	#待实现
	#已经实现
	def judgeContract(self, _jsonAst, _sourceCode, _filename):
		JA = judgeAst(_jsonAst, _sourceCode, _filename)
		if not JA.run():
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
			codeExecuteResult = subprocess.run("cp " + self.cacheContractPath + " " + desCode, check = True, shell = True)
			astExecuteResult = subprocess.run("cp " + self.cacheJsonAstPath + self.cacheJsonAstName + " " + desJsonAst, check = True, shell = True)
			return
		except:
			raise Exception("Failed to store the result.")
				
if __name__ == "__main__":
	#从命令行参数处接收需求数量
	userNeed = sys.argv[1]
	dbcfe = DosByComplexFallbackExtractor(int(userNeed))
	dbcfe.extractContracts()
