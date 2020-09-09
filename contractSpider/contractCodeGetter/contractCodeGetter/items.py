# Define here the models for your scraped items
#
# See documentation in:
# https://docs.scrapy.org/en/latest/topics/items.html

import scrapy


class ContractcodegetterItem(scrapy.Item):
    # define the fields for your item here like:
    #序号
    number = scrapy.Field()
    #代币名称
    name = scrapy.Field()
    #代币地址
    address = scrapy.Field()
    #代币市值，可选
    #marketCap = scrapy.Field()
    #pass
