#encoding:utf-8

#单个节点 节点中有两项 当前 节点值 和 指向下一节点的指针
class SingleNode:
  def __init__(self, item, next=None):
    self.item = item
    self.next = next

  def __repr__(self):
    return repr(self.item)

#链表 所有节点 有序集合
#链表 链表头 链表尾
class LinkedList:
  def __init__(self):
    self.head = None
    self.tail = None

  def append(self, item):
    node = SingleNode(item)
    if self.head is None:
      self.head = node
    else:
      self.tail.next = node
    self.tail = node

    return self

  def iternodes(self):
    current = self.head
    while current:
      yield current
      current = current.next

ll = LinkedList()
ll.append("abc")
ll.append(10).append(1)
ll.append("def")

print(ll.head, ll.tail)
print("*"*60)
for item in ll.iternodes():
  print(item)