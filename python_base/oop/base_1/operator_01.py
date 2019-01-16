#encoding:utf-8

class Cart:
  def __init__(self):
    self.items = []

  def __len__(self):
    return len(self.items)

  def additem(self, item):
    self.items.append(item)

  def __add__(self, other):
    print(other)
    self.items.append(other)
    return self

  def __getitem__(self, item):
    return self.items[item]

  def __setitem__(self, key, value):
    print(key, value)
    self.items[key] = value

  def __iter__(self):
    return iter(self.items)

  def __repr__(self):
    return str(self.items)

  def __missing__(self, key):
    pass

cart = Cart()
print(len(cart))

print(cart + 2 + 3 + 4 + 5 + 6 + 7 )
for x in cart:
  print(x)

cart[3] = 100
print(cart)
cart[3] = 7000
print(cart)



class Fib:
  def __init__(self):
    self.lst = [0, 1, 1]

  def __call__(self, x):
    if x < len(self.lst):
      return self.lst

    for i in range(2, x):
      self.lst.append(self.lst[i-1] + self.lst[i])
    return self.lst

a = Fib()
print(a(60))