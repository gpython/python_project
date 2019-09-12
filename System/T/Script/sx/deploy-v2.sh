#!/bin/bash
#上线脚本
TIMESTAMP=`date +"%s"`
DATE=`date +"%F"`

PORT=8080
PROJECT_NAME=wxmail
FRONT_NAME=tommail

TOMCAT_DIR=/data/tomcat
TOMCAT_LOG=/data/tomcat/logs/catalina.out

NGINX=/usr/local/nginx-1.16/sbin/nginx

WEBAPP=/data/tomcat/webapps
CODE_DIR=/data/tomcat/webapps/${PROJECT_NAME}
CODE_WAR=/data/tomcat/webapps/${PROJECT_NAME}.war

ARCH_DIR=/data/code/code_arch
ROLL_DIR=/data/code/roll_arch

B_URL="http://tom-wxmail-tommail:8181/${DATE}/${PROJECT_NAME}.war"
F_URL="http://tom-wxmail-tommail:8181/${DATE}/${FRONT_NAME}.tar.gz"

#shutdown nginx
function::shut_nginx(){
  echo "Shutdown nginx ..."
  ${NGINX} -s stop
  sleep 2
  nginx_pid=`ps aux | grep nginx | grep -v "grep" | awk '{print $2}'`
  # -n the length of STRING is nonzero
  if [ -n "${nginx_pid}" ]
  then
    echo "pkill nginx"
    pkill nginx
  fi 
}
#start nginx
function::start_nginx(){
  echo "start nginx..."
  ${NGINX}
  ps axu | grep nginx
}

#关闭tomcat
function::shut_tomcat(){
  cd ${TOMCAT_DIR}
  echo "shutdown tomcat ...."
  ./bin/shutdown.sh
  sleep 5
  echo "ps aux | grep ${TOMCAT_DIR} | grep -v "grep" | awk '{print $2}'"
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
    -f)
      echo "Deploy 前端代码..."
      cd ${ARCH_DIR}/${DATE}
      tar zxvf ${FRONT_NAME}.tar.gz -C ${WEBAPP}/
      ;;
    -b)
      echo "Deploy 后端代码..."
      cd ${ARCH_DIR}/${DATE}
      cp ${PROJECT_NAME}.war ${WEBAPP}/
      ;;
    -a)
      echo "Deploy 前后端代码..."
      cp ${PROJECT_NAME}.war ${WEBAPP}/
      tar zxvf ${FRONT_NAME}.tar.gz -C ${WEBAPP}/  
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
    -f)
      echo "Backup 前端代码.."
      mv ${WEBAPP}/${FRONT_NAME} ./
      ;;
    -b)
      echo "Backup 后端代码.."
      mv ${WEBAPP}/${PROJECT_NAME}* ./
      ;;
    -a)
      echo "Backup 前后端代码.."
      mv ${WEBAPP}/* ./
      ;;
  esac
}

#rollback
function::roll(){
  mkdir /tmp/${TIMESTAMP} -p

  case $1 in 
    -f)
      echo "Rolling 前端代码.."
      mv ${WEBAPP}/${FRONT_NAME} /tmp/${TIMESTAMP}/
      cp -a ${ROLL_DIR}/${DATE}-origin/${FRONT_NAME} ${WEBAPP}/
      ;;
    -b)
      echo "Rolling 后端代码.."
      mv ${WEBAPP}/${PROJECT_NAME}* /tmp/${TIMESTAMP}/
      cp -a ${ROLL_DIR}/${DATE}-origin/${PROJECT_NAME}.war ${WEBAPP}/
      ;;
    -a)
      echo "Rolling 前后端代码.."
      mv ${WEBAPP}/* /tmp/${TIMESTAMP}/
      cp -a ${ROLL_DIR}/${DATE}-origin/${PROJECT_NAME}.war ${WEBAPP}/
      cp -a ${ROLL_DIR}/${DATE}-origin/${FRONT_NAME} ${WEBAPP}/
      ;;
  esac
}

function::code_get(){
  cd ${ARCH_DIR}/${DATE}
  case $1 in 
    -f)
      echo "Get Front Code..."
      wget ${F_URL}
      ;;
    -b)
      echo "Get Backend code..."
      wget ${B_URL} 
      ;;
    -a)
      echo "Get Front and Backed code.."
      wget ${B_URL}
      wget ${F_URL}
      ;;
  esac
  sleep 2
}
######################

if [ ! -d ${ARCH_DIR}/${DATE} ]
then
  mkdir ${ARCH_DIR}/${DATE} -p
fi

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
        function::shut_nginx
        function::shut_tomcat
        function::backup -b
        function::deploy_code -b
        function::start_tomcat
        function::start_nginx
      fi
      if [[ $OPTARG == "rollback" ]]
      then
        function::shut_nginx
        function::shut_tomcat
        function::roll -b
        function::start_tomcat
        function::start_nginx
      fi
      ;;
    f)
      if [[ $OPTARG == "deploy" ]]
      then
        function::code_get -f
        function::shut_nginx
        function::shut_tomcat
        function::backup -f
        function::deploy_code -f
        function::start_tomcat
        function::start_nginx
      fi
      if [[ $OPTARG == "rollback" ]]
      then
        function::shut_nginx
        function::shut_tomcat
        function::roll -f
        function::start_tomcat
        function::start_nginx
      fi
      ;;      
    a)
      if [[ $OPTARG == "deploy" ]]
      then
        function::code_get -a
        function::shut_nginx
        function::shut_tomcat
        function::backup -a
        function::deploy_code -a
        function::start_tomcat
        function::start_nginx
      fi
      if [[ $OPTARG == "rollback" ]]
      then
        function::shut_nginx
        function::shut_tomcat
        function::roll -a
        function::start_tomcat
        function::start_nginx
      fi
      ;;
    h)
      echo "Help"
      echo "$0 -a [deploy|rollback]"
      echo "$0 -b [deploy|rollback]"
      echo "$0 -f [deploy|rollback]"
      ;;
    ?) #unkonows argments is ?
      echo "Unknow Argument"
      exit 1
      ;;
  esac
done
