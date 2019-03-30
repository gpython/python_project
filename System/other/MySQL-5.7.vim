wget https://jaist.dl.sourceforge.net/project/boost/boost/1.59.0/boost_1_59_0.tar.gz
wget http://ftp.ntu.edu.tw/pub/MySQL/Downloads/MySQL-5.7/mysql-5.7.23.tar.gz
yum -y install gcc-c++ ncurses-devel cmake make perl gcc autoconf automake zlib libxml libgcrypt libtool bison

/usr/sbin/groupadd mysql
/usr/sbin/useradd -g mysql mysql
mkdir -p /data/mysql/data
mkdir -p /data/mysql/binlog
mkdir -p /data/mysql/mysql
mkdir -p /data/mysql/logs
mkdir -p /data/mysql/slowlogs
chown -R mysql.mysql /data/mysql

tar zxvf boost_1_59_0.tar.gz -C /usr/local/
tar zxvf mysql-5.7.23.tar.gz
cd mysql-5.7.23


cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DMYSQL_DATADIR=/data/mysql/data \
-DWITH_BOOST=/usr/local/boost_1_59_0 \
-DSYSCONFDIR=/etc \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_PARTITION_STORAGE_ENGINE=1 \
-DWITH_FEDERATED_STORAGE_ENGINE=1 \
-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DENABLED_LOCAL_INFILE=1 \
-DENABLE_DTRACE=0 \
-DDEFAULT_CHARSET=utf8mb4 \
-DDEFAULT_COLLATION=utf8mb4_general_ci \
-DWITH_EMBEDDED_SERVER=1


chmod +w /usr/local/mysql
chown -R mysql.mysql /usr/local/mysql
ln -s /usr/local/mysql/lib/libmysqlclient.so.20 /usr/lib/libmysqlclient.so.20

vim /etc/my.cnf
[client]
port		= 3306
socket		= /tmp/mysql.sock

[mysqld]
port		= 3306
basedir 	= /usr/local/mysql
datadir 	= /data/mysql/data
socket		= /tmp/mysql.sock
pid-file 	= /data/mysql/mysql.pid

symbolic-links=0
skip-external-locking

default-storage-engine=INNODB

#MYISAM
key_buffer_size = 64M

max_allowed_packet = 1M
table_open_cache = 256
#sort_buffer_size = 1M
#read_buffer_size = 1M
#read_rnd_buffer_size = 2M
#myisam_sort_buffer_size = 32M
#thread_cache_size = 8
#thread_concurrency = 2

#INNODB
innodb_buffer_pool_size = 128M   ########
innodb_log_file_size = 32M
innodb_log_buffer_size = 8M
innodb_file_per_table = 1
innodb_flush_method = O_DIRECT
innodb_data_home_dir = /data/mysql/data
innodb_data_file_path = ibdata1:10M:autoextend   ######

#LOGGING
log-error 	= /data/mysql/logs/mysql_error.log
#slow_query_log = /data/mysql/slowlogs/slow.log

#BINLOG
server-id	= 1
binlog_format=mixed
log-bin = /data/mysql/binlog/binlog

#OTHER
tmp_table_size  = 32M
max_heap_table_size = 32M
query_cache_type = 0
query_cache_size = 16M
max_connections = 51200
#thread_cache = 2
#table_cache = 128
open_files_limit = 65535



[mysqldump]
quick
max_allowed_packet = 16M

[mysql]
no-auto-rehash

[myisamchk]
key_buffer_size = 128M
sort_buffer_size = 128M
read_buffer = 2M
write_buffer = 2M

[mysqlhotcopy]
interactive-timeout


/usr/local/mysql/bin/mysqld  --basedir=/usr/local/mysql --datadir=/data/mysql/data --user=mysql --initialize-insecure

ll /data/mysql/
ll /data/mysql/data/
cp support-files/mysql.server /etc/init.d/mysqld

启动项
chmod 755 /etc/init.d/mysqld
/etc/init.d/mysqld status
/etc/init.d/mysqld start
netstat -antp | grep 3306

chkconfig --add mysqld
chkconfig --level 2345 mysqld on
chkconfig --list | grep 3:on

vim /etc/profile
  PATH=$PATH:/usr/local/mysql/bin
source /etc/profile


密码设置
/usr/local/mysql/bin/mysqladmin -u root password q1w2e3
mysql -uroot -pq1w2e3 -e "use mysql ; delete from user where password=''; select user, host, password from user;"
/usr/local/mysql/bin/mysql -u root -p

echo "/usr/local/mysql/lib" >> /etc/ld.so.conf
ldconfig
ldconfig -v | grep mysql


####################################################
wget  http://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
yum localinstall mysql57-community-release-el7-11.noarch.rpm
yum install mysql-community-server


vim /etc/my.cnf
[client]
port		= 3306
socket		= /tmp/mysql.sock

[mysqld]
port		= 3306
#basedir 	= /usr/local/mysql
datadir 	= /data/mysql/data
socket		= /tmp/mysql.sock
pid-file 	= /data/mysql/mysql.pid

symbolic-links=0
skip-external-locking

validate_password_policy=0
validate_password = off
default-storage-engine=INNODB

#MYISAM
key_buffer_size = 64M

max_allowed_packet = 1M
table_open_cache = 256
#sort_buffer_size = 1M
#read_buffer_size = 1M
#read_rnd_buffer_size = 2M
#myisam_sort_buffer_size = 32M
#thread_cache_size = 8
#thread_concurrency = 2

#INNODB
innodb_buffer_pool_size = 128M   ########
innodb_log_file_size = 32M
innodb_log_buffer_size = 8M
innodb_file_per_table = 1
innodb_flush_method = O_DIRECT
innodb_data_home_dir = /data/mysql/data
innodb_data_file_path = ibdata1:10M:autoextend   ######

#LOGGING
log-error 	= /data/mysql/logs/mysql_error.log
#slow_query_log = /data/mysql/slowlogs/slow.log

#BINLOG
server-id	= 1
binlog_format=mixed
log-bin = /data/mysql/binlog/binlog

#OTHER
tmp_table_size  = 32M
max_heap_table_size = 32M
query_cache_type = 0
query_cache_size = 16M
max_connections = 51200
#thread_cache = 2
#table_cache = 128
open_files_limit = 65535

character_set_server=utf8
init_connect='SET NAMES utf8'

[mysqldump]
quick
max_allowed_packet = 16M

[mysql]
no-auto-rehash

[myisamchk]
key_buffer_size = 128M
sort_buffer_size = 128M
read_buffer = 2M
write_buffer = 2M

[mysqlhotcopy]
interactive-timeout

#########
systemctl start mysqld

#默认密码
grep 'temporary password' /data/mysql/logs/mysql_error.log

#更改root密码
alter user 'root'@'localhost' identified by '123';
flush privileges;

























####
cmake  -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DMYSQL_DATADIR=/data/mysql/data \
-DSYSCONFDIR=/etc \
-DMYSQL_USER=mysql \
-DWITH_SYSTEMD=1 \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_ARCHIVE_STORAGE_ENGINE=1 \
-DWITH_MEMORY_STORAGE_ENGINE=1 \
-DWITH_READLINE=1 \
-DMYSQL_TCP_PORT=3306 \
-DENABLED_LOCAL_INFILE=1 \
-DENABLE_DOWNLOADS=1 \
-DWITH_PARTITION_STORAGE_ENGINE=1 \
-DEXTRA_CHARSETS=all \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_DEBUG=0 \
-DMYSQL_MAINTAINER_MODE=0 \
-DWITH_SSL:STRING=bundled \
-DWITH_ZLIB:STRING=bundled \
-DDOWNLOAD_BOOST=1 \
-DWITH_BOOST=./boost










