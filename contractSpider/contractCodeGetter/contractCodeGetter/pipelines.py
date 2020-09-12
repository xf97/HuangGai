# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html


# useful for handling different item types with a single interface
from itemadapter import ItemAdapter
import json
import os

#合约及其地址信息存储位置
ADDRESS_DATA_PATH = "contractAndItsAddr.json"
#源代码写入位置
CONTRACT_SOURCE_CODE_PATH = "../sourceCode/"


class ContractcodegetterPipeline:
	def __init__(self):
		#使用该文件保存爬取结果
		self.preResult = self.initPreResult(ADDRESS_DATA_PATH)

	#如果上一次结果存在，则读取结果
	def initPreResult(self, _dataPath):
		preResult = dict()
		try:
			with open(_dataPath, "r", encoding = "utf-8") as f:
				preResult = json.loads(f.read())
		except:
			preResult = dict()
		return preResult

	def writeResult(self, _file, _dict):
		_file.write(json.dumps(_dict, indent = 0))

	#spider参数传入当前的爬虫，根据spider.name区分爬虫
	#如果爬取到的结果已经存在，则不写入
	def process_item(self, item, spider):
		aInfo = dict(item)
		name = aInfo["name"]
		key = aInfo["address"]
		#写入新地址
		if key not in self.preResult.keys():
			self.preResult[key] = name
		return item

	#在爬虫关闭时执行
	def close_spider(self, spider):
		#关闭文件
		#在爬虫结束时，将数据写入存储
		file = open(ADDRESS_DATA_PATH, "w+")
		self.writeResult(file, self.preResult) #将dict写入为json
		file.close()

class SourceCodeGetterPipeline:
	def process_item(self, item, spider):
		filePath = os.path.join(CONTRACT_SOURCE_CODE_PATH, item["filename"] + ".sol") 
		#若文件不存在，则写入文件
		if not os.path.exists(filePath):
			with open(filePath, "w+", encoding = "utf-8") as f:
				f.write(item["sourceCode"])
		return item


