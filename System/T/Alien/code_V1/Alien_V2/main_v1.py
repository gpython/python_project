#encoding:utf-8
from setting import HostConf, RedisConf, AntConf
from log import logging
import telnetlib
import time
import sys
import os
import signal
import redis
#import socket
import gevent
from gevent import socket
import multiprocessing
import threading

logger = logging.getLogger(__file__)
logger.setLevel(logging.INFO)
pub_poker = []

class RedisConn(object):
  def __init__(self, RedisConf):
    self.pool = redis.ConnectionPool(host=RedisConf['host'],
      port=RedisConf['port'],
      db=RedisConf['db']
    )
    self.conn = redis.Redis(connection_pool=self.pool)

  def j_set(self, key, value):
    self.conn.set(key, value)

  def j_get(self, key):
    return self.conn.get(key)

  def flushall(self):
    self.conn.flushall()

rconn = RedisConn(RedisConf)



def store_db(SortKey, dic_data):
  global pub_poker
  data = {}

  #天线列表 1 2 3 4
  ant_list = AntConf['antList']
  #新一轮 标识
  restart_flag = AntConf['newGame']
  #从redis获取标识 ON 为开启新一轮
  flag = rconn.j_get(restart_flag)

  if flag == 'ON':
    rconn.flushall()
    rconn.j_set(restart_flag, 'OFF')

  for ant_num in ant_list:
    key = "%s_Ant_%s" %(SortKey, ant_num)
    static_key = "%s_Fix_%s" %(SortKey, ant_num)

    value = dic_data.get('%s' %ant_num, [])
    value.sort()
    #五张牌
    if key == AntConf['primary'] and static_key == AntConf['primary_Fix']:
      if len(value) > 5 or len(value) < 3:
        try:
          value = '::'.join(value)
          rconn.j_set(key, value)
        except Exception, e:
          rconn.j_set(key, '')
      else:
        value = '::'.join(value)
        rconn.j_set(key, value)

        if len(pub_poker) == 2:
          if len(set(pub_poker)) == 1:
            rconn.j_set(static_key, value)
#          print pub_poker
          pub_poker = []
        else:
          pub_poker.append(value)

#        rconn.j_set(key, value)
    #选手牌 判断
    else:
      #选手牌数大于两张或 0时 合成字符串直接存redis
      #牌数为空 存 " "
      if len(value) > 2 or len(value) == 0:
        try:
          value = '::'.join(value)
          rconn.j_set(key, value)
        except Exception, e:
          rconn.j_set(key, '')
      #否则选手牌数为两张 与已经存的固定值做对比
      #如果此选手固定值为空 则直接存 合成字符串的固定值
      #否则判断 当前两张牌的值与 之前固定值的 是否相同 不同则存
      elif len(value) == 1:
        fix_value = rconn.j_get(static_key)
        value = '::'.join(value)
        if not fix_value or len(fix_value.split('::')) == 1:
          rconn.j_set(static_key, value)
        rconn.j_set(key, value)
      else:
        value = '::'.join(value)
        rconn.j_set(static_key, value)
        rconn.j_set(key, value)
        """
        static_val = fix_value.split('::')
        static_val.sort()
        if static_val != value:
          value = '::'.join(value)
          rconn.j_set(static_key, value)
        """
####    print "*"*60
####    print "Get Change  Redis ", key, rconn.j_get(key)
####    print "Get Static  Redis ", static_key, rconn.j_get(static_key)
####    print "*"*60

def host_check(ip, port):

  is_alive = False
  i = 0
  while True:
    if is_alive or i > AntConf['retryCount']:
      break
    else:
      try:
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        s.settimeout(2)
        s.connect((ip, port))
        is_alive = True
      except socket.error, e:
        is_alive = False
        i += 1
        logger.error("Host [%s:%s] alive checking count %d Exception %s" %(ip, port, i, e))
        s.close()
        gevent.sleep(AntConf['hostTimeout'])
  return is_alive

def alien_tag_id(SortKey, HostIP, Port=23, Username='alien', Password='password'):
  host_aliving = host_check(HostIP, Port)
  if not host_aliving:
    logger.error("FATAL ERROR!!! HOST [%s:%s] NOT ALIVING AND START THE HOST FOR ALL THINGS GO" %(HostIP, Port))
    return

  try:
    tn = telnetlib.Telnet(HostIP, Port, timeout=2)
    tn.read_until("Username>") # wait till prompted for username
    tn.write("%s\n" %Username)
    tn.read_until("Password>") # wait till prompted for password
    tn.write("%s\n" %Password)
    tn.read_until("Alien>")
  except Exception, e:
    logger.error("Alien Host [%s] Exception Host not Alive or login username or password error Reason: %s " %(HostIP, e))
  else:
    while True:
      start = time.time()
      tic = lambda: 'Interval Timeout at %1.1f seconds\n' % (time.time() - start)

      tn.write("Get TagList\n") # enter commands
      alien_data = tn.read_until('Alien>')

      alien_info = {}
      if alien_data and "No Tags" not in alien_data and len(alien_data) >0:
        x = alien_data.strip('Get TagList\\n').strip('Alien>').strip('\n').strip('').strip('\r\n').split('\r\n')

        for info in x:
          try:
            ant_num = info.split(',')[-2].split(':')[1]
            tag_id = info.split(',')[0].split(':')[1]
            if alien_info.has_key(ant_num):
              alien_info[ant_num].append(tag_id)
            else:
              alien_info[ant_num] = [tag_id,]
          except Exception, e:
            pass
      store_db(SortKey, alien_info)
      gevent.sleep(AntConf['tagTimeout'])
####      print tic()

def main():
  rconn.flushall()
  logger.info("Project start and flush all keys of redis db 0")

  threads = [gevent.spawn(alien_tag_id, HostConf[i]['sortKey'], HostConf[i]['host']) for i in HostConf]
  gevent.joinall(threads)

#  process_list = [multiprocessing.Process(target=alien_tag_id, args=(HostConf[i]['sortKey'], HostConf[i]['host'])) for i in HostConf]
#  for p in process_list:
#    p.start()

#  thread_list = [threading.Thread(target=alien_tag_id, args=(HostConf[i]['sortKey'], HostConf[i]['host'])) for i in HostConf]
#  for p in thread_list:
#    p.start()

if __name__ == '__main__':
  main()
