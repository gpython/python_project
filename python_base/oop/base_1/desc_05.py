import  inspect

class Typed:
  def __init__(self, type):
    self.type = type

  def __get__(self, instance, owner):
    pass

  def __set__(self, instance, value):
    print("__set__", self, instance, value)
    if not isinstance(value, self.type):
      raise ValueError(value)
    inspect.__dict__[self.name] = value

class TypeAsset:
  def __init__(self, cls):
    print("----------")
    self.cls = cls

  def __call__(self, name, age):
    params = inspect.signature(self.cls).parameters
    print(params)
    for name, params in params.items():
      print(name, params.annotation)
      if params.annotation != params.empty:
        setattr(self.cls, name, Typed(params.annotation))
    return self.cls

@TypeAsset
class Person:   #Person = TypeAsset(Person)

  def __init__(self, name:str, age:int):
    self.name = name
    self.age = age

  def __repr__(self):
    print("{} is {}".format(self.name, self.age))

p1 = Person('tom', 10)
print(p1.name)
