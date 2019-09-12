import json
import requests
import argparse

url = 'http://zabbix.g.com/api_jsonrpc.php'
headers = {'content-type': 'application/json'}

def get_info(data):
  try:
    r = requests.post(url, data=data, headers=headers)
  except e:
    print "Error %s" %e
  else:  
    response = json.loads(r.text)
  return response  
  
def json_dumps(data):
  print json.dumps(data, sort_keys=True, indent=4, separators=(',', ':'))

def get_result():
  data = json.dumps({
    'jsonrpc': '2.0',
    'method': 'user.login',
    'params': {
      'user': 'admin',
      'password': 'zabbix',
    },
    'id': 0
  })
  response = get_info(data)
#  json_dumps(response)
  return response['result']  

#Get the hosts info (hostid and host -> hostname) that belong to the host group 
def get_hosts(auth_result, hostgroup):
  data = json.dumps({
    'jsonrpc': '2.0',
    'method': 'hostgroup.get',
    'params': {
      'output': 'extend',
#      'output': ['hostid', 'name'],
#      'selectGroups': 'extend',
#      'selectParentTemplates': ['templateid', 'name'],
      'selectHosts': ['hostid', 'host'],
      'filter': {
        "name":"test-group",
      }
    },
    'auth': "%s" %auth_result,
    'id': 1,
  })
  response = get_info(data)
#  json_dumps(response)
  host_list = []
  for host in response['result'][0]['hosts']:
    host_list.append(host['hostid'])
  return host_list

def get_graphs(auth_result, host_list, graphtype=0, dynamic=0):
  if (graphtype == 0):
    selecttype = ['graphid']
    select = 'selectGraphs'
  if (graphtype == 1):
    selecttype = ['itemid', 'value_type']
    select = 'selectItems'
  data = json.dumps({
    'jsonrpc': '2.0',
    'method': 'graph.get',
    'params': {
      'output' : ['graphid', 'name'],
#        'output': 'extend',
#      select : [selecttype, 'name'],
      select: 'extend',
      'hostids': host_list,
#      'sortfield': 'name',
#      'filter': {
#        'name': host_list,
#      },
    },  
    'auth': "%s" %auth_result,
    'id': 2,
  })  
  response = get_info(data)
  json_dumps(response)
if __name__ == '__main__':
  auth_result = get_result()
  host_info = get_hosts(auth_result, '')
  print host_info
  get_graphs(auth_result, host_list=host_info, graphtype=1, dynamic=0) 
