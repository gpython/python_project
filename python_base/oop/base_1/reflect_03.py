#encoding:utf-8

class dispatcher:
  def cmd1(self):
    print("cmd1")

  def reg(self, cmd, fn):
    if isinstance(cmd, str):
      setattr(self.__class__, cmd, fn)
    else:
      print("error")

  def run(self):
    while True:
      cmd = input(">> ")
      if cmd.strip() == "quit":
        return
      getattr(self, cmd, self.defaultfn)()

  def defaultfn(self):
    print("default")

dis = dispatcher()

dis.reg("cmd2", lambda self: print(10))
dis.reg("cmd3", lambda self: print(20))

dis.run()