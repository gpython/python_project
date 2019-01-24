#encoding:utf-8
import asyncio
import threading


async def sleep(x):
  for i in range(3):
    print("sleep {}".format(i))
    await asyncio.sleep(x)

async def showthread(x):
  for i in range(3):
    print("showthread {}".format(i))
    print(threading.enumerate())
    await asyncio.sleep(2)

loop = asyncio.get_event_loop()
task = [sleep(3), showthread(3)]
loop.run_until_complete(asyncio.wait(task))
loop.close()