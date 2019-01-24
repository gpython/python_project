#encoding:utf-8

class Animal:
  x = 123
  def __init__(self, name):
    self._name = name
    self.__age = 10

  @property
  def name(self):
    return self._name

  def shout(self):
    print("Animal shout")

class Cat(Animal):
  x = "cat"
  def __init__(self, name):
    Animal.__init__(self, name)
    self.catname = name

  def shout(self):
    print("Cat Miao ...")

  @classmethod
  def clsmeth(cls):
    print(cls, cls.__name__)

class Garfield(Cat):
  pass

class PersiaCat(Cat):
  pass

class Dog(Animal):
  def run(self):
    print("Dog run")

tom = Garfield("tom")
#tom = Cat("tom")
print(tom.name)
print(tom.shout())
print(tom.clsmeth())
print(Garfield.clsmeth())
# print(tom._Animal__age)
print("*"*60)
print(tom.__dict__)

print(Garfield.__dict__)
print(Cat.__dict__)
print(Animal.__dict__)