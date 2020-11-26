#!/usr/bin/pythin
#-*- coding: utf-8 -*-

import json
import os
from colorPrint import *	#该头文件中定义了色彩显示的信息
import re
import subprocess

'''
抽取标准是-判断合约是否满足ERC20标准
具体做法是-基于OpenZeppelin的IERC20.sol中定义的函数和事件，要求
单个合约中(而不是文件级别)同时存在这些函数和事件(函数的名字都不能变)
'''

#缓存路径
CACHE_PATH = "./cache/"
#注入所需信息存储路径
INJECT_INFO_PATH = "./injectInfo/"
#合约属性标志
CONTRACT_FLAG = "contract"
#布尔真值标志
BOOL_TRUE_FLAG = True 
#布尔假值标志
BOOL_FALSE_FLAG = False
#函数类型标志
FUNCTION_FLAG = "function"
#外部可见性标志
EXTERNAL_FLAG = "external"
#VIEW标志
VIEW_FLAG = "view"
#totalSupply字符串
TOTAL_SUPPLY_STR = "totalSupply"
#balanceOf字符串
BALANCE_OF_STR = "balanceOf"
#transfer字符串
TRANSFER_STR = "transfer"
#allowance字符串
ALLOWANCE_STR = "allowance"
#approve字符串
APPROVE_STR = "approve"
#transferFrom字符串
TRANSFER_FROM_STR = "transferFrom"
#参数列表标志
PARA_LIST_FLAG = "ParameterList"
#uint256标志
UINT256_FLAG = "uint256"
#bool标志
BOOL_FLAG = "bool"
#地址类型标志
ADDRESS_FLAG = "address"
#Transfer标志
EVENT_TRANSFER_FLAG = "Transfer"
#Approval标志
EVENT_APPROVAL_FLAG = "Approval"


class judgeAst:
	def __init__(self, _json, _sourceCode, _filename):
		self.cacheContractPath = "./cache/temp.sol"
		self.cacheFolder = "./cache/"
		self.json =  _json
		self.filename = _filename
		self.sourceCode = _sourceCode

	def run(self):
		idList = list()	#存储approve函数id的列表，应该只能长度为1
		#核心任务就一个，判断合约是否满足ERC20标准
		#不能是接口，必须要实现这些函数
		#是通过源代码还是抽象语法树? 还是抽象语法树准确一点
		#1. 拿到所有全部实现了的合约
		contractList = list()	#实现了的合约列表 
		for contract in self.findASTNode(self.json, "name", "ContractDefinition"):
			if contract["attributes"]["contractKind"] == CONTRACT_FLAG and contract["attributes"]["fullyImplemented"] == BOOL_TRUE_FLAG:
				contractList.append(contract)
			else:
				continue
		#2. 进入每个合约，看每个函数是否符合标准
		#满足抽取标准的合约实在太少，弱化抽取标准
		for contract in contractList:
			#换一个合约就重新声明一次
			funcFlag = self.judgeFunc(contract)
			eventFlag = self.judgeEvent(contract)
			#如果符合标准，就记录approve函数的id
			if funcFlag and eventFlag:
				idList.append(self.getApproveId(contract))
			else:
				continue
		#3. 存储信息
		if not idList:
			return False
		else:
			idDict = dict()
			idDict["approveId"] = idList
			self.storeInjectInfo(idDict)
			return True

	def getApproveId(self, _contractAst):
		for func in self.findASTNode(_contractAst, "name", "FunctionDefinition"):
			if self.getApprove(func):
				#捕获approve函数
				return func["id"]
			else:
				continue
		return -1


	#判断单个合约内是否存在所有需求的事件
	def judgeEvent(self, _contractAst):
		#TransferFlag = False
		ApprovalFlag = False
		for event in self.findASTNode(_contractAst, "name", "EventDefinition"):
			'''
			if not TransferFlag:
				TransferFlag = self.getTransferEvent(event)
			'''
			if not ApprovalFlag:
				ApprovalFlag = self.getApprovalEvent(event)
		return ApprovalFlag


	#单个合约是否存在所有需求的事件
	def getTransferEvent(self, _eventAst):
		if _eventAst["attributes"]["name"] != EVENT_TRANSFER_FLAG:
			return False
		#参数
		paraList = _eventAst["children"][0]	#参数列表
		if paraList["name"] != PARA_LIST_FLAG:
			return False
		if len(paraList["children"]) != 3:
			#有三个参数
			return False
		if paraList["children"][0]["attributes"]["type"] != ADDRESS_FLAG and paraList["children"][0]["attributes"]["indexed"] != BOOL_TRUE_FLAG:
			#参数为address类型和uint256类型
			return False
		if paraList["children"][1]["attributes"]["type"] != ADDRESS_FLAG and paraList["children"][1]["attributes"]["indexed"] != BOOL_TRUE_FLAG:
			#参数为address类型和uint256类型
			return False
		if paraList["children"][2]["attributes"]["type"] != UINT256_FLAG and paraList["children"][2]["attributes"]["indexed"] != BOOL_FALSE_FLAG:
			#参数为address类型和uint256类型
			return False
		return True

	#单个合约是否存在所有需求的事件
	def getApprovalEvent(self, _eventAst):
		if _eventAst["attributes"]["name"] != EVENT_APPROVAL_FLAG:
			return False
		#参数
		paraList = _eventAst["children"][0]	#参数列表
		if paraList["name"] != PARA_LIST_FLAG:
			return False
		if len(paraList["children"]) != 3:
			#有三个参数
			return False
		if paraList["children"][0]["attributes"]["type"] != ADDRESS_FLAG and paraList["children"][0]["attributes"]["indexed"] != BOOL_TRUE_FLAG:
			#参数为address类型和uint256类型
			return False
		if paraList["children"][1]["attributes"]["type"] != ADDRESS_FLAG and paraList["children"][1]["attributes"]["indexed"] != BOOL_TRUE_FLAG:
			#参数为address类型和uint256类型
			return False
		if paraList["children"][2]["attributes"]["type"] != UINT256_FLAG and paraList["children"][2]["attributes"]["indexed"] != BOOL_FALSE_FLAG:
			#参数为address类型和uint256类型
			return False
		return True


	#判断单个合约内是否存在所有需求的函数
	def judgeFunc(self, _contractAst):
		#totalSupplyFlag = False
		#balanceOfFlag = False
		#transferFlag = False
		#allowanceFlag = False
		approveFlag = False
		#transferFromFlag = False
		for func in self.findASTNode(_contractAst, "name", "FunctionDefinition"):
			if not approveFlag:
				approveFlag = self.getApprove(func)
			'''
			if not totalSupplyFlag:
				totalSupplyFlag = self.getTotalSupply(func)
			if not balanceOfFlag:
				balanceOfFlag = self.getBalanceOf(func)
			if not transferFlag:
				transferFlag = self.getTransfer(func)
			if not allowanceFlag:
				allowanceFlag = self.getAllowance(func)
			if not transferFromFlag:
				transferFromFlag = self.getTransferFrom(func)
			'''
		#六个函数同时存在才返回True
		return approveFlag
		#return totalSupplyFlag and balanceOfFlag and transferFlag and allowanceFlag and approveFlag and transferFromFlag

	def getTotalSupply(self, _funcAst):
		if _funcAst["attributes"]["kind"] != FUNCTION_FLAG:
			return False
		if _funcAst["attributes"]["name"] != TOTAL_SUPPLY_STR:
			return False
		if _funcAst["attributes"]["visibility"] != EXTERNAL_FLAG:
			return False
		if _funcAst["attributes"]["stateMutability"] != VIEW_FLAG:
			return False
		paraList = _funcAst["children"][0]	#参数列表
		if paraList["name"] != PARA_LIST_FLAG:
			return False
		if len(paraList["children"]) != 0:
			#无参数
			return False
		returnValue = _funcAst["children"][1] #返回值
		if len(returnValue["children"]) != 1:
			#有一个返回值
			return False
		if returnValue["children"][0]["attributes"]["type"] != UINT256_FLAG:
			#返回值为uint256类型
			return False
		#通过层层筛选，找到目标函数
		return True

	def getBalanceOf(self, _funcAst):
		if _funcAst["attributes"]["kind"] != FUNCTION_FLAG:
			return False
		if _funcAst["attributes"]["name"] != BALANCE_OF_STR:
			return False
		if _funcAst["attributes"]["visibility"] != EXTERNAL_FLAG:
			return False
		if _funcAst["attributes"]["stateMutability"] != VIEW_FLAG:
			return False
		paraList = _funcAst["children"][0]	#参数列表
		if paraList["name"] != PARA_LIST_FLAG:
			return False
		if len(paraList["children"]) != 1:
			#有一个参数
			return False
		if paraList["children"][0]["attributes"]["type"] != ADDRESS_FLAG:
			#参数为address类型
			return False		
		returnValue = _funcAst["children"][1] #返回值
		if len(returnValue["children"]) != 1:
			#有一个返回值
			return False
		if returnValue["children"][0]["attributes"]["type"] != UINT256_FLAG:
			#返回值为uint256类型
			return False
		#通过层层筛选，找到目标函数
		return True

	def getTransfer(self, _funcAst):
		if _funcAst["attributes"]["kind"] != FUNCTION_FLAG:
			return False
		if _funcAst["attributes"]["name"] != TRANSFER_STR:
			return False
		if _funcAst["attributes"]["visibility"] != EXTERNAL_FLAG:
			return False
		paraList = _funcAst["children"][0]	#参数列表
		if paraList["name"] != PARA_LIST_FLAG:
			return False
		if len(paraList["children"]) != 2:
			#有两个参数
			return False
		if paraList["children"][0]["attributes"]["type"] != ADDRESS_FLAG and paraList["children"][1]["attributes"]["type"] != UINT256_FLAG:
			#参数为address类型和uint256类型
			return False
		returnValue = _funcAst["children"][1] #返回值
		if len(returnValue["children"]) != 1:
			#有一个返回值
			return False
		if returnValue["children"][0]["attributes"]["type"] != BOOL_FLAG:
			#返回值为bool类型
			return False
		#通过层层筛选，找到目标函数
		return True

	def getAllowance(self, _funcAst):
		if _funcAst["attributes"]["kind"] != FUNCTION_FLAG:
			return False
		if _funcAst["attributes"]["name"] != ALLOWANCE_STR:
			return False
		if _funcAst["attributes"]["visibility"] != EXTERNAL_FLAG:
			return False
		if _funcAst["attributes"]["stateMutability"] != VIEW_FLAG:
			return False
		paraList = _funcAst["children"][0]	#参数列表
		if paraList["name"] != PARA_LIST_FLAG:
			return False
		if len(paraList["children"]) != 2:
			#有两个参数
			return False
		if paraList["children"][0]["attributes"]["type"] != ADDRESS_FLAG and paraList["children"][1]["attributes"]["type"] != ADDRESS_FLAG:
			#参数为address类型和uint256类型
			return False
		returnValue = _funcAst["children"][1] #返回值
		if len(returnValue["children"]) != 1:
			#有一个返回值
			return False
		if returnValue["children"][0]["attributes"]["type"] != UINT256_FLAG:
			#返回值为bool类型
			return False
		#通过层层筛选，找到目标函数
		return True

	def getApprove(self, _funcAst):
		if _funcAst["attributes"]["kind"] != FUNCTION_FLAG:
			return False
		if _funcAst["attributes"]["name"] != APPROVE_STR:
			return False
		if _funcAst["attributes"]["visibility"] != EXTERNAL_FLAG:
			return False
		paraList = _funcAst["children"][0]	#参数列表
		if paraList["name"] != PARA_LIST_FLAG:
			return False
		if len(paraList["children"]) != 2:
			#有两个参数
			return False
		if paraList["children"][0]["attributes"]["type"] != ADDRESS_FLAG and paraList["children"][1]["attributes"]["type"] != UINT256_FLAG:
			#参数为address类型和uint256类型
			return False
		returnValue = _funcAst["children"][1] #返回值
		if len(returnValue["children"]) != 1:
			#有一个返回值
			return False
		if returnValue["children"][0]["attributes"]["type"] != BOOL_FLAG:
			#返回值为bool类型
			return False
		#通过层层筛选，找到目标函数
		return True

	def getTransferFrom(self, _funcAst):
		if _funcAst["attributes"]["kind"] != FUNCTION_FLAG:
			return False
		if _funcAst["attributes"]["name"] != TRANSFER_FROM_STR:
			return False
		if _funcAst["attributes"]["visibility"] != EXTERNAL_FLAG:
			return False
		paraList = _funcAst["children"][0]	#参数列表
		if paraList["name"] != PARA_LIST_FLAG:
			return False
		if len(paraList["children"]) != 3:
			#有两个参数
			return False
		if paraList["children"][0]["attributes"]["type"] != ADDRESS_FLAG and paraList["children"][1]["attributes"]["type"] != ADDRESS_FLAG and paraList["children"][2]["attributes"]["type"] != UINT256_FLAG:
			#参数为address类型和uint256类型
			return False
		returnValue = _funcAst["children"][1] #返回值
		if len(returnValue["children"]) != 1:
			#有一个返回值
			return False
		if returnValue["children"][0]["attributes"]["type"] != BOOL_FLAG:
			#返回值为bool类型
			return False
		#通过层层筛选，找到目标函数
		return True

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


	def storeInjectInfo(self, _injectInfo):
		try:
			#保存信息
			with open(os.path.join(INJECT_INFO_PATH, self.filename.split(".")[0] + ".json"), "w", encoding = "utf-8") as f:
				json.dump(_injectInfo, f, indent = 1)
			#print("%s %s %s" % (info, self.filename + " target injected information...saved", end))
		except:
			#print("%s %s %s" % (bad, self.filename + " target injected information...failed", end))
			pass

	def findASTNode(self, _ast, _name, _value):
		queue = [_ast]
		result = list()
		literalList = list()
		while len(queue) > 0:
			data = queue.pop()
			for key in data:
				if key == _name and  data[key] == _value:
					result.append(data)
				elif type(data[key]) == dict:
					queue.append(data[key])
				elif type(data[key]) == list:
					for item in data[key]:
						if type(item) == dict:
							queue.append(item)
		return result

	#传入：657:17:0
	#传出：657, 674
	def srcToPos(self, _src):
		temp = _src.split(":")
		return int(temp[0]), int(temp[0]) + int(temp[1])