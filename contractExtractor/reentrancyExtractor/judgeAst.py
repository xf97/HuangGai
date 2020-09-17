#!/usr/bin/python
#-*- coding: utf-8 -*-

'''
该部分程序通过解析合约编译产生的json_ast文件，
来判断合约是否满足以下三个标准:
#hiding
'''

'''
关键问题：合约继承怎么处理
通过观察合约编译产生的jsonAst(eg., testCase/testInherance.sol)发现
编译后的jsonAst文件并不会将基类的代码体现在子类的编译结果中，因此当需要考虑
如果子类合约中不包含我们需要确定的语句，但基类中却包含怎么办
更进一步想，如果靠近子类的不带有需求语句的基类合约覆盖了带有需求语句的
基类合约那该如何处理？　
'''

'''
哪些东西会被继承？或者说，可以被子类使用的基类资源是哪些？
non-private资源，那么我们仅考虑搜查以下两类资源：
1.　状态变量
2.　函数定义(FunctionDefinition)
'''

'''
如果在一群继承合约中，存在一个“孤立”的合约（即，不参与继承的合约）；或在一个文件中存在多路互相独立的继承流，如何处理？
将继承基类合约最多的子类合约作为主合约
'''

'''
如何区分多态函数？
使用函数签名－即FunctionSelector区分函数
但后返回的合约中的同FunctionSelector函数中没有需求语句，但先返回的合约中的同FunctionSelector函数中有时
不计入统计
'''

#WARNING
'''
部分函数有“函数选择器”值，但部分函数没有，这些函数之间并没有明显地差异，这令人费解?
稳妥的解决方法，用命令"solc --hashes myContract.sol -o ."
'''

CALL_FLAG = 1
PAYABLE_FLAG = 2
MAPPING_FLAG = 3

import json
from inherGraph import inherGraph #该库接收jsonAst，按线性继承顺序，从最上层基类到最底层子类的顺序返回每个"ContractDefinition"的jsonAst
import subprocess
import os


class judgeAst:
	def __init__(self, _json):
		self.cacheContractPath = "./cache/temp.sol"
		self.cacheFolder = "./cache/"
		self.json =  _json
		self.inherGraph = inherGraph(_json)
		self.callTransferSendFlag = False
		self.payableFlag = False
		self.mapping = False
		#该列表每个元素的存储结构是(函数签名，包含的语句类型)
		self.funcHashAndItsStatement = list()
		self.contractAndItsHashes = dict()

	#该函数用于生成每个合约中每个函数的函数选择器值
	def getFuncHash(self):
		try:
			#生成哈希签名
			compileResult = subprocess.run("solc --hashes " + self.cacheContractPath + " -o .", check = True, shell = True)
			#获取保存哈希值的文件名
			hashFileName = [filename for filename in os.listdir(self.cacheFolder) if filename.split(".")[1] == "signatures"]
			#打开每个文件，读取每个函数的哈希值，保存为字典
			#key为合约名，元素[0]是函数名，元素[1]是函数选择器值
			#最后与要清空cache文件夹


	def run(self):
		for contractAst in self.inherGraph.astList():
			#如果有在上层捕获的函数，那么就应该在本层删除同函数签名的函数
			if len(self.funcHashAndItsStatement) > 0:
				self.polymorphism(contractAst, self.funcHashAndItsStatement)
			if self.etherOutStatement(contractAst)[0]:
				self.funcHashAndItsStatement.extend(self.etherOutStatement(contractAst)[1])
			if self.payableFunc(contractAst)[0]:
				self.funcHashAndItsStatement.extend(self.payableFunc(contractAst)[1])
			if self.mappingState(contractAst)[0]:
				self.funcHashAndItsStatement.extend(self.mappingState(contractAst)[1])
		'''
		if len(self.funcHashAndItsStatement) < 3:
			return False
		'''
		#遍历结束，检查结果
		for item in self.funcHashAndItsStatement:
			if self.callTransferSendFlag and self.payableFlag and self.mapping:
				return True
			if item[1] == MAPPING_FLAG:
				self.mapping = True
			elif item[1] == CALL_FLAG:
				self.callTransferSendFlag = True
			elif item[1] == PAYABLE_FLAG:
				self.payableFlag = True
		#print(self.callTransferSendFlag, self.payableFlag, self.mapping)
		return self.callTransferSendFlag and self.payableFlag and self.mapping

	def polymorphism(self, _ast, _list):
		funcList = self.findASTNode(_ast, "name", "FunctionDefinition")
		signatureList = [item[0] for item in _list]	#构建上层已有的函数签名列表
		for func in funcList:
			#构造函数没有FunctionSelector
			if func["attributes"]["kind"] == "function":
				#很奇怪
				signature  = func["attributes"]["functionSelector"]
				if signature in signatureList:
					#找到下层的复写了上层的函数，就从上层的列表中删除这一项
					for i in range(0, len(_list)):
						if i[0] == signature:
							_list.pop(i)	#按索引删除元素
							break
				else:
					continue
			else:
				continue


	def etherOutStatement(self, _ast):
		result = list()
		memberList = self.findASTNode(_ast, "name", "MemberAccess")
		funcList = self.findASTNode(_ast, "name", "FunctionDefinition")
		for item in memberList:
			if item["attributes"]["member_name"] == "transfer" and item["attributes"]["type"] == "function (uint256)":
				#找到使用transfer
				#现在去找外层的FunctionDefinition
				signature = self.getMemberTypeSig(item, funcList)
				result.append((signature, CALL_FLAG))
			if item["attributes"]["member_name"] == "send" and item["attributes"]["type"] == "function (uint256) returns (bool)":
				#找到使用send
				signature = self.getMemberTypeSig(item, funcList)
				result.append((signature, CALL_FLAG))
			if item["attributes"]["member_name"] == "value" and item["attributes"]["type"] == "function (uint256) pure returns (function (bytes memory) payable returns (bool,bytes memory))":
				if item["children"][0]["attributes"]["member_name"] == "call" and item["children"][0]["attributes"]["type"] == "function (bytes memory) payable returns (bool,bytes memory)":
					signature = self.getMemberTypeSig(item, funcList)
					result.append((signature, CALL_FLAG))
		if len(result) > 0:
			return True, result
		else:
			return False, list()

	def getMemberTypeSig(self, _item, _list):
		#根据源代码的包含关系来判断语句属于哪个函数
		startPos, endPos = self.srcToPos(_item["src"])
		for func in _list:
			funcSPos, funcEPos = self.srcToPos(func["src"])
			if startPos > funcSPos and endPos < funcEPos:
				return func["attributes"]["functionSelector"]


	#传入：657:17:0
	#传出：657, 674
	def srcToPos(self, _src):
		temp = _src.split(":")
		return int(temp[0]), int(temp[0]) + int(temp[1])

	def payableFunc(self, _ast):
		result = list()
		payableList = self.findASTNode(_ast, "name", "FunctionDefinition")
		funcList = payableList[:]
		for item in payableList:
			if item["attributes"]["stateMutability"] == "payable":
				#如果是payable函数，特殊处理
				if item["attributes"]["kind"] == "fallback":
					signature = "fallback"
				else:
					signature = item["attributes"]["functionSelector"]
				result.append((signature, PAYABLE_FLAG))
		if len(result) > 0:
			return True, result
		else:
			return False, list()

	def mappingState(self, _ast):
		result = list()
		varList = self.findASTNode(_ast, "name", "VariableDeclaration")
		for item in varList:
			if item["attributes"]["stateVariable"] == True and item["attributes"]["type"] == "mapping(address => uint256)":
				result.append((-1, MAPPING_FLAG))
		if len(result) > 0:
			return True, result
		else:
			return False, result


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
		

