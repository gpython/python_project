import json
from zabbix_login import get_auth_result, json_dumps, get_info

def get_hostgroup(auth_result):
  data = json.dumps({
    'jsonrpc': '2.0',
    'method': 'hostgroup.get',
    'params': {
      'output': ['groupid', 'hosts', 'name'],
      'selectHosts': ['hostid', 'host', 'name', 'status'],
      'sortfield': 'groupid',
      'filter': {
#        'name': 'test-group',
         'groupid': [5,6,7,8],
      }
    },
    'auth': '%s' %auth_result,
    'id': 1
  })
  response = get_info(data)
  print json_dumps(response)


if __name__ == '__main__':
  auth_result = get_auth_result()
  get_hostgroup(auth_result)
