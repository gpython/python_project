import argparse

parser = argparse.ArgumentParser(description="Zabbix for Argument")

parser.add_argument('-g', '--group', dest='group', action='store', nargs='+', help='group name')
parser.add_argument('-d', '--device', dest='device', action='store', nargs='+',help='device name')

args = parser.parse_args()

if args.group:
  group_list = list(set(args.group))
else:
  group_list = []

if args.device:
  host_list = list(set(args.device))
else:
  host_list = []

print host_list
print group_list  
