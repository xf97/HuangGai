#!/usr/bin/python
#-*- coding: utf-8 -*-

import json
import copy
import os
import subprocess

#标记语句
LABEL_STATEMENT = "line_number: "
#合约结果命名后缀
INJECTED_CONTRACT_SUFFIX = "_TOD.sol"
#标记文件命名后缀
INJECTED_INFO_SUFFIX = "_TODInfo.txt"
#结果保存路径
DATASET_PATH = "./dataset/"
#二进制运算标志
BINARY_OPERATION_FLAG = "BinaryOperation"
#布尔类型标志
BOOL_FLAG = "bool"
#插入标记字符串
INJECTED_FLAG = "\t//injected TRANSACTION ORDER DEPENDENCE"
#存储额度关系的账本
MAPPING_FLAG = "mapping(address => uint256)"
#赋值符号
ASSIGN_FLAG = "="
#uint256标志
UINT256_FLAG = "uint256"
#相等判断符号
EQU_FLAG = "=="
#不相等判断符号
UN_EQU_FLAG = "!="
#常量标志 
LITERAL_FLAG = "Literal"
#0常量字符串
INT_CONST_0_FLAG = "int_const 0"
#替换0的数字
VALUE_1_STR = "1"
#0的标识符
VALUE_0_STR = "0"
#标识符标志
IDENTIFIER_FLAG = "Identifier"
#布尔真值的字符串
BOOL_TRUE_STR = "true"
#mapping调用标志
INDEX_ACCESS_FLAG = "IndexAccess"

class TODInjector:
	def __init__(self, _contractPath, _infoPath, _astPath, _originalContractName):
		self.contractPath = _contractPath
		self.infoPath = _infoPath
		self.info = self.getInfoJson(self.infoPath)
		self.sourceCode = self.getSourceCode(self.contractPath)
		self.ast = self.getJsonAst(_astPath)
		self.preName = _originalContractName
		try:
			os.mkdir(DATASET_PATH)
		except:
			#print("The dataset folder already exists.")
			pass

	def getJsonAst(self, _astPath):
		with open(_astPath, "r", encoding = "utf-8") as f:
			temp = json.loads(f.read())
		return temp

	def getInfoJson(self, _path):
		with open(_path, "r", encoding = "utf-8") as f:
			temp = json.loads(f.read())
		return temp

	def getSourceCode(self, _path):
		try:
			with open(_path, "r", encoding = "utf-8") as f:
				return f.read()
		except:
			raise Exception("Failed to get source code when injecting.")
			return str()

	#该种bug的注入方式类似于整数溢出
	#先做个基础版出来-不考虑函数调用
	def inject(self):
		#下述数据结构保存不同字符串和对应插入位置的关系
		#字典，Key插入位置，元素值-[结束位置，插入语句]
		srcAndItsStr = dict()
		#1. 根据函数id找到函数
		approveIdList = self.info["approveId"]
		#2. 获得外部传入的参数-传入的函数一定是外部可见性的，因此每个参数外部都可以传入 
		for _id in approveIdList:
			#获得函数ast
			funcAst = self.findASTNode(self.ast, "id", _id)[0]	#一定能找到ast，而且只有一个
			#进入函数中，找uint256型参数-根据搜寻函数的限制，有且只会有一个uint256型变量
			uintId = self.getExternalUintPara(funcAst)
			#2.1 首先找函数内的赋值语句，要求赋值的这个值必须是外部传入的参数，如果没有这个语句，直接不予注入
			block = self.findASTNode(funcAst, "name", "Block")[0]	#从块中找
			assignId, mappingId = self.getAssignment(block, uintId)
			if assignId == -1:
				continue
			else:
				#2.2 然后进入到函数块中，寻找有没有语句对这个参数进行数值上的检验-要求这个数值一定要是0 (== 0, 或者 != 0)
				#如果没有这样的语句，就可以直接标注bug了-如果有将 == 0 换成一个非零值，例如 1
				#print(uintId, assignId)
				#记录赋值语句
				assignSpos, assignEpos = self.srcToPos(self.findASTNode(self.ast, "id", assignId)[0]["src"])
				while self.sourceCode[assignEpos] != "\n":
					assignEpos += 1
				#停下时指向换行符号
				srcAndItsStr[assignEpos] = [assignEpos, INJECTED_FLAG]
				for binaryOpe in self.findASTNode(block, "name", "BinaryOperation"):
					#要求符号，参与变量和数字常量符合要求
					if binaryOpe["attributes"]["type"] == BOOL_FLAG and (binaryOpe["attributes"]["operator"] == EQU_FLAG or binaryOpe["attributes"]["operator"] == UN_EQU_FLAG):
						#符号符合要求
						#要记录常量的位置
						opeList = binaryOpe["children"]
						if len(opeList) != 2:
							continue
						else:
							num1 = [ope for ope in opeList if ope["name"] == LITERAL_FLAG]
							num2 = [ope for ope in opeList if ope["name"] == IDENTIFIER_FLAG]
							num3 = [ope for ope in opeList if ope["name"] == INDEX_ACCESS_FLAG]
							if len(num1) == 1 and len(num2) == 1:
								#这是常量和标识符
								num1 = num1[0]
								num2 = num2[0]
								#num1必然是常量，num2必然是标识符
								if num2["attributes"]["referencedDeclaration"] == uintId and num1["attributes"]["value"] == VALUE_0_STR and num1["attributes"]["type"] == INT_CONST_0_FLAG:
									#此时num1是想要的常量
									#[bug update] 把比较的那一段直接换成真值
									sPos, ePos = self.srcToPos(binaryOpe["src"])
									srcAndItsStr[sPos] = [ePos, BOOL_TRUE_STR]
								else:
									continue
							elif len(num1) == 1 and len(num3) == 1:
								#这是常量和账本
								num1 = num1[0]
								num3 = num3[0]["children"][0]["children"][0]
								#num1必然是常量，num2必然是标识符
								if num3["attributes"]["referencedDeclaration"] == mappingId and num1["attributes"]["value"] == VALUE_0_STR and num1["attributes"]["type"] == INT_CONST_0_FLAG:
									#此时num1是想要的常量
									#[bug update] 把比较的那一段直接换成真值
									sPos, ePos = self.srcToPos(binaryOpe["src"])
									srcAndItsStr[sPos] = [ePos, BOOL_TRUE_STR]
								else:
									continue								
					else:
						continue
		'''
		#3. 扩展approveIdList-该点改动是为了应对_approve函数
		self.getCalledId(approveIdList)
		print(approveIdList)
		'''
		if not srcAndItsStr:
			return False	#没有可以注入的语句
		#3. 然后，在self.sourceCode中插入语句
		newSourceCode, newInjectInfo = self.insertStatement(srcAndItsStr)
		#4. 输出并保存结果，然后产生自动标记
		self.storeFinalResult(newSourceCode, self.preName)
		self.storeLabel(newSourceCode, newInjectInfo, self.preName)
		return True

	#返回值应该是赋值语句的id
	def getAssignment(self, _blockAst, _id):
		flagId = -1
		assignId = -1
		for assign in self.findASTNode(_blockAst, "name", "Assignment"):
			try:
				if assign["attributes"]["operator"] != ASSIGN_FLAG and assign["attributes"]["type"] != UINT256_FLAG:
					continue
				else:
					#参与的几个数字
					numList = assign["children"]
					'''
					一般来说，我们需要的赋值语句都是直接赋值的，右边是传入参数，左边是mapping(address => uint256)
					而不是通过任何运算
					'''
					if len(numList) != 2:
						continue
					else:
						num1 = numList[0]["children"][0]
						num2 = numList[1]
						if num2["attributes"]["referencedDeclaration"] == _id and num1["attributes"]["type"] == MAPPING_FLAG:
							flagId = assign["id"]
							assignId = num1["children"][0]["attributes"]["referencedDeclaration"]
							break
						else:
							continue
			except:
				continue
		return flagId, assignId

	def getExternalUintPara(self, _funcAst):
		#获得参数列表-不是返回列表
		paraList = _funcAst["children"][0]	#列表类型-传入的approve函数必有uint256参数
		return paraList["children"][1]["id"]

	def getCalledId(self, _list):
		calleeIdList = list()
		for funcId in _list:
			funcAstList = self.findASTNode(self.ast, "id", funcId)	#这里找到的是函数的ast
			#从中抽取functionCall
			funcCallList = self.findASTNode(funcAstList[0], "name", "FunctionCall")
			if not funcCallList:
				continue
			else:
				for funcCall in funcCallList:
					try:
						if funcCall["children"][0]["attributes"]["referencedDeclaration"] > 0 and funcCall["children"][0]["attributes"]["value"] != REQUIRE_FLAG and funcCall["children"][0]["attributes"]["value"] != ASSERT_FLAG:
							#加一个判断-事件也符合我们的标准，不抽取事件
							_id = funcCall["children"][0]["attributes"]["referencedDeclaration"]
							#print(_id)
							ast = self.findASTNode(self.ast, "id", _id)[0]	#只会有一个值
							#print("hahahha")
							if ast["name"] != "EventDefinition":
								calleeIdList.append(_id) 
						else:
							continue
					except:
						continue
		#print(calleeIdList)
		_list.extend(calleeIdList)


	def storeFinalResult(self, _sourceCode, _preName):
		with open(os.path.join(DATASET_PATH, _preName + INJECTED_CONTRACT_SUFFIX), "w+",  encoding = "utf-8") as f:
			f.write(_sourceCode)
		return
	
	def storeLabel(self, _sourceCode, _dict, _preName):
		startIndex = _sourceCode.find(INJECTED_FLAG)
		lineBreak = "\n"
		labelLineList = list()
		while startIndex != -1:
			num = _sourceCode[:startIndex].count(lineBreak) + 1
			labelLineList.append(LABEL_STATEMENT + str(num) + lineBreak)
			startIndex = _sourceCode.find(INJECTED_FLAG, startIndex + len(INJECTED_FLAG))
		with open(os.path.join(DATASET_PATH, _preName + INJECTED_INFO_SUFFIX), "w+",  encoding = "utf-8") as f:
			f.writelines(labelLineList)
		return

	def insertStatement(self, _insertInfo):
		tempCode = str()	
		tempDict = copy.deepcopy(_insertInfo) #使用副本
		startIndex = 0
		indexList = sorted(_insertInfo.keys())
		offset = list()
		for index in indexList:
			tempCode += self.sourceCode[startIndex: index] + _insertInfo[index][1]
			startIndex = _insertInfo[index][0]
			offset.append(len(_insertInfo[index][1]) + (_insertInfo[index][0] - index))
			newIndex = index + sum(offset)
			tempDict[newIndex] = tempDict.pop(index)
		tempCode += self.sourceCode[startIndex:]
		return tempCode, tempDict
		
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


	def output(self):
		pass