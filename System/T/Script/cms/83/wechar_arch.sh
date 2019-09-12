#!/bin/bash
PROJECT_DIR=/root/.m2/repository/com/tom/WeChatServer/1/
TIME=`date +"%F"`
STAMP=`date +"%F-%H-%M-%s"`
ARCH_DIR=/data/code_arch/${TIME}

#目录不存在创建 目录存在 重命名并创建新目录
if [ ! -d ${ARCH_DIR} ]
then
  mkdir ${ARCH_DIR} -p
else
  mv ${ARCH_DIR} ${ARCH_DIR}-${STAMP}
  mkdir ${ARCH_DIR} -p
fi


cd ${PROJECT_DIR}
cp WeChatServer-1.war ${ARCH_DIR}/WeChatServer.war

echo
echo "http://tom-cms-code:8181/${TIME}/WeChatServer.war"
echo "-------MD5----------"
md5sum ${ARCH_DIR}/WeChatServer.war
