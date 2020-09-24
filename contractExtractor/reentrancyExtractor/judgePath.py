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
human-summary里有对每个合约功能的概述->可以用来判断->不能用来判断，对于Receive ETH而言，只判断payable关键字而不判断合约是否真的可以接收以太币
require显示出每个合约的每个函数中用到的require和assert
最子类合约状态变量的内存情况　
对状态变量的写入及对应的auth操作
'''
import subprocess
import os
from inherGraph import inherGraph #该库用于返回主合约的合约名

#缓存路径
#进行抽取时，合约仍然存于cache文件夹中
CACHE_PATH = "./cache/"
#终端输出记录文件
TERMINAL_FILE = "log.txt"

#未使用　
#发送以太币标志字符串
SEND_ETH_FLAG = "Send ETH"
#收取以太币标志字符串
RECEIVE_ETH_FLAG =  "Receive ETH"

'''
考虑使用slither和script
'''

class judgePath:
	def __init__(self, _contractPath, _json):
		self.contractPath = _contractPath
		self.inherGraph = inherGraph(_json)
		self.targetContractName = self.getMainContract()
		try:
			#如果存在log.txt，则删除已存在的log.txt
			if os.path.exists(os.path.join(CACHE_PATH, TERMINAL_FILE)):
				os.remove(os.path.join(CACHE_PATH, TERMINAL_FILE))
		except:
			#不存在的话，启动脚本，记录终端输出　
			compileResult = subprocess.run("script -f " + TERMINAL_FILE, check = True, shell = True)
			print(compileResult.read())

	def getMainContract(self):
		return self.inherGraph.getMainContractName()



	def run(self):
		#第一步，应该是生成合约所有函数的CFG
		self.getAllFuncCFG()
		#第二步，产生函数间的调用图（可能跨合约）
		#self.getAllFuncCallGraph()
		#第三步，根据合约的CFG和函数调用图，尝试组合出所有路径
		return True
		'''
		不可用，slither的contract-summary并不准确
		#1. 使用Slither生成contract-summary, slither将生成每个子类合约的合约总结
		compileResult = subprocess.run("slither " + _contractPath + " --print human-summary", check = True, shell = True)
		#2. 读取log.txt，判断主合约是否具有收取以太币、发送以太币的功能，有的话返回True
		return self.findTargetFeatures(self.contractName)
		'''

	def getAllFuncCFG(self):
		print(self.targetContractName)
