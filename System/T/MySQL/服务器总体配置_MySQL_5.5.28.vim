安装的MySQL为mysql-5.5.28.tar.gz 
wget http://sourceforge.net/projects/mysql.mirror/files/MySQL%205.5.28/mysql-5.5.28.tar.gz/download
wget http://124.254.47.40/download/30352191/38131622/1/gz/190/9/1349709875902_9/mysql-5.5.28.tar.gz

机器上需要先安装cmake 和 bison


yum install -y gcc gcc-c++ gcc-g77 autoconf automake zlib* fiex* libxml* ncurses-devel libmcrypt* libtool-ltdl-devel*

yum -y install bison
tar zxvf cmake-2.8.4.tar.gz
cd cmake-2.8.4
./bootstrap
gmake
gmake install

MySQL安装

/usr/sbin/groupadd mysql
/usr/sbin/useradd -g mysql mysql
mkdir -p /data/mysql/data
mkdir -p /data/mysql/binlog
mkdir -p /data/mysql/mysql
mkdir -p /data/mysql/logs
mkdir -p /data/mysql/slowlogs
chown -R mysql.mysql /data/mysql

tar zxvf mysql-5.5.28.tar.gz
cd mysql-5.5.28

cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
-DMYSQL_UNIX_ADDR=/tmp/mysql.sock \
-DDEFAULT_CHARSET=utf8 \
-DDEFAULT_COLLATION=utf8_general_ci \
-DWITH_EXTRA_CHARSETS:STRING=utf8,gbk \
-DEXTRA_CHARSETS=all \
-DWITH_MYISAM_STORAGE_ENGINE=1 \
-DWITH_INNOBASE_STORAGE_ENGINE=1 \
-DWITH_DEBUG=0 \
-DWITH_READLINE=1 \
-DENABLED_LOCAL_INFILE=1 \
-DMYSQL_DATADIR=/data/mysql/data \
-DMYSQL_TCP_PORT=3306

##################################################################
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DMYSQL_UNIX_ADDR=/tmp/mysql.sock -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_EXTRA_CHARSETS:STRING=utf8,gbk -DEXTRA_CHARSETS=all -DWITH_MYISAM_STORAGE_ENGINE=1 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_DEBUG=0 -DWITH_READLINE=1 -DENABLED_LOCAL_INFILE=1 -DMYSQL_DATADIR=/data/mysql/data -DMYSQL_TCP_PORT=3306
##################################################################



make
make install

chmod +w /usr/local/mysql

chown -R mysql.mysql /usr/local/mysql

ln -s /usr/local/mysql/lib/libmysqlclient.so.18 /usr/lib/libmysqlclient.so.18

cp support-files/my-huge.cnf /etc/my.cnf

vim /etc/my.cnf
#以下为添加参数
	basedir 	= /usr/local/mysql  
	datadir 	= /data/mysql/data  
	log-error 	= /data/mysql/logs/mysql_error.log  
	pid-file 	= /data/mysql/mysql.pid
	#--------Append---------------
	open_files_limit    = 10240 
	back_log = 600 
	max_connections = 5000 
	max_connect_errors = 6000 
	table_cache = 512 
	external-locking = FALSE 
	max_allowed_packet = 32M 
	sort_buffer_size = 6M 
	join_buffer_size = 8M 
	thread_cache_size = 300 
	thread_concurrency = 8 
	query_cache_size = 512M 
	query_cache_limit = 2M 
	query_cache_min_res_unit = 2k 
	
	binlog_cache_size = 4M 
	binlog_format = MIXED 
	max_binlog_cache_size = 64M 
	max_binlog_size = 1G 
	expire_logs_days = 30 
	read_buffer_size = 4M 
	read_rnd_buffer_size = 16M
	#---------------------
	log-bin=/data/mysql/binlog/binlog

/usr/local/mysql/scripts/mysql_install_db --basedir=/usr/local/mysql --datadir=/data/mysql/data --user=mysql

ll /data/mysql/
ll /data/mysql/data/
cp support-files/mysql.server /etc/rc.d/init.d/mysqld
vim /etc/rc.d/init.d/mysqld 
	basedir=/usr/local/mysql
	datadir=/data/mysql/data

启动项
chmod 755 /etc/rc.d/init.d/mysqld 
/etc/rc.d/init.d/mysqld status
/etc/rc.d/init.d/mysqld start
netstat -antp | grep 3306

chkconfig --add mysqld
chkconfig --level 2345 mysqld on
chkconfig --list

密码设置
/usr/local/mysql/bin/mysqladmin -u root password q1w2e3
/usr/local/mysql/bin/mysql -u root -p

echo "/usr/local/mysql/lib" >> /etc/ld.so.conf
ldconfig 
ldconfig -v | grep mysql

PATH变量
vim /etc/profile
	PATH=$PATH:/usr/local/mysql/bin

开机启动
vim /etc/rc.local
/etc/rc.d/init.d/mysqld start













[client]
character-set-server = utf8
port        = 3306
socket      = /tmp/mysql.sock

[mysqld]
character-set-server = utf8
port        = 3306
socket      = /tmp/mysql.sock
basedir     = /usr/local/mysql
datadir     = /data/mysql/data
log-error   = /data/mysql/logs/mysql_error.log
pid-file    = /data/mysql/mysql.pid

open_files_limit = 51200
back_log = 600
max_connections = 5000
max_connect_errors = 6000

table_cache = 1024
max_allowed_packet = 32M
max_heap_table_size = 64M
read_buffer_size = 4M
read_rnd_buffer_size = 16M
sort_buffer_size = 8M
join_buffer_size = 8M
thread_cache_size = 300
thread_concurrency = 8
query_cache_size = 512M
query_cache_limit = 2M

#ft_min_word_len = 4
#default-storage-engine = MYISAM
thread_stack = 192K

transaction_isolation = READ-COMMITTED
tmp_table_size = 246M

log-bin=/data/mysql/binlog/binlog
binlog_format=mixed
binlog_cache_size = 4M
max_binlog_cache_size = 8M
max_binlog_size = 1G
server-id = 1

relay-log-index = /data/mysql/relaylog/relaylog
relay-log-info-file = /data0/mysql/relaylog/relaylog
relay-log = /data0/mysql/relaylog/relaylog
expire_logs_days = 30

#slow_query_log
#long_query_time = 2


key_buffer_size = 512M

bulk_insert_buffer_size = 64M
myisam_sort_buffer_size = 128M
myisam_max_sort_file_size = 10G
myisam_repair_threads = 1
myisam_recover


innodb_additional_mem_pool_size = 16M
innodb_buffer_pool_size = 2G
innodb_data_file_path = ibdata1:2000M;ibdata2:10M:autoextend
#innodb_data_file_path = ibdata1:10M:autoextend
innodb_write_io_threads = 8
innodb_read_io_threads = 8
innodb_thread_concurrency = 16
innodb_flush_log_at_trx_commit = 1
innodb_log_buffer_size = 16M
innodb_log_file_size = 256M
innodb_log_files_in_group = 3
innodb_max_dirty_pages_pct = 90
innodb_lock_wait_timeout = 120
innodb_file_per_table = 0


[mysqldump]
quick
max_allowed_packet = 32M

[mysql]
no-auto-rehash

[myisamchk]
key_buffer_size = 512M
sort_buffer_size = 512M
read_buffer = 8M
write_buffer = 8M

[mysqlhotcopy]
interactive-timeout

[mysqld_safe]
open-files-limit = 8192



MyISAM转innodb后的参数设置优化

转了MYSQL数据库引擎之后，相关的参数也要重新调整和优化

innodb_flush_logs_at_trx_commit=0（为2好像更合理吧。）
 
该参数设定了事务提交时内存中log信息的处理。
1) =1时，在每个事务提交时，日志缓冲被写到日志文件，对日志文件做到磁盘操作的刷新。Truly ACID。速度慢。 2) =2时，在每个事务提交时，日志缓冲被写到文件，但不对日志文件做到磁盘操作的刷新。只有操作系统崩溃或掉电才会删除最后一秒的事务，不然不会丢失事务。 3) =0时，日志缓冲每秒一次地被写到日志文件，并且对日志文件做到磁盘操作的刷新。任何mysqld进程的崩溃会删除崩溃前最后一秒的事务
抱怨Innodb比MyISAM慢 100倍？那么你大概是忘了调整innodb_flush_log_at_trx_commit 。默认值1的意思是每一次事务提交或事务外的指令都需要把日志写入（flush）硬盘，这是很费时的。特别是使用电池供电缓存（Battery backed up cache）时。设成2对于很多运用，特别是从MyISAM表转过来的是可以的，它的意思是不写入硬盘而是写入系统缓存。日志仍然会每秒flush到硬盘，所以你一般不会丢失超过1-2秒的更新。设成0会更快一点，但安全方面比较差，即使MySQL挂了也可能会丢失事务的数据。而值2只会在整个操作系统挂了时才可能丢数据。

innodb_buffer_pool_size=2048M（这个数值，是否可以调整？当然，在内存不多的情况下，2G也是可以的）
如果用Innodb，那么这是一个重要变量。相对于MyISAM来说，Innodb对于buffer size更敏感。MySIAM可能对于大数据量使用默认的key_buffer_size也还好，但Innodb在大数据量时用默认值就感觉在爬了。 Innodb的缓冲池会缓存数据和索引，所以不需要给系统的缓存留空间，如果只用Innodb，可以把这个值设为内存的70%-80%。和 key_buffer相同，如果数据量比较小也不怎么增加，那么不要把这个值设太高也可以提高内存的使用率。
这是InnoDB最重要的设置，对InnoDB性能有决定性的影响。默认的设置只有8M，所以默认的数据库设置下面InnoDB性能很差。在只有InnoDB存储引擎的数据库服务器上面，可以设置60-80%的内存。更精确一点，在内存容量允许的情况下面设置比InnoDB tablespaces大10%的内存大小。
innodb_data_file_path=innodb_data_file_path=ibdata1:10G;ibdata2:10G;ibdata3:10G:autoextend（格式似乎错误，innodb_data_file_path出现了两次，而每个数据文件超过10G之后，再建立文件，有没有可能10G太大了？）
参数的名字和实际的用途有点出入，它不仅指定了所有InnoDB数据文件的路径，还指定了初始大小分配，最大分配以及超出起始分配界线时是否应当增加文件的大小。此参数的一般格式如下:
path-to-datafile:size-allocation[:autoextend[:max-size-allocation]]
例如，假设希望创建一个数据文件sales，初始大小为100MB，并希望在每次达到当前大小限制时，自动增加8MB（8MB是指定autoextend时的默认扩展大小).但是，不希望此文件超过1GB，可以使用如下配置:
innodb_data_home_dir =
innodb_data_file_path = /data/sales:100M:autoextend:8M: max:1GB
如果此文件增加到预定的1G的限制，可以再增加另外一个数据文件,如下:
innodb_data_file_path = /data/sales:100M:autoextend:8M: max:1GB;innodb_data_file_path = /data2/sales2:100M:autoextend:8M: max:2GB
要注意的是，在这些示例中，inndb_data_home_dir参数开始设置为空，因为最终数据文件位于单独的位置(/data/和/data2/）.如果希望所有 InnoDB数据文件都位于相同的位置，就可以使用innodb_data_home_dir来指定共同位置，然后在通过 inndo_data_file_path来指定文件名即可。如果没有定义这些值，将在datadir中创建一个sales。
innodb_log_file_size=256M（大多数推荐设置）
对于写很多尤其是大数据量时非常重要。要注意，大的文件提供更高的性能，但数据库恢复时会用更多的时间。我一般用64M-512M，具体取决于服务器的空间。
该参数决定了recovery speed。太大的话recovery就会比较慢，太小了影响查询性能，一般取256M可以兼顾性能和recovery的速度
注意：在重新设置该值时，好像要把原来的文件删除掉。
innodb_log_buffer_size=4M（也是推荐设置）
此参数确定些日志文件所用的内存大小，以M为单位。缓冲区更大能提高性能，但意外的故障将会丢失数据.MySQL开发人员建议设置为1－8M之间
默认值对于多数中等写操作和事务短的运用都是可以的。如果经常做更新或者使用了很多blob数据，应该增大这个值。但太大了也是浪费内存，因为1秒钟总会 flush（这个词的中文怎么说呢？）一次，所以不需要设到超过1秒的需求。8M-16M一般应该够了。小的运用可以设更小一点。
innodb_flush_logs_at_trx_commit=2（此处配置重复，前面的为0，这里又配置为2，是否设置为2对于我们提高速度更需要？） transaction-isolation=READ-COMITTED（内涵没有了解清楚，但如果不影响网站功能，这样也OK）
如果应用程序可以运行在READ-COMMITED隔离级别，做此设定会有一定的性能提升。innodb_flush_method=O_DIRECT（推荐设置）
设置InnoDB同步IO的方式：
1) Default – 使用fsync（）。 2) O_SYNC 以sync模式打开文件，通常比较慢。 3) O_DIRECT，在Linux上使用Direct IO。可以显著提高速度，特别是在RAID系统上。避免额外的数据复制和double buffering（mysql buffering 和OS buffering）。innodb_thread_concurrency=16（如果满足这个值大约为cpu数+磁盘数）*2，那暂时OK的，如果我们不清楚物理CPU和磁盘够成，这个参数不设置，用默认的也OK）
用于限制能够进入innodb层的线程数
当进入innodb层调用read_row/write_row/update_row/delete_row时，会检查已经进入innodb的线程数：innodb_srv_conc_enter_innodb
如果已经满了，就会等待innodb_thread_sleep_delay毫秒尝试一次
如果再次失败，则进入到一个FIFO队列sleep。
当在innodb层完成操作后，会调用innodb_srv_conc_exit_innodb退出innodb层
当线程进入时，获得一段时间片innodb_concurrency_tickets，在时间片范围内，该线程就无需检测，直接进入innodb。
理论上讲，我们可以把innodb_thread_concurrency设置为（cpu数+磁盘数）*2，但这需要取决于具体的应用场景。
innodb_commit_concurrency ，用于限制在innodb层commit阶段的线程数，大多数情况下，默认值已经足够。



精简配置文件
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
key_buffer_size = 64M

max_allowed_packet = 1M
table_open_cache = 256
#sort_buffer_size = 1M
#read_buffer_size = 1M
#read_rnd_buffer_size = 2M
#myisam_sort_buffer_size = 32M
thread_cache_size = 8
thread_concurrency = 2

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
slow_query_log = /data/mysql/slowlogs/slow.log

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
thread_cache = 2
table_cache = 128
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

