<<<<<<< HEAD
#描述符Str
class Str:
    def __get__(self, instance, owner):
        print('Str调用')
    def __set__(self, instance, value):
        print('Str设置...')
    def __delete__(self, instance):
        print('Str删除...')

#描述符Int
class Int:
    def __get__(self, instance, owner):
        print('Int调用')
    def __set__(self, instance, value):
        print('Int设置...')
    def __delete__(self, instance):
        print('Int删除...')

class People:
    name=Str()
    age=Int()
    def __init__(self,name,age): #name被Str类代理,age被Int类代理,
        self.name=name
        self.age=age

#何地？：定义成另外一个类的类属性

#何时？：且看下列演示

p1=People('alex',18)

#描述符Str的使用
p1.name
p1.name='egon'
del p1.name
=======
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
>>>>>>> 6e6ba2362bc5133550890014cd0922fb669f707f
