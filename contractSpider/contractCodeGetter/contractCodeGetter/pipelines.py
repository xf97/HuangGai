# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html


# useful for handling different item types with a single interface
from itemadapter import ItemAdapter
import json


class ContractcodegetterPipeline:
	def __init__(self):
		#使用该文件保存爬取结果
		self.file = open("tokenAndItsAddr.json", "ab+")

	def process_item(self, item, spider):
		#print(item)
		aInfo = json.dumps(dict(item)) + ",\n"
		self.file.write(aInfo.encode("utf-8"))
		return item

	#在爬虫关闭时执行
	def close_spider(self, spider):
		#关闭文件
		self.file.close()