#!/bin/env python
import json
import re

"""
#zabbix regular expressions
#dministration -> General -> Regular expressions
Name: File Partition for discovery 
Expressions: ^(sda|sdb|sdc|sdd|sde|sdf|sdg|vda|vdb|vdc|vde|cdf|vdg|xvda|xvdb|xvdc|xvdd|xvde|xvdf|xvdg)

copy the file to Agent /usr/local/zabbix_agent/scripts/

Append the follow content to zabbix_agentd.conf
################################diskFsDiscovery############################################
UserParameter=vfs.read.ops[*],cat /proc/diskstats | grep $1 | head -1 | awk '{print $$4}'
UserParameter=vfs.read.ms[*],cat /proc/diskstats | grep $1 | head -1 | awk '{print $$7}'
UserParameter=vfs.write.ops[*],cat /proc/diskstats | grep $1 | head -1 | awk '{print $$8}'
UserParameter=vfs.write.ms[*],cat /proc/diskstats | grep $1 | head -1 | awk '{print $$11}'
UserParameter=vfs.io.active[*],cat /proc/diskstats | grep $1 | head -1 | awk '{print $$12}'
UserParameter=vfs.io.ms[*],cat /proc/diskstats | grep $1 | head -1 | awk '{print $$13}'
UserParameter=vfs.read.sectors[*],cat /proc/diskstats | grep $1 | head -1 | awk '{print $$6}'
UserParameter=vfs.write.sectors[*],cat /proc/diskstats | grep $1 | head -1 | awk '{print $$10}'
UserParameter=disk.fs.discovery,/usr/bin/python /usr/local/zabbix_agent/scripts/diskFsDiscovery.py
"""

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
