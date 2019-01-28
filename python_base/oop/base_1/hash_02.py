#encoding:utf-8

class Mylist(list):
  def __hash__(self):
    print("hash__-")
    return hash(self[0])

  def __eq__(self, other):
    print("_eq__-")
    return self[0] == other


l1 = Mylist([1,2,3])
# print(l1)

d = {}
print('-----')
d[l1] = l1
print(d)

d[1] = 10
print(d)