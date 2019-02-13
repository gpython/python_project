#描述器
#python中 一个类实现了__get__ __set__ __delete__三个方法中的任何一个方法 就是描述器
#如果仅实现了__get__ 就是非数据描述符
#同时实现了__get__ __set__ 就是数据描述符
#如果一个类的类属性设置为描述器 那么他就是被称为owner属主
#描述器 对于类属性 有意义

#调用机制 必须要有属主 owner类
#调用机制 必须把自己的实例 作为另一个类的 类属性 才可以 作为另一个类的 实例属性 self属性 是不可行的
#A类为 描述器  A的实例x作为B类的类属性

#同时实现了__get__ __set__ 就是 数据描述器
class A:
  def __init__(self):
    print("A.init")
    self.a = "a"

  # self都是A的实例
  # owner都是B类 属主类
  # instance说明
  # -None表示是没有B类的实例 对应调用B.x
  # <__main__.B object at 0x021F5430> 表示是B的实例 对应调用B().x
  def __get__(self, instance, owner):
    print("A.__get__", self, instance, owner)
    return self
  #实例的__dict__优先于非数据描述器
  #数据描述器 优先于实例的__dict__
  #
  def __set__(self, instance, value):
    print("A.__set__", self, instance, value)

class B:
  x = A()
  def __init__(self):
    print("B.init")
    self.x = 100

# print(B.x)
# print("*"*60)
# b = B()
# print(b.x)
# print()
b = B()
print("*"*60)
print(b.x)
print("*"*60)

b.x = 1000
print(b.x)
print("*"*60)
# B.x = 5000
print(b.__dict__)
print(B.__dict__)
print(b.x)
print(B.x)