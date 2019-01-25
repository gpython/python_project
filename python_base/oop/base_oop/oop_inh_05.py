#encoding:utf-8
class Document:
  def __init__(self, content):
    self._content = content

class Word(Document): pass
class Pdf(Document): pass

class PrintableMixin:
  def print(self):
    print(self.content, "Mixin")

class PrintableWord(PrintableMixin, Word): pass

print(PrintableWord.__dict__)
print(PrintableWord.mro())

def printable(cls):
  cls.print = lambda self: self._content
  return cls

@printable
class PrintablePdf(Word): pass

print(PrintablePdf.__dict__)
print(PrintablePdf.mro())

p = PrintablePdf('Yhis is PrintablePdf')
print(p.print())
print(p.__dict__)