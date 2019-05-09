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






##################################
MyISAM 会把索引 缓存到 内存中 数据有OS 缓存
Innodb 索引和数据都 缓存在内存中 提高数据库运行效率

系统表空间 和 独立表空间选择
Innodb_file_per_table
比较
  系统表空间无法简单收缩文件大小
  独立表空间可以通过optimize table命令收缩系统文件

  系统表空间会产生IO瓶颈
  独立表空间可以同时向多个文件刷新数据

show engine innodb status 上次执行到本次执行间隔的状态值

内存配置相关参数
  确定MySQL的 每个连接 使用的内存
  以下四个参数是 为每个链接分配的内存大小 与连接数成倍数 的消耗内存

  以下参数 内存使用总和 = 每个线程所需要内存×连接数

  sort_buffer_size
   每个连接排序缓冲区的大小
   有查询排序操作时为每个连接分配缓冲区 直接为每个连接 分配此参数指定 的内存大小

  join_buffer_size
   为每个关联 分配 此参数指定 的内存大小

  read_buffer_size 4k倍数
   为myisam表全表扫描时分配读缓冲区 所需内存大小

  read_rnd_buffer_size
   索引缓冲区 分配 所需内存大小

为缓存池分配内存
  Innodb_buffer_pool_size
  总内存 - 每个线程所需要内存×连接数 -系统保留内存

  key_buffer_size (myisam)


Innodb I/O相关配置
  Innodb_log_file_size
  Innodb_log_files_in_group
  事务日志总大小
  Inndob_log_file_size*Innodb_log_files_in_group

  事务日志缓冲区
  Innodb_log_buffer_size
  事务 先提交到事务日志缓冲区 然后在 刷新到磁盘上的事务日志文件中

  Innodb_flush_log_at_trx_commit
  0 每秒进行一次log写入cache 并flush log到磁盘
  1 默认 在每次事务提交执行log写入cache 并flush log到磁盘
  2 建议 每次事务提交 执行log数据写入到cache 每秒执行一次flush log到磁盘

  Innodb_flush_method=O_DIRECT

  Innodb_file_per_table = 1
  Innodb_doublewrite = 1
   避免不完整页 (16k) 写入 建议开启

安全
  max_allowed_packet
  skip_name_resolve
  sysdate_is_now
  read_only
  skip_slave_start













