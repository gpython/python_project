####OOP

__dict__ 类或实例的属性 可写的字典 用户自定义的 类方法或属性在此

foo() 等价于 foo.__call__()
函数即对象 对象foo加上() 就是调用对象的__call__()方法

实例化对象的时候 并不会调用enter 进入with语句块调用__enter__ 方法 然后执行语句体
最后离开with语句块时 调用__exit__方法

反射 自省

getattr(object, name[, default]) 通过name返回object的属性值 当属性不存在 将使用default返回 如果没有default 则抛出AttributeError name必须为字符串

setattr(object, name, value) object的属性存在 则覆盖 不存在 则新增

hasattr(object, name) 判断对象是否有这个名字的属性 name必须为字符串

__getattr__ 当通过搜索实例 实例的类 及 祖先类查找不到属性 就会调用此方法
 
__setattr__ 通过访问实例属性 进行增加 修改都要调用它

__delattr__ 当通过实例来删除属性时调用此方法

__getattribute__ 实例所有属性调用都从这个方法开始


实例的所有属性访问 第一个都会调用__getattribute__方法 它阻止了属性的查找 该方法返回(计算后的)值 或者抛出一个AttributeError异常
它的return值将作为属性查找的结果 结果抛出AttributeError异常 则会直接调用__getattr__方法 因为表示属性没有找到
__getattribute__方法中为了避免在该方法中无限的递归 它的实现应该永远调用基类的同名方法以访问需要的任何属性 object.getattribute(self, name)


实例调用__getattribute__() -> instance.__dict__ -> instance.__class__.__dict__ -> 继承的祖先类(知道object)的__dict__ -> 调用__getattr__()