import scrapy


class GetcontractaddressspiderSpider(scrapy.Spider):
    name = 'getContractAddressSpider'
    #allowed_domains = ['https://cn.bing.com/']
    #start_urls = ['https://cn.etherscan.com/tokens?p=1/']
    start_urls = ['https://cn.etherscan.com/contractsVerified']

    #解析爬取结果，response是返回对象
    def parse(self, response):
    	print(response.body)
