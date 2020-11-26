#!/usr/bin/python
#-*- coding: utf-8 -*-

import re
import os
import subprocess
from shutil import rmtree

'''
本文件用于收集黄盖所有的源代码，然后复制到github仓库中，
以防止代码丢失
'''

def getFilePath(root_path, file_list, dir_list):
    # 获取该目录下所有的文件名称和目录名称
    dir_or_files = os.listdir(root_path)
    for dir_file in dir_or_files:
        # 获取目录或者文件的路径
        dir_file_path = os.path.join(root_path, dir_file)
        # 判断该路径为文件还是路径
        if os.path.isdir(dir_file_path):
            dir_list.append(dir_file_path)
            # 递归获取所有文件和目录的路径
            getFilePath(dir_file_path, file_list, dir_list)
        else:
            file_list.append(dir_file_path)


if __name__ == "__main__":
	#建立文件夹
    os.mkdir("./src/")
    # 根目录路径
    root_path = "."
    # 用来存放所有的文件路径
    file_list = []
    # 用来存放所有的目录路径
    dir_list = []
    getFilePath(root_path, file_list, dir_list)
    pyList = list()
    for i in file_list:
        if i.endswith(".py"):
            pyList.append(i)
    pyList.remove("./getSourceCode.py")
    #拷贝所有的py文件
    for i in pyList:
        #组合出目标地址
        prefix = i.split("/")[-2]
        #print(prefix)
        filename = prefix + "_" + os.path.basename(i)
        desPath = os.path.join("./src/", filename)
        codeExecuteResult = subprocess.run("cp -v -rf " + i + " " + desPath, check = True, shell = True)
    #将文件拷贝到目标地址
    codeExecuteResult = subprocess.run("cp -v -rf ./src/" + " " + "/home/xiaofeng/桌面/MyGithub/HuangGai/", check = True, shell = True)
    #然后，删除文件
    rmtree("./src/")
    