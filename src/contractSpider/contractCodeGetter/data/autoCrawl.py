#!/usr/bin/python
#-*- coding: utf-8 -*-

import subprocess

def autoCrawl():
	#completeResult = subprocess.run("scrapy crawl latestContractsAddress", shell = True)
	completeResult = subprocess.run("scrapy crawl getContractAddressSpider", shell = True)
	completeResult = subprocess.run("scrapy crawl nontokenContractAddress", shell = True)
	completeResult = subprocess.run("scrapy crawl codeGetter", shell = True)

autoCrawl()