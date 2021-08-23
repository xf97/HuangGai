#!/usr/bin/python
#-*- coding:utf-8 -*-


'''
__author__ = xiaofeng
This program is used to delete the source code comments (include single and multiple lines commnets) from the Solitidy source code. 
'''

'''
Attention: Don't deleting the NatSpec comments
For Solidity you may choose /// for single or multi-line comments, or /** and ending with */.
'''

import os
import sys

class deleter:
	def __init__(self, filePath):
		self.path = filePath
		self.content = self.getContentStr(self.path)

	def getContentStr(self, filePath):
		with open(filePath, "r", encoding = "utf-8") as f:
			#全量读取，不管什么符号
			content = f.read()
			return content
		return str()

	def removeMulComments(self, content):
		#移除content中的多行comment
		length = len(content)
		result = str()
		index = 0
		while index < length:
			if index < length - 2 and content[index] == "/" and content[index + 1] == "*"  and content[index + 2] != "*":
				#找到非NatSpec的多行注释
				#不添加到结果中
				index += 2
				tempIndex = index
				flag = False
				#寻找多行注释末尾
				while index < length - 1 and not (content[index] == "*" and content[index + 1] == "/"):
					#判断是不是到了下一个多行注释了
					if index < length - 2 and content[index] == "/" and content[index + 1] == "*":
						#触发bug
						flag = True
						break
					#没有找到末尾
					index += 1
				if flag == False:
					index += 2	#越过多行注释末尾
				else:
					result += "/*"
					index = tempIndex
			elif index < length - 2 and content[index] == "/" and content[index + 1] == "*" and content[index + 2] == "*":
				result += "/**"
				index += 3
			else:
				result += content[index]
				index += 1
		return result

	def removeSingleComments(self, content):
		length = len(content)
		result = str()
		index = 0
		while index < length:
			if index < length - 1 and content[index] == "\"":
				#字符串，免死金牌
				result += "\""
				index += 1
				while index < length and content[index] != "\"":
					result += content[index]
					index += 1
				result += "\""
				index += 1
			elif index < length - 2 and content[index] == "/" and content[index + 1] == "/" and content[index + 2] != "/":
				#找到非NatSpec的单行注释
				#不添加结果中
				index += 2
				#注意，solidity中将LF，VF，FF，CR都认为是单行注释终止符
				#要用ascii码识别
				#LF: \n, 0x0a-10
				#CR: \r, 0x0d-14
				#CRLF: \r\n, 0x0d 0x0a - 14 10
				#FF: 换页符, 0x0c-13
				#ok来试一试
				while index < length:
					if ord(content[index]) == 10 or ord(content[index]) == 13:
						#到达末尾
						break
					elif ord(content[index]) == 14:
						if index < length - 1 and ord(content[index + 1]) == 10:
							index += 1
						break
					else:
						#注释内容
						index += 1
				#越出末尾
				index += 1
				#主动添加末尾换行符
				result += "\n"
			elif index < length - 2 and content[index] == "/" and content[index + 1] == "/" and content[index + 2] == "/":
				result += "///"
				index += 3
			else:
				result += content[index]
				index += 1
		return result

	def deleteCommentAndReturnContent(self):
		#self.content = self.removeMulComments(self.content)
		self.content = self.removeSingleComments(self.content)
		return self.content

def getFileCotent(_filename):
	f = open(_filename, "r", encoding = "utf-8")
	content = f.read()
	f.close()
	return content

def writeFileContent(_oldfilename, _content):
	#name_list = _oldfilename.split(".")
	#覆盖写
	f = open(_oldfilename, "w", encoding = "utf-8")
	f.write(_content)
	f.close()
	#print("It's done.")

def getAllSolName():
	fileList = os.listdir()
	solList = list()
	for i in fileList:
		if ".sol" in i:
			#print(i)
			solList.append(i)
	return solList



if __name__ == "__main__":
	#先洗一遍文件编码
	solList = getAllSolName()
	for i in solList:
		content = getFileCotent(i)
		writeFileContent(i, content)
	#然后开始清除注释
	solList = getAllSolName()
	for index, i in enumerate(solList):
		aDeleter = deleter(i)
		unCommentedContent = aDeleter.deleteCommentAndReturnContent()
		writeFileContent(i, unCommentedContent)
		print(index + 1)


