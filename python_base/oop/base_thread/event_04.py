from threading import Event, Thread
import datetime
import logging

logging.basicConfig(level=logging.INFO)

def add(x:int, y:int):
  logging.info(x+y)


class Timer:
  def __init__(self, interval, fn, *args, **kwargs):
    self.interval = interval
    self.fn = fn
    self.args = args
    self.kwargs = kwargs
    self.event = Event()

  def start(self):
    Thread(target=self.__run).start()

  def cancel(self):
    self.event.set()

  def __run(self):
    start = datetime.datetime.now()
    logging.info("waiting")

    self.event.wait(self.interval)
    if not self.event.is_set():
      self.fn(*self.args, **self.kwargs)
    delta = (datetime.datetime.now() - start).total_seconds()
    logging.info("finished {}".format(delta))
    self.event.set()

t = Timer(4, add, 10, 30)
t.start()
# t.cancel()
e = Event()
e.wait(4)
print("======")
