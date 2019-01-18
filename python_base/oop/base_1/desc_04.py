class Typed:
  def __init__(self, type):
    self.type = type

  def __get__(self, instance, owner):
    pass

  def __set__(self, instance, value):
    print("__set__", self, instance, value)
    if not isinstance(value, self.type):
      raise ValueError(value)


class Person:
  name = Typed(str)
  age = Typed(int)

  def __init__(self, name, age:int):
    self.name = name
    self.age = age


p = Person('googl', 10)

import  inspect
print(inspect.signature(Person).parameters)