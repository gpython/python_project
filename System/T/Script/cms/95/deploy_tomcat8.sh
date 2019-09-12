#!/bin/bash
TIMESTAMP=`date +"%F-%H-%M-%s"`
DATE=`date +"%F"`

PORT=8081
PROJECT_NAME=WeChatServer

TOMCAT_DIR=/data/tomcat8/
TOMCAT_LOG=/data/tomcat8/logs/catalina.out

WEBAPP=/data/tomcat8/webapps
CODE_DIR=/data/tomcat8/webapps/${PROJECT_NAME}
CODE_WAR=/data/tomcat8/webapps/${PROJECT_NAME}.war

ARCH_DIR=/data/code/code_arch
ROLL_DIR=/data/code/roll_arch

B_URL="http://tom-cms-code:8181/${DATE}/${PROJECT_NAME}.war"

#关闭tomcat
function::shut_tomcat(){
  cd ${TOMCAT_DIR}
  echo "shutdown tomcat ...."
  ./bin/shutdown.sh
  sleep 5
  echo "ps aux | grep ${TOMCAT_DIR} | grep -v "grep" | awk '{print \$2}'"
  tomcat_pid=`ps aux | grep ${TOMCAT_DIR} | grep -v "grep" | awk '{print $2}'`
  if [ -n "${tomcat_pid}" ]
  then
    #tomcat_pid=`ps aux | grep ${TOMCAT_DIR} | grep -v grep | awk '{print $2}'`
    echo "kill tomcat ..."
    echo "kill -9 ${tomcat_pid}"
    kill -9 ${tomcat_pid}
  fi 
  ps axu | grep ${TOMCAT_DIR}
  sleep 5
}
#启动tomcat
function::start_tomcat(){
  cd ${TOMCAT_DIR}
  echo "start tomcat ...."
  ./bin/startup.sh
  tail -f ${TOMCAT_LOG}
}

#部署代码
function::deploy_code(){
  echo "Deploy ..."
  cd ${ARCH_DIR}/${DATE}
  case $1 in 
    -b)
      echo "Deploy 后端代码..."
      cd ${ARCH_DIR}/${DATE}
      cp ${PROJECT_NAME}.war ${WEBAPP}/
      ;;
  esac
  sleep 3
}

function::backup(){
  echo "Backup ..."
  #第一次的备份
  if [ ! -d ${ROLL_DIR}/${DATE}-origin ]
  then
    mkdir ${ROLL_DIR}/${DATE}-origin -p
    cd ${ROLL_DIR}/${DATE}-origin
  else
    #后续一天内上线多次的前一次备份 仅仅备份 最原始的备份在-origin目录内
    mkdir ${ROLL_DIR}/${DATE}-${TIMESTAMP}
    cd ${ROLL_DIR}/${DATE}-${TIMESTAMP}
  fi

  case $1 in 
    -b)
      echo "Backup 后端代码.."
      mv ${WEBAPP}/${PROJECT_NAME}* ./
      ;;
  esac
}

#rollback
function::roll(){
  mkdir /tmp/${TIMESTAMP} -p

  case $1 in 
    -b)
      echo "Rolling 后端代码.."
      mv ${WEBAPP}/${PROJECT_NAME}* /tmp/${TIMESTAMP}/
      cp -a ${ROLL_DIR}/${DATE}-origin/${PROJECT_NAME}.war ${WEBAPP}/
      ;;
  esac
}

function::code_get(){
  if [ ! -d ${ARCH_DIR}/${DATE} ]
  then
    mkdir ${ARCH_DIR}/${DATE} -p
  else
    mv ${ARCH_DIR}/${DATE} ${ARCH_DIR}/${DATE}-${TIMESTAMP}
    mkdir ${ARCH_DIR}/${DATE} -p
  fi
  cd ${ARCH_DIR}/${DATE}

  case $1 in 
    -b)
      echo "Get Backend code..."
      wget ${B_URL} -O ${PROJECT_NAME}.war
      ;;
  esac
  sleep 2
}
######################

#下载代码 关闭tomcat 备份war包 部署代码 启动tomcat
#-b 后端代码
#-f 前端代码
#-s 
while getopts "a:b:f:h" arg
do
  case $arg in
    b)
      if [[ $OPTARG == "deploy" ]]
      then
        function::code_get -b
        function::shut_tomcat
        function::backup -b
        function::deploy_code -b
        function::start_tomcat
      fi
      if [[ $OPTARG == "rollback" ]]
      then
        function::shut_tomcat
        function::roll -b
        function::start_tomcat
      fi
      ;;
    h)
      echo "Help"
      echo "$0 -b [deploy|rollback]"
      ;;
    ?) #unkonows argments is ?
      echo "Unknow Argument"
      exit 1
      ;;
  esac
done
