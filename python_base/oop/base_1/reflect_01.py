class A:
  def __init__(self, x):
    self.x = x

  def __getattr__(self, item):
    print("__getattr__", item)
    # return self.x

  def __setattr__(self, key, value):
    print("__setattr__", key, value)
    # self.key = value

# a = A(10)
# b = A(20)

# print(a.x)
# print(b.y)
# print(a.z)







