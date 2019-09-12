数据库 MyISAM到InnoDB引擎迁移注意事项

#41 原数据从库 引擎MyISAM 有小部分表Innodb
#mysql 配置文件

/usr/local/mysql/my.cnf
[client]
port		= 3306
socket		= /tmp/mysqld.sock

[mysqld]
port		= 3306
socket		= /tmp/mysql.sock
datadir         = /data/mydata
skip-external-locking
key_buffer_size = 16M
max_allowed_packet = 16M
table_open_cache = 64
sort_buffer_size = 512K
net_buffer_length = 8K
read_buffer_size = 256K
read_rnd_buffer_size = 512K
myisam_sort_buffer_size = 8M
max_connections = 20000
skip_name_resolve
wait_timeout=120
interactive_timeout=120
max_heap_table_size=128M
tmp_table_size=128M
slow_query_log=TRUE
long_query_time=5


log-bin=mysql-bin
binlog_format=mixed

server-id	= 3
binlog-ignore-db = mysql
binlog-ignore-db = information_schema
binlog-ignore-db = performance_schema

#binlog-do-db=opencms
#replicate-do-db=opencms

###即将更改为Innodb 注意项目见 #97配置
# Uncomment the following if you are using InnoDB tables
#innodb_data_home_dir = /data/mydata
#innodb_data_file_path = ibdata1:10M:autoextend
#innodb_log_group_home_dir = /data/mydata
# You can set .._buffer_pool_size up to 50 - 80 %
# of RAM but beware of setting memory usage too high
#innodb_buffer_pool_size = 16M
#innodb_additional_mem_pool_size = 2M
# Set .._log_file_size to 25 % of buffer pool size
#innodb_log_file_size = 5M
#innodb_log_buffer_size = 8M
#innodb_flush_log_at_trx_commit = 1
#innodb_lock_wait_timeout = 50

[mysqldump]
quick
max_allowed_packet = 16M

[mysql]
no-auto-rehash
# Remove the next comment character if you are not familiar with SQL
#safe-updates

[myisamchk]
key_buffer_size = 20M
sort_buffer_size = 20M
read_buffer = 2M
write_buffer = 2M

[mysqlhotcopy]
interactive-timeout

#版本信息
/usr/local/mysql/bin/mysql --version
/usr/local/mysql/bin/mysql  Ver 14.14 Distrib 5.5.62, for linux-glibc2.12 (x86_64) using readline 5.1

#安全关闭从服务器
/usr/local/mysql/bin/mysqladmin shutdown  -S /tmp/mysql.sock -uroot -p
#启动命令
/usr/local/mysql/bin/mysqld_safe --user=mysql  &
#登录命令
/usr/local/mysql/bin/mysql -u root -p


#97
#新安装测试数据库 版本与原数据库一致
#配置文件
[client]
port= 3306
socket= /tmp/mysql.sock

[mysqld]

skip-grant-tables

port= 3306
basedir = /usr/local/mysql  
datadir = /data/mydata 
socket= /tmp/mysql.sock
pid-file = /data/mydata/mysql.pid

skip-external-locking

#MYISAM
key_buffer_size = 512M

max_allowed_packet = 64M
table_open_cache = 512
sort_buffer_size = 2M
read_buffer_size = 2M
read_rnd_buffer_size = 8M
myisam_sort_buffer_size = 64M
query_cache_size = 32M


wait_timeout=120
interactive_timeout=120


#thread_cache_size = 8
#thread_concurrency = 32

skip_name_resolve = on

#INNODB
innodb_buffer_pool_size = 48G   ########
innodb_log_file_size = 512M
innodb_log_buffer_size = 64M
innodb_file_per_table = 1
innodb_flush_method = O_DIRECT
innodb_data_home_dir = /data/mydata
#innodb_data_file_path = ibdata1:2000M;ibdata2:10M:autoextend  ######

character_set_server=utf8
collation-server=utf8_general_ci

#LOGGING
#log-error = /data/mydata/logs/mysql_error.log  
log-error = /data/mydata/mysql_error.log  

slow_query_log = ON
long_query_time = 3
#slow_query_log_file = /data/mydata/slowlogs/slow.log
slow_query_log_file = /data/mydata/slow.log

#BINLOG
#####server-id= 1
binlog_format=mixed
#log-bin = /data/mydata/binlog/binlog
log-bin = /data/mydata/binlog

server-id	= 3
binlog-ignore-db = mysql
binlog-ignore-db = information_schema
binlog-ignore-db = performance_schema

expire_logs_days = 90

#OTHER
#####tmp_table_size  = 32M
tmp_table_size  = 128M
#####max_heap_table_size = 32M
max_heap_table_size = 128M
query_cache_type = 0
query_cache_size = 16M
max_connections = 51200
#table_cache = 128
open_files_limit = 65535

[mysqldump]
quick
max_allowed_packet = 16M

[mysql]
no-auto-rehash

[myisamchk]
key_buffer_size = 256M
sort_buffer_size = 256M
read_buffer = 2M
write_buffer = 2M

[mysqlhotcopy]
interactive-timeout


#数据目录
/data/mydata
chown mysql.mysql /data/mydata

srync 拷贝#41 已关闭的 数据库文件到 #97 /data/mydata目录
配置参数变更
备份 ib_logfile0 ib_logfile1

启动#97 数据库 查看错误日志 

启动成功 登录 更改表引擎

for loop in `mysql -uroot -proot#2019 -e "use opencms; show tables;" | grep -P "CMS_*" | grep CMS`
do 
  echo mysql -uroot -proot#2019 -e "use opencms; alter table ${loop} engine=Innodb;"
  mysql -uroot -proot#2019 -e "use opencms; alter table ${loop} engine=Innodb;"
  sleep 2
done

for loop in `mysql -uroot -proot#2019 -e "use opencms; show tables;" | grep -P "CMS_*" | grep CMS`
do 
  echo mysql -uroot -proot#2019 -e "use opencms; alter table ${loop} engine=Innodb;"
  sleep 2
done



###################### Master 45 ##########################
/bin/sh /usr/local/mysql/bin/mysqld_safe --datadir=/data/mydata --pid-file=/data/mydata/debian.pid
mysql    16601 18.5  1.5 1508788 256540 ?      Sl   Mar07 27276:03 /usr/local/mysql/bin/mysqld --basedir=/usr/local/mysql --datadir=/data/mydata --plugin-dir=/usr/local/mysql/lib/plugin --user=mysql --log-error=/data/mydata/debian.err --pid-file=/data/mydata/debian.pid --socket=/tmp/mysqld.sock --port=3306
