import threading
import logging
import time

FORMAT = "%(asctime)s %(threadName)s %(thread)d %(message)s"
logging.basicConfig(format=FORMAT, level=logging.INFO)

def boss(event:threading.Event):
  logging.info("I am boss waiting for u")
  #等待通知
  event.wait()
  logging.info("Good Job")

def worker(event:threading.Event, count=10):
  logging.info("I am working ...")
  cups = []
  while True:
    logging.info("make 1")
    time.sleep(0.5)
    cups.append(1)
    if len(cups) >= count:
      #通知
      event.set()
      break
  logging.info("I finished my job cups={}".format(len(cups)))

event = threading.Event()

w = threading.Thread(target=worker, args=(event,))
b = threading.Thread(target=boss, args=(event,))

w.start()
b.start()
w.join()
b.join()

logging.info("--------------------worker finished ")




