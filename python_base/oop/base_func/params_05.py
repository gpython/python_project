#encoding:utf-8
import datetime
from functools import wraps
import time
import  inspect
"""
import inspect

#函数
def iadd(x, y=10):    
  return x+y

#函数 签名
sig = inspect.signature(iadd)
#签名参数列表 有序 和函数定义参数列表参数位置一样
params = sig.parameters

print(params)
#参数位置和iadd函数参数位置一样
Out[43]:
mappingproxy({'x': <Parameter at 0x6fffd97da20 'x'>,
              'y': <Parameter at 0x6fffc8e4c60 'y'>})

#有序字典key值遍历 遍历iadd函数参数 
for k in params.keys():
  print(params[k])
  #带默认值函数 输出默认值
  print(params[k].default)

x
<class 'inspect._empty'>
y=10
10

"""



def m_cache(expire):
  def _cache(fn):
    local_cache = {} #对不同函数名字 是不同的cache
    @wraps(fn)
    def wrapper(*args, **kwargs):
      #local_cache 缓存过期时间
      #执行迭代期间 字典的大小不能更改 iteration
      #不可在循环中直接删除字典key值
      #过期key暂存列表
      expire_keys = []
      for k, (_, ts) in local_cache.items():
        if datetime.datetime.now().timestamp() - ts > expire:
          expire_keys.append(k)
       for k in expire_keys:
        local_cache.pop(k)

      print("args {} kwargs {}".format(args, kwargs))

      key_dict = {}

      #函数签名
      sig = inspect.signature(fn)       #参数签名
      params = sig.parameters           #函数 参数 有序字典
      params_list = list(params.keys()) #函数所有参数 有序字典的 keys 有序字典key位置 与位置参数位置一一对应
      print("params_list {} ".format(params_list))

      #位置参数 args
      for i, v in enumerate(args):
        print("位置参数i:{} v:{}".format(i, v))
        k = params_list[i]
        key_dict[k] = v

      #关键字参数
      # for k, v in kwargs.items():
      #   key_dict[k] = v
      key_dict.update(kwargs)

      #缺省值 问题
      for k in params.keys():
        if k not in key_dict.keys():
          key_dict[k] = params[k].default

      #key 字典构建 排序处理 tuple可hash
      key = tuple(sorted(key_dict.items()))
      print("排序处理 字典 key构建{}".format(key))

      if key not in local_cache.keys():
        print("---------------------------------key:{} miss caceh------------------".format(key))
        ret = fn(*args, **kwargs)
        local_cache[key] = (ret, datetime.datetime.now().timestamp())
        print("local_cache: {} ".format(local_cache))

      return local_cache[key][0]
    return wrapper
  return _cache


def timeit(fn):
  def wrapper(*args, **kwargs):
    start = datetime.datetime.now()
    ret = fn(*args, **kwargs)
    delta = (datetime.datetime.now() - start).total_seconds()
    print("time speed: {} seconds".format(delta))
    return ret
  return wrapper



@timeit
@m_cache(5)
def iadd(x, y=10, *args, **kwargs):
  time.sleep(3)
  return x + y

@m_cache(5)
def fib(n):
  if n < 2:
    return n
  return fib(n-1) + fib(n-2)


print(iadd(5, z=11))
print(iadd(5, z=11))
print(iadd(5, z=11))

print(iadd(10, 20))
print(iadd(10, 20))
print(iadd(10, 20))
print(iadd(10, 20))
print(iadd(10, 20))
print(iadd(10, 20))
# # print(add(10, 20))
# # print(add(10, 20))
# print("*"*60)
# print(iadd(x=10, y=20))
# print(iadd(x=10, y=20))
# print(iadd(x=10, y=20))
# print(iadd(x=10, y=20))
# print("*"*60)
# print(iadd(18, y=39))
# print(iadd(18, y=39))
# print(iadd(18, y=39))
# print(iadd(18, y=39))
# print(iadd(18, y=39))
# print("*"*60)
# print(list(fib(i) for i in range(10)))
# print('----')
# print(list(fib(i) for i in range(11)))
# print(list(fib(i) for i in range(12)))
# print(iadd(18, y=37))



