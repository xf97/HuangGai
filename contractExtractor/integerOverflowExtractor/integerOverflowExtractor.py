#!/usr/bin/python
#-*- coding: utf-8 -*-

'''
四个抽取标准
1. 参与计算的运算数字中，两个数字都由参数给定
2. 运算是+, -, +=, -=
3. 参与运算的三个数字都是uint256类型
4. 同一函数内存在由三个参与运算的标识符参与的require或assert校验语句
'''