#encoding:utf-8

class Property:
  def __init__(self, fget, fset=None):
    self.fget = fget
    self.fset = fset


  def __set__(self, instance, value):
    if callable(self.fset):
      self.fset(instance, value)
    else:
      raise AttributeError()

  def __get__(self, instance, owner):
    if instance:
      return self.fget(instance)
    return self


  def setter(self, fn):
    self.fset = fn
    return self



class A:
  def __init__(self, data):
    self._data = data

  @Property
  def data(self):    #data = Property(data)
      return self._data

  @data.setter      #data = Property(data).setter(data) ->
  def data(self, data):
    self._data = data


a = A(10)
print(a.data)

a.data = 100
print(a.data)
