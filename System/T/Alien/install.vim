################################REDIS###################################
yum install gcc gcc-c++ libstdc++-devel zlib-devel
mkdir /data/redis/6379/data
mkdir /data/redis/6379/log
mkdir /etc/redis


wget http://download.redis.io/releases/redis-3.2.9.tar.gz
tar zxvf redis-3.2.9.tar.gz 
cd redis-3.2.9
make
make PREFIX=/usr/local/redis install

cp redis.conf /etc/redis/redis_6379.conf

vim redis_6379.conf
bind 192.168.9.206 127.0.0.1
protected-mode yes
port 6379
tcp-backlog 511
timeout 0
tcp-keepalive 300
daemonize yes
supervised no
pidfile /var/run/redis_6379.pid
loglevel notice
logfile "/data/redis/6379/log/redis.log"
databases 16
save 900 1
save 300 10
save 60 10000
stop-writes-on-bgsave-error yes
rdbcompression yes
rdbchecksum yes
dbfilename dump_6379.rdb
dir /data/redis/6379/data
slave-serve-stale-data yes
slave-read-only yes
repl-diskless-sync no
repl-diskless-sync-delay 5
repl-disable-tcp-nodelay no
slave-priority 100
appendonly no
appendfilename "appendonly_6379.aof"
appendfsync everysec
no-appendfsync-on-rewrite no
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb
aof-load-truncated yes
lua-time-limit 5000
slowlog-log-slower-than 10000
slowlog-max-len 128
latency-monitor-threshold 0
notify-keyspace-events ""
hash-max-ziplist-entries 512
hash-max-ziplist-value 64
list-max-ziplist-size -2
list-compress-depth 0
set-max-intset-entries 512
zset-max-ziplist-entries 128
zset-max-ziplist-value 64
hll-sparse-max-bytes 3000
activerehashing yes
client-output-buffer-limit normal 0 0 0
client-output-buffer-limit slave 256mb 64mb 60
client-output-buffer-limit pubsub 32mb 8mb 60
hz 10
aof-rewrite-incremental-fsync yes

启动
/usr/local/redis/bin/redis-server /etc/redis/redis_6379.conf 

vim /etc/profile
PATH=$PATH:/usr/local/redis/bin


##############################PHP################################
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
yum install php56w.x86_64 php56w-cli.x86_64 php56w-common.x86_64 php56w-gd.x86_64 php56w-ldap.x86_64 php56w-mbstring.x86_64 php56w-mcrypt.x86_64 php56w-mysql.x86_64 php56w-mysqli php56w-pdo.x86_64 php56w-fpm php56w-openssl php56w-opcache  

yum install php72w.x86_64 php72w-cli.x86_64 php72w-common.x86_64 php72w-gd.x86_64 php72w-ldap.x86_64 php72w-mbstring.x86_64 php72w-mcrypt.x86_64 php72w-mysql.x86_64 php72w-mysqli php72w-pdo.x86_64 php72w-fpm php72w-openssl php72w-opcache

vim /etc/php-fpm.d/www.conf
[www]
listen = 127.0.0.1:9000 
listen.allowed_clients = 127.0.0.1
user = www
group = www
pm = dynamic
pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 2
pm.max_spare_servers = 3

slowlog = /data/logs/php-fpm/www-slow.log
php_admin_value[error_log] = /data/logs/php-fpm/www-error.log
php_admin_flag[log_errors] = on
php_value[session.save_handler] = files
php_value[session.save_path]    = /var/lib/php/session
php_value[soap.wsdl_cache_dir]  = /var/lib/php/wsdlcache
##############################
vim /etc/php.ini
max_execution_time = 300
memory_limit = 128M
post_max_size = 16M
upload_max_filesize = 2M
max_input_time = 300
date.timezone = Asia/Shanghai
##################################
chown root.www /var/lib/php -R

service php-fpm start

#############################################



RFID注意事项
默认IP 192.168.1.100
Console线连接进入更改IP
help
info

get ipaddress
get gateway
get dhcp
#查看哪些端口已开启监听
get ant 

#设置IP 网关 关闭dhcp  打开监听端口
set ipaddress=192.168.9.10
set gateway=192.168.9.1
set dhcp=off
set ant= 0 1 2 3

RFAenuation值范围从0（没有衰减，最大功率）到MaxAttenuation（最大衰减，最小功率），该值增加10代表信号衰减1db
功率通过指令“RFA”功率衰减设定，例如，发送指令“RFA=0”表示功率衰减为0，即输出功率最大。发送指令“RFA=150”表示功率衰减为150/10 dB，即15 dB，输出功率最小。功率衰减设置间隔为10，即1 dB
get RFA
RFA = 60

开启编程模式可以进行 录入牌值


save
