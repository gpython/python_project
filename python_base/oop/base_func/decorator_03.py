#encoding:utf-8
from functools import wraps
import  datetime
import inspect
import time

#函数缓存装饰器

def m_cache(duration=10):
  def _cache(fn):
    local_cache = {} #本地缓存
    @wraps(fn)
    def wrapper(*args, **kwargs):
      #缓存
      #先计算当前时间 与 缓存时间 差值 是否 过期
      expire_key= []
      for k, (_,ts) in local_cache.items():
        if datetime.datetime.now().timestamp() - ts > duration:
          expire_key.append(k)

      for k in expire_key:
        local_cache.pop(k)

      print("args {} kwargs {}".format(args, kwargs))

      key_dict = {}

      #签名 与函数定义参数顺序一致
      sig = inspect.signature(fn)
      params = sig.parameters
      params_list = list(params.keys())

      #位置参数
      for i, v in enumerate(args):
        k = params_list[i]
        key_dict[k] = v

      #kwargs
      key_dict.update(kwargs)

      for k in params.keys():
        if k not in key_dict.keys():
          key_dict[k] = params[k].default

      #构建key
      key = tuple(sorted(key_dict.items()))

      if key not in local_cache:
        ret = fn(*args, **kwargs)
        local_cache[key] = (ret, datetime.datetime.now().timestamp())

      return local_cache[key][0]

    return wrapper
  return _cache

def timeit(fn):
  @wraps(fn)
  def wrapper(*args, **kwargs):
    start = datetime.datetime.now()
    ret = fn(*args, **kwargs)
    delta = (datetime.datetime.now()-start).total_seconds()
    print("time speed {}".format(delta))
    return ret
  return wrapper


@timeit
@m_cache(10)
def add(x, y):
  time.sleep(2)
  return x+y


print(add(10, 20))
print(add(x=1, y=20))
print(add(10, y=2))
print(add(10, 20))
time.sleep(3)
print(add(10, 20))
print(add(10, 20))
print(add(10, 20))
time.sleep(10)
print(add(10, 20))