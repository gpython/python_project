def copy_properties(src):
  def wrapper(dst):
    dst.__name__ = src.__name__
    dst.__doc__ = src.__doc__
    dst.__qualname__ = src.__qualname__
    print("----------")
    return dst
  return wrapper


def logger(fn):
  @copy_properties(fn) #->@wrapper #wrapper = wrapper(wrapper)
  def wrapper(*args, **kwargs):
    print("before")
    ret = fn(*args, **kwargs)
    print("after")
    return ret
  return wrapper

@logger
def add(x, y):  #add = logger(add)
  return x + y


data = add(10, 20)
print(data)