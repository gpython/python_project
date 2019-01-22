#encoding:utf-8
commands = {}

def reg(name):
  def _reg(fn):
    commands[name] = fn
    return fn
  return _reg


def defaultfunc():
  return "UNknown commands"

def dispatcher():
  while True:
    cmd = input(">> ")
    if cmd.strip() == "quit":
      return
    ret = commands.get(cmd, defaultfunc)()
    print(ret)


@reg('m')
def m():
  return 'this is M'

@reg('n')
def n():
  return "This is N"

dispatcher()