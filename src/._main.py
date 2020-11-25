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


#常量部分
USER_NEEDS_PATH = "userNeeds.json"	#用户需求文档，指定了每种bug的所需合约数量和注入的最长时间
CONFIG_PATH = "config.json"	#配置文档

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
		#3. 遍历每种bug，遇到需要的启动
		for bug in userNeeds:
			num = userNeeds[bug][0]
			#超时时间-分钟换算成秒
			timeOut = userNeeds[bug][1] * 60
			if num != 0:
				#执行该种bug的注入
				#读取信息
				extractPath = scriptAndPath[bug]["Extractor"][0]				
				extractIns = scriptAndPath[bug]["Extractor"][1] + " " + str(num)	#增加需求数量
				#打印信息
				print("Injecting --", bug)
				print("Injecting --", bug, " Step 1: Extracting")
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
					print("Injecting --", bug, " Step 2: Injecting")
					#注入
					#切换到注入工作目录
					injectPath = os.path.join(self.rootPath, injectPath)
					os.chdir(injectPath)	
					#然后调用命令
					subprocess.run(injectIns, check = True, shell = True)
					#注入结束，打印信息
					print("Injecting --", bug, "Done!")
					successNum += 1
				except subprocess.TimeoutExpired:
					print("TIME OUT: Injecting ", bug)
					#os.killpg(os.getpgid(process.pid), signal.SIGKILL)
					#os.killpg(process.pid, signal.SIGKILL)
					os.killpg(os.getpgid(process.pid),signal.SIGUSR1)
					time.sleep(3)
					timeOutNum += 1
					continue
				except:
					print("Unknown error: Injecting ", bug)
					falseNum += 1
					continue
			else:
				continue
		print(successNum, timeOutNum, falseNum)

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