#encoding:utf-8
import functools
import time

@functools.lru_cache()
def add(x, y=5):
  time.sleep(2)
  ret = x + y
  print(ret)
  return ret

print(add(4))
print('*'*60)
print(add(4))
print(add(4))


@functools.lru_cache()
def fib(n):
  if n < 2:
    return n
  return fib(n-1) + fib(n-2)

print([fib(x) for x in range(4)])