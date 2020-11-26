#!/usr/bin/python
#-*- coding: utf-8 -*-

CALL_FLAG = 1
PAYABLE_FLAG = 2
MAPPING_FLAG = 3

#缓存路径
CACHE_PATH = "./cache/"
#签名文件后缀
SIG_SUFFIX = ".signatures"

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
		self.payableFlag = False
		#该列表每个元素的存储结构是(函数签名，包含的语句类型)
		self.funcHashAndItsStatement = list()
		self.contractAndItsHashes = dict()
		self.getFuncHash()

	#该函数用于生成每个合约中每个函数的函数选择器值
	def getFuncHash(self):
		try:
			#生成哈希签名
			compileResult = subprocess.run("solc --hashes --overwrite " + self.cacheContractPath + " -o " + CACHE_PATH, check = True, shell = True, stdout = subprocess.PIPE, stderr = subprocess.PIPE)
			#获取保存哈希值的文件名
			hashFileName = [filename for filename in os.listdir(self.cacheFolder) if filename.split(".")[1] == "signatures"]
			#打开每个文件，读取每个函数的哈希值，保存为字典
			for file in hashFileName:
				resultList = list()
				with open(os.path.join(CACHE_PATH, file), "r", encoding = "utf-8") as f:
					for i in f.readlines():
						funcName = i.split(": ")[1][:-1]	#最后[:-1]是为了去除最后的\n
						funcName = funcName.split("(")[0]	#再切除参数列表
						signature = i.split(": ")[0]
						resultList.append([funcName, signature])
				self.contractAndItsHashes[file.split(".")[0]] = resultList
		except:
			raise Exception("Failed to generate function selector.")
		#for i in self.contractAndItsHashes:
		#	print(self.contractAndItsHashes[i])
		#key为合约名，元素[0]是函数名，元素[1]是函数选择器值
		#最后与要清空cache文件夹

	def run(self):
		'''
		for key in self.contractAndItsHashes:
			print(key, self.contractAndItsHashes[key])
		'''
		for contractAst in self.inherGraph.astList():
			#如果有在上层捕获的函数，那么就应该在本层删除同函数签名的函数
			contractName = self.getContractName(contractAst) #获取本层正在处理的合约名
			if len(self.funcHashAndItsStatement) > 0:
				self.polymorphism(contractAst, self.funcHashAndItsStatement, contractName)
			if self.payableFunc(contractAst, contractName)[0]:
				self.funcHashAndItsStatement.extend(self.payableFunc(contractAst, contractName)[1])
			'''
			if self.etherOutStatement(contractAst, contractName)[0]:
				self.funcHashAndItsStatement.extend(self.etherOutStatement(contractAst, contractName)[1])
			if self.mappingState(contractAst)[0]:
				self.funcHashAndItsStatement.extend(self.mappingState(contractAst)[1])
			'''
		#结果去重
		self.funcHashAndItsStatement =  list(set(self.funcHashAndItsStatement))
		#遍历结束，检查结果
		#print(type(self.funcHashAndItsStatement))
		for item in self.funcHashAndItsStatement:
			if item[1] == PAYABLE_FLAG:
				self.payableFlag = True
				break
		#print(self.payableFlag)
		#[code update] 通过函数的源代码位置来确定函数位置
		if self.payableFlag:
			return True, [item[2] for item in self.funcHashAndItsStatement]
		else:
			return False, list()

	#传入：合约ast
	#传出：合约名
	def getContractName(self, _ast):
		return _ast["attributes"]["name"]

	#*待修改*#
	#修改完成
	def polymorphism(self, _ast, _list, _contractName):
		#funcList = self.findASTNode(_ast, "name", "FunctionDefinition")
		thisSignatureList = self.getAContractSig(_contractName)	#该函数用于读取本层合约中所有的函数签名
		upperSignatureList = [item[0] for item in _list]	#构建上层已有的函数签名列表
		result = list()
		popIndex = list()
		for index in range(0, len(_list)):
			if _list[index][0] in thisSignatureList:
				popIndex.append(index)
		for index in range(0, len(_list)):
			if index in popIndex:
				continue
			else:
				result.append(_list[index])
		_list = result[:]



	def getAContractSig(self, _contractName):
		'''
		print(self.contractAndItsHashes[_contractName])
		print("*" * 30)
		for i in self.contractAndItsHashes[_contractName]:
			print(i[1])
		'''
		signatureList = list()
		for record in self.contractAndItsHashes[_contractName]:
			signatureList.append(record[1])
		return signatureList
		#return [signature for signature in self.contractAndItsHashes[_contractName][1]]

	def etherOutStatement(self, _ast, _contractName):
		result = list()
		memberList = self.findASTNode(_ast, "name", "MemberAccess")
		funcList = self.findASTNode(_ast, "name", "FunctionDefinition")
		for item in memberList:
			if item["attributes"]["member_name"] == "transfer" and item["attributes"]["type"] == "function (uint256)":
				#找到使用transfer
				#现在去找外层的FunctionDefinition
				signature = self.getMemberTypeSig(item, funcList, _contractName)
				result.append((signature, CALL_FLAG))
			if item["attributes"]["member_name"] == "send" and item["attributes"]["type"] == "function (uint256) returns (bool)":
				#找到使用send
				signature = self.getMemberTypeSig(item, funcList, _contractName)
				result.append((signature, CALL_FLAG))
			if item["attributes"]["member_name"] == "value" and item["attributes"]["type"] == "function (uint256) pure returns (function (bytes memory) payable returns (bool,bytes memory))":
				if item["children"][0]["attributes"]["member_name"] == "call" and item["children"][0]["attributes"]["type"] == "function (bytes memory) payable returns (bool,bytes memory)":
					signature = self.getMemberTypeSig(item, funcList, _contractName)
					result.append((signature, CALL_FLAG, item["src"]))
		if len(result) > 0:
			return True, result
		else:
			return False, list()

	#*待修改*#
	#修改完成
	def getMemberTypeSig(self, _item, _list, _contractName):
		#根据源代码的包含关系来判断语句属于哪个函数
		startPos, endPos = self.srcToPos(_item["src"])
		for func in _list:
			funcSPos, funcEPos = self.srcToPos(func["src"])
			if startPos > funcSPos and endPos < funcEPos:
				#找到了所属函数
				#根据所属函数和合约来返回函数签名
				#可能出现意外，因为构造函数和回退函数没有函数签名，也没有函数名
				if func["attributes"]["kind"] == "function":
					functionName = func["attributes"]["name"]	
					for item in self.contractAndItsHashes[_contractName]:
						if item[0] == functionName:
							return item[1]
				#此种处理，会导致后续合约覆盖本层合约的fallback，因为实际部署到区块链上的合约只拥有一个fallback函数　
				elif func["attributes"]["kind"] == "fallback":
					return "fallback"
				#同理，因为Solidity继承时，子类部署时基类的构造函数会自动执行，因此不存在覆盖
				elif func["attributes"]["kind"] == "constructor":
					return _contractName + ".constructor"


	#传入：657:17:0
	#传出：657, 674
	def srcToPos(self, _src):
		temp = _src.split(":")
		return int(temp[0]), int(temp[0]) + int(temp[1])

	#*待修改*#
	#修改完成
	#修改为只匹配实现了的函数
	def payableFunc(self, _ast, _contractName):
		result = list()
		payableList = self.findASTNode(_ast, "name", "FunctionDefinition")
		funcList = payableList[:]
		for item in payableList:
			if item["attributes"]["stateMutability"] == "payable" and item["attributes"]["implemented"] == True:
				#如果是payable函数，特殊处理
				if item["attributes"]["kind"] == "fallback":
					signature = "fallback"
				elif item["attributes"]["kind"] == "constructor":
					signature = _contractName + ".constructor"
				elif item["attributes"]["kind"] == "function":
					functionName = item["attributes"]["name"]
					#print(functionName)
					for func in self.contractAndItsHashes[_contractName]:
						if func[0] == functionName:
							#print(func[1])
							signature = func[1]
				result.append((signature, PAYABLE_FLAG, item["src"]))
		if len(result) > 0:
			return True, result
		else:
			return False, list()

	def mappingState(self, _ast):
		result = list()
		varList = self.findASTNode(_ast, "name", "VariableDeclaration")
		for item in varList:
			if item["attributes"]["stateVariable"] == True and item["attributes"]["type"] == "mapping(address => uint256)":
				result.append((-1, MAPPING_FLAG, item["src"]))
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
		

