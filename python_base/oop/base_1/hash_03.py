#encoding:utf-8
from collections import Hashable

#唯一 坐标点
class Point:
  def __init__(self, x, y):
    self.x = x
    self.y = y

  def __hash__(self):
    return hash((self.x, self.y))

  def __eq__(self, other):
    #先判断 同一对象 直接返回True 为同一坐标
    if self is other:
      return True
    #判断两个点坐标是否一致
    return self.x == other.x and self.y == other.y

p1 = Point(10, 20)
p2 = Point(10, 20)
print(hash(p1))
print(hash(p2))


print(p1 is p2)

print(p1 == p2)

print(set((p1, p2)))

print(isinstance(p1, Hashable))