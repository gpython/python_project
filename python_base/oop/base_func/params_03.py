#encoding:utf-8

def partical(func, *args, **kwargs):
  def newfunc(*fargs, **fkwargs):
    newkeywords = kwargs.copy()
    newkeywords.update(fkwargs)
    print("newkeywords:", newkeywords)
    print("args:", args)
    print("fargs:", fargs)

    return func(*(args + fargs), **newkeywords)

  newfunc.func = func
  newfunc.args = args
  newfunc.kwargs = kwargs
  return newfunc

def add(x, y):
  return x + y

newadd = partical(add, 6)
data = newadd(y=4)
print(data)
print(newadd.args)
print(newadd.kwargs)
# print(add.args)
print(newadd.__name__)