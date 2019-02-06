#encoding:utf-8

class Typed:
  def __init__(self, type):
    self.type = type

  def __get__(self, instance, owner):
    print("__get__: ", self, instance, owner)
    pass

  def __set__(self, instance, value):
    print("__set__: ", self, instance, value)
    if not isinstance(value, self.type):
      raise ValueError(value)


class Person:
  name = Typed(str)
  age = Typed(int)

  def __init__(self, name:str, age:int):
    self.name = name
    self.age = age

p = Person('google', 10)
p.name

import  inspect

params = inspect.signature(Person).parameters

for name, param in params.items():
  print(name, param)
  print(name, param.annotation)
