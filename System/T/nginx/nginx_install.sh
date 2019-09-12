#!/bin/bash
NGINX_URL=https://nginx.org/download/nginx-1.16.0.tar.gz
NGINX_USER=www

#base package
apt install libpcre3 libpcre3-dev  openssl libssl-dev zlib1g-dev

wget ${NGINX_URL}

tar zxvf nginx-1.16.0.tar.gz
cd nginx-1.16.0
./configure --prefix=/usr/local/nginx-1.16 --user=${NGINX_USER} --group=${NGINX_USER} --with-http_ssl_module --with-http_flv_module --with-http_gzip_static_module --with-http_stub_status_module --with-stream

make
make install

mkdir /usr/local/nginx/conf/vhost -p
mkdir /data/logs/nginx -p
mkdir /data/nginx/error_page -p
chown ${NGINX_USER}.${NGINX_USER} /data/logs/nginx
chown ${NGINX_USER}.${NGINX_USER} /data/nginx -R



mv /usr/local/nginx/conf/nginx.conf{,_}

cat >> /usr/local/nginx/conf/nginx.conf << EOF
user  ${NGINX_USER};
worker_processes  4;
error_log  /data/logs/nginx/nginx_error.log  error;
pid 	/usr/local/nginx/logs/nginx.pid;

worker_rlimit_nofile 65535;

events {
  use epoll;
  worker_connections  65535;
}

http {
  include       mime.types;
  default_type  application/octet-stream;

    #log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
    #                  '\$status \$body_bytes_sent "\$http_referer" '
    #                  '"\$http_user_agent" "\$http_x_forwarded_for"';

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
  types_hash_max_size 2048;
  
  server_tokens off;

  #fastcgi_connect_timeout 300;
  #fastcgi_send_timeout 300;
  #fastcgi_read_timeout 300;
  #fastcgi_buffer_size 64k;
  #fastcgi_buffers 4 64k;
  #fastcgi_busy_buffers_size 128k;
  #fastcgi_temp_file_write_size 128k;
  
  proxy_connect_timeout   60;   
  proxy_send_timeout      60;   
  proxy_read_timeout      60;   
  proxy_buffer_size       64k;   
  proxy_buffers           4 64k;   
  proxy_busy_buffers_size 128k;   
  proxy_temp_file_write_size 128k; 
# proxy_cache_path /data/tmp/nginx/cache/one  levels=1:2   keys_zone=one:10m max_size=2g;
# proxy_cache_key "";

  gzip  on; 
  gzip_min_length  1k;
  gzip_buffers     4 16k;
  gzip_http_version 1.0;
  gzip_comp_level 2;
  gzip_types       text/plain application/x-javascript text/css application/xml;
  gzip_vary on;
  
 
  log_format  access  '\$remote_addr \$upstream_addr - \$remote_user [\$time_local] "\$request" '
    '\$status \$body_bytes_sent "\$http_referer"  \$scheme://\$host\$request_uri'
    '"\$http_user_agent" \$http_x_forwarded_for';	

# server_names_hash_bucket_size 64;
# server_name_in_redirect off;


  #ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
  #ssl_prefer_server_ciphers on;


  #access_log /var/log/nginx/access.log;
  #error_log /var/log/nginx/error.log;
  #upstream tomcms {
  #  server 127.0.0.1:8080;
  #  #server 127.0.0.1:8080 weight=10 max_fails=2 fail_timeout=30s;
  #}

  include vhost/*.conf;
}
EOF

cat > /usr/local/nginx/conf/vhost/example.conf << EOF
server 
{
    listen 80;
    server_name 127.0.0.1;
    charset utf-8;
    
    #root /data/htdocs/wwwroot;
    
    if (\$http_user_agent ~ "Sogou web spider|JikeSpider|Indy Library|Alexa Toolbar|bingbot|AskTbFXTV|AhrefsBot|CoolpadWebkit|Microsoft URL Control|YYSpider|DigExt|YisouSpider|MJ12bot|heritrix|EasouSpider|Ezooms|curl") {
    return 403;
  }

    #if (\$http_referer ~* "(xx.xx.xx|xx.xx.xx)"){
    #    return 403;
    #}

    #location ~ ^/cps/ {
#    location / {
#        index index.jsp;
#
#        #limit_rate_after 5m;
#        #limit_rate  200k;
#
#        proxy_set_header  Host \$host;
#        proxy_set_header  X-Real-IP  \$remote_addr;
#        proxy_set_header  X-Forwarded-For \$proxy_add_x_forwarded_for;
##       proxy_set_header X-Forwarded-For \$remote_addr;
#        #proxy_set_header Accept-Encoding "none";  
#        proxy_pass http://tomcms;
#    }
#
#    location ~ ^/(WEB-INF)/ {
#        deny all;
#    }

    error_page 502 503 504 /502.html;
    location = /502.html {
        root  /data/nginx/error_page;
    }
    error_page 400 401 403 404 /404.html;
    location = /404.html {
        root  /data/nginx/error_page;
    }
    access_log  /data/logs/nginx/example.tom.com.access.log access;
}
EOF

cat > /data/nginx/error_page/502.html << EOF
500
EOF
cat > /data/nginx/error_page/404.html << EOF
404
EOF
chown ${NGINX_USER}.${NGINX_USER} /data/nginx -R

##################Location 优先级###########################
location表达式类型
~ 表示执行一个正则匹配，区分大小写
~* 表示执行一个正则匹配，不区分大小写
^~ 表示普通字符匹配。使用前缀匹配。如果匹配成功，则不再匹配其他location。
= 进行普通字符精确匹配。也就是完全匹配。
@ "@" 定义一个命名的 location，使用在内部定向时，例如 error_page, try_files

location优先级说明
在nginx的location和配置中location的顺序没有太大关系。正location表达式的类型有关。相同类型的表达式，字符串长的会优先匹配。
以下是按优先级排列说明：
第一优先级：等号类型（=）的优先级最高。一旦匹配成功，则不再查找其他匹配项。
第二优先级：^~类型表达式。一旦匹配成功，则不再查找其他匹配项。
第三优先级：正则表达式类型（~ ~*）的优先级次之。如果有多个location的正则能匹配的话，则使用正则表达式最长的那个。
第四优先级：常规字符串匹配类型。按前缀匹配。

location优先级示例
配置项如下:
location = / {
# 仅仅匹配请求 /
[ configuration A ]
}
location / {
# 匹配所有以 / 开头的请求。但是如果有更长的同类型的表达式，则选择更长的表达式。如果有正则表达式可以匹配，则
# 优先匹配正则表达式。
[ configuration B ]
}
location /documents/ {
# 匹配所有以 /documents/ 开头的请求。但是如果有更长的同类型的表达式，则选择更长的表达式。
#如果有正则表达式可以匹配，则优先匹配正则表达式。
[ configuration C ]
}
location ^~ /images/ {
# 匹配所有以 /images/ 开头的表达式，如果匹配成功，则停止匹配查找。所以，即便有符合的正则表达式location，也
# 不会被使用
[ configuration D ]
}
location ~* \.(gif|jpg|jpeg)$ {
# 匹配所有以 gif jpg jpeg结尾的请求。但是 以 /images/开头的请求，将使用 Configuration D
[ configuration E ]
}

请求匹配示例
/ -> configuration A
/index.html -> configuration B
/documents/document.html -> configuration C
/images/1.gif -> configuration D
/documents/1.jpg -> configuration E

注意，以上的匹配和在配置文件中定义的顺序无关。
################### PHP7 ####################
apt-get install  libxml2-dev libssl-dev libbz2-dev libjpeg-dev libpng-dev libxpm-dev libfreetype6-dev libgmp-dev libgmp3-dev libmcrypt-dev libmysqlclient15-dev libpspell-dev librecode-dev libcurl4-gnutls-dev libgmp-dev libgmp3-dev librecode-dev libpspell-dev  libmysqlclient15-dev  libmcrypt-dev  libreadline-dev libtidy-dev libxslt1-dev  -y

tar zxvf php-7.3.6.tar.gz
cd php-7.3.6/

./configure \
--prefix=/usr/local/php \
--with-config-file-path=/usr/local/php/etc \
--enable-fpm \
--with-fpm-user=www  \
--with-fpm-group=www \
--enable-inline-optimization \
--disable-debug \
--disable-rpath \
--enable-shared  \
--enable-soap \
--with-libxml-dir \
--with-xmlrpc \
--with-openssl \
--with-mcrypt \
--with-mhash \
--with-pcre-regex \
--with-sqlite3 \
--with-zlib \
--enable-bcmath \
--with-iconv \
--with-bz2 \
--enable-calendar \
--with-curl \
--with-cdb \
--enable-dom \
--enable-pcntl \
--enable-exif \
--enable-fileinfo \
--enable-filter \
--with-pcre-dir \
--enable-ftp \
--with-gd \
--with-openssl-dir \
--with-jpeg-dir \
--with-png-dir \
--with-zlib-dir  \
--with-freetype-dir \
--enable-gd-native-ttf \
--enable-gd-jis-conv \
--with-gettext \
--with-gmp \
--with-mhash \
--enable-json \
--enable-mbstring \
--enable-mbregex \
--enable-mbregex-backtrack \
--with-libmbfl \
--with-onig \
--enable-pdo \
--with-mysqli=mysqlnd \
--with-pdo-mysql=mysqlnd \
--with-zlib-dir \
--with-pdo-sqlite \
--with-readline \
--enable-session \
--enable-shmop \
--enable-simplexml \
--enable-sockets  \
--enable-sysvmsg \
--enable-sysvsem \
--enable-sysvshm \
--enable-wddx \
--with-libxml-dir \
--with-xsl \
--enable-zip \
--enable-mysqlnd-compression-support \
--with-pear \
--enable-opcache


make ZEND_EXTRA_LIBS='-liconv'
make install


cp php.ini-production /usr/local/php/etc/php.ini
cp sapi/fpm//init.d.php-fpm /etc/rc.d/init.d/php7-fpm
chmod 755 /etc/rc.d/init.d/php7-fpm

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

##memcache memecached
apt-get install  libmemcached-dev zlib1g-dev
/usr/local/php/bin/pecl install memcached

cd /usr/local/src/
git clone https://github.com/websupport-sk/pecl-memcache
cd pecl-memcache/
/usr/local/php/bin/phpize 
./configure --with-php-config=/usr/local/php/bin/php-config
make
make install

#redis
wget https://github.com/edtechd/phpredis/archive/php7.zip
unzip php7.zip 
cd phpredis-php7/
/usr/local/php/bin/phpize 
./configure --with-php-config=/usr/local/php/bin/php-config
make
make install

#Opcache
[opcache]
opcache.enable=1
opcache.enable_cli=1
opcache.memory_consumption=128
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=10000
opcache.validate_timestamps=0
opcache.file_cache=/tmp

extension_dir = "/usr/local/php/lib/php/extensions/no-debug-non-zts-20180731/"
extension = "memcache.so"
extension = "memcached.so"
extension = "redis.so"
zend_extension = "opcache.so"


