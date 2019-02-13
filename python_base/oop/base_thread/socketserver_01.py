import socketserver
import threading


class MyHandler(socketserver.BaseRequestHandler):
  def setup(self):
    super().setup()
    self.event = threading.Event()

  def handle(self):
    super().handle()
    print(self.__dict__)
    print(self.server.__dict__)
    print(threading.enumerate())
    print(threading.current_thread())
    print("*"*30)
    print(self.server, self.client_address, self.request)

    while not self.event.is_set():
      data = self.request.recv(1024)
      msg = "Your msg {}".format(data.decode())
      print("msg from {} data info: {}".format(self.client_address[1], msg))
      self.request.send(msg.encode())

  def finish(self):
    super().finish()
    self.event.set()


addr = ('127.0.0.1', 9998)
server = socketserver.ThreadingTCPServer(addr, MyHandler)
server.serve_forever()

