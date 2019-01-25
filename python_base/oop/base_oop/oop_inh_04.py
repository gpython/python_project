#encoding:utf-8

def printable(cls):
  def _print(self):
    return self.content
  cls.print = _print
  return cls

class Document:
  def __init__(self, content):
    self.content = content

class Word(Document): pass
class Pdf(Document): pass

@printable
class PrintableWord(Word): pass

print(PrintableWord.__dict__)
print(PrintableWord.mro())

p = PrintableWord('this is printableword content')
print(p.print())