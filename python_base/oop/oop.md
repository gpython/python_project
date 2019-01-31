####OOP
- 类属性保存在类的__dict__中 实例属性保存在实例的__dict__中
- 如果从实例访问类的属性 就需要借助__class__找到所属的类
- 对象先寻找自己的__dict__ 若没有 从类的__dict__中寻找

- 是类的也就是这个类所有实例的 所有实例都可以访问
- 是实例的 就是这个实例自己的 通过类访问不到
- 类变量是属于类的变量 这个类的所有实例可以共享这个变量
- 实例可以动态的给自己添加一个属性 实例.__dict__[变量名] 和 实例.变量名 都可以访问到
- 实例的同名变量会 隐藏 这类变量 或者说覆盖了 这个类变量

- 实例属性查找顺序
- 实例使用 . 来访问属性 会先找自己的__dict__ 如果没有 然后通过 实例.__class__找到自己的类 再去类的__dict__中查找
- 注意 如果实例使用__dict__[变量名] 访问变量 将不会按照 上面的查找顺序 找变量


__dict__ 类或实例的属性 可写的字典 用户自定义的 类方法或属性在此


#### 继承

- __base__ 类的基类
- __bases__ 类的基类元组
- __mro__ 显示方法查找顺序 基类的元组
- mro()   同上  int.mro()
- __subclasses__() 类的子类列表  int.__subclasses__() 


- 属性查找顺序
    - 实例.__dict__ => 类.__dict__ => 有继承 父类.__dict__
- super().__init__(params)
- 父类.__init__(self, params)
- super(当前类, self).__init__(params)  #不推荐
- 作为一个好习惯 如果父类定义了__init__方法 就该在子类的__init__中调用
- 自己的私有属性 就该自己的方法读取和修改 不要借助其他类的方法 即使是父类或者派生类的方法
- 父类的 祖先类的 继承后都是自己的 除了私有的

```python
def printable(cls):
  def _print(self):
    return self.content
  cls.print = _print
  return cls

def printable(cls):
  cls.print = lambda self: self.content
  cls.name = 'gppgle'
  return cls


@printable
class Printable:      #Printable = printable(Printable)
  def __init__(self, content):
    self.content = content

p = Printable('abc')
print(p.print())
print(p.__dict__)
print(Printable.__dict__)
```
#### Mixin

- __getitem__(self, i) 列表索引值 获取 list[i]



#### hash
- __hash__ 方法只是返回一个hash值作为set的key 但是去重 还需要__eq__来判断2个对象是否相等
- hash值相等 只是hash冲突 不能说明两个对象是相等的
- 一般来说 提供__hash__方法是为了作为set或者dict的key的 去重的同时提供__eq__方法
- 可hash对象必须提供__hash__方法 没有提供的话 isinstance(p1, collections.Hashable)一定为False
- 去重提供__eq__方法


__len__ 内建函数len()返回对象的长度 bool()函数调用的时候 如果有__bool__()方法 则会看__len__()方法是否存在存在返回非0为真

__iter__ 迭代容器时 调用 返回一个新的迭代器对象

__contains__ in成员对象符 没有实现 就调用__iter__方法遍历 

__getitem__ 实现self[key]访问 序列对象 key接受整数为索引 或者切片 对于set和dict key为hashable key不存在引发keyerror异常

__setitem__ 和__getitem__ 的访问类似 是设置值的方法

__missing__ 字典使用__getitem__()调用时 key不存在执行此方法


foo() 等价于 foo.__call__()
函数即对象 对象foo加上() 就是调用对象的__call__()方法

实例化对象的时候 并不会调用enter 进入with语句块调用__enter__ 方法 然后执行语句体
最后离开with语句块时 调用__exit__方法

反射 自省

当设置 对象属性的时候 __setattr__ 一定先被触发调用 但是是否将属性放到__dict__中 非程序所控制 自己控制的 增加

__setattr__ 可以拦截对实例属性的增加 修改操作 如果要设置生效 需要自己操作实例的__dict__ 此时 查找相应属性时就从__dict__中获取 不再从__getattr__中查找

__getattr__ 一个类属性会按照继承关系查找 对象属性查找 

instance.dict -> instance.__class__.dict->继承到祖先类的object的dict -> 调用getattr() __getattr__ -> 若没有 异常


__getattribute__ > __dict__ > __getattr__ 属性查找 优先级顺序 (类中方法查找优先级顺序)

类或对象属性查找时 __getattribute__ 先被执行  优先于__dict__之前执行

__getattr__ 先查找__dict__ 然后在执行__getattr__

实例的所有的属性访问 第一个都会调用__getattribute__方法 它阻止了属性的查找 该方法返回 计算后的值 或者抛出AttributeError异常

他的return值将作为属性查找的结果 如果抛出AttributeError异常 则会直接调用__getattr__方法 因为表示属性没有找到



- getattr(object, name[, default]) 通过name返回object的属性值 当属性不存在 将使用default返回 如果没有default 则抛出AttributeError name必须为字符串
- setattr(object, name, value) object的属性存在 则覆盖 不存在 则新增
- hasattr(object, name) 判断对象是否有这个名字的属性 name必须为字符串
- __getattr__ 当通过搜索实例 实例的类 及 祖先类查找不到属性 就会调用此方法
- __setattr__ 通过访问实例属性 进行增加 修改都要调用它
- __delattr__ 当通过实例来删除属性时调用此方法
- __getattribute__ 实例所有属性调用都从这个方法开始


实例的所有属性访问 第一个都会调用__getattribute__方法 它阻止了属性的查找 该方法返回(计算后的)值 或者抛出一个AttributeError异常
它的return值将作为属性查找的结果 结果抛出AttributeError异常 则会直接调用__getattr__方法 因为表示属性没有找到
__getattribute__方法中为了避免在该方法中无限的递归 它的实现应该永远调用基类的同名方法以访问需要的任何属性 object.getattribute(self, name)


实例调用__getattribute__() -> instance.__dict__ -> instance.__class__.__dict__ -> 继承的祖先类(知道object)的__dict__ -> 调用__getattr__()

### 描述器
- __get__
- __set__
- __delete__
- object.__get__(self, instance, owner)
- object.__set__(self, instance, value)
- object.__delete__(self, instance)
- self指代当前实例 调用者
- instance 是owner的实例
- owner是属性的所属的类


- python中 一个类实现了__get__ __set__ __delete__三个方法中的任何一个方法 就是描述器
- 如果仅实现了__get__ 就是非数据描述符
- 同时实现了__get__ __set__ 就是数据描述符
- 如果一个类的类属性设置为描述器 那么他就是被称为owner属主
- 描述器 对于类属性 有意义
- 调用机制 必须要有属主 owner类
- 调用机制 必须把自己的实例 作为另一个类的 类属性 才可以 作为另一个类的 实例属性 self属性 是不可行的
- A类为 描述器  A的实例x作为B类的类属性
- 
- 如果仅实现了__get__ 就是          非数据描述器
- 同时实现了__get__ __set__ 就是   数据描述器

- 实例的__dict__优先于非数据描述器
- 数据描述器 优先于实例的__dict__


mod = __import__("moduleName")
mod = importlib.import_module(m)
getattr(mod, "ClassName")().funcName()

内建函数 __import__()

import 语句本质上就是调用__import__这个函数 但不鼓励直接使用 建议使用importlib.import_module()
 
sys = __import__("sys") 等价于 import sys 

```python
import importlib

def plugin_load(plugin_name:str, sep=":"):
  m,_,c = plugin_name.partition(sep)
  mod = importlib.import_module(m)
  cls = getattr(mod, c)
  return cls()

if __name__ == '__main__':
  a = plugin_load("test:A")

```


