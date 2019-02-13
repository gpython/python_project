#encoding:utf-8

import threading
import logging
import time
logging.basicConfig(level=logging.INFO)

cups = []

def boss():
  pass

def worker(n):
  while True:
    time.sleep(0.5)
    cups.append(1)
    logging.info("make one")
    if len(cups) >= n:
      logging.info("I finished my job. {}".format(len(cups)))
      break

b = threading.Thread(target=boss)
w = threading.Thread(target=worker, args=(10,))

w.start()

b.start()

w.join()
b.join()

logging.info("Now cups counts is {}".format(len(cups)))