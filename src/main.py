#!/usr/bin/python
#-*- coding: utf-8 -*-

'''
这是黄盖主控程序
用于根据用户的需求，拉起不同种类bug的注入模块
'''

#导入第三方库部分
import os
import json
import subprocess
import sys
import signal	#用于指定杀死进程时的信号
import time
#定制输出
from rich import print
from rich.console import Console
from rich.table import Column, Table


#常量部分
USER_NEEDS_PATH = "userNeeds.json"	#用户需求文档，指定了每种bug的所需合约数量和注入的最长时间
CONFIG_PATH = "config.json"	#配置文档
DATASET_PATH = "/dataset"

class bugInjector:
	def __init__(self, _userNeeds, _configPath):
		self.userNeedsPath = _userNeeds
		self.configPath = _configPath
		self.rootPath = os.getcwd()	#根目录，用于在目录跳转时作为中转

	def run(self):
		#1. 读取用户的需求　
		userNeeds = dict()
		userNeeds = self.getUserNeeds()
		#2. 读取配置，主要是每种bug的抽取器和注入器的启动命令和对应路径
		scriptAndPath = dict()
		scriptAndPath = self.getConfig()
		successNum = 0
		timeOutNum = 0
		falseNum = 0
		#注入信息表格记录数据
		#键是bug名，值是注入的数量和保存的路径
		injectInfo = dict()
		console = Console()	#定制输出
		#3. 遍历每种bug，遇到需要的启动
		for bug in userNeeds:
			injectInfo[bug] = list()
			num = userNeeds[bug][0]
			#超时时间-分钟换算成秒
			timeOut = userNeeds[bug][1] * 60
			if num != 0:
				#执行该种bug的注入
				#读取信息
				extractPath = scriptAndPath[bug]["Extractor"][0]				
				extractIns = scriptAndPath[bug]["Extractor"][1] + " " + str(num)	#增加需求数量
				#打印信息
				console.log("[bold cyan]Injecting[/bold cyan] -- " + bug)
				console.log("[bold cyan]Injecting[/bold cyan] -- " + bug + " Step 1: Extracting")
				#抽取
				#切换到抽取工作目录
				extractPath = os.path.join(self.rootPath, extractPath)
				os.chdir(extractPath)
				#然后调用命令
				process = subprocess.Popen(extractIns, shell = True, preexec_fn = os.setpgrp)
				try:
					process.communicate(timeout = timeOut)
					#切换回根目录
					os.chdir(self.rootPath)
					#读取注入信息
					injectPath = scriptAndPath[bug]["Injector"][0]				
					injectIns = scriptAndPath[bug]["Injector"][1]
					#打印信息
					console.log("[bold cyan]Injecting[/bold cyan] -- " + bug + " Step 2: Injecting")
					#注入
					#切换到注入工作目录
					injectPath = os.path.join(self.rootPath, injectPath)
					os.chdir(injectPath)	
					#然后调用命令
					subprocess.run(injectIns, check = True, shell = True)
					#注入结束，打印信息
					console.log("[bold cyan]Injecting[/bold cyan] --", bug, "[bold yellow]Done![/bold yellow]")
					successNum += 1
					injectInfo[bug].append("Success")		
					injectInfo[bug].append(num)
					injectInfo[bug].append(injectPath + DATASET_PATH)
				except subprocess.TimeoutExpired:
					console.log("[bold red]TIME OUT[/bold red]: Injecting ", bug)
					#os.killpg(os.getpgid(process.pid), signal.SIGKILL)
					#os.killpg(process.pid, signal.SIGKILL)
					os.killpg(os.getpgid(process.pid),signal.SIGUSR1)
					time.sleep(3)
					timeOutNum += 1
					injectInfo[bug].append("Time out")	
					injectInfo[bug].append(0)
					injectInfo[bug].append(injectPath + DATASET_PATH)
					continue
				except:
					console.log("[bold red]Unknown error[/bold red]: Injecting ", bug)
					falseNum += 1
					injectInfo[bug].append("Exception")	
					injectInfo[bug].append(0)
					injectInfo[bug].append(injectPath + DATASET_PATH)
					continue
			else:
				continue
		#最终信息打印部分
		#概述表格
		overviewTable = Table(show_header = True, header_style = "bold magenta")
		overviewTable.add_column("Inject summary", style = "dim", width = 12)
		overviewTable.add_column("Success bug type num", style = "dim", width = 12)		
		overviewTable.add_column("Timeout bug type num", style = "dim", width = 12)
		overviewTable.add_column("Unknown error bug type num", style = "dim", width = 12)
		overviewTable.add_row("", str(successNum), str(timeOutNum), str(falseNum))
		console.print(overviewTable)
		#详情表格
		informationTable = Table(show_header = True, header_style = "bold magenta")
		informationTable.add_column("Bug type", style = "dim", width = 22)
		informationTable.add_column("Inject status", style = "dim", width = 8)		
		informationTable.add_column("Success contracts num", style = "dim", width = 12)
		informationTable.add_column("Date set path", style = "dim")
		for bug in injectInfo:
			if len(injectInfo[bug]) != 0:
				informationTable.add_row(str(bug), str(injectInfo[bug][0]), str(injectInfo[bug][1]), str(injectInfo[bug][2]))
			else:
				#分组为空，重新设计
				informationTable.add_row(str(bug), "Not required.", "Not required.", "Not required.")
		console.print(informationTable)


	def getConfig(self):
		with open(self.configPath, "r", encoding = "utf-8") as f:
			text = f.read()
			#要清洗换行符号
			text = text.replace("\n", "")
			return json.loads(text)
		return str()

	def getUserNeeds(self):
		with open(self.userNeedsPath, "r", encoding = "utf-8") as f:
			text = f.read()
			#要清洗换行符号
			text = text.replace("\n", "")
			return json.loads(text)
		return str()



#主控模块
if __name__ == "__main__":
	main = bugInjector(USER_NEEDS_PATH, CONFIG_PATH)
	main.run()