import json
import re

pattern = re.compile(r'ram|loop|sr')

def disk_fs_discovery():
  with open('/proc/diskstats') as f:
    disk_info = f.readlines()

  disks = []

  for disk in disk_info:
    d = disk.split()[2].strip()
    if pattern.match(d):
      continue
    disks.append({ '{#PNAME}': d }) 
  return disks

  
if __name__ == '__main__':
  disks = disk_fs_discovery()
  print json.dumps({'data': disks}, sort_keys=True, indent=4, separators=(',', ':'))
