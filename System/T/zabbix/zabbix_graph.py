import json
import pprint
from zabbix_login import get_auth_result, json_dumps, get_info


def get_graph(auth_result, graphtype=0):
  if (graphtype == 0):
    selectType = ['graphid', 'name']
    select = 'selectGraphs'
  if (graphtype == 1) :
    selectType = ['itemid', 'name']
    select = 'selectItems'

  data = json.dumps({
    'jsonrpc': '2.0',
    'method': 'graph.get',
    'params': {
      'output': ['graphid', 'name'],
      select: selectType,
#      'selectItems': ['name'],
#      'selectHosts': ['name'],
      'hostids': [10105, 10107, 10108],
      'sortfield': 'name',
      'filter': {
        'name': ["Disk - iops/second By sda1", "Disk space usage /"],
      },
    },
    'auth': '%s' %auth_result,
    'id': 1
  })
  response = get_info(data)
  print json_dumps(response)
#  output = response['result']
#  pprint.pprint output
#  print 
#  bb = sorted(output, key = lambda x:x['graphid'])
#  pprint.pprint bb
# return response

  graphs = []
#  if (graphtype == 0):
#    for i in response['result'][0]['graphs']:
#      print i['']
      
if __name__ == '__main__':
  auth_result = get_auth_result()
  get_graph(auth_result, graphtype=0)







