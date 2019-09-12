########
apt install libterm-readkey-perl
git clone https://github.com/innotop/innotop.git
cd innotop/
perl Makefile.PL
make install

innotop --user root --password Pas4wd
#######
apt-get install percona-toolkit

#######
wget https://repo.percona.com/apt/pool/main/p/percona-xtrabackup/percona-xtrabackup_2.3.10-1.stretch_amd64.deb

apt install libcurl3 libev4
dpkg -i percona-xtrabackup_2.3.10-1.stretch_amd64.deb

apt install libmariadbclient18 libdbi-perl mysql-common percona-xtrabackup libdbd-mysql-perl

###### 备份须知 ########
#xtrabackup只能备份innodb和xtradb两种引擎的表，而不能备份myisam引擎的表；
#innobackupex是一个封装了xtrabackup的Perl脚本，支持同时备份innodb和myisam
#但在对myisam备份时需要加一个全局的读锁。还有就是myisam不支持增量备份。

##### 备份数据库 指定备份的库 备份到目录 /backup/mysql_backup/ #####
# my.cnf文件内指定了data的存放目录
#指定库 主从复制使用 position id
USER=root
PASSWD=Pas4wd
innobackupex --defaults-file=/etc/my.cnf --user=${USER} --password=${PASSWD} --database="articlefilter crawler opencms tongji tv_file_upload we_chat" /backup/mysql_backup/ >> /tmp/master_info.log

#指定备份数据量比较大的库
innobackupex --defaults-file=/etc/my.cnf --user=${USER} --password=${PASSWD} --database="opencms" /backup/mysql_backup/ >> /tmp/master_info.log

#注：第一次增量备份要建立在完整备份之上才可以
# –incremental /data/backup_incre 指定增量备份存放的目标目录
# –incremental-basedir=/data/mysql_backup 指定完整备份的目录

innobackupex --defaults-file=/etc/my.cnf --user=${USER} --password=${PASSWD} --database="opencms" --incremental /data/backup_incre --incremental-basedir=/data/mysql_backup/ >> /tmp/incre_info.log

#进行第二次增量备份，需要指定上一次增量备份的目录
# –incremental /data/backup_incre 指定这次增量备份目录
# –incremental-basedir=/data/backup_incre/2019-06-18 指定上次增量备份目录

innobackupex --defaults-file=/etc/my.cnf --user=${USER} --password=${PASSWD} --database="opencms" --incremental /data/backup_incre --incremental-basedir=/data/mysql_backup/2019-06-18 >> /tmp/incre_info.log


### 还原备份 ####
#创建完的备份之后的数据还不能马上用于还原，需要回滚未提交事务，前滚提交事务，让数据库文件保持一致性
#成功后会输出，成功后备份可以被用来还原数据库了
#prepare的过程，其实是读取备份文件夹中的配置文件，然后innobackupex重做已提交事务，回滚未提交事务，
#之后数据就被写到了备份的数据文件（innodb）中，并重建日志文件
#--user-memory 指定prepare阶段可使用的内存大小，默认为10MB，内存多则快
# –apply-log 准备还原备份的选项
# –use-memory=8G 设置准备还原数据时使用的内存，可以提高准备所花费的时间

## prepare数据库（预备份--apply-log）##
#innobackupex --defaults-file=/etc/my.cnf --user=${USER} --password --apply-log /backup/mysql_backup/2019-06-18
innobackupex --defaults-file=/etc/my.cnf  --apply-log /backup/mysql_backup/2019-06-18

## 恢复数据库 ##
#注意: 还原是先关闭服务 如果服务是启动的 那么就不能还原到datadir 并且datadir必须是为空的
# 因为innobackupex --copy-back 不会覆盖已存在的文件
#innobackupex　使用　--copy-back 来还原备份（recovery）
#innobackupex 会根据my.cnf的配置，将所有备份数据复制到my.cnf里面指定的 datadir 路径下

innobackupex --defaults-file=/etc/my.cnf --user=${USER} --password --copy-back /backup/mysql_backup/2019-06-18

###

innobackupex --ibbackup=xtrabackup_55 --defaults-file=/etc/my.cnf  --apply-log /data/backup/2019-06-20_19-14-12
innobackupex --ibbackup=xtrabackup_55 --defaults-file=/etc/my.cnf  --copy-back /data/backup/2019-06-20_19-14-12
###
## 修改datadir目的的权限，启动数据库 ##
chown mysql.mysql /data/mydata -R

# 恢复出的数据目录里没有 mysql performance_schema两张表
# 需要生产者两张表的数据 拷贝到数据库目录里 
# 启动数据库
/etc/init.d/mysqld start 


### 主从复制 ####
#Master机器添加 复制用户
grant replication slave on "." to "repl"@"172.25.18.%" identified by "Pas4wd";
flush privileges;
#查看授权结果
show grants for 'repl'@'172.25.18.%';

#测试slave登录master
mysql -urepl -h 172.25.18.97 -p

##从服务器 my.cnf 配置
vim /etc/my.cnf
[client]
port= 3306
socket= /tmp/mysql.sock

[mysqld]

#skip-grant-tables

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
#####server-id= 10
binlog_format=mixed
#log-bin = /data/mydata/binlog/binlog
log-bin = /data/mydata/mysql-bin
expire_logs_days = 30

server-id	= 10
master-info-file = /data/mydata/master.info
relay-log-index = /data/mydata/relay-bin.index
relay-log-info-file = /data/mydata/relay-bin.info
relay-log = /data/mydata/relay-bin

read_only = 1

#binlog-ignore-db = mysql
#binlog-ignore-db = information_schema
#binlog-ignore-db = performance_schema

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

#slave 执行连接到Master 
#Master Log_file 和Log_pos信息在 mysql数据目录中备份文件信息中
change master to 
MASTER_HOST='172.25.18.97', 
MASTER_USER='repl',
MASTER_PASSWORD='Pas4wd',
MASTER_LOG_FILE='mysql-bin.000326',
MASTER_LOG_POS=286179411;

#启动slave
start slave;

#查看信息
show slave status;



#随心邮件 数据库备份 全库备份
###########5.6
innobackupex --ibbackup=xtrabackup_56 --defaults-file=/etc/my.cnf --user=root --password=tompass --socket=/tmp/mysql.sock  /data/backup

xtrabackup: The latest check point (for incremental): '107653011842'
xtrabackup: Stopping log copying thread.
.>> log scanned up to (107653011842)

xtrabackup: Creating suspend file '/data/backup/2019-06-26_12-47-03/xtrabackup_log_copied' with pid '20497'
xtrabackup: Transaction log of lsn (107646441924) to (107653011842) was copied.
190626 13:30:54  innobackupex: All tables unlocked

innobackupex: Backup created in directory '/data/backup/2019-06-26_12-47-03'
innobackupex: MySQL binlog position: filename 'mysql-bin.000304', position 669650068
190626 13:30:54  innobackupex: Connection to database server closed
190626 13:30:54  innobackupex: completed OK!

#slave 执行连接到Master 
#Master Log_file 和Log_pos信息在 mysql数据目录中备份文件信息中
change master to 
MASTER_HOST='172.25.16.212', 
MASTER_USER='repl',
MASTER_PASSWORD='repl',
MASTER_PORT=3306,
MASTER_LOG_FILE='mysql-bin.000006',
MASTER_LOG_POS=303230462;

#启动slave
start slave;

#查看信息
show slave status;







#####################################

