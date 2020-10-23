#!/usr/bin/python
#-*- coding: utf-8 -*-

'''
2020/9/19
可能需要为了配合judgePath而修改　
'''


class inherGraph:
	def __init__(self, _json):
		self.json = _json
		self.contractAndItsBases = dict()

	def astList(self):
		#获取所有合约的定义
		contractList = self.findASTNode(self.json, "name", "ContractDefinition")
		self.idList = list()
		maxNum, mainId = (0, 0)
		#判断哪个合约将作为“主合约”
		for contract in contractList:
			num = len(contract["attributes"]["contractDependencies"])	#基类数量
			_id = contract["id"]
			self.contractAndItsBases[_id] = contract["attributes"]["contractDependencies"]
			if num > maxNum:
				maxNum = num
				mainId = _id
		#获取基类和主合约的id
		#此处列表的顺序，就已经代表了线性化继承顺序后的从“最基类”到“最子类”的顺序
		self.idList.extend(self.contractAndItsBases[mainId])
		self.idList.append(mainId)
		#移除空值
		while None in self.idList:
			self.idList.remove(None)
		#根据调用，逐个返回contract
		for _id in self.idList:
			yield self.findASTNode(self.json, "id", _id)[0]

	def getMainContractName(self):
		#获取所有合约的定义
		contractList = self.findASTNode(self.json, "name", "ContractDefinition")
		self.idList = list()
		maxNum, mainId = (0, 0)
		#判断哪个合约将作为“主合约”
		for contract in contractList:
			num = len(contract["attributes"]["contractDependencies"])	#基类数量
			_id = contract["id"]
			self.contractAndItsBases[_id] = contract["attributes"]["contractDependencies"]
			if num > maxNum:
				maxNum = num
				mainId = _id
		#获取基类和主合约的id
		#此处列表的顺序，就已经代表了线性化继承顺序后的从“最基类”到“最子类”的顺序
		self.idList.extend(self.contractAndItsBases[mainId])
		self.idList.append(mainId)
		#根据调用，逐个返回contract
		return self.findASTNode(self.json, "id", self.idList[-1])[0]["attributes"]["name"]
		'''
		for _id in self.idList:
			yield self.findASTNode(self.json, "id", _id)[0]
		'''

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
		

			

