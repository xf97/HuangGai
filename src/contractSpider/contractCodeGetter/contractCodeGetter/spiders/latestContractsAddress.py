import scrapy
import re
from contractCodeGetter.items import ContractcodegetterItem as infoItem

'''
该部分用于爬取最近验证过的500个合约的源代码
'''

class LatestcontractsaddressSpider(scrapy.Spider):
    name = 'latestContractsAddress'
    #allowed_domains = ['cn.etherscan.com']
    custom_settings = {
        'ITEM_PIPELINES' : {'contractCodeGetter.pipelines.ContractcodegetterPipeline': 300}
    }
    baseUrl = "https://cn.etherscan.com" #基础url
    offset = "/contractsVerified/1" #初始偏移值，选取开源的合约进行爬取
    start_urls = [baseUrl + offset] #爬取的起始域名

    def parse(self, response):    	
    	pageText = response.body.decode("utf-8")
    	#尝试使用xpath来提取地址，xpath可以成功提取，但是由于无法匹配对应的合约名比较困难，所以选择re进行信息提取
    	#addressList = response.xpath("//a[@class='hash-tag text-truncate']/text()").extract() #使用xpath提取出网页中的合约地址
    	#尝试使用re来提取同时提取地址和对应的合约名
    	infoPattern = re.compile(r"hash-tag text-truncate(\')>((0x)|(0X))[A-Za-z0-9]{40}</a></td><td>(.)+?</td>")
    	#提取地址模式
    	addressPattern = re.compile(r"((0x)|(0X))[A-Za-z0-9]{40}")
    	#提取合约名模式
    	namePattern = re.compile(r"<td>(.)+?</td>")
    	for info in infoPattern.finditer(pageText):
    		infoText = info.group(0)
    		name = namePattern.search(infoText).group(0)[4:-5] #去掉头尾的<td>，</td>
    		address = addressPattern.search(infoText).group(0)
    		item = infoItem()
    		infoText = info.group(0)
    		name = namePattern.search(infoText).group(0)[4:-5] #去掉头尾的<td>，</td>
    		address = addressPattern.search(infoText).group(0)
    		#赋值给item对象
    		item["name"] = name
    		item["address"] = address
    		#返回给管道
    		yield item

    	#抓取页面中的”下一页“链接来进行换页
    	#本句xpath的意思是，从页面中选取a标签，其属性值指定为class="page-link"并且aria-label="Next"，取出该a标签的href值
    	if len(response.xpath("//a[@class = 'page-link' and @aria-label='Next']/@href").extract()) > 0:
    		self.offset = response.xpath("//a[@class = 'page-link' and @aria-label='Next']/@href").extract()[0]
    		yield scrapy.Request(self.baseUrl + self.offset, callback = self.parse)