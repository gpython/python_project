#encoding:utf-8
from flask import request, render_template, Response
from . import api
from ..Comm import res_format
from ..setting import RedisConn
from .texas import Score, Poker, poke_maker, Comp, Comp_2w
import multiprocessing
import time
import redis
import json
import ast
import os
import thread

pool = redis.ConnectionPool(host = RedisConn['HOST'],
                            port = RedisConn['PORT'],
                            db = RedisConn['DB'])
r = redis.Redis(connection_pool = pool)

@api.route('/')
def api_urls():
  rtn_format = res_format({'status':'ok'})
  return Response(response = rtn_format,
    mimetype="application/json",
    status=200)

#选手人数 用户牌型{1:[10, 20], 2:[30, 40], ...} 公共牌型 剩余牌  剩余随机牌数
def process(poker_num, user, pub, left_poke, rand_num):
  result = []
  count = 0
  if rand_num  == 2:
    for i in left_poke:
      for j in left_poke:
        if i == j:
          continue
        count += 1
        rand_poke = [i, j]
        result.append(Comp(user, pub, rand_poke))

  if rand_num == 1:
    for i in left_poke:
      count += 1
      rand_poke = [i,]
      result.append(Comp(user, pub, rand_poke))

  if rand_num == 0:
    count = 1
    rand_poke = []
    result.append(Comp(user, pub, rand_poke))

  if rand_num == 5:
    run_num_dic = {2:10000, 3:7000, 4:5000, 5:4000, 6:3350, 7:2800, 8:2500, 9:2000}

    run_num = run_num_dic.get(poker_num, 0)

    count = poker_num * run_num
    pool = multiprocessing.Pool(processes = 9)
    result = []

    for loop in xrange(poker_num):
      result.append(pool.apply_async(Comp_2w, (user, pub, left_poke, rand_num, run_num)))
    pool.close()
    pool.join()

  r = {}

  for i in result:
    try:
      rs = i.get()
    except Exception, e:
      rs = i

    if isinstance(rs, list):
      for rs_t in rs:
        for k, v in rs_t.items():
          if k in r:
            r[k] += v
          else:
            r[k] = v
    if isinstance(rs, dict):
      for k, v in rs.items():
        if k in r:
          r[k] += v
        else:
          r[k] = v

  for i in r:
    # print(i,r[i], count)
    percent = float(r[i])*100/float(count)
    r[i] = "%.2f" %percent
  return r

class RedisProcess:
  def __init__(self):
    _pool = redis.ConnectionPool(host = RedisConn['HOST'],
                            port = RedisConn['PORT'],
                            db = RedisConn['DB'])
    _r = redis.Redis(connection_pool = _pool)
    self.conn = _r
    self.poke_list = [
      14, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,
      28,16,17,18,19,20,21,22,23,24,25,26,27,
      42,30,31,32,33,34,35,36,37,38,39,40,41,
      56,44,45,46,47,48,49,50,51,52,53,54,55
    ]

  def get(self, key):
    r_poke_list = self.conn.get(key)
    if r_poke_list:
      self.poke_list = eval(r_poke_list)
    else:
      r.set('r_poke_list', self.poke_list)

    return self.poke_list

  def set(self, key, value):
    self.conn.set(key, value)

#实际使用连接
@api.route('/poke', methods=['POST'])
def poke():
  r = RedisProcess()
  poke_list = r.get('r_poke_list')

  """
  接受post请求
  import requests
  import json
  url = 'http://192.168.9.206:8888/api/poke'
  poker_info = {'pub': [23, 35, 30], 'user': {1: [2, 3], 2: [18, 22], 9: [9, 17]}}
  data = {'p': json.dumps(poker_info)}
  res = requests.post(url, data)
  print json.loads(res.text)
  """
  data = request.form.get('p', '{}')
  # print data
  poke_info = ast.literal_eval(data)
  # print poke_info

  #公共牌型 用户牌型
  pub = poke_info.get('pub', [])
  pub = [int(i) for i in pub]
  user = poke_info.get('user', {})
  for u in user:
    user[u] = [int(i) for i in user[u]]
  #用户个数 公共牌数
  user_len = len(user)
  pub_len = len(pub)

  #已经发出去的所有牌型列表
  used_poke = []
  for i in user:
    used_poke += user[i]
  used_poke += pub
  #随机发牌数 = 5-公共牌个数
  rand_num = 5 - pub_len

  #剩余牌型列表
  left_poke = list(set(poke_list) - set(used_poke))
  #剩余牌型存到redis
  r.set('r_poke_list', left_poke)

  poke_info.update({'left_poke':left_poke})


  r = process(user_len, user, pub, left_poke, rand_num)
  b = r.get('t10', 0)
  if b:
    del r['t10']

  rtn_format = res_format({'status':'ok', 'poke_info':poke_info, 'r':r, 'b': b})
  return Response(response = rtn_format,
    mimetype="application/json",
    status=200)


def run_cmd(cmd):
  os.system(cmd)

#关机
#data={'key':'RsKu4eWqqoF8sOWZsKwFpqQwQ1qm1A1CIAGOsJYGNpA='}
#res = requests.post(url, data)
@api.route('/shutdown', methods=['POST'])
def shudown():
  cmd_list = ['shutdown']
  key = request.form.get('key')
  if key == 'RsKu4eWqqoF8sOWZsKwFpqQwQ1qm1A1CIAGOsJYGNpA=':
    thread.start_new_thread(run_cmd, ('init 0',))

#测试用连接
@api.route('/texas', methods=['GET', 'POST'])
def texas():
  r = RedisProcess()
  poke_list = r.get('r_poke_list')

  poke_info = poke_maker(5, 3)
  #公共牌型 用户牌型
  pub = poke_info.get('pub', {})
  user = poke_info.get('user', {})
  #用户个数 公共牌数
  user_len = len(user)
  pub_len = len(pub)

  #已经发出去的所有牌型列表
  used_poke = []
  for i in user:
    used_poke += user[i]
  used_poke += pub
  #随机发牌数 = 5-公共牌个数
  rand_num = 5 - pub_len

  #剩余牌型列表
  left_poke = list(set(poke_list) ^ set(used_poke))
  #剩余牌型存到redis
  r.set('r_poke_list', left_poke)

  #run_num = 5000

  poke_info.update({'left_poke':left_poke, 'rand_num': rand_num})

  r = process(5, user, pub, left_poke, rand_num)

  rtn_format = res_format({'status':'ok', 'poke_info':poke_info, 'r':r})
  return Response(response = rtn_format,
    mimetype="application/json",
    status=200)





