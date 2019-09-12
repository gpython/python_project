#encoding:utf-8
from setting import RedisConf, AntConf
from log import logging
from gevent import socket
import gevent
import telnetlib
import redis


logger = logging.getLogger(__file__)
logger.setLevel(logging.INFO)

Pool = redis.ConnectionPool(
  host=RedisConf['host'],
  port=RedisConf['port'],
  db=RedisConf['db'])
RConn = redis.Redis(connection_pool=Pool)

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



class TagGet:
  Username = 'alien'
  Password = 'password'
  Port = 23
  AntList = [0, 1, 2, 3]
  PubStaticKey = 'C_Fix_0'

  def __init__(self, sort_key, host_ip):
    self._sort_key = sort_key
    self._host_ip = host_ip
    self._tn = None
    self._tn_run = False
    self._pub_card = []
    self.process_data = {}

  def connect(self):
    while True:
      try:
        logger.info('IP Address %s is starting......' %self._host_ip)
        self._tn = telnetlib.Telnet(self._host_ip, self.Port, timeout=2)
        self._tn.read_until("Username>")  # wait till prompted for username
        self._tn.write("%s\n" % self.Username)
        self._tn.read_until("Password>")  # wait till prompted for password
        self._tn.write("%s\n" % self.Password)
        self._tn.read_until("Alien>")
        logger.info('IP Address %s Starting OK!!!' %self._host_ip)
        self._tn_run = True
        #return True
      except Exception as e:
        logger.error("connecting error %s" %e)
        #return False
        pass
      finally:
        if self._tn_run:
          break

  def _process_player_card(self, static_key, value):
    tmp_val = RConn.get(static_key) or ''
    tmp_val = tmp_val.split('::')
    if len(value) > 2 or len(value) == 0:
      #RConn.set(static_key, '')
      pass

    if len(value) == 2:
      value.sort()
      value = '::'.join(value)
      RConn.set(static_key, value)

    if len(value) == 1:
      if len(tmp_val) == 2:
        return
      value += tmp_val
      value = '::'.join(tmp_val)
      RConn.set(static_key, value)


  def _process_public_card(self):
    tmp_val = RConn.get(self.PubStaticKey) or ''
    tmp_val = tmp_val.split('::')
    value = list(set(self._pub_card))

    if len(value) > 5 or len(value) < 3:
      #RConn.set(self.PubStaticKey, '')
      pass
    else:
      #if len(tmp_val) < len(value):
      value.sort()
      value = '::'.join(value)
      RConn.set(self.PubStaticKey, value)


  def indb(self):
    for ant_num in self.AntList:
      static_key = "%s_Fix_%s" %(self._sort_key, ant_num)
      value = self.process_data.get('%s' %ant_num, [])
      if self._sort_key in ['A', 'B'] or static_key == 'C_Fix_1':
        self._process_player_card(static_key, value)
      else:
        self._pub_card += value
    self._process_public_card()


  def process(self, _raw_data):
    if _raw_data and "No Tags" not in _raw_data and len(_raw_data) > 0:
      data = _raw_data.strip('Get TagList\\n').strip('Alien>').strip('\n').strip('').strip('\r\n').split('\r\n')

      for info in data:
        try:
          ant_num = info.split(',')[-2].split(':')[1]
          tag_id = info.split(',')[0].split(':')[1]
          if len(tag_id) != 9 or tag_id[:2] not in ['01', '02', '03', '04']:
            continue
          if self.process_data.has_key(ant_num):
            self.process_data[ant_num].append(tag_id)
          else:
            self.process_data[ant_num] = [tag_id, ]
        except:
          pass

  def get(self):
    self._tn.write("Get TagList\n")
    _raw_data = self._tn.read_until('Alien>')
    self.process(_raw_data)


  def run(self):
    host_aliving = host_check(self._host_ip, self.Port)
    if not host_aliving:
      logger.error("FATAL ERROR!!! HOST [%s:%s] NOT ALIVING AND START THE HOST FOR ALL THINGS GO" % (HostIP, Port))
      return
    #if self.connect():
    self.connect()
    if self._tn_run:
      while True:
        self.get()
        #print(self._host_ip, self.process_data)

        self.indb()

        self._pub_card = []
        self.process_data = {}

        gevent.sleep(AntConf['tagTimeout'])


if __name__ == '__main__':
  RConn.flushall()
  logger.info("Project start and flush all keys of redis db 0")
  obj_A = TagGet('A', '192.168.9.10')
  obj_B = TagGet('B', '192.168.9.20')
  obj_C = TagGet('C', '192.168.9.30')

  gevent.joinall([
    gevent.spawn(obj_A.run),
    gevent.spawn(obj_B.run),
    gevent.spawn(obj_C.run)
  ])
