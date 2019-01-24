#encoding:utf-8


def printable(cls):
  def _print(self):
    return self.content
  cls.print = _print
  return cls

def printable(cls):
  cls.print = lambda self: self.content
  cls.name = 'gppgle'
  return cls


@printable
class Printable:      #Printable = printable(Printable)
  def __init__(self, content):
    self.content = content

p = Printable('abc')
print(p.print())
print(p.__dict__)
print(Printable.__dict__)