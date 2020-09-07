import scrapy


class GetcontractaddressspiderSpider(scrapy.Spider):
    name = 'getContractAddressSpider'
    allowed_domains = ['cn.etherscan.com/tokens']
    #start_urls = ['https://cn.etherscan.com/tokens?p=1/']
    start_urls = ['https://cn.etherscan.com/tokens?p=1']

    #解析爬取结果，response是返回对象
    def parse(self, response):
    	fname = response[:-1]
    	with open(fname + ".html",  "wb") as f:
    		f.write(response.body)
    	print("hahahahahaha")
