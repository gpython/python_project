jdk-8u101-linux-x64.tar.gz
apache-tomcat-8.5.5.tar.gz


tar zxvf jdk-8u101-linux-x64.tar.gz -C /usr/local/

ln -s /usr/local/jdk1.8.0_101 /usr/local/jdk

cat >> /etc/profile << EOF
export JAVA_HOME=/usr/local/jdk 
export JRE_HOME=\${JAVA_HOME}/jre
export CLASSPATH=.:\${JAVA_HOME}/lib:\${JRE_HOME}/lib
export PATH=\${JAVA_HOME}/bin:\$PATH
EOF


### tomcat
tar zxvf apache-tomcat-8.5.5.tar.gz -C /usr/local/
mv /usr/local/apache-tomcat-8.5.5 /usr/local/tomcat

