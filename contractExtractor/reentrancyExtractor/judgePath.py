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
'''
import subprocess

class judgePath:
	def __init__(self, _contractPath):
		self.contractPath = _contractPath

	def run(self):
		#1. 判断是否存在账本变量
		ledger = self.findLedger()
		#2. 产生控制流
		return True

	def findLedger(self):
		return str()