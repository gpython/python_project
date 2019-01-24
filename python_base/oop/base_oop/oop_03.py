#encoding:utf-8
import random

# class Randnum:
#   def __init__(self, minnum=0, maxnum=100, num=10):
#     self.min = minnum
#     self.max = maxnum
#     self.num = num
#
#   def create(self):
#     return [random.randint(self.min, self.max) for x in range(self.num)]
#
# r = Randnum()
# print(r.create())


class RandnumGenerator:
  def __init__(self, count=10, start=1, stop=100):
    self.count = count
    self.start = start
    self.stop = stop
    #
    self.gen = self._generate()

  def _generate(self):
    # 生成器 挂住
    while True:
      yield [random.randint(self.start, self.stop) for _ in range(self.count)]

  def generate(self, count):
    self.count =count
    return next(self.gen)


class Point:
  def __init__(self, x, y):
    self.x = x
    self.y = y

  def __repr__(self):
    return "{}:{}".format(self.x, self.y)




r = RandnumGenerator()
lst = r.generate(3)
zlst = zip(r.generate(10), r.generate(10))
print(lst)
print(list(zlst))

points = [Point(*v) for v in zip(r.generate(10), r.generate(10))]

for p in points:
  print(p)
