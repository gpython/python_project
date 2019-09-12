#!/bin/bash
#测试服 执行 
PROJECT_DIR=/data/tomcat/webapps
TIME=`date +"%F"`
ARCH_DIR=/data/code_arch/${TIME}

if [ ! -d ${ARCH_DIR} ]
then
  mkdir ${ARCH_DIR} -p
fi

cd ${PROJECT_DIR}
cp wxmail.war ${ARCH_DIR}
tar zcvf ${ARCH_DIR}/tommail.tar.gz tommail/ --exclude res

echo
echo "http://tom-wxmail-tommail:8181/${TIME}/wxmail.war"
echo "http://tom-wxmail-tommail:8181/${TIME}/tommail.tar.gz"
