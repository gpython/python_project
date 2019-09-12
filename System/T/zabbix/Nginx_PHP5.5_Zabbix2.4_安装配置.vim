wget http://sourceforge.net/projects/mysql.mirror/files/MySQL%205.5.28/mysql-5.5.28.tar.gz/download

wget http://ftp.gnu.org/gnu/libiconv/libiconv-1.14.tar.gz
http://pkgs.fedoraproject.org/repo/pkgs/libmcrypt/libmcrypt-2.5.8.tar.gz/0821830d930a86a5c69110837c55b7da/libmcrypt-2.5.8.tar.gz
ftp://ftp.gnome.org/mirror/temp/sf2015/l/la/lanmp/mhash-0.9.9.9.tar.gz
http://pkgs.fedoraproject.org/repo/pkgs/mcrypt/mcrypt-2.6.8.tar.gz/97639f8821b10f80943fa17da302607e/mcrypt-2.6.8.tar.gz

wget http://nginx.org/download/nginx-1.9.2.tar.gz
wget http://cn2.php.net/get/php-5.5.26.tar.gz/from/this/mirror
wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.36.tar.gz
wget http://labs.frickle.com/files/ngx_cache_purge-2.3.tar.gz

wget http://sourceforge.net/projects/zabbix/files/ZABBIX%20Latest%20Stable/2.4.5/zabbix-2.4.5.tar.gz/download

安装必要的包
sudo -s
LANG=C
yum -y install gcc gcc-c++ autoconf libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel libidn libidn-devel openssl openssl-devel openldap openldap-devel nss_ldap openldap-clients openldap-servers gd-devel libXpm-devel

编译安装PHP所需要的包
tar zxvf libiconv-1.14.tar.gz
cd libiconv-1.14/
./configure --prefix=/usr/local
make
make install
cd ../

tar zxvf libmcrypt-2.5.8.tar.gz 
cd libmcrypt-2.5.8/
./configure
make
make install
/sbin/ldconfig
cd libltdl/
./configure --enable-ltdl-install
make
make install
cd ../../

tar zxvf mhash-0.9.9.9.tar.gz
cd mhash-0.9.9.9/
./configure
make
make install
cd ../

ln -s /usr/local/lib/libmcrypt.la /usr/lib/libmcrypt.la
ln -s /usr/local/lib/libmcrypt.so /usr/lib/libmcrypt.so
ln -s /usr/local/lib/libmcrypt.so.4 /usr/lib/libmcrypt.so.4
ln -s /usr/local/lib/libmcrypt.so.4.4.8 /usr/lib/libmcrypt.so.4.4.8
ln -s /usr/local/lib/libmhash.a /usr/lib/libmhash.a
ln -s /usr/local/lib/libmhash.la /usr/lib/libmhash.la
ln -s /usr/local/lib/libmhash.so /usr/lib/libmhash.so
ln -s /usr/local/lib/libmhash.so.2 /usr/lib/libmhash.so.2
ln -s /usr/local/lib/libmhash.so.2.0.1 /usr/lib/libmhash.so.2.0.1
ln -s /usr/local/bin/libmcrypt-config /usr/bin/libmcrypt-config
ln -s /usr/lib64/libldap.so /usr/lib/libldap.so


tar zxvf mcrypt-2.6.8.tar.gz
cd mcrypt-2.6.8/
/sbin/ldconfig
./configure
make
make install
cd ../

tar zxvf pcre-8.36.tar.gz 
cd pcre-8.36
./configure 
make
make install


Nginx安装
tar zxvf nginx-1.9.2.tar.gz 
tar zxvf ngx_cache_purge-2.3.tar.gz 
/usr/sbin/groupadd www
/usr/sbin/useradd -g www www
mkdir /data/tmp/nginx/client -p
mkdir /data/tmp/nginx/proxy -p
mkdir /data/tmp/nginx/fcgi -p
mkdir /data/logs/nginx -p
cd nginx-1.9.2
 ./configure --prefix=/usr/local/nginx --error-log-path=/data/logs/nginx/error.log --http-log-path=/data/logs/nginx/access.log --user=www --group=www --with-http_ssl_module --with-http_flv_module --with-http_gzip_static_module --with-http_stub_status_module --with-stream --http-client-body-temp-path=/data/tmp/nginx/client --http-proxy-temp-path=/data/tmp/nginx/proxy --http-fastcgi-temp-path=/data/tmp/nginx/fcgi --add-module=../ngx_cache_purge-2.3
make
make install

vim /usr/local/nginx/conf/nginx.conf
###############################Nginx配置文件#######################################
worker_processes  1;
error_log  /data/logs/nginx/nginx_error.log  error;
#error_log  /data/logs/nginx/nginx_error.log   debug;
pid 	/usr/local/nginx/logs/nginx.pid;

worker_rlimit_nofile 65535;

events {
  use epoll;
  worker_connections  65535;
}

http {
	include       mime.types;
	default_type  application/octet-stream;
	
	server_names_hash_bucket_size 128;
 	client_header_buffer_size 32k;
 	large_client_header_buffers 4 32k;
 	client_max_body_size 100m;
      
 	client_body_buffer_size 256k;
 	client_header_timeout 3m;
 	client_body_timeout 3m;
 	send_timeout 3m;	
	
	sendfile        on;
	tcp_nopush on;
	keepalive_timeout  65;
	tcp_nodelay on;
	
	server_tokens off;

	fastcgi_connect_timeout 300;
	fastcgi_send_timeout 300;
	fastcgi_read_timeout 300;
	fastcgi_buffer_size 64k;
	fastcgi_buffers 4 64k;
	fastcgi_busy_buffers_size 128k;
	fastcgi_temp_file_write_size 128k;
	
	proxy_connect_timeout   60;   
 	proxy_send_timeout      60;   
 	proxy_read_timeout      60;   
 	proxy_buffer_size       64k;   
 	proxy_buffers           4 64k;   
 	proxy_busy_buffers_size 128k;   
  proxy_temp_file_write_size 128k; 
#	proxy_cache_path /data/tmp/nginx/cache/one  levels=1:2   keys_zone=one:10m max_size=2g;
#	proxy_cache_key "$host$request_uri";

	gzip  on;	
	gzip_min_length  1k;
 	gzip_buffers     4 16k;
 	gzip_http_version 1.0;
 	gzip_comp_level 2;
 	gzip_types       text/plain application/x-javascript text/css application/xml;
 	gzip_vary on;
	
	log_format  access  '$remote_addr $upstream_addr - $remote_user [$time_local] "$request" '
    '$status $body_bytes_sent "$http_referer"  $scheme://$host$request_uri'
    '"$http_user_agent" $http_x_forwarded_for';	
	
	
#	server {
#		listen 80;
#		server_name _;
#		return 500;
#	}
	
	include vhost/*.conf;	
}

vim /usr/local/nginx/conf/vhost/zabbix.conf
server {
  listen 80;
  server_name zabbix.g.com;
  index index.html index.php index.html;
  root /data/htdocs/zabbix;

  location / {
    try_files $uri $uri/ /index.php?$args;
  }

  location ~ ^(.+.php)(.*)$ {
    fastcgi_split_path_info ^(.+.php)(.*)$;
    include fastcgi.conf;
    fastcgi_pass 127.0.0.1:9000;
    fastcgi_index index.php;
    fastcgi_param PATH_INFO $fastcgi_path_info;
  }

  access_log /data/logs/nginx/zabbix.access.log access;
}
#########################################################################################
PHP安装

echo "/usr/local/lib" >> /etc/ld.so.conf
ldconfig

mkdir /data/logs/php

tar zxvf php-5.5.26.tar.gz 
cd php-5.5.26

./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --with-mysql=/usr/local/mysql --with-mysqli=/usr/local/mysql/bin/mysql_config --with-iconv-dir=/usr/local --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-mbstring --with-mcrypt --with-gd --enable-gd-native-ttf --with-openssl --with-mhash --enable-pcntl --enable-sockets --with-gettext --with-ldap --with-ldap-sasl --with-xmlrpc --enable-zip --enable-soap --enable-fpm --enable-bcmath --enable-shmop --enable-dom --enable-sysvsem --enable-inline-optimization --with-curl --enable-mbregex

#############################PHP5.6######################################
--prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --with-mysql=/usr/local/mysql --with-mysqli --with-iconv-dir=/usr/local --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-mbstring --with-mcrypt --with-gd --enable-gd-native-ttf --with-openssl --with-mhash --enable-pcntl --enable-sockets --with-gettext --with-ldap=shared --with-ldap-sasl --with-xmlrpc --enable-zip --enable-soap --enable-fpm --enable-bcmath --enable-shmop --enable-dom --enable-sysvsem --enable-inline-optimization --with-curl --enable-mbregex
#########################################################################

make ZEND_EXTRA_LIBS='-liconv'
make install

cp php.ini-production /usr/local/php/etc/php.ini
cp sapi/fpm//init.d.php-fpm /etc/rc.d/init.d/php-fpm
chmod 755 /etc/rc.d/init.d/php-fpm

vim /usr/local/php/etc/php.ini
#######################ZABBIX PHP 配置参数##########################
max_execution_time = 300
memory_limit = 128M
post_max_size = 16M
upload_max_filesize = 2M
max_input_time = 300
date.timezone = Asia/Shanghai
#####################################################################

vim /usr/local/php/etc/php-fpm.conf
###############################配置php-fpm###########################
[global]
pid = run/php-fpm.pid
error_log = /data/logs/php/php-fpm.log
log_level = notice
emergency_restart_threshold = 10
emergency_restart_interval = 1m
process_control_timeout = 5s
daemonize = yes

[www]
listen = 127.0.0.1:9000
listen.backlog = -1
listen.allowed_clients = 127.0.0.1
listen.owner = nobody
listen.group = nobody
listen.mode = 0666
user = www
group = www
pm = static

;优化选项
pm.max_children = 5
pm.start_servers = 1
pm.min_spare_servers = 1
pm.max_spare_servers = 2

request_terminate_timeout = 0
request_slowlog_timeout = 0
slowlog = /data/logs/php/$pool.log.slow
rlimit_files = 65535
rlimit_core = 0
chroot = 
chdir = 
catch_workers_output = yes
php_flag[display_errors] = off
#####################################################################

yum install net-snmp net-snmp-devel net-snmp-utils fping

groupadd zabbix
useradd -g zabbix zabbix

tar zxvf zabbix-2.4.5.tar.gz
./configure --prefix=/usr/local/zabbix --enable-server --enable-agent --with-mysql=/usr/local/mysql/bin/mysql_config --with-net-snmp --with-libcurl --with-libxml2 --enable-java
make
make install

cp misc/init.d/tru64/zabbix_* /etc/rc.d/init.d/
chmod 755 /etc/rc.d/init.d/zabbix_*

创建zabbix用户
create database zabbix;
grant all on zabbix.* to 'zabbix'@'localhost' identified by 'zabbix';
grant all on zabbix.* to 'zabbix'@'127.0.0.1' identified by 'zabbix';

cd database/mysql

mysql -uzabbix -pzabbix zabbix < schema.sql 
mysql -uzabbix -pzabbix zabbix < images.sql
mysql -uzabbix -pzabbix zabbix < data.sql

cd ../..

ln -s /usr/local/zabbix/sbin/zabbix_server /usr/local/sbin/zabbix_server
ln -s /usr/local/zabbix/sbin/zabbix_agentd /usr/local/sbin/zabbix_agentd
vim /usr/local/zabbix/etc/zabbix_server.conf
DBName=zabbix
DBUser=zabbix
DBPassword=zabbix
DBPort=3306

/etc/rc.d/init.d/zabbix_server start

mkdir /data/htdocs/zabbix -p
cp frontends/php/* /data/htdocs/zabbix/ -ar
chown -R www.www /data/htdocs/zabbix


Zabbix 客户端安装
yum install net-snmp net-snmp-devel net-snmp-utils fping

groupadd zabbix
useradd -g zabbix zabbix

#tar zxvf zabbix-3.0.1.tar.gz
tar zxvf zabbix-2.4.5.tar.gz
./configure --prefix=/usr/local/zabbix_agent --enable-agent
make
make install
cp misc/init.d/tru64/zabbix_agentd /etc/rc.d/init.d/
chmod 755 /etc/rc.d/init.d/zabbix_agentd
cp /usr/local/zabbix_agent/sbin/zabbix_agentd /usr/local/sbin/
ln -s /usr/local/zabbix_agent/bin/* /usr/bin/

vim /usr/local/zabbix_agent/etc/zabbix_agentd.conf
Server=10.10.10.9
ServerActive=10.10.10.9
Hostname=BJ-CN-A-01

#hostname=`hostname`
#CentOS6
#hostname=`ifconfig | grep eth1 -A 1 | grep -Po '(?<=addr:).*(?= Bcast)'`
CentOS7
hostname=`ifconfig | grep eth0 -A 1 | grep -Po '(?<=inet ).*(?= netmask)'`
sed -i 's/Server=127.0.0.1/Server=10.19.160.14/' /usr/local/zabbix_agent/etc/zabbix_agentd.conf
sed -i 's/ServerActive=127.0.0.1/ServerActive=10.19.160.14/' /usr/local/zabbix_agent/etc/zabbix_agentd.conf
sed -i "s/Hostname=Zabbix server/Hostname=${hostname}/" /usr/local/zabbix_agent/etc/zabbix_agentd.conf
grep -Pv '(^#|^$)' /usr/local/zabbix_agent/etc/zabbix_agentd.conf


#JZ_CLient_Server 3.0 client

groupadd zabbix
useradd -g zabbix zabbix
tar zxvf zabbix-3.0.1.tar.gz
cd zabbix-3.0.1
./configure --prefix=/usr/local/zabbix_agent3.0 --enable-agent
make && make install
ln -s /usr/local/zabbix_agent3.0 /usr/local/zabbix_agent
cp misc/init.d/tru64/zabbix_agentd /etc/rc.d/init.d/
chmod 755 /etc/rc.d/init.d/zabbix_agentd
ln -s /usr/local/zabbix_agent/sbin/zabbix_agentd /usr/local/sbin/

hostname=`ifconfig | grep eth0 -A 1 | grep -Po '(?<=addr:).*(?= Bcast)'`
sed -i 's/Server=127.0.0.1/Server=10.19.160.14/' /usr/local/zabbix_agent/etc/zabbix_agentd.conf
sed -i 's/ServerActive=127.0.0.1/ServerActive=10.19.160.14/' /usr/local/zabbix_agent/etc/zabbix_agentd.conf
sed -i "s/Hostname=Zabbix server/Hostname=${hostname}/" /usr/local/zabbix_agent/etc/zabbix_agentd.conf
grep -Pv '(^#|^$)' /usr/local/zabbix_agent/etc/zabbix_agentd.conf


mkdir /usr/local/zabbix_agent/scripts

cat >> /usr/local/zabbix_agent/etc/zabbix_agentd.conf << EOF
#Nginx Status
UserParameter=Nginx.Accepted-Connections,/usr/local/zabbix_agent/scripts/nginx_status.sh accepted
UserParameter=Nginx.Active-Connections,/usr/local/zabbix_agent/scripts/nginx_status.sh active
UserParameter=Nginx.Handled-Connections,/usr/local/zabbix_agent/scripts/nginx_status.sh handled
UserParameter=Nginx.Reading-Connections,/usr/local/zabbix_agent/scripts/nginx_status.sh reading
UserParameter=Nginx.Total-Requests,/usr/local/zabbix_agent/scripts/nginx_status.sh requests
UserParameter=Nginx.Waiting-Connections,/usr/local/zabbix_agent/scripts/nginx_status.sh waiting
UserParameter=Nginx.Writting-Connections,/usr/local/zabbix_agent/scripts/nginx_status.sh writing

#lld Disk IO
UserParameter=mount_disk_discovery,/bin/bash /usr/local/zabbix_agent/scripts/mount_disk_discovery.sh mount_disk_discovery

#PHP-FPM
UserParameter=php-fpm.status[*],/usr/local/zabbix_agent/scripts/php-fpm_status.sh \$1

#TCP_stat
UserParameter=tcp[*],/usr/local/zabbix_agent/scripts/tcp_stat.sh \$1

#### LLD Port And Service Discovery
UserParameter=jz.port.discovery,/usr/bin/python /usr/local/zabbix_agent/scripts/port_and_service_discovery.py --port
UserParameter=jz.serv.discovery,/usr/bin/python /usr/local/zabbix_agent/scripts/port_and_service_discovery.py --serv

#### Opened File
UserParameter=jz.opened.files,awk '{print \$1-\$2}' < /proc/sys/fs/file-nr

EOF

grep -Pv '(^#|^$)' /usr/local/zabbix_agent/etc/zabbix_agentd.conf





