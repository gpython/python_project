import requests
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

if __name__ == '__main__':
  get_auth_result()
