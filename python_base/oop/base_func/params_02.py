#encoding:utf-8
from functools import wraps

import inspect
def check(fn):
  @wraps(fn)
  def wrapper(*args, **kwargs):
    print(args, kwargs)
    sig = inspect.signature(fn)
    params = sig.parameters
    params_list = tuple(params.keys())

    print("sig: ", sig)
    print("params: ", params)
    print("params_list: ", params_list)

    for i, v in enumerate(args):
      k = params_list[i]
      if isinstance(v, params[k].annotation):
        print(v, 'is', params[k].annotation)
      else:
        errstr = "{} {} {}".format(v, "is not", params[k].ennotation)
        print(errstr)
        raise TypeError

    for k, v in kwargs.items():
      if isinstance(v, params[k].annotation):
        print(v, "is", params[k].annotation)
      else:
        errstr = "{} {} {}".format(v, "is not", params[k].annotation)
        print(errstr)
        raise TypeError
      return wrapper
    ret= fn(*args, **kwargs)
    return ret
  return wrapper


@check
def add(x:int, y:int) ->int:
  return x+y

add(10, 100)