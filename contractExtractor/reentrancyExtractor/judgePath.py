#!/usr/bin/python
#-*- coding: utf-8 -*-

'''
该部分程序用于判断目标合约是否包含目标路径　
如果包含，则需要保存目标路径
'''

'''
可用工具：slither真是个宝藏工具
slither可能可用的功能：
合约各个函数的调用图
文件中各个合约的继承关系
最子类合约的构造函数执行结果
function-summary里有每个函数读写、内外部调用的总结
human-summary里有对每个合约功能的概述->可以用来判断
require显示出每个合约的每个函数中用到的require和assert
最子类合约状态变量的内存情况　
对状态变量的写入及对应的auth操作
'''
import subprocess　
import os

#缓存路径
#进行抽取时，合约仍然存于cache文件夹中
CACHE_PATH = "./cache/"
#终端输出记录文件
TERMINAL_FILE = "log.txt"

#发送以太币标志字符串
SEND_ETH_FLAG = "Send ETH"
#收取以太币标志字符串
RECEIVE_ETH_FLAG =  "Receive ETH"

'''
考虑使用slither和script
'''

class judgePath:
	def __init__(self, _contractPath, _targetContractName):
		self.contractPath = _contractPath
		self.contractName = _targetContractName
		try:
			#如果存在log.txt，则删除已存在的log.txt
			if os.path.exists(os.path.join(CACHE_PATH, TERMINAL_FILE)):
				os.remove(os.path.join(CACHE_PATH, TERMINAL_FILE))
		except:
			#不存在的话，启动脚本，记录终端输出　
			compileResult = subprocess.run("script -f " + TERMINAL_FILE, check = True, shell = True)
			print(compileResult.read())


	def run(self):
		#1. 使用Slither生成contract-summary, slither将生成每个子类合约的合约总结
		compileResult = subprocess.run("slither " + _contractPath + " --print human-summary", check = True, shell = True)
		#2. 读取log.txt，判断主合约是否具有收取以太币、发送以太币的功能，有的话返回True
		return self.findTargetFeatures(self.contractName)

	def findTargetFeatures(self, _contractName):
		#读取log.txt
		#根据主合约名字，寻找主合约的功能
		#如果主合约包含我们想要功能，就返回True
		#否则返回False