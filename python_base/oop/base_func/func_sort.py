#encoding:utf-8
lst = [1,5,8,3,9,0,7,4,6,2]

def sort(iterable, key=lambda a,b:a<b, reverse=False):
  ret = []
  for x in iterable:
    print(x)
    #从第二次循环开始 每次取出iterable原始值 与 已经在排序的ret中的每个值进行比较
    for i, y in enumerate(ret):
      #iterable中取出值与 ret中每个值的大小比较
      #默认升序 1 2 3 4  reverse降序 4 3 2 1
      flag = key(x, y) if reverse else key(y, x)
      #默认 如果取出值 小于排序中值 将此值插入到排序值位置 排序值后移一个位置
      if flag:
        ret.insert(i, x)
        break


    #第一次iterable循环 ret中没有值 将第一次iterable循环到的值存储到ret中
    else:
      ret.append(x)

  return ret

print(sorted(lst, key=lambda a,b: a<b))
