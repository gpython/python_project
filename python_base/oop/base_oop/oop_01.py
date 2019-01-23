#encoding:utf-8

class Person:
  x = "class_attr"
  height = 178
  def __init__(self, name, age=18):
    self.name = name
    self.age = age

  def show(self, x, y):
    print(self.name, self.age, self.x, x, y)
    self.y = x
    Person.x = x


a = Person("tom")
b = Person("Jerry", 20)

a.show(10, 1000)
print(b.x)
print(a.x)

print(Person.height, a.height, b.height)
print(a.__class__, b.__class__)
print(a.__class__.__qualname__, a.__class__.__name__)

#对象属性 将属性添加到对象上
#相当于为对象新增一个属性 height
#在当前对象的__dict__中就会有此键值
a.height = 180
b.height = 183
print(Person.height, a.height, b.height)

#类的属性字典 方法只有一份 只是传参不一样而已
#方法属于类
print(Person.__dict__)

#对象保存自己的属性 对象自己的属性字典
#对象的字典中没有方法 方法属于类的
print(a.__dict__)
print(b.__dict__)
print(a.x)
#异常
#print(b.__dict__['x'])

#类属性保存在类的__dict__中 实例属性保存在实例的__dict__中
#如果从实例访问类的属性 就需要借助__class__找到所属的类
#对象先寻找自己的__dict__ 若没有 从类的__dict__中寻找

#是类的也就是这个类所有实例的 所有实例都可以访问
#是实例的 就是这个实例自己的 通过类访问不到
