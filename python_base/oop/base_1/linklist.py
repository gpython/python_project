#encoding:utf-8

class SingleNode:
  def __init__(self, val, next=None, prev=None):
    self.val = val
    self.next = next
    self.prev = prev

  def __repr__(self):
    return str(self.val)

  def __str__(self):
    return str(self.val)

class LinkedList:
  def __init__(self):
    self.head = None
    self.tail = None

  def append(self, val):
    node = SingleNode(val)
    prev = self.tail
    if prev is None:
      self.head = node
    else:
      prev.next = node

    self.tail = node


  def iternodes(self, reverse=False):
    current = self.head
    while current:
      yield current
      current = current.next

ll = LinkedList()
node = SingleNode(1)
ll.append(node)

node = SingleNode(2)
ll.append(node)

node = SingleNode("abc")

for node in ll.iternodes():
  print(node)