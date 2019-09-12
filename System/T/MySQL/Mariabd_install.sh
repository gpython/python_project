#!/bin/bash

MARIADB_URL=http://93-soft:9393/mariadb-10.3.15-linux-glibc_214-x86_64.tar.gz 
PASSWD=pas4wd

apt install  libaio1 libnuma-dev libncurses5-dev libncursesw5-dev
#yum install -y numactl libaio


wget ${MARIADB_URL}

tar zxvf mariadb-10.3.15-linux-glibc_214-x86_64.tar.gz -C /usr/local/
chown root.staff /usr/local/mariadb-10.3.15-linux-glibc_214-x86_64/ -R
ln -s /usr/local/mariadb-10.3.15-linux-glibc_214-x86_64 /usr/local/mysql

/usr/sbin/groupadd mysql
/usr/sbin/useradd -g mysql mysql
mkdir -p /data/mysql/data
mkdir -p /data/mysql/binlog
mkdir -p /data/mysql/mysql
mkdir -p /data/mysql/logs
mkdir -p /data/mysql/slowlogs
chown -R mysql.mysql /data/mysql

cd /usr/local/mysql
cp support-files/mysql.server /etc/init.d/mysqld
sed -i 's@^datadir=@datadir=/data/mysql/data@' /etc/init.d/mysqld
sed -i 's@^basedir=@basedir=/usr/local/mysql@' /etc/init.d/mysqld
chmod 755 /etc/init.d/mysqld

cat > /etc/my.cnf << EOF
[client]
port		= 3306
socket		= /tmp/mysql.sock

[mysqld]
port		= 3306
basedir 	= /usr/local/mysql  
datadir 	= /data/mysql/data  
socket		= /tmp/mysql.sock
pid-file 	= /data/mysql/mysql.pid

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

#thread_cache_size = 8
#thread_concurrency = 32

skip_name_resolve = on

#INNODB
innodb_buffer_pool_size = 2G   ########
innodb_log_file_size = 256M
innodb_log_buffer_size = 16M
innodb_file_per_table = 1
innodb_flush_method = O_DIRECT
innodb_data_home_dir = /data/mysql/data
innodb_data_file_path = ibdata1:10M:autoextend  ######

character_set_server=utf8
collation-server=utf8_general_ci

#LOGGING
log-error 	= /data/mysql/logs/mysql_error.log  

slow_query_log = ON
long_query_time = 3
slow_query_log_file = /data/mysql/slowlogs/slow.log

#BINLOG
server-id	= 1
binlog_format=mixed
log-bin = /data/mysql/binlog/binlog

expire_logs_days = 90

#OTHER
tmp_table_size  = 32M
max_heap_table_size = 32M
query_cache_type = 0
query_cache_size = 16M
max_connections = 51200
#table_cache = 128
open_files_limit = 65535

wait_timeout = 604800

[mysqldump]
quick
max_allowed_packet = 64M

[mysql]
no-auto-rehash

[myisamchk]
key_buffer_size = 256M
sort_buffer_size = 256M
read_buffer = 2M
write_buffer = 2M

[mysqlhotcopy]
interactive-timeout
EOF

./scripts/mysql_install_db --user=mysql --basedir=/usr/local/mysql --datadir=/data/mysql/data
/etc/init.d/mysqld start
/usr/local/mysql/bin/mysqladmin -u root password ${PASSWD}
echo "export PATH=\$PATH:/usr/local/mysql:/usr/local/mysql/bin" >> /etc/profile
source /etc/profile
/usr/local/mysql/bin/mysql -uroot -p${PASSWD} -e "use mysql; delete from user where password=''; delete from user where user=''; select user, host, password from user;"
