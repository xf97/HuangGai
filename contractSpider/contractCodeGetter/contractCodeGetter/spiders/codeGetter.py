import scrapy


class CodegetterSpider(scrapy.Spider):
    name = 'codeGetter'
    allowed_domains = ['cn.etherscan.com']
    baseUrlPrefix = "https://cn.etherscan.com/address/"
    baseUrlSuffix = "#code"
    contractAddress = str()
    start_urls = ['http://cn.etherscan.com/']

    def getContractAddress(self, _addressPath):
    	pass

    def parse(self, response):
        pass
