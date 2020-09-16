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
non-private资源，那么我们仅考虑搜查以下三类资源：
1.　状态变量
2.　函数定义(FunctionDefinition)
3.	修改器
'''

'''
哪些东西可能被重写？
根据Solidity 0.7.1 文档
函数、函数修改器
'''

import json
from inherGraph import inherGraph #该库接收jsonAst，按继承顺序，从最底层子类到最上层基类的顺序返回每个"ContractDefinition"的jsonAst


class judgeAst:
	def __init__(self, _json):
		self.json =  _json
		self.inherGraph = inherGraph(_json)
		self.callTransferSendFlag = False
		self.payableFlag = False
		self.mapping = False

	def run(self):
		

