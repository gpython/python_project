#encoding:utf-8
#from setting import HostConf, RedisConf, AntConf
#from log import logging
import telnetlib
import time
import sys
import os
#import signal
#import redis
#import socket
#import gevent
#from gevent import socket
#import multiprocessing
#import threading


def alien_tag_id(HostIP, Port=23, Username='alien', Password='password'):
  try:
    tn = telnetlib.Telnet(HostIP, Port, timeout=2)
    tn.read_until("Username>") # wait till prompted for username
    tn.write("%s\n" %Username)
    tn.read_until("Password>") # wait till prompted for password
    tn.write("%s\n" %Password)
    tn.read_until("Alien>")
  except Exception, e:
    print "Alien Host [%s] Exception Host not Alive or login username or password error Reason: %s " %(HostIP, e)
  else:
    while True:
      tn.write("Get TagList\n") # enter commands
      alien_data = tn.read_until('Alien>')
      print alien_data
      alien_info = {}
      if alien_data and "No Tags" not in alien_data and len(alien_data) >0:
        x = alien_data.strip('Get TagList\\n').strip('Alien>').strip('\n').strip('').strip('\r\n').split('\r\n')
        # print x
        for info in x:
          ant_num = info.split(',')[-2].split(':')[1]
          tag_id = info.split(',')[0].split(':')[1]
          if alien_info.has_key(ant_num):
            # alien_info[ant_num].append(tag_id)
            alien_info[ant_num] = []
            break
          else:
            alien_info[ant_num] = [tag_id,]
        print alien_info
        or_id = alien_info.get(ant_num, '')
        if or_id:
          poker_dict = {'A':14, 'J':11, 'Q':12, 'K':13}
          print "\033[33m原始值: %s\033[0m" %or_id
          change_id = raw_input('参照此格式 ->[黑桃01 红桃02 梅花03 方块04][A23456789JQK] 输入例如 02j -> ')
          try:
            color_id = int(change_id[0:2].strip('0'))
            poker_tmp_id = change_id[2:].lstrip('0').upper()
            print poker_tmp_id
            poker_id = poker_dict.get(poker_tmp_id, '') or int(poker_tmp_id)
            check_id = (color_id-1)*14 + poker_id
            value = "{:0>2d} {:0>2d} 00 {:0>2d}".format(color_id, poker_id, check_id)
            print "\033[31m新牌值: %s\033[0m" %(value)
            tn.write("p = %s\n" %value) # enter commands
            alien_data = tn.read_until('Alien>')
            set_data = alien_data.strip('Alien>').strip('\n').strip('').strip('\r\n').split('\n')
            print "更新值 %s" %set_data[1]

            tn.write("Get TagList\n") # enter commands
            new_data = tn.read_until('Alien>')
            print new_data.strip('Get TagList\\n').strip('Alien>').strip('\n').strip('').strip('\r\n').split('\r\n')
            print
          except Exception,e:
            print e
          con = raw_input("按回车继续#")
          if con == '\n':
            continue

if __name__ == '__main__':
  alien_tag_id(HostIP='192.168.9.10')
