#!/bin/bash
Remote_User='root'
Remote_IP='119.1.1.1'
Remote_Passwd=''

Change_DNS()
{
  Remote_IP=$1
  expect -c "
  set timeout -1;
  spawn ssh ${Remote_User}@${Remote_IP} \"cat /etc/resolv.conf;
  echo '
nameserver 117.121.9.100
nameserver 117.121.9.140
  ' > /etc/resolv.conf;
  cat /etc/resolv.conf
\"
  expect {
    \"*yes/no*\" {send \"yes\r\"; exp_continue}
    \"*password*\" {send \"${Remote_Passwd}\r\"}
  }
  expect eof; "
}

Check_DNS()
{
  Remote_IP=$1
  expect -c "
  set timeout -1;
  spawn ssh ${Remote_User}@${Remote_IP} \"cat /etc/resolv.conf;\"
  expect {
    \"*yes/no*\" {send \"yes\r\"; exp_continue}
    \"*password*\" {send \"${Remote_Passwd}\r\"}
  }
  expect eof; "
}
for loop in `cat list.vim`
do
  echo "##############${loop}#############"
#  Change_DNS ${loop}
   Check_DNS ${loop}
  echo
done
