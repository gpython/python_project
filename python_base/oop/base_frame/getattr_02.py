class Context(dict):
  def __getattr__(self, item):
    try:
      return self[item]
    except KeyError:
      raise AttributeError("Attribute {} not found".format(item))

  def __setattr__(self, key, value):
    self[key] = value

class NestedContext(Context):
  def __init__(self, globalcontext:Context=None):
    super().__init__()
    self.relate(globalcontext)

  def relate(self, globalcontext:Context=None):
    self.globalcontext = globalcontext

  def __getattr__(self, item):
    print(self)
    if item in self.keys():
      return self[item]
    return self.globalcontext[item]

ctx = Context()
ctx.x = 6
ctx.y = 'gool'

nc = NestedContext()
nc.relate(ctx)
nc.x = 'ncccccccccc'

print(nc)
print(nc.x)
print(nc.y)
print(nc.__dict__)



# app = Context()
# app["key1"] = "value"
# print(app.key1)
# app.key2 = 'yahoo'
# print(app["key2"])
# print(app.__dict__)
# print(app.__class__.__dict__)
class A:
  x = 100
  def __init__(self):
    self.x = 10

a = A()
print(a.x)
print(A.x)
