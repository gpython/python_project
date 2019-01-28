#encoding:utf-8

class Fib:
  def __init__(self):
    self.lst = [0,1,1]

  def __call__(self, x):
    if x < len(self.lst):
      return self.lst

    for i in range(2, x):
      self.lst.append(self.lst[i-1] + self.lst[i])
    return self.lst


f = Fib()
print(f(10))
print(f(3))