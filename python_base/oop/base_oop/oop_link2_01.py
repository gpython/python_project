#encoding:utf-8

class Node:
  def __init__(self, item, next=None):
    self.item = item
    self.next = next

  def __repr__(self):
    return repr(self.item)

class LinkList:
  def __init__(self):
    self.head = None
    self.tail = None
    #借助列表可以 随机访问链表中 某个位置的元素
    self.items = []

  def append(self, item):
    node = Node(item)
    if self.head is None:
      self.head = node        #设置链表开头节点 此时开头节点与结尾节点相同
    else:
      self.tail.next = node   #第二次开始 节点的下一节点 在上一节点基础之上 指向当前节点
    self.tail = node          #第一次设置 第二次之后 更新尾节点

    self.items.append(node)

    return self

  def iternode(self):
    current = self.head
    while current:
      yield current
      current = current.next

  def getitem(self, index):
    try:
      return self.items[index]
    except IndexError:
      return None

ll = LinkList()
ll.append(10).append(20).append(100).append(30).append(42).append(22)

print(ll.getitem(10))

for item in ll.iternode():
  print(item)