#enconding=utf-8
#import argparse
import json
import re
import sys
import os.path

def port_serv(boolen_port=0, boolen_serv=0):
  port_pattern = re.compile(r'^\d+$')
  serv_pattern = re.compile(r'^[^\d#]+[a-zA-Z0-9_-].+$')

  port_dis = {'data':[]}
  serv_dis = {'data':[]}

  port_list = []
  serv_list = []
  
  with open(os.path.dirname(__file__)+'/port_and_service.vim') as f:
    for line in f.readlines():
      std_line = line.strip('\n').strip(' ')
      port = port_pattern.match(std_line)
      serv = serv_pattern.match(std_line)

      if port:
        port_list.append(port.group())
      if serv:
        serv_list.append(serv.group())

  port_list = list(set(port_list))
  serv_list = list(set(serv_list))

  if port_list:
    for port in port_list:
      port_dis['data'].append({'{#PORT}':port})

  if serv_list:
    for serv in serv_list:
      serv_dis['data'].append({'{#SERVICE}':serv})

  if boolen_port:
    return port_dis
  if boolen_serv:
    return serv_dis


if __name__ == '__main__':
  boolen_port = False
  boolen_serv = False
#  parser = argparse.ArgumentParser(description="JZ Port and Service discovery")
#  parser.add_argument('--port', '-p', action='store_true', default=False, dest='boolen_port', help='set a switch to true')
#  parser.add_argument('--serv', '-s', action='store_true', default=False, dest='boolen_serv', help='set a switch to true')
  if len(sys.argv) == 1:
#    parser.print_help()
    sys.exit(1)
#  result = parser.parse_args()
  if sys.argv[1] == '-p' or sys.argv[1] == '--port':
    boolen_port = True
  
  if sys.argv[1] == '-s' or sys.argv[1] == '--serv':
    boolen_serv = True

#  boolen_port = result.boolen_port
#  boolen_serv = result.boolen_serv

  data = port_serv(boolen_port, boolen_serv)
  print(json.dumps(data, ensure_ascii=False, indent=2, sort_keys=True, separators=(',', ':')))

