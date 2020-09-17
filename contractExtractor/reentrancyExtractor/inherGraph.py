#!/usr/bin/python
#-*- coding: utf-8 -*-


class inherGraph:
	def __init__(self, _json):
		self.json = _json
		self.contractAndItsBases = dict()

	def astList(self):
		#获取所有合约的定义
		contractList = self.findAstNode(self.json, "name", "ContractDefinition")
		idList = list()
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
		#此处列表的顺序，就已经代表了线性化继承顺序后的从“最基类”到“最上层”的顺序
		idList.extend(self.contractAndItsBases[mainId])
		idList.append(mainId)
		#根据调用，逐个返回contract
		for _id in idList:
			yield self.findAstNode(self.json, "id", _id)[0]

	def findASTNode(self, _ast, _name, _value):
		queue = [_ast]
		result = list()
		literalList = list()
		while len(queue) > 0:
			data = queue.pop()
			for key in data:
				if key == _key and  data[key] == _value:
					result.append(data)
				elif type(data[key]) == dict:
					queue.append(data[key])
				elif type(data[key]) == list:
					for item in data[key]:
						if type(item) == dict:
							queue.append(item)
		return result
		

			

