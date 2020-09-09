# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html


# useful for handling different item types with a single interface
from itemadapter import ItemAdapter


class ContractcodegetterPipeline:
	def __init__(self):
		pass

    def process_item(self, item, spider):
    	#这个item一定要返回给引擎
        return item

    #在爬虫关闭时执行
    def close_spider(self, spider):
    	pass