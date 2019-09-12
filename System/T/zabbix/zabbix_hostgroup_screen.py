#encoding:utf-8
import sys
import requests
import argparse
import json

url = 'http://zabbix.g.com/api_jsonrpc.php'
headers = {'content-type': 'application/json'}

Zabbix_User = 'admin'
Zabbix_Passwd = 'zabbix'

def get_info(data):
  try:
    r = requests.post(url, data=data, headers=headers)
  except Exception, e:
    print "Error %s" %e
  else:
    response = json.loads(r.text)
    return response

def json_dumps(data):
  return json.dumps(data, sort_keys=True, indent=4, separators=(',', ':'))

def get_auth_result():
  data = json.dumps({
    'jsonrpc': '2.0',
    'method': 'user.login',
    'params': {
      'user': '%s' %Zabbix_User,
      'password': '%s' %Zabbix_Passwd,
    },
    'id': 0
  })

  response = get_info(data)
  return response['result']


def get_data(method, auth, id, params):
  data = { 
    "jsonrpc": "2.0",
    "method": "%s" %method,
    "params": params,
    "auth": "%s" %auth,
    "id": id, 
  }
#  print json_dumps(data)
  response = get_info(json.dumps(data))
  return response

def get_hostgroup_of_host(method, auth, id, group_name):
  hostgroup_params = {
    "output": "extend",
    "filter": {
      "name": group_name,
    },
    "selectHosts": ["hostid", "host"],
  }
  response = get_data(method=method, auth=auth, id=id, params=hostgroup_params)
#  print json_dumps(response)
# 单一主机组 获取主机列表  
#  for i in response['result'][0]['hosts']:
#    hosts.append(i['host'])
# 多个主机组 获取主机列表
  if response['result']:
    hosts = []
    for result in response['result']:
      for i in result['hosts']:
        hosts.append(i['host'])
    return list(set(hosts))
  else:
    print "Group list Error"
    sys.exit()

def get_host_of_graph(method, auth, id, host_name, graphtype, dynamic, column):
  if(graphtype == 0):
    select_type = 'selectGraphs'
    select_list = ['graphid', 'name']
  if(graphtype == 1):
    select_type = 'selectItems'
    select_list = ['itemid', 'name']

  graph_params = {
    'output': ['hostid', 'host'],
    select_type: select_list,
    'searchByAny': 1,
    'filter': {
      'host': "%s" %host_name,
    },
  }


  response = get_data(method=method, auth=auth, id=id, params=graph_params)
#  print json_dumps(response)

  if response['result']:
    graphs = []
    if(graphtype == 0):
      for i in response['result'][0]['graphs']:
        graphs.append(i['graphid'])
    if(graphtype == 1):
      for i in response['result'][0]['items']:
        graphs.append(i['itemid'])
#  print graphs
  else:
    print "Not Host data"
    sys.exit()

  graph_list = []
  x = 0
  y = 0
  for graph in graphs:
    graph_list.append({
      "resourcetype": graphtype,
      "resourceid": graph,
      "width": "550",
      "height": "150",
      "x": str(x),
      "y": str(y),
      "colspan": "1",
      "rowspan": "1",
      "elements": "0",
      "valign": "0", 
      "halign": "0",
      "style": "0",
      "url": "",
      "dynamic": str(dynamic)
    })
    x += 1
    if x == column:
      x = 0
      y += 1
#  for i in graph_list:
#    print i
  return graph_list

def screen_create(auth, id, host, graphids, columns):
  if len(graphids) % columns == 0:
    vsize = len(graphids)/columns
  else:
    vsize = len(graphids)/columns + 1

  screen_exist_params = {
    "output": "extend",
    "filter": {
      "name": "%s" %host,
    },
  }
  response = get_data(method="screen.get", auth=auth, id=id, params=screen_exist_params)

  if response['result'] == []:
    print "Screen HOST [%s] Not Exists And Creating .... " %host
    screen_method = 'screen.create'
    screen_params = [{
      "name": "%s" %host,
      "hsize": columns,
      "vsize": vsize,
      "screenitems": [], 
    },]
    for i in graphids:
      screen_params[0]['screenitems'].append(i)
  else:
    print "Screen HOST [%s] Existed And updating .... " %host
    screen_name = response['result'][0]['name']
    screenid = response['result'][0]['screenid']
    screen_method = 'screen.update'

    screen_params = [{
      "screenid": screenid,
      "screenitems": [],
    },]
    for i in graphids:
      screen_params[0]['screenitems'].append(i)
  
#  print json_dumps(screen_params)
  response = get_data(method=screen_method, auth=auth, id=id, params=screen_params)  
#  print json_dumps(response)
  return response


if __name__ == '__main__': 
  ZABBIX_AUTH = get_auth_result()

  parser = argparse.ArgumentParser(description="zabbix screen prompt")
  parser.add_argument("-G", "--Group", dest="Group", nargs="+", action="store", help="zabbix Group name")
  parser.add_argument('-H', '--Host', dest='Host', nargs='+', action='store', help='zabbix Host name')
  parser.add_argument('-c', '--column', dest='column', action='store', type=int, default=2, help="zabbix screen columns number")
  parser.add_argument('-t', '--type', dest='graphtype', action='store', type=int, choices=[0,1], default=0, help="screen graph type 1 - item graph 0 - mulititem graph")
#  parser.add_argument('-d', '--dynamic', dest='dynamic', action='store', type=int, choices=[0,1], default=0, help="dynamic" )
  
  args = parser.parse_args()
  columns = args.column
  graphtype = args.graphtype

  if not args.Host and not args.Group:
    print "Must input a group or a host"
    sys.exit()

  if args.Host:
    host_list = args.Host
  else:
    host_list = []
  
  if args.Group:
    group_list = list(set(args.Group))
    group_hosts = get_hostgroup_of_host(method='hostgroup.get', auth=ZABBIX_AUTH, id=1, group_name=group_list)
  else:
    group_hosts = []

  hosts = list(set(host_list + group_hosts))
  for host in hosts:
    graph_list = get_host_of_graph(method='host.get', auth=ZABBIX_AUTH, id=2, host_name='%s' %host, graphtype=graphtype, dynamic=0, column=columns)
    screen_result = screen_create(auth=ZABBIX_AUTH, id=3, host="%s" %host, graphids=graph_list, columns=columns)
    print json_dumps(screen_result)
