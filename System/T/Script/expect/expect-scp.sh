#!/bin/bash

set -e

Remote_User='m'
Remote_Passwd='P'

USAGE=0
TEST=0

function color() {
  echo -e "\033[31m $@ \033[0m"
}

function usage() {
  color "Usage:
    `basename $0` -f LIST_NAME -C \"PACKAGE_NAME\"
    `basename $0` -f list.vim -C \"easter.*.*.*.tar.gz resource.*.*.*.tar.gz\"
    `basename $0` -f list.vim -t
    `basename $0` -h
  "
  exit 1
}

while getopts "f:C:ht" arg
do
  case ${arg} in
    f)
      FILE_NAME=${OPTARG}
      ;;
    C)
      PACK_NAME=${OPTARG}
      ;;
    t)
      TEST=1
      ;;
    *|h)
      USAGE=1
      ;;
  esac
done

if [ $# -eq 0 -o ${USAGE} -eq 1 ]
then
  usage
fi

#if [[ ${FILE_NAME} == "" || ${PACK_NAME} == "" ]]
if [[ ${FILE_NAME} == "" ]]
then
  usage
fi

function Easter_VN_Copy()
{
  Remote_IP=$1
  PACKAGE="${PACK_NAME}"
  echo ${PACKAGE}
  expect -c "
  set timeout -1;
  spawn scp ${PACKAGE} ${Remote_User}@${Remote_IP}:/data/easter/pack/
  expect {
    \"*yes/no*\" {send \"yes\r\"; exp_continue}
    \"*password*\" {send \"${Remote_Passwd}\r\"}
  }
  expect eof; "
}

function Test(){
  Remote_IP=$1
  expect -c "
  set timeout -1;
  spawn ssh ${Remote_User}@${Remote_IP} \"pwd\"
  expect {
    \"*yes/no*\" {send \"yes\r\"; exp_continue}
    \"*password*\" {send \"${Remote_Passwd}\r\"}
  }
  expect eof; "
}


function main(){
  for loop in `cat ${FILE_NAME}`
  do
    if [[ ${TEST} == 1 ]]
    then
      echo "##############${loop}#############"
      Test ${loop}
      echo
    fi
    if [[ ${PACK_NAME} != "" ]]
    then
      echo "##############${loop}#############"
      Easter_VN_Copy ${loop} ${PACK_NAME}
      echo
    fi
  done
}

main
