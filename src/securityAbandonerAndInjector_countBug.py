#!/usr/bin/python
#-*- coding: utf-8 -*-

import os

def countBug():
	infoList = [infoFile for infoFile in os.listdir() if "nfo.txt" in infoFile]
	lineNum = 0
	for file in infoList:
		f = open(file, "r")
		lineNum += len(f.readlines())
		f.close()
	print(lineNum)

countBug()