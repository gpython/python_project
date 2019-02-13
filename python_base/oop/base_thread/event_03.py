from threading import Event, Thread
import logging

logging.basicConfig(level=logging.INFO)

def do(event:Event, interval:int):
  while not event.wait(interval):
    logging.info("do sth")

e = Event()
Thread(target=do, args=(e, 3)).start()

e.wait(10)
e.set()
print("main exit")

#使用同一个Event 对象的标记flag
#谁wait就是等到flag变为True 或等到超时时返回False 不限制等待的个数
#Event的wait优于time.sleep 他会更快的切换到其他的线程 提高并发效率

import threading


def do(event):
  print('start')
  event.wait()
  print('execute')


event_obj = threading.Event()
for i in range(10):
  t = threading.Thread(target=do, args=(event_obj,))
  t.start()

event_obj.clear()
inp = input('input:')
if inp == 'true':
  event_obj.set()