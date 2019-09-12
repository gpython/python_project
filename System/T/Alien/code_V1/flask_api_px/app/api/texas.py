#encoding:utf-8
import re
import os
import time
import random
import multiprocessing

#        A  2  3  4  5  6  7  8  9 10  J  Q  K
#♠ 黑：[14, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13]
#♥ 红：[28,16,17,18,19,20,21,22,23,24,25,26,27]
#♣ 梅：[42,30,31,32,33,34,35,36,37,38,39,40,41]
#♦ 方：[56,44,45,46,47,48,49,50,51,52,53,54,55]

#Poker_num = 0,1,2,3,4,5,6,7,8,9,10,J,Q,K,A

def Poker(n):
  t = n % 14
  num = t if t else 14
  ch = "abcdef"[num-10] if num > 9 else str(num)
  show = "0,1,2,3,4,5,6,7,8,9,10,J,Q,K,A".split(",")[num]
  color = {0: '♠',1: '♥',2: '♣',3: '♦',}[(n-1)/14]

  poker_num = "%s%s" %(color, show)
  # print poker_num
  return {'poker_num': poker_num,
          'num': num, 'ch': ch, 'color': color}

#同花顺
def Zcompare(args):
  suit = {'♠':[],'♥':[],'♣':[],'♦':[]}
  map(lambda x: suit[x['color']].append(x), args)

  global straight
  def t(x):
    global straight
    interval = straight[len(straight)-1]['num'] - x['num']
    if interval == 1:
      straight.append(x)
    elif len(straight)<5:
      straight = [x]

  for s in suit:
    if len(suit[s]) > 4:
      straight = [suit[s][0]]
      if suit[s][0]['num'] == 14:
        suit[s].append(Poker(1))
      map(t, suit[s])

      if len(straight) > 4:
        p = ''.join(map(lambda x: x['ch'], straight))
        return 'z' +p[0]

  return False

#四条
def Ycompare(args):
  p = ''.join(map(lambda x: str(x['ch']), args))
  mat = re.match(r'(\w*)(\w)\2\2\2(\w*)', p)
  if mat:
    pk = 'y' + mat.group(2) + mat.group(1) + mat.group(3)
    return pk[:3]
  return False

#葫芦
def Xcompare(args):
  p = ''.join(map(lambda x: str(x['ch']), args))
  mat1 = re.match(r'(\w*)(\w)\2(\w*)(\w)\4\4(\w*)', p)
  if mat1:
    return 'x' + mat1.group(4) + mat1.group(2)
  mat2 = re.match(r'(\w*)(\w)\2\2(\w*)(\w)\4(\w*)', p)
  if mat2:
    return 'x' + mat2.group(2) + mat2.group(4)
  return False


#同花
def Wcompare(args):
  suit = {'♠':[],'♥':[],'♣':[],'♦':[]}
  map(lambda x: suit[x['color']].append(x['ch']), args)
  ws = ''
  for s in suit:
    if len(suit[s]) > 4:
      ws = ''.join(map(lambda x: str(x), suit[s]))
  if len(ws) > 4:
    return 'w' + ws[:5]
  return False

#顺子
def Vcompare(args):
  global straight
  straight = [args[0]]
  if args[0]['num'] == 14:
    args.append(Poker(1))

  def t(x):
    global straight
    interval = straight[len(straight)-1]['num'] - x['num']
    if interval == 1:
      straight.append(x)
    elif interval == 0:
      pass
    elif len(straight)<5:
      straight = [x]
  map(t, args)

  if len(straight) > 4:
    p = ''.join(map(lambda x: str(x['ch']), straight))
    return 'v' + p[0]
  return False

#三条
def Ucompare(args):
  p = ''.join(map(lambda x: str(x['ch']), args))

  mat = re.match(r'(\w*)(\w)\2\2(\w*)', p)
  if mat:
    pk = "u" + mat.group(2) +  mat.group(1) + mat.group(3)
    return pk[:4]
  return False

#两对
def Tcompare(args):
  p = ''.join(map(lambda x: str(x['ch']), args))
  mat = re.match(r'(\w*?)(\w)\2(\w*?)(\w)\4(\w*)', p)
  if mat:
    pk = "t" + mat.group(2) + mat.group(4) + mat.group(1) + mat.group(3)+ mat.group(5)
    return pk[:4]
  return False

#一对
def Scompare(args):
  p = ''.join(map(lambda x: str(x['ch']), args))
  mat = re.match(r'(\w*)(\w)\2(\w*)', p)
  if mat:
    pk = 's' + mat.group(2) + mat.group(1) + mat.group(3)
    return pk[:5]
  return False
#高牌
def Rcompare(args):
  pk = ''.join(map(lambda x: str(x['ch']), args))
  return pk[:5]

def Score(args):
  x = sorted(map(Poker, args), cmp=lambda x,y:cmp(x['num'],y['num']), reverse=True)
  return Zcompare(x) or Ycompare(x) or Xcompare(x) or Wcompare(x)  or Vcompare(x) or Ucompare(x) or Tcompare(x) or Scompare(x) or Rcompare(x)

#结果分析
def CompResult(x, user_result):
  result = {}
  #平分的情况
  U = {}
  if x[0][1] == x[1][1]:
    user_result['t10'] = 1

    tmp = x[0][1]
    for i in x:

      if i[1] == tmp:
        U[i[0]] = 1
    if U:
      u_len = len(U)
      for i in U:
        user_result[i] = float(1)/float(u_len)
  else:
    user_result[x[0][0]] = 1
    # print user_result
  return user_result

#牌型比较===============================================
def Comp_2w(user_list, pub_poker, poker_list, rand_num, run_num=1000):
  user_result = {}
  user_poker_list = {}
  t_result = []

  for i in range(run_num):
    result = {}
    #随机发牌
    rand_poker = random.sample(random.sample(poker_list, 20-rand_num), rand_num)
    # print rand_poker, os.getpid()
    # print rand_poker
    for i in user_list:
      user_result[i] = 0
      #用户牌型 = 用户手牌 + 公共牌 + 剩余随机牌
      user_poker = user_list[i] + pub_poker + rand_poker
      # print i,user_poker
      #得到每个用户牌型花色数据
      result[i] = Score(user_poker)
      # print result[i]
    # print result
    X = sorted(result.iteritems(), key = lambda x: x[1], reverse=True)
    t_result.append(CompResult(X, user_result))
  return t_result


#牌型枚举比较
def Comp(user_list, pub_poke, rand_poke):
  user_result = {}
  result = {}

  for i in user_list:
    user_result[i] = 0
    user_poker = user_list[i] + pub_poke + rand_poke
    result[i] = Score(user_poker)

  X = sorted(result.iteritems(), key = lambda x: x[1], reverse=True)
  return CompResult(X, user_result)


#生成用户随机 牌型 和公共牌型
# 选手数量 和 公共牌数量
def poke_maker(user_num, pub_num):
  """
  poke_info = {'user':{1: [2,3], 2:[18,22], 9:[9, 17]},
              'pub':[23, 35, 30]}
  """
  poke_info = {'user':{}, 'pub':{}}
  poke_list = [
    14, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,
    28,16,17,18,19,20,21,22,23,24,25,26,27,
    42,30,31,32,33,34,35,36,37,38,39,40,41,
    56,44,45,46,47,48,49,50,51,52,53,54,55
  ]
  tmp_list = sorted(random.sample([i for i in range(9)], user_num))

  for uid in tmp_list:
    poke_info['user'][uid] = random.sample(poke_list, 2)
    map(lambda x: poke_list.remove(x), poke_info['user'][uid])
  pub_list = random.sample(poke_list, pub_num)
  map(lambda x: poke_list.remove(x), pub_list)

  poke_info['pub'] = pub_list

  return poke_info


if __name__ == '__main__':
  P_list = {
    'Rcompare_高牌  ' : [14, 34, 25, 18, 55],
    'Scompare_一对  ' : [2, 8, 22, 23, 56],
    'Tcompare_两对  ' : [2, 16, 23, 48, 34],
    'Ucompare_三条  ' : [2, 16, 30, 54, 38],
    'Vcompare_顺子  ' : [10, 25, 40, 55, 56],
    'Wcompare_同花  ' : [2, 3, 7, 5, 9],
    'Xcompare_葫芦  ' : [55, 16, 30, 2, 41],
    'Ycompare_四条  ' : [13, 27, 41, 55, 2],
    'Zcompare_同花顺' : [10,11,12,13,14]
  }

  # for k, v in P_list.items():
  #   print "%-3s %-20s" %(i, '||'.join([i['poker_num'] for i in map(Poker,v)]))
  #   print "%-20s : %-20s" %(k, Score(v))

  user_poker= {
    '1': [1, 34, 25, 18, 55],
    '2': [2, 8, 22, 23, 56],
    '3': [2, 16, 23, 48, 34],
    '4': [2, 16, 30, 54, 38],
    '5': [10, 25, 40, 55, 56],
    '6': [2, 3, 7, 5, 9],
    '7': [55, 16, 30, 2, 41],
    '8': [13, 27, 41, 55, 2],
    '9': [10,11,12,13,14]
  }
  #人数 公共牌数量  运行次数
  Rank(4, 4, 20000)





  # result = {}
  # for i in user_poker:
  #   result[i] = Score(user_poker[i])
  # print result

  # print sorted(result.iteritems(), key = lambda x: x[1], reverse=True)

  # poker_list = [
  #   14, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,
  #   28,16,17,18,19,20,21,22,23,24,25,26,27,
  #   42,30,31,32,33,34,35,36,37,38,39,40,41,
  #   56,44,45,46,47,48,49,50,51,52,53,54,55
  # ]
  # poker_name = {
  #   'R':'高牌  ',
  #   'S':'一对S  ',
  #   'T':'两对T  ',
  #   'U':'三条U  ',
  #   'V':'顺子V  ',
  #   'W':'同花W  ',
  #   'X':'葫芦X  ',
  #   'Y':'四条Y  ',
  #   'Z':'同花顺Z'
  # }
  # for i in range(10000):
  #   rand_poker = random.sample(poker_list, 7)
  #   S = Score(rand_poker)
  #   P = poker_name.get(S[0].upper(), '高牌')
  #   print "%-3s %-10s %-45s %-10s <br>" %(i, P, '  '.join([i['poker_num'] for i in map(Poker, rand_poker)]), S)

