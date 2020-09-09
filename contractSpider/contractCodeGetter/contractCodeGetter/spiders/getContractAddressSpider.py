import scrapy
from contractCodeGetter.items import ContractcodegetterItem


class GetcontractaddressspiderSpider(scrapy.Spider):
    name = 'getContractAddressSpider'
    #允许爬取的网页范围
    allowed_domains = ["https://cn.etherscan.com"]
    #allowed_domains = ["http://www.itcast.cn"]
    start_urls = ['https://cn.etherscan.com/tokens?p=1/']
    #首批处理的url，可以是多个
    #start_urls = ['http://www.itcast.cn/']

    #解析爬取结果，response是返回对象
    def parse(self, response):
    	print(response.body.decode("utf-8"))
    	'''
    	address_list = response.xpath("")

    	for address in address_list:
    		#scrapy item对象
    		item = ContractcodegetterItem()

    		yield item
    	'''
