import json
from zabbix_login import get_auth_result, json_dumps, get_info

def get_graph(auth, hostname, graphtype, dynamic, columns):
  if(graphtype == 0):
    selecttype = ['graphid', 'name']
    select = 'selectGraphs'
  
  if(graphtype == 1):
    selecttype = ['itemid', 'name']
    select = 'selectItems'

  data = json.dumps({
    'jsonrpc': '2.0',
    'method': 'host.get',
    'params': {
      select: selecttype,
      'output': ['hostid', 'host'],
      'searchByAny': 1,
      'filter': {
        'host': "%s" %hostname 
      },
    },
    'auth': '%s' %auth,
    'id': 2
  })
  
  print data
  response = get_info(data)
  print json_dumps(response)

  graphs = []
  if(graphtype == 0):
    for i in response['result'][0]['graphs']:
      graphs.append(i['graphid'])
  
  if (graphtype == 1):
    for i in response['result'][0]['items']:
      graphs.append(i['itemid'])
  
  print graphs
  graph_list = []
  x = 0
  y = 0
  
  for graph in graphs:
    graph_list.append({
      'resourcetype': graphtype,
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
    if x == columns:
      x = 0
      y += 1
  for i in graph_list:
    print i
  return graph_list    


def screen_create(auth, screen_name, graphids, columns):
  if len(graphids) % columns == 0:
    vsize = len(graphids) / columns
  else:
    vsize = (len(graphids) / columns) + 1

  values = {
    "jsonrpc": "2.0",
    "method": "screen.create",
    "params": [{
      "name": "%s" %screen_name,
      "hsize": columns,
      "vsize": vsize,
      "screenitems": [],
    }],
    "auth": "%s" %auth,
    "id": 2
  }

  for i in graphids:
    values['params'][0]['screenitems'].append(i)
  print json_dumps(values)    
#  screen_result = get_info(json.dumps(values))
#  print json_dumps(screen_result)

if __name__ == '__main__':
  auth = get_auth_result()
  graphids = get_graph(auth, hostname='BJ-CN-A-01', graphtype=0, dynamic=0, columns=2)
  screen_create(auth=auth, screen_name="BJ-CN-A-01", graphids=graphids, columns=2)

