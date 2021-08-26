#!/usr/bin/python
#-*- coding:utf-8 -*-

'''
根本宗旨-给定文件夹和注入的bug类型
自动吊起SolidiFI进行注入
'''

import os	#获取文件
import subprocess	#拉起进程
import time	#记录注入耗时
from rich import progress
import re
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

#驱动SolidiFI命令
RUN_SOLIDIFU_COMMAND = "python3 solidifi.py -i"

#要自动适配solc版本
def changeSolcVersion(_sourceCode):
	pragmaPattern = re.compile(r"(\b)pragma(\s)+(solidity)(\s)*(.)+?(;)")
	lowVersionPattern = re.compile(r"(\b)(\d)(\.)(\d)(.)(\d)+(\b)")
	pragmaStatement_mulLine = pragmaPattern.search(_sourceCode, re.S)	#匹配多行
	pragmaStatement_sinLine = pragmaPattern.search(_sourceCode)	#匹配多行 
	pragmaStatement = pragmaStatement_sinLine if pragmaStatement_sinLine else pragmaStatement_mulLine #优先使用单行匹配
	defaultSolc = "0.5.12"
	#如果存在声明
	if pragmaStatement:
		#抽取出最低版本
		solcVersion = lowVersionPattern.search(pragmaStatement.group())
		#print("solcVersion", solcVersion)
		if solcVersion:
			defaultSolc = solcVersion.group()
	#否则使用默认声明
	try:
		subprocess.run("solc use " + defaultSolc, check = True, shell = True, stdout = subprocess.PIPE, stderr = subprocess.PIPE)	#切换版本	
		print("当前编译器版本: ", defaultSolc)			
	except Exception as e:
		#切换编译器失败，则终止运行
		print(e)
		raise Exception("Failed to switch the solc version.")

#给定文件夹参数和bug类型
def runSolidiFI(_folderPath, _buyType):
	startTime = time.time()
	#首先获取所有的合约路径
	localPath = os.getcwd()	#获得本地路径
	solList = [file for file in os.listdir(_folderPath) if file.endswith(".sol")]
	solList = [os.path.join(_folderPath,file) for file in solList]
	successNum = 0
	#然后调用进程
	for sol in progress.track(solList, description = "注入进度"):
		try:
			#读取源代码
			sourceCode = open(sol, "r", encoding = "utf-8").read()
			changeSolcVersion(sourceCode)	#调整编译器版本
			subprocess.run(" ".join([RUN_SOLIDIFU_COMMAND, str(sol), str(_buyType)]), check = True, shell = True, stdout = subprocess.PIPE, stderr = subprocess.PIPE)
			successNum += 1
		except Exception as e:
			print(e)
			continue
	endTime = time.time()
	print("需要被注入的合约总数: ", len(solList))
	print("成功注入的合约总数: ", successNum)
	print("注入耗时: ", endTime - startTime)



runSolidiFI("./TOD", "TOD")
