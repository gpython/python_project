#encoding:utf-8

class C(object):
  def __init__(self, x):
    self._x = x

  @property
  def x(self):   # x = property(x)
    return self._x

  @x.setter
  def x(self, value):
    self._x = value

  @x.deleter
  def x(self):
    del self._x


c = C()
print(c.x)


