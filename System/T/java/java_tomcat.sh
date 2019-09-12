#!/bin/bash
#tomcat应用使用普通用户执行
#目录 /data/tomcat

#jdk-8u101-linux-x64.tar.gz
#apache-tomcat-8.5.41.tar.gz
wget http://backup-93:9393/jdk-8u101-linux-x64.tar.gz
wget http://backup-93:9393/apache-tomcat-8.5.41.tar.gz

USER=tom

mkdir /data

tar zxvf jdk-8u101-linux-x64.tar.gz -C /usr/local/
chown root.staff /usr/local/jdk1.8.0_101 -R
ln -s /usr/local/jdk1.8.0_101 /usr/local/jdk

tar zxvf apache-tomcat-8.5.41.tar.gz -C /data/
chown ${USER}.${USER} /data/apache-tomcat-8.5.41 -R
ln -s /data/apache-tomcat-8.5.41 /data/tomcat
mv /data/tomcat/webapps/* /tmp/

cat >> /etc/profile << EOF
export JAVA_HOME=/usr/local/jdk
export PATH=\$JAVA_HOME/bin:\$CATALINA_HOME/bin:\$PATH 
export CLASSPATH=.:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar
EOF
source /etc/profile

cat >> /home/${USER}/.bashrc << EOF
export JAVA_HOME=/usr/local/jdk
export PATH=\$JAVA_HOME/bin:\$CATALINA_HOME/bin:\$PATH 
export CLASSPATH=.:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar
EOF




