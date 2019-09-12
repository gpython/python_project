#encoding:utf-8
import json
import simplejson

def datetime_handler(x):
  if isinstance(x, datetime.datetime):
    return str(x)
  raise TypeError("Unknown type")

def res_format(data):
  return simplejson.dumps(data,
    indent=2,
    ensure_ascii=False,
    sort_keys=True,
    separators=(',',':'),
    default=datetime_handler)

def rtn_data(data):
  if data:
    rtn_format = res_format({'status':200, 'result':data})
  else:
    rtn_format = res_format({'status':404, 'result':data})
  return rtn_format

def json_dumps(data):
  return json.dumps(data, ensure_ascii=False, indent=2, sort_keys=True, separators=(',', ':'))
