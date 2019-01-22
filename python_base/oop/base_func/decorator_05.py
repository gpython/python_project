#encoding:utf-8

def cmds_dispatcher():
  commands = {}

  def reg(name):
    def _reg(fn):
      commands[name] = fn
      return fn
    return _reg

  def defaultfunc():
    return "Unknown function"

  def dispatcher():
    while True:
      cmd = input(">> ")
      if cmd.strip() == "quit":
        return
      data = commands.get(cmd, defaultfunc)()
      print(data)

  return reg, dispatcher

reg, dispatcher = cmds_dispatcher()

@reg('m')
def m():
  return "this is m"

@reg("n")
def n():
  return "this is n"

dispatcher()