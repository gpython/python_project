
#可迭代对象
li = [1,2,3,4,5,6]

#可迭代对象转换为迭代器
iter(li)

def func():
  yield 1
  yield 2
  yield 3

#生成器
li = func()

#生成器转换为迭代器
data = iter(li)

#生成器 迭代器 都有__next__()
data.__next__()
li.__next__()

#传入参数 生成器 或者 可迭代对象
def get_all(arg):
  data = iter(arg)
  print(data.__next__())


