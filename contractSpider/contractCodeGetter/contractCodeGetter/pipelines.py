# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html


# useful for handling different item types with a single interface
from itemadapter import ItemAdapter
import json

'''
需要一个去重机制，避免写入同样地址的合约
首先要明确的一点是：单次爬取的数据，不会存在重复的地址
'''

ADDRESS_DATA_PATH = "tokenAndItsAddr.json"


class ContractcodegetterPipeline:
	def __init__(self):
		#使用该文件保存爬取结果
		self.file = open("tokenAndItsAddr.json", "ab+")
		self.preResult = self.initPreResult(ADDRESS_DATA_PATH)
		#print(self.preResult)

	#如果上一次结果存在，则读取它
	def initPreResult(self, _dataPath):
		preResult = list()
		try:
			with open(_dataPath, "r", encoding = "utf-8") as f:
				for line in f.readlines():
					preResult.append(line[:-2]) #去除每条字符串最后的",\n"
		except:
			preResult = []
		return preResult

	'''
	#初始化序号，接上上次爬取时的最新数据
	def initNum(self, _dataPath):
		maxNum = 0
		try:
			with open(_dataPath, "r", encoding = "utf-8") as f:
				for oneInfo in f.readlines():
					data = json.loads(oneInfo[:-2]) #去除每条字符串最后的",\n"
					maxNum = max(maxNum, data["number"])
		except:
			maxNum = 0
		return maxNum
	'''
		

	#spider参数传入当前的爬虫，根据spider.name区分爬虫
	#如果爬取到的结果已经存在，则不写入
	def process_item(self, item, spider):
		#print(item)
		aInfo = json.dumps(dict(item))
		if aInfo not in self.preResult:
			aInfo += ",\n"
			self.file.write(aInfo.encode("utf-8"))
		return item

	#在爬虫关闭时执行
	def close_spider(self, spider):
		#关闭文件
		self.file.close()

	#爬虫开启时执行
	def open_spider(self, spider):
		pass
