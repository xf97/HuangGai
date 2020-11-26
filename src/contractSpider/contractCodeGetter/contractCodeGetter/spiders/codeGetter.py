import scrapy
import json
from contractCodeGetter.items import SourceCodeGetterItem as infoItem

#合约地址存储位置
ADDRESS_DATA_PATH = "contractAndItsAddr.json"


class CodegetterSpider(scrapy.Spider):
    name = 'codeGetter'
    allowed_domains = ['cn.etherscan.com']
    baseUrlPrefix = "https://cn.etherscan.com/address/"
    baseUrlSuffix = "#code"
    contractAddress = str()
    #随意定义一个存在的初始连接，后续连接将通过代码修改
    start_urls = ["https://cn.etherscan.com/address/0x7556fccfb056ada7aa10c6ed88b5def40d66c591#code"] 
    index = 0 #获取地址的顺序下标
    #指定本spider使用的管道
    custom_settings = {
        'ITEM_PIPELINES' : {'contractCodeGetter.pipelines.SourceCodeGetterPipeline': 500}   #500的给源代码用 }
    }

    def __init__(self):
        #读取合约地址
        with open(ADDRESS_DATA_PATH, "r", encoding = "utf-8") as f:
                addressData = json.loads(f.read())
        self.addressList = list(addressData.keys())
    
    def getContractAddress(self, _index):
        return self.addressList[_index]

    def parse(self, response):
        if self.index == 0:
            #首次连接，避免重复下载starts_url，直接跳过
            try:
                self.contractAddress = self.getContractAddress(self.index)
                self.index += 1
                yield scrapy.Request(self.baseUrlPrefix + self.contractAddress + self.baseUrlSuffix, callback = self.parse)
            except IndexError:
                #当所有合约都被爬取完时，数组将越界，引发异常，结束爬取
                return
        else:
            #捕获异常，持续爬取
            try:
                #获取源码
                pageText = response.body.decode("utf-8")
                #通过xpath拿出源代码
                sourceCode = response.xpath("//pre[@id='editor']/text()").extract()[0]
                #print(sourceCode)
                #存储信息
                item = infoItem()
                item["filename"] = self.contractAddress
                item["sourceCode"] = sourceCode
                #返回item给管道
                yield item
                #构造下一个请求
                try:
                    self.contractAddress = self.getContractAddress(self.index)
                    self.index += 1
                    yield scrapy.Request(self.baseUrlPrefix + self.contractAddress + self.baseUrlSuffix, callback = self.parse)
                except IndexError:
                    #当所有合约都被爬取完时，数组将越界，引发异常，结束爬取
                    return
            except:
                try:
                    self.contractAddress = self.getContractAddress(self.index)
                    self.index += 1
                    yield scrapy.Request(self.baseUrlPrefix + self.contractAddress + self.baseUrlSuffix, callback = self.parse)
                except IndexError:
                    #当所有合约都被爬取完时，数组将越界，引发异常，结束爬取
                    return
