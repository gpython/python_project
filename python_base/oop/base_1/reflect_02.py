#encoding:utf-8

def dispatcher():
  cmds = {}

  def reg(cmd, fn):
    if isinstance(cmd, str):
      cmds[cmd] = fn
    else:
      print("error")

  def run():
    while True:
      cmd = input(">> ")
      if cmd.strip() == "quit":
        return
      cmds.get(cmd.strip(), defaultfn)()

  def defaultfn():
    return None

  return reg, run

reg, run = dispatcher()

reg('cmd1', lambda : 1)
reg('cmd2', lambda : 2)
reg('cmd3', lambda : 3)

run()
