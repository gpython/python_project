#encoding:utf-8
from functools import partial


class ClassMethod:
  def __init__(self, fn):
    self.fn = fn

  def __get__(self, instance, cls):
    print("ClassMethod", self, instance, cls)
    return partial(self.fn, cls)


class StaticMethod:
  def __init__(self, fn):
    self.fn = fn

  def __get__(self, instance, owner):
    print("StaticMethod: ", self, instance, owner)
    return self.fn



class A:
  def __init__(self):
    pass

  @ClassMethod
  def foo(cls):   #foo = ClassMethod(foo)
    print('This is ClassMethod')

  @StaticMethod
  def bar():      #bar = StaticMethod(bar)
    print("This is StaticMethod")




f = A.foo   #类属性  调用ClassMethod __get__方法 返回 partial(self.fn, cls) cls属性所属类
f()         #执行partial(self.fn, cls)()

f = A.bar   #类属性 调用 StaticMethod __get__方法 返回self.fn
f()         #执行self.fn()
