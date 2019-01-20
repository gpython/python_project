#encoding:utf-8
from functools import wraps
import  datetime, time

def logger(duration, func=lambda name, duration: print("{} took {}s".format(name, duration))):
  def _logger(fn):
    @wraps(fn)
    def wrapper(*args, **kwargs):
      start = datetime.datetime.now()
      ret = fn(*args, **kwargs)
      delta = (datetime.datetime.now() - start).total_seconds()
      if delta < duration:
        func(fn.__name__, delta)
      return ret
    return wrapper
  return _logger

@logger(5)
def add(x, y):
  time.sleep(1)
  return x + y

print(add(10, 20), add.__name__, add.__wrapped__, add.__dict__, sep="\n")
