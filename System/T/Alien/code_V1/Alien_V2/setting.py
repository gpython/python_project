#encoding:utf-8

HostConf = {
  'JZ_A': {
    'host': '192.168.9.10',
    'port': 23,
    'username': 'alien',
    'password': 'password',
    'sortKey': 'A',
  },

  'JZ_B': {
    'host': '192.168.9.20',
    'port': 23,
    'username': 'alien',
    'password': 'password',
    'sortKey': 'B',
  },
  'JZ_C': {
    'host': '192.168.9.30',
    'port': 23,
    'username': 'alien',
    'password': 'password',
    'sortKey': 'C',
  }

}

RedisConf  = {
  'host': '127.0.0.1',
  'port': 6379,
  'username': '',
  'password': '',
  'db': 0,
}

AntConf = {
  'primary': 'C_Ant_0',
  'primary_Fix': 'C_Fix_0',
  'tagTimeout': 0.1,
  'hostTimeout': 3,
  'queuePrefix': 'AntQueue::',
  'digestPrefix': 'Digest::',
  'antList': [0, 1, 2, 3],
  'retryCount': 100,
  'newGame': 'GameFlag'
}
