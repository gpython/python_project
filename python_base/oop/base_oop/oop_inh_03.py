#encoding:utf-8

class Printable:
  def print(self):
    print(self.content)

class Document:
  def __init__(self, content):
    self.content = content

class Word(Document): pass
class Pdf(Document): pass

class PrintableWord(Printable, Word): pass

print(PrintableWord.__dict__)
print(PrintableWord.mro())

p = PrintableWord("this is printableword")
p.print()
print(p.__dict__)
print(Printable.__dict__)
print(Word.__dict__)