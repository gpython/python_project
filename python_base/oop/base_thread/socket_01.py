import threading
import time
import socket
import logging

logging.basicConfig(format="%(asctime)s %(threadName)s %(message)s", level=logging.INFO)


class ChatServer:
  def __init__(self, ip="127.0.0.1", port=9999):
    self.sock = socket.socket()
    self.addr = (ip, port)
    self.event = threading.Event()

    self.clients = {}

  def start(self):
    self.sock.bind(self.addr)
    self.sock.listen()

    threading.Thread(target=self._accept, name="accept").start()

  def stop(self):
    for c in self.clients.values():
      c.close()
    self.sock.close()
    self.event.wait(3)
    self.event.set()

  def _accept(self):
    while not self.event.is_set():
      conn, client = self.sock.accept()
      self.clients[client] = conn

      threading.Thread(target=self._recv, args=(conn,), name="recv").start()

  def _recv(self, conn):
    while not self.event.is_set():
      data = conn.recv(1024)
      logging.info(data.decode())
      msg = "ack {}".format(data.decode())

      for conn in self.clients.values():
        conn.send(msg.encode())

cs = ChatServer()
cs.start()

e = threading.Event()

def showthread():
  while not e.wait(5):
    logging.info(threading.enumerate())

showthread()

cs.stop()

