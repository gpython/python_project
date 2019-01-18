from functools import partial


class StaticMethod:
  def __init__(self, fn):
    self.fn = fn

  def __get__(self, instance, owner):
    print(self, instance, owner)
    return self.fn


class ClassMethod:
  def __init__(self, fn):
    self.fn = fn

  def __get__(self, instance, cls):
    print(self, instance, cls)
    # return self.fn(cls) None
    return partial(self.fn, cls)

class A:
  #以下相当于类实例

  @StaticMethod
  def foo():    #foo = StaticMethod(foo)
    print("foo")

  @ClassMethod
  def bar(cls): #bar = ClassMethod(bar)
    print(cls.__name__)

# f = A.foo
# f()
# print(f())

f = A.bar
f()