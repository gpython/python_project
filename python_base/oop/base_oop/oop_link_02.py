#encoding:utf-8

class SingleNode:
  def __init__(self, item, next=None):
    self.item = item
    self.next = next

  def __repr__(self):
    return repr(self.item)


class LinkedList:
  def __init__(self):
    self.head = None
    self.tail = None

  def append(self, item):
    node = SingleNode(item)
    if self.head is None:
      self.head = node
    else:
      self.tail.next = node #当前最后一个节点关联下一跳
    self.tail = node        #更新结尾节点
    return self

  def iternodes(self):
    current = self.head
    while current:
      yield current.item
      current = current.next


ll = LinkedList()
ll.append(10)
# ll.append(20).append(30)
print(ll.head, ll.tail)


for item in ll.iternodes():
  print(item)
