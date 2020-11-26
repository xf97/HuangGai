#!/usr/bin/python
#-*- coding: utf-8 -*-

#屏蔽完成后文件保存路径
TEMP_STORAGE_PATH = "./tempStorage/"
#暂存合约名
CONTRACT_NAME = "temp.sol"
#暂存路径信息名
PATH_INFO_NAME = "temp_sol.json"

import subprocess
import os

class reentrancyAbandoner:
	def __init__(self, _contractPath, _pathInfo):
		self.contractPath = _contractPath
		self.infoPath = _pathInfo

	#暂时没有已知的针对重入的目标语句
	def shield(self):
		pass

	def output(self):
		try:
			#使用cp命令拷贝两份结果
			desCode = os.path.join(TEMP_STORAGE_PATH, CONTRACT_NAME)
			desJsonAst = os.path.join(TEMP_STORAGE_PATH, PATH_INFO_NAME)
			#执行拷贝，显示详细信息
			subprocess.run("cp " + self.contractPath + " " + desCode, check = True, shell = True)
			subprocess.run("cp " + self.infoPath + " " + desJsonAst, check = True, shell = True)
			#print("Successfully generate the IR.")
			return
		except:
			raise Exception("Failed to store the IR.")
