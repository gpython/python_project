import json
from zabbix_login import get_auth_result, json_dumps, get_info

def get_data(method, auth, id, params):
  data = {
    "jsonrpc": "2.0",
    "method": "%s" %method,
    "params": params,
    "auth": "%s" %auth,
    "id": id,
  }
  print json_dumps(data)
  response = get_info(json.dumps(data))
  return response

if __name__ == '__main__':
  auth = get_auth_result()

  graph_params = {
    "output":["graphid", "name", "graphtype"],
    "hostids": 10107,
    "sortfield": "name",
  }
#  graph_get = get_data(method="graph.get", auth=auth, id=1, params=graph_params)
#  print json_dumps(graph_get)

  screen_create_params = {
    "name": "Graphs",
    "hsize": 2,
    "vsize": 5,
    "screenitems": [{
      "resourcetype": 0,
      "resourceid": "635",
      "rowspan": 1,
      "colspan": 1,
      "x": "1",
      "y": "1"
    }] 
  }
#  screen_create = get_data(method='screen.create', auth=auth, id=2, params=screen_create_params)
#  print json_dumps(screen_create)  


  hostgroup_params = {
    "output": "extend",
    "filter": {
      "name": ["test-group","Discovered hosts"]
    },
    "selectHosts": ["hostid", "host"],
  }
  hosts = []
  hostgroup_get = get_data(method="hostgroup.get", auth=auth, id=3, params=hostgroup_params)
  print json_dumps(hostgroup_get)
#  for i in hostgroup_get['result'][0]['hosts']:
#    hosts.append(i['host'])
  for result in hostgroup_get['result']:
    for i in result['hosts']:
      hosts.append(i['host'])
  print "Hosts= ", {}.fromkeys(hosts).keys()

  host_params = {
    "output": ["hostid", "host"],
    "selectGraphs": ["graphid", "name"],
    "filter": {
      "host": hosts
    }
  }
#  host_get = get_data(method="host.get", auth=auth, id=4, params=host_params)
#  print json_dumps(host_get)

  screen_params = {
    "output": "extend",
    "filter": {
      "name": ["CN-BJ-A-03", "CN-BJ-A-02", "CN-BJ-A-01"]
    },
  }
  screen_get = get_data(method="screen.get", auth=auth, id=4, params=screen_params)
  print json_dumps(screen_get)
  if screen_get['result'] == []:
    print "The Screen is not create"
  else:
    screen_name = screen_get['result'][0]['name']
    screenid = screen_get['result'][0]['screenid']
    print "Screen_name: %s Screenid: %s" %(screen_name, screenid)  

