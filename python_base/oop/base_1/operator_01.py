#encoding:utf-8

#__getitem__ __setitem__ __iter__

class Cart:
  def __init__(self):
    self.items = []

  def __len__(self):
    return len(self.items)

  def additem(self, item):
    self.items.append(item)

  def __add__(self, other):
    print(other)
    self.items.append(other)
    return self

  def __getitem__(self, item):
    return self.items[item]

  def __setitem__(self, key, value):
    print(key, value)
    self.items[key] = value

  def __iter__(self):
    return iter(self.items)

  def __repr__(self):
    return str(self.items)

  def __missing__(self, key):
    pass

cart = Cart()
print(len(cart))

print(cart + 2 + 3 + 4 + 5 + 6 + 7 )
for x in cart:
  print(x)

cart[3] = 100
print(cart)
cart[3] = 7000
print(cart)


#__call__


class Fib:
  def __init__(self):
    self.lst = [0, 1, 1]

  def __call__(self, x):
    if x < len(self.lst):
      return self.lst

    for i in range(2, x):
      self.lst.append(self.lst[i-1] + self.lst[i])
    return self.lst

a = Fib()
print(a(60))

# __enter__ __exit__
class Point:
  def __init__(self):
    print("init")

  def __enter__(self):
    print("__enter__")
    return self

  def __exit__(self, exc_type, exc_val, exc_tb):
    print(self.__class__.__name__)

p = Point()
with p as f:
  print(f == p)
  print(f is p)
  print(p)
  print(f)


import time
import datetime
from functools import wraps

#函数装饰器
def timeit(fn):
  @wraps(fn)     #wraps(fn)(wrapper) a = wrap(fn); -> a(wrapper); @a
  def wrapper(*args, **kwargs):
    start = datetime.datetime.now()
    ret = fn(*args, **kwargs)
    delta = (datetime.datetime.now() - start).total_seconds()
    print("{} took {}s".format(fn.__name__, delta))
    return ret
  return wrapper

@timeit
def func(x, y):  #func = timeit(func)
  return  x+y

#类装饰器
class TimeIt:
  def __init__(self, fn):
    self._fn = fn
    wraps(fn)(self)   #@wraps(fn)

  def __call__(self, *args, **kwargs):
    #对象被调用时 执行__call__()方法
    print("__call__")
    start = datetime.datetime.now()
    ret = self._fn(*args, **kwargs)
    delta = (datetime.datetime.now() - start).total_seconds()
    print("{} took {}".format(self._fn.__name__, delta))
    return ret

@TimeIt
def func(x, y):  #func = TimeIt(func)
  time.sleep(10)
  return x + y

#fun = TimeIt(func)
#对象被调用时 执行类的__call__方法
func(10, 20)
