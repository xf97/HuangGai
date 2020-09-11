import scrapy
from contractCodeGetter.items import ContractcodegetterItem
import re
import json

#默认数据保存位置
ADDRESS_DATA_PATH = "tokenAndItsAddr.json"

class GetcontractaddressspiderSpider(scrapy.Spider):
    name = 'getContractAddressSpider'
    #允许爬取的网页的根域名
    allowed_domains = ["cn.etherscan.com"]
    baseUrl = "https://cn.etherscan.com/tokens?p=" #基础url
    offset = 1 #偏移量，用于翻页
    #首批处理的url，可以是多个
    start_urls = [baseUrl + str(offset)]
    #num = 0 

    def __init__(self):
        pass
    	#self.num = self.initNum(ADDRESS_DATA_PATH)

    '''
    #初始化序号，接上上次爬取时的最新数据
    def initNum(self, _dataPath):
        maxNum = 0
        try:
            with open(_dataPath, "r", encoding = "utf-8") as f:
                for oneInfo in f.readlines():
                    data = json.loads(oneInfo[:-2]) #dict(eval(oneInfo[:-2]))， 去除每条字符串最后的",\n"
                    maxNum = max(maxNum, data["number"])
        except:
            maxNum = 0
        return maxNum
    '''


    #如果有多个请求(eg., 在start_urls中)，则每个parse方法都对应一个请求，并发执行
    #解析爬取结果，response是返回对象
    def parse(self, response):
        '''
        另有，response内置了re方法
        '''
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
            name = namePattern.search(infoText).group()[1:-1] #截取代币合约名字
            address = addressPattern.search(infoText).group()[1:-1] #截取代币合约地址
    		#print(self.num, name, address)
    		#写入信息
            item["name"] = name
            item["address"] = address
    		#使用yield字段加快执行速度，如果返回的是item类型，则返回给管道
    		#返回的是请求，则返回给调度器
            yield item
        #处理完一页信息后，翻页
        #由于cn.etherscan.com的限制，最多只展示20页
        if self.offset < 20:
            self.offset += 1
            nowUrl = self.baseUrl + str(self.offset) #拼接出下一个要拼接的url
            #以下请求将会发送给调度器
            yield scrapy.Request(nowUrl, callback = self.parse) #指定parse为响应本次调用的回调函数并发送请求
