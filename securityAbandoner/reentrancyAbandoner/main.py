#!/usr/bin/python
#-*- coding: utf-8 -*-

#cache路径

class reentrancyAbandoner:
	def __init__(self, _pathInfo):
		self.pathInfo = _pathInfo	#所有文件的路径信息情况
		self.targetContract = self.targetContractList(self.pathInfo)	#所有目标合约
		self.targetInfoFile = self.targetPathInfo(self.pathInfo)

	def run(self):
		#1. 根据路径信息，提取路径信息文件和合约到缓存文件夹
		for contractFile in self.targetContract:
			pathInfoFile = self.getInfoFile(self.targetInfoFile)
			self.cacheFile(contractFile, pathInfoFile)
			#2. 提取缓存文件，尝试还原路径
			pathList = self.getPartContract()
			#3. 探查路径，找到目标语句，并屏蔽他
		
