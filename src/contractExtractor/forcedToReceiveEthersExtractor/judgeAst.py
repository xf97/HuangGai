#!/usr/bin/pythin
#-*- coding: utf-8 -*-

import json
import os
from colorPrint import *	#该头文件中定义了色彩显示的信息
import re
import subprocess

#缓存路径
CACHE_PATH = "./cache/"
#注入所需信息存储路径
INJECT_INFO_PATH = "./injectInfo/"
#注入信息源代码键值
SRC_KEY = "srcPos"
#元组标志
TUPLE_FLAG = "tuple()"
#require和assert函数类型标志
REQUIRE_FUNC_TYPE_FLAG = "function (bool) pure"
#require的另一种形式 的定义
REQUIRE_FUNC_STRING_TYPE_FLAG = "function (bool,string memory) pure"
#require标志
REQUIRE_FLAG = "require"
#assert标志
ASSERT_FLAG = "assert"
#二进制运算标志
BINARY_OPERATION_FLAG = "BinaryOperation"
#布尔类型标志
BOOL_FLAG = "bool"
#相等类型标志
EQU_FLAG  = "=="
#uint256型标志
UINT256_FLAG = "uint256"
#与符号
AND_FLAG = "&&"
#或符号
OR_FLAG = "||"
#整数类型常量前缀
PRE_INT_CONST_STR = "int_const"
#常量标志
LITERAL_FLAG = "Literal"
#pure常量标志
PURE_FLAG = "pure"


class judgeAst:
	def __init__(self, _json, _sourceCode, _filename):
		self.cacheContractPath = "./cache/temp.sol"
		self.cacheFolder = "./cache/"
		self.json =  _json
		self.filename = _filename
		self.sourceCode = _sourceCode

	#可以适当考虑增强捕捉&&, ||等运算符出现的情况　
	def run(self):
		injectInfo = dict()
		injectInfo[SRC_KEY] = list()
		#1. 捕捉所有可能导致程序分支的语句
		#暂且捕捉以下三个: require, assert, if
		#此处返回完整的ast
		#[再次精确定义]只要BinaryOperation并且符号是==的，并且children[1]的typeString是uint256的
		#[bug fix] 不去修改pure函数中的语句，因为address(this).balance会读取区块链的状态而pure函数不能读取状态
		pureFuncSrcList = self.getPureFuncSrcList(self.json)
		branchAstList = list()
		#1.1 assert语句
		branchAstList.extend(self.getAssertStatement(self.json))
		#1.2 require语句
		branchAstList.extend(self.getRequireStatement(self.json))
		#1.3 if语句
		branchAstList.extend(self.getIfStatement(self.json))
		#print(len(branchAstList))
		#2. 过滤不满足要求的条件部分语句
		#要求参与的操作数其中一个是uint256常数
		branchAstList = self.filterConditionPart(branchAstList)
		#print(branchAstList)
		#3.　记录这些可以被替换的值的位置
		for item in branchAstList:
			sPos, ePos = self.srcToPos(item)
			#[bug fix 2020/11/09] 此处不记录在pure函数中的语句
			if not self.inPureFunc(pureFuncSrcList, sPos, ePos):
				injectInfo[SRC_KEY].append([sPos, ePos])
			else:
				continue
		#4. 存储信息
		if not injectInfo[SRC_KEY]:
			return False
		else:
			self.storeInjectInfo(injectInfo)
			return True

	def inPureFunc(self, _pureFuncSrcList, _startPos, _endPos):
		for item in _pureFuncSrcList:
			if item[0] < _startPos and item[1] > _endPos:
				return True
			else:
				continue
		return False

	def getPureFuncSrcList(self, _ast):
		srcList = list()
		for func in self.findASTNode(_ast, "name", "FunctionDefinition"):
			if func["attributes"]["stateMutability"] == PURE_FLAG:
				#找到pure函数，记录位置
				srcList.append(self.srcToPos(func["src"]))
			else:
				continue
		return srcList

	def filterConditionPart(self, _astList):
		result = list()
		for item in _astList:
			#要求只能有两个操作数
			#item["children"]是两个操作数
			if len(item["children"]) != 2:
				continue
			ope1 = item["children"][0]
			ope2 = item["children"][1]
			if ope1["name"] == LITERAL_FLAG and ope1["attributes"]["type"].split()[0] == PRE_INT_CONST_STR:
				result.append(ope2["src"])
			elif ope2["name"] == LITERAL_FLAG and ope2["attributes"]["type"].split()[0] == PRE_INT_CONST_STR:
				result.append(ope1["src"])
			else:
				continue
		return result


	def getIfStatement(self, _ast):
		#IfStatement的children[0]的条件部分
		astList = list()
		for ifStatement in self.findASTNode(_ast, "name", "IfStatement"):
			#获取条件部分
			conditionPart = ifStatement["children"][0]
			#检测条件部分是否满足要求
			if conditionPart["name"] == BINARY_OPERATION_FLAG and conditionPart["attributes"]["type"] == BOOL_FLAG and conditionPart["attributes"]["operator"] == EQU_FLAG and conditionPart["attributes"]["commonType"]["typeString"] == UINT256_FLAG:
				#满足，记录ast
				astList.append(conditionPart)
			else:
				continue
		return astList


	def getAssertStatement(self, _ast):
		funcCall = self.findASTNode(_ast, "name", "FunctionCall")
		srcList = list()
		for call in funcCall:
			if call["attributes"]["type"] == TUPLE_FLAG:
				children0 = call["children"][0]
				children1 = call["children"][1]
				if children0["attributes"]["type"] == REQUIRE_FUNC_TYPE_FLAG and \
				   children0["attributes"]["value"] == ASSERT_FLAG and \
				   children1["name"] == BINARY_OPERATION_FLAG and \
				   children1["attributes"]["type"] == BOOL_FLAG and \
				   children1["attributes"]["operator"] == EQU_FLAG and \
				   children1["attributes"]["commonType"]["typeString"] == UINT256_FLAG:
				   #找到assert语句
				   #这时候，只拿下来它的条件部分
				   srcList.append(children1)
				else:
					continue
			else:
				continue
		return srcList

	def getRequireStatement(self, _ast):
		funcCall = self.findASTNode(_ast, "name", "FunctionCall")
		srcList = list()
		for call in funcCall:
			if call["attributes"]["type"] == TUPLE_FLAG:
				children0 = call["children"][0]	#children[0]是运算符
				children1 = call["children"][1]	#children[1]是操作数
				if (children0["attributes"]["type"] == REQUIRE_FUNC_TYPE_FLAG or \
					children0["attributes"]["type"] == REQUIRE_FUNC_STRING_TYPE_FLAG) and \
				   children0["attributes"]["value"] == REQUIRE_FLAG and \
				   children1["name"] == BINARY_OPERATION_FLAG and \
				   children1["attributes"]["type"] == BOOL_FLAG and \
				   children1["attributes"]["operator"] == EQU_FLAG and \
				   children1["attributes"]["commonType"]["typeString"] == UINT256_FLAG:
				   #然后尝试增加抽取语句
				   #找到require语句
				   srcList.append(children1)
				else:
					continue
			else:
				continue
		return srcList



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