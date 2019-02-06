#encoding:utf-8

import functools

print(dir()) #收集当前模块的所有对象
print(dir(functools))  #收集指定模块的所有对象
print(functools)
print(functools.wraps)