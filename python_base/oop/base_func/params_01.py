#encoding:utf-8
import inspect


def check(fn):
  def wrapper(*args, **kwargs):
    print(args, kwargs)
    sig = inspect.signature(fn)
    print(sig)
    print("params:", sig.parameters)
    print("return: ", sig.return_annotation)
    print("--------------------------------")

    for i, (name, param) in enumerate(sig.parameters.items()):
      print(i+1, name, param.annotation, param.kind, param.default)
      print(param.default is param.empty, end="\n\n")

    for k, v in kwargs.items():
      if isinstance(v, sig.parameters[k].annotation):
        print('=====')
        print(v, 'is', sig.parameters[k].annotation)

    ret = fn(*args, **kwargs)
    return ret

  return wrapper

@check
def add(x:int, y:int=100) ->int:
  return  x+ y

@check
def add1(x, y=5):
  return x-y

add(10, y=1000)
add1(1000, y=10)