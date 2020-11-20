#!/usr/bin/python
#-*- coding: utf-8 -*-

import os

def getBugNum():
	infotxt = [file for file in os.listdir() if "nfo.txt" in file]
	linenum = 0
	for item in infotxt:
		f = open(item, "r")
		linenum += len(f.readlines())
		f.close()
	print(linenum)


getBugNum()