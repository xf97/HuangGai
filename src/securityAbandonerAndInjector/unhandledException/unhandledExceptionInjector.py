#!/usr/bin/python
#-*- coding: utf-8 -*-

import json
import copy
import os
import subprocess

#标记语句
LABEL_STATEMENT = "line_number: "
#合约结果命名后缀
INJECTED_CONTRACT_SUFFIX = "_unhandledException.sol"
#标记文件命名后缀
INJECTED_INFO_SUFFIX = "_unhandledExceptionInfo.txt"
#结果保存路径
DATASET_PATH = "./dataset/"
#插入标记字符串
INJECTED_FLAG = "\t//inject UNHANDLED EXCEPTION\n"
#表达式语句标志
EXP_FLAG = "ExpressionStatement"
#赋值语句标志
ASS_FLAG = "Assignment"
#if语句标志
IF_FLAG = "IfStatement"
#变量声明语句
VAR_DECLARATION_FLAG = "VariableDeclarationStatement"
#布尔变量补全声明
BOOL_VALUE_STR = "= true;\n"
#布尔和byte32补充声明
BOOL_BYTES_VALUE_STR = "= (false, bytes(msg.data));\n"
#布尔标志
BOOL_STR = "true"
#tab符号
TAB_FLAG = "\t"
#value标志
VALUE_FLAG = "value"
#call标志
CALL_FLAG = "call"
#delegatecall标志
DELEGATECALL_FLAG = "delegatecall"

class unhandledExceptionInjector:
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

	#待实现
	#已经实现
	def inject(self):
		#根据不同类型的语句，应该有不同的注入方法
		#键是开始拼接语句的位置，值是一个列表，第一个元素是结束拼接语句的位置，第二个元素是插入的元素
		srcAndItsStr = dict()
		for item in self.info.values():
			#1. 表达式语句最好处理，直接标记
			if item[0] == EXP_FLAG:
				#因为item[2]不指向分号，所以要更新item[2]的位置
				newEnd = item[2]
				while self.sourceCode[newEnd] != ";":
					newEnd += 1
				newEnd += 1	#越过分号
				srcAndItsStr[newEnd] = [newEnd, INJECTED_FLAG]
			#2. 赋值语句
			elif item[0] == ASS_FLAG:
				#更换思想，与其切断，不如重置
				newStatement = self.getNewStatement_forAssign(item[1], item[2], item[3])
				#从头部开始注入
				newEnd = item[2]
				while self.sourceCode[newEnd] != ";":
					newEnd += 1
				newEnd += 1	#越过分号
				srcAndItsStr[item[1]] = [newEnd, (newStatement + ";" + INJECTED_FLAG)]
			#3. 变量声明语句
			elif item[0] == VAR_DECLARATION_FLAG:
				#处理方式与赋值语句相同
				newStatement = self.getNewStatement_forVarDeclaration(item[1], item[2], item[3])
				#从头部开始注入
				newEnd = item[2]
				while self.sourceCode[newEnd] != ";":
					newEnd += 1
				newEnd += 1	#越过分号
				srcAndItsStr[item[1]] = [newEnd, (newStatement + ";" + INJECTED_FLAG)]
			#4. if语句-要明晰括号中间是表达式语句
			#和require和assert语句
			#最难处理的
			#todo
			elif type(item[0]) == list:
				#也是原文修改
				origiState = self.sourceCode[item[1]: item[2]]
				srcAndItsStr[item[1]] = [item[2], BOOL_STR]
				newStart = item[0][0] - 1
				srcAndItsStr[newStart] = [newStart, "\t\n" + origiState + ";" + INJECTED_FLAG]
			else:
				continue
		#print(srcAndItsStr)
		#已经记录的注入的位置，现在，插入语句
		newSourceCode, newInjectInfo = self.insertStatement(srcAndItsStr)
		#然后，保存结果并自动标记
		self.storeFinalResult(newSourceCode, self.preName)
		self.storeLabel(newSourceCode, newInjectInfo, self.preName)

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

	#未使用
	def getNewStatement_forIf(self, _startPos, _endPos, _type):
		origiState = self.sourceCode[_startPos: _endPos]
		#把其中的语句

	def getNewStatement_forAssign(self, _startPos, _endPos, _type):
		#拿到原来的语句
		#注意分号
		origiState = self.sourceCode[_startPos: _endPos]
		#拆分
		(var, lowCall) = origiState.split("=", 1)	#只拆分最左侧第一个等号
		#注意拆分后，如果是call/delegatecall语句，就拼接其他结果
		if _type == CALL_FLAG or _type == DELEGATECALL_FLAG:
			var += BOOL_BYTES_VALUE_STR
		else:
			var += BOOL_VALUE_STR
		lowCall = TAB_FLAG + lowCall
		#返回去
		return var + lowCall

	def getNewStatement_forVarDeclaration(self, _startPos, _endPos, _type):
		#拿到原来的语句
		#注意分号
		origiState = self.sourceCode[_startPos: _endPos]
		#拆分
		(var, lowCall) = origiState.split("=", 1)	#只拆分最左侧第一个等号
		#注意拆分后，如果是call/delegatecall语句，就拼接其他结果
		if _type == CALL_FLAG or _type == DELEGATECALL_FLAG:
			var += BOOL_BYTES_VALUE_STR
		else:
			var += BOOL_VALUE_STR
		lowCall = TAB_FLAG + lowCall
		#返回去
		return var + lowCall

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