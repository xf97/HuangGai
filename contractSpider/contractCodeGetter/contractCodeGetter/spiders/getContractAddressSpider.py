import scrapy
from contractCodeGetter.items import ContractcodegetterItem
import re
import json

#默认数据保存位置
DATA_PATH = "./../data/tokenAndItsAddr.json"

class GetcontractaddressspiderSpider(scrapy.Spider):
    name = 'getContractAddressSpider'
    #允许爬取的网页的根域名
    allowed_domains = ["cn.etherscan.com"]
    start_urls = ['https://cn.etherscan.com/tokens?p=1/']
    #首批处理的url，可以是多个

    def __init__(self):
    	self.num = self.initNum(DATA_PATH)

    def initNum(self, _dataPath):
        with open(_dataPath, "r", encoding = "utf-8") as f:
            data = json.load(f)
        print(data)


    #如果有多个请求(eg., 在start_urls中)，则每个parse方法都对应一个请求，并发执行
    #解析爬取结果，response是返回对象
    def parse(self, response):
    	#代币信息列表
    	#itemsList = list()
    	#页面信息
    	pageText = response.body.decode("utf-8")
    	#考虑使用正则表达式抓取信息
    	#提前编译正则表达式，以提高运行效率
    	infoPattern = re.compile(r"token/((0x)|(0X))[A-Za-z0-9]{40}(\')(>)(.)+?(</a>)")
    	#该模式能够匹配诸如以下模式的信息
    	#token/0x合约地址'>合约名</a>
    	namePattern = re.compile(r"(>)(.)+?(<)")
    	addressPattern = re.compile(r"/((0x)|(0X))[A-Za-z0-9]{40}(\')")
    	for info in infoPattern.finditer(pageText):
    		#使用item存储信息
    		item = ContractcodegetterItem()
    		#逐个取出信息
    		infoText = info.group()
    		self.num += 1 #序号增加1
    		name = namePattern.search(infoText).group()[1:-1] #截取代币合约名字
    		address = addressPattern.search(infoText).group()[1:-1] #截取代币合约地址
    		#print(self.num, name, address)
    		#写入信息
    		item["number"] = self.num
    		item["name"] = name
    		item["address"] = address
    		#使用yield字段加快执行速度，如果返回的是item类型，则返回给管道
    		#返回的是请求，则返回给调度器
    		yield item
    		#itemsList.append(item)
    	#此处return给引擎
    	#return itemsList
