#encoding:utf-8
"""
__hash__ 内建函数hash()调用的返回值 返回一个整数
如果定义这个方法 该类的实例就可hash
可hash 不代表可去重

__eq__ 对应== 操作符 判断两个对象是否相等 返回bool值

__hash__方法只是返回一个hash值作为set的key 但是去重还需要__eq__来判断两个对象是否相等
hash值相等 只是hash冲突

可hash对象必须提供__hash__方法 没有提供的话 isinstance(p1, collections.Hashable)一定为False
去重要提供__eq__方法
"""

class A:
  def __init__(self):
    self.a = 'a'
    self.b = 'b'

  def __hash__(self):
    return hash((self.a, self.b))

  def __eq__(self, other):
    if self is other:
      return True
    return self.a == other.a and self.b == other.b

