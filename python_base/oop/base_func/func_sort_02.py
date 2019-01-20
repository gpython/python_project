#encoding:utf-8
lst = [2,3,1,4,5,6,2]

# def sort(iterable, key=lambda a,b: a<b, reverse=False):
#   ret = []
#   for x in lst:
#     for i, y in enumerate(ret):
#       # y=2
#       # x=3
#       flag = key(x, y) if reverse else key(y, x)
#       if flag:
#         ret.insert(i, x)
#         break
#     else:
#       ret.append(x)
#       print(x)
#   return ret
#
# print(sort(lst, reverse=False))

def sort(iterable, key=lambda x,y: x>y, reverse=False):
  ret = []
  if key is None:
    key = lambda x, y: x>y
  for x in iterable:
    for i, y in enumerate(ret):
      # flag = key(x, y) if reverse else key(y, x)
      if flag:
        ret.insert(i, x)
        break
    else:
      ret.append(x)
  return ret

print(sort(lst))


