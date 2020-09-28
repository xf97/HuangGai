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
from colorPrint import *	#该头文件中定义了色彩显示的信息
from pydot import io 	#该头文件用来读取.dot文件
import re

#缓存路径
#进行抽取时，合约仍然存于cache文件夹中
CACHE_PATH = "./cache/"
#终端输出记录文件
TERMINAL_FILE = "log.txt"

#图文件后缀
DOT_SUFFIX = ".dot"
#有向边标志　
EDGE_FLAG = " -> "
#payable函数标志
PAYABLE_FLAG = "payable"
#构造函数标志
CONSTRUCTOR_FLAG = "constructor"
#回退函数标志
FALLBACK_FLAG = "fallback"
#账本类型标志
MAPPING_FLAG = "mapping(address => uint256)"
#dot中cluster标志
CLUSTER_FLAG = "cluster_"
#dot中label标志
LABEL_FLAG = "[label="
#UINT256标志
UINT256_FLAG = "uint256"
#加等于标志
ADD_EQU_FLAG = "+="
#等于标志
EQU_FLAG = "="
#加标志
ADD_FLAG = "+"
#SafeMath标志
SAFEMATH_FLAG = "SAFEMATH"
#库类型标志
LIBRARY_FLAG = "library"
#add函数名标志
ADD_STR_FLAG = "add"


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
		#print(self.contractPath)
		self.inherGraph = inherGraph(_json)
		self.targetContractName = self.getMainContract()
		self.json = _json
		self.receiveEthPath = list()
		self.sendEthPath = list()
		try:
			#如果存在log.txt，则删除已存在的log.txt
			if os.path.exists(os.path.join(CACHE_PATH, TERMINAL_FILE)):
				os.remove(os.path.join(CACHE_PATH, TERMINAL_FILE))
			#启动脚本，记录终端输出　
			#compileResult = subprocess.run("script -f " + TERMINAL_FILE, check = True, shell = True)
			print(compileResult.read())
		except:
			print("Failed to record terminal output.")


	def getMainContract(self):
		return self.inherGraph.getMainContractName()

	def run(self):
		#第一步，应该是生成合约所有函数的CFG
		#因为slither的此功能故障，因此暂时失效此功能
		#self.getAllFuncCFG()
		#第二步，产生函数间的调用图（可能跨合约）
		self.getAllFuncCallGraph()
		#第三步，根据合约的CFG和函数调用图，尝试组合出所有路径
		#3.1 构造函数调用关系图
		self.getCallGraphDot()
		#3.2 寻找以payable函数为起点的函数调用路径，寻找其中增值的mapping变量
		increaseLedger = self.findLedger(self.funcCallGraph)
		#3.3 寻找路径 ，其中存在对增值mapping变量减值的操作，并且有.transfer/.send/.call.value语句
		#最好能够保存减值操作和传输语句的相对位置（或许能够以调用链中的偏移量来记录），结果记录在出钱语句中
		decreseLedger = self.outOfEther(self.funcCallGraph, increaseLedger)
		#清除生成的缓存资料
		self.deleteDot()
		if len(ledgerName) == 0:
			return False
		return True
		'''
		不可用，slither的contract-summary并不准确
		#1. 使用Slither生成contract-summary, slither将生成每个子类合约的合约总结
		compileResult = subprocess.run("slither " + _contractPath + " --print human-summary", check = True, shell = True)
		#2. 读取log.txt，判断主合约是否具有收取以太币、发送以太币的功能，有的话返回True
		return self.findTargetFeatures(self.contractName)
		'''

	#待实现
	def outOfEther(self, _callGraph, _ledger):
		ledgerId = [int(name.split(".")[1]) for name in _ledger]	#获取账本的id
		decreaseLedger = list()
		for path in _callGraph:
			#检查每条路径
			(ledger, ledgerIndex) = self.findDecreseLedger(path, ledgerId)
			(sendEth, sendEthIndex) = self.findsendEth(path)
			if ledgerIndex == -1 or sendEthIndex == -1:
				continue
			else:
				#找到目标路径
				self.sendEthPath.append(path)
				decreaseLedger.append(ledger)
				print(ledgerIndex, sendEthIndex)
		decreaseLedger = list(set(result))
		return decreaseLedger

	def deleteDot(self):
		pass


	def getAllFuncCFG(self):
		#打印的输出地点在本地
		try:
			subprocess.run("slither  " + self.contractPath + " --print cfg", check = True, shell = True)
		except:
			print("Failed to generate control flow graph.")

	def getAllFuncCallGraph(self):
		#打印的输出地点在本地
		try:
			subprocess.run("slither " + self.contractPath + " --print call-graph", check = True, shell = True)
		except:
			print("Failed to generate functions call-graph.")

	def getCallGraphDot(self):
		dotFileName = self.targetContractName + DOT_SUFFIX
		try:
			f =  io.open(dotFileName)
			edgeList =  list()
			self.funcCallGraph = list()
			#逐行遍历dot文件，找到所有有向边
			for line in f.readlines():
				if line.find(EDGE_FLAG) != -1:
					#找到有向边，分裂起点和终点
					edgeInfo = list()
					edgeInfo.append(line.split(EDGE_FLAG)[0])
					edgeInfo.append(line.split(EDGE_FLAG)[1][:-1]) #去掉结尾换行符
					#加入边集
					edgeList.append(edgeInfo) 
			#根据边集，拼接路径
			#我的起点是你的终点
			temp = edgeList[:]	#为防止出现问题，准备一个副本
			for edge in edgeList:
				result = edge[:]
				#两个工作，我的终点是你的起点吗，我的起点是你的终点吗
				startPos = edge[0]
				endPos = edge[1]
				for line in temp:
					if line[1] == startPos:
						#它的终点是我的起点，加入
						result.insert(0, line[0])
						#更新起点　
						startPos = line[0]
					if line[0] == endPos:
						#它的起点是我的终点，加入
						result.append(line[1])
						#更新终点
						endPos = line[1]
				#跨合约的函数调用拼接完毕
				self.funcCallGraph.append(result)
			#接下来拼接“独立”函数
			f.seek(0,0)	#回到文件开头
			startFuncList = [funcName[0]for funcName in self.funcCallGraph]
			for line in f.readlines():
				if line.find(LABEL_FLAG) != -1:
					funcName = line.split(" ")[0]
					if funcName not in startFuncList:
						self.funcCallGraph.append([funcName])
					else:
						continue
		except:
			print("Failed to read functions call-graph.")

	#待实现
	#已经实现
	def findLedger(self, _callGraph):
		#find each payable function and its contract
		#dict
		payableList = self.getPayableFunc(self.json)
		#contractName to num
		newCallGraph = self.contractNameToNum(_callGraph)
		#mapping
		mappingList = self.getMapping(self.json)
		#给定调用图、payable函数列表、mapping，寻找在以payable函数开头的路劲中，其中使用过（加过钱）的mappingAList
		increaseMapping = self.findIncreaseMapping(payableList, newCallGraph, mappingList)
		return increaseMapping

	def findIncreaseMapping(self, _payableList, _funcPath, _mappingList):
		result = list()
		for payableFunc in _payableList:
			for onePath in _funcPath:
				if onePath[0] == payableFunc:
					#找到一条路径
					if len(self.findOnePathMapping(onePath, _mappingList)):
						self.receiveEthPath.append(onePath)	#找到一条收钱路径
						result.extend(self.findOnePathMapping(onePath, _mappingList))
				else:
					continue
		result = list(set(result))
		return result

	def findOnePathMapping(self, _path, _mappingList):
		result = list()
		contractList = self.findASTNode(self.json, "name", "ContractDefinition")
		for func in _path:
			#拆分出函数名和合约名
			funcName = func.split(".")[1]
			contractName = func.split(".")[0]
			#找到合约的AST
			for contract in contractList:
				if contract["attributes"]["name"] == contractName:
					functionList = self.findASTNode(contract, "name", "FunctionDefinition")
					for oneFunc in functionList:
						if oneFunc["attributes"]["kind"] == CONSTRUCTOR_FLAG and funcName == CONSTRUCTOR_FLAG:
							#找到函数的ast
							statementList = self.findASTNode(oneFunc, "name", "Assignment")		
							result.extend(self.getMapping_addEqu(statementList, _mappingList))	
							result.extend(self.getMapping_add(statementList, _mappingList))
							result.extend(self.getMapping_SafeMathAdd(statementList, _mappingList))
						elif oneFunc["attributes"]["kind"] == FALLBACK_FLAG and funcName == FALLBACK_FLAG:
							statementList = self.findASTNode(oneFunc, "name", "Assignment")
							result.extend(self.getMapping_addEqu(statementList, _mappingList))	
							result.extend(self.getMapping_add(statementList, _mappingList))
							result.extend(self.getMapping_SafeMathAdd(statementList, _mappingList))
						elif oneFunc["attributes"]["name"] == funcName:
							statementList = self.findASTNode(oneFunc, "name", "Assignment")	
							result.extend(self.getMapping_addEqu(statementList, _mappingList))
							result.extend(self.getMapping_add(statementList, _mappingList))
							result.extend(self.getMapping_SafeMathAdd(statementList, _mappingList))
		#最后记得去重
		result = list(set(result))
		return result

	#如果该赋值语句中存在对mapping的+=操作，则返回mappingList
	def getMapping_addEqu(self, _astList, _mappingList):
		result = list()
		for _ast in _astList:
			if _ast["attributes"]["type"] == UINT256_FLAG and _ast["attributes"]["operator"] == ADD_EQU_FLAG:
				if _ast["children"][0]["attributes"]["type"] == UINT256_FLAG:
					#print("hahahah")
					#寻找id
					for ledger in _mappingList:
						_id = ledger.split(".")[1]
						if str(_id) == str(_ast["children"][0]["children"][0]["attributes"]["referencedDeclaration"]):
							#在payable起始的函数的调用序列的该赋值语句中，有对mapping(address=>uint256)的+=操作
							result.append(ledger)
						else:
							continue
				else:
					continue
			else:
				continue
		return result

	#如果该赋值语句中存在对mapping的+操作，则返回mappingList
	def getMapping_add(self, _astList, _mappingList):
		result = list()
		for _ast in _astList:
			try:
				if _ast["attributes"]["type"] == UINT256_FLAG and _ast["attributes"]["operator"] == EQU_FLAG:
					#print(_ast["attributes"])
					num = _ast["children"][0]
					operator = _ast["children"][1]
					if num["attributes"]["type"] == UINT256_FLAG and operator["attributes"]["operator"] == ADD_FLAG:
						for ledger in _mappingList:
							_id = ledger.split(".")[1]
							if str(_id) == str(num["children"][0]["attributes"]["referencedDeclaration"]):
								#在payable起始的函数的调用序列的该赋值语句中，有对mapping(address=>uint256)的+=操作
								result.append(ledger)
			except:
				continue
		return result

	#待实现
	def getMapping_SafeMathAdd(self, _astList, _mappingList):
		safeMathAst = dict()
		for ast in self.findASTNode(self.json, "name", "ContractDefinition"):
			if ast["attributes"]["name"].upper() == SAFEMATH_FLAG and ast["attributes"]["contractKind"] == LIBRARY_FLAG:
				safeMathAst = ast
				#找到safeMath的AST
				break
			else:
				continue
		addId = int()
		#用id来指明函数调用
		for func in self.findASTNode(self.json, "name", "FunctionDefinition"):
			if func["attributes"]["name"].lower() == ADD_STR_FLAG:
				addId = func["id"]
				break
			else:
				continue
		#下一步，来找调用
		result = list()
		#赋值语句的ast
		for _ast in _astList:
			try:
				if _ast["attributes"]["type"] == UINT256_FLAG and _ast["attributes"]["operator"] == EQU_FLAG:
					#print(_ast["attributes"])
					num = _ast["children"][0]
					operator = _ast["children"][1]
					if num["attributes"]["type"] == UINT256_FLAG and operator["attributes"]["type"] == UINT256_FLAG:
						mapping = num["children"][0]
						safeMathAdd = operator["children"][0]
						if safeMathAdd["attributes"]["member_name"].lower() == ADD_STR_FLAG and  safeMathAdd["attributes"]["referencedDeclaration"] == addId:
							#确定了，这一句使用safeMath库里add函数，考察接收结果的是否是我们要的结构
							for ledger in _mappingList:
								_id = ledger.split(".")[1]
								if str(_id) == str(mapping["attributes"]["referencedDeclaration"]):
									#在payable起始的函数的调用序列的该赋值语句中，有对mapping(address=>uint256)的SafeMath.add操作
									result.append(ledger)
			except:
				continue
		return result

	def contractNameToNum(self,_callGraph):
		dotFileName = self.targetContractName + DOT_SUFFIX
		#try:
		result = list()
		f = io.open(dotFileName)
		contractNameDict = dict()
		alnumPattern = re.compile("")
		for line in f.readlines():
			if line.find(CLUSTER_FLAG) != -1:
				#找到集群声明标志，拆分出编号和合约名
				try:
					temp = line.split(" ")[1]
					#下述方法不能应对合约名以下划线开头的情况，使用土办法
					num, contractName = self.splitTemp(temp)
					contractNameDict[contractName] = num
				except:
					continue
			else:
				continue
		for _list in _callGraph:
			aList = list()
			for func in _list:
				try:
					num = func.split("_")[0][1:] #1为了去掉开头的双引号
					funcName = func.split("_")[1][:-1]  #去掉尾部双引号
					for item in contractNameDict.items():
						if item[1] == num:
							temp = item[0] + "." + funcName
							aList.append(temp)
						else:
							continue
				except:
					continue
			result.append(aList)
		#print(contractNameDict)
		#print(result)
		return result

	def splitTemp(self, _str):
		result = list()
		flag = 0
		temp = str()
		for char in _str:
			if char != "_":
				temp += char
			elif char == "_" and flag < 1:
				temp = str()
				flag += 1
			elif char == "_" and flag == 1:
				result.append(temp)
				temp = str()
				flag += 1
			elif flag >= 2:
				temp += char
		result.append(temp)
		return result[0], result[1]


	def getMapping(self, _json):
		#variable声明
		mappingDict = dict()
		for ast in self.findASTNode(_json, "name", "VariableDeclaration"):
			#print(ast)
			if ast["attributes"]["type"] == MAPPING_FLAG:
				mappingName = ast["id"]
				startPos, endPos = self.srcToPos(ast["src"])
				mappingDict[mappingName] = [startPos, endPos]
		contractDict = dict()
		#dict: {合约名，[起始位置，终止位置]}
		for ast in self.findASTNode(self.json, "name", "ContractDefinition"):
			contractName = ast["attributes"]["name"]
			startPos, endPos = self.srcToPos(ast["src"])
			contractDict[contractName] = [startPos, endPos]
		#根据从属关系，拼接返回结果
		result = list()
		for mappingName in mappingDict:
			startPos, endPos = mappingDict[mappingName]
			for item in contractDict.items():
				if startPos >= item[1][0] and endPos <= item[1][1]:
					#找到合约和函数的对应关系
					temp = item[0] + "." + str(mappingName)
					result.append(temp)
					break
				else:
					continue
		return result

	def getPayableFunc(self, _json):
		contractDict = dict()
		#dict: {合约名，[起始位置，终止位置]}
		for ast in self.findASTNode(self.json, "name", "ContractDefinition"):
			contractName = ast["attributes"]["name"]
			startPos, endPos = self.srcToPos(ast["src"])
			contractDict[contractName] = [startPos, endPos]
		#payable func
		funcList = list()
		for ast in self.findASTNode(self.json, "name", "FunctionDefinition"):
			if ast["attributes"]["stateMutability"] == PAYABLE_FLAG:
				if ast["attributes"]["kind"] == CONSTRUCTOR_FLAG:
					functionName = CONSTRUCTOR_FLAG
				elif ast["attributes"]["kind"] == FALLBACK_FLAG:
					functionName = FALLBACK_FLAG
				else:
					functionName = ast["attributes"]["name"]
				startPos, endPos = self.srcToPos(ast["src"])
				#bug修复，不同合约可能有重名函数
				funcList.append([functionName, startPos, endPos])
		#根据从属关系，拼接返回结果
		result = list()
		for func in funcList:
			startPos = func[1]
			endPos = func[2]
			for item in contractDict.items():
				if startPos >= item[1][0] and endPos <= item[1][1]:
					#找到合约和函数的对应关系
					temp = item[0] + "." + func[0]
					result.append(temp)
					break
				else:
					continue
		return result #返回payable函数

	#在给定的ast中返回包含键值对"_name": "_value"的字典列表
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


		
