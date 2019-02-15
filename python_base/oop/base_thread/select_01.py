import threading
import selectors
import socket
import logging

FORMAT = "%(asctime)s %(threadName)s %(thread)s %(message)s"
logging.basicConfig(format=FORMAT, level=logging.INFO)

#回调函数 自己定义形参
#接受请求
def accept(sock:socket.socket, mask):
  conn, raddr = sock.accept()
  conn.setblocking(False)

  #监视conn这个文件对象 监视请求发送数据
  key = selector.register(conn, selectors.EVENT_READ, read)
  logging.info("接受请求 监视有数据发送过来 的注册事件 {}".format(key))

#接受发送来数据 recv
def read(conn:socket.socket, mask):
  data = conn.recv(1024)
  msg = "RECV data info {}".format(data.decode())

  #发送数据
  conn.send(msg.encode())


#构造缺省性能最优selector
selector = selectors.DefaultSelector()

#创建TCP Server
sock = socket.socket()
sock.bind(("0.0.0.0", 9988))
sock.listen()
logging.info("1# 开始监听请求 {}".format(sock))

sock.setblocking(False)

#注册文件对象sock关注读事件 返回selectorkey
#将sock 关注事件 data都绑定到key实例属性上

key = selector.register(sock, selectors.EVENT_READ, accept)
#key 包含信息如下
# fileobj=<socket.socket fd=284, family=AddressFamily.AF_INET, type=SocketKind.SOCK_STREAM, proto=0, laddr=('0.0.0.0', 9999)>,
# fd=284,
# events=1,
# data=<function accept at 0x01F494F8>
logging.info("2# 注册接受请求 循环监听 accept 事件 {}".format(key))

e = threading.Event()

def select(e):
  while not e.is_set():
    #开始监听 等到有文件对象监控事件产生 返回(key, mask)元组
    logging.info("3# 另起线程 开始循环监听事件")
    events = selector.select()
    logging.info("---------------------- 循环中 新监听事件发生 ")

    for key, mask in events:
      logging.info("+++循环中+++ 监控到的 key: {}".format(key))
      logging.info("+++循环中+++ 监控到的 mask: {}".format(mask))
      #监控事件产生 调用相应的函数
      callback = key.data   #回调函数
      callback(key.fileobj, mask)

threading.Thread(target=select, args=(e,), name="threading_select").start()

def main():
  while not e.is_set():
    cmd = input(">> ")
    if cmd.strip() == "quit":
      e.set()
      fobjs = []
      logging.info("shutdown select {}".format(list(selector.get_map().items())))

      for fd, key in selector.get_map().items():
        print(fd, key)
        print(key.fileobj)
        logging.info("shutdown select get_map {}+{}+{}".format(fd, key, key.fileobj))
        fobjs.append(key.fileobj)

      for fobj in fobjs:
        selector.unregister(fobj)
        fobj.close()
      selector.close()

if __name__ == "__main__":
  main()







