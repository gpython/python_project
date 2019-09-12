yum install GeoIP-devel GeoIP openssl openssl-devel

tar zxvf pcre-8.36.tar.gz 
cd pcre-8.36
./configure 
make
make install

tar zxvf nginx-1.9.2.tar.gz 
tar zxvf ngx_cache_purge-2.3.tar.gz 
cd ../nginx-1.9.2
./configure --prefix=/usr/local/nginx --error-log-path=/data/logs/nginx/error.log --http-log-path=/data/logs/nginx/access.log --user=www --group=www --with-http_ssl_module --with-http_flv_module --with-http_gzip_static_module --with-http_stub_status_module --http-client-body-temp-path=/data/tmp/nginx/client --http-proxy-temp-path=/data/tmp/nginx/proxy --http-fastcgi-temp-path=/data/tmp/nginx/fcgi --add-module=../ngx_cache_purge-2.3 --with-http_geoip_module

make && make install

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

mkdir /usr/local/nginx/conf/vhost -p

vim /usr/local/nginx/conf/vhost/ssl.conf
server {
  listen 80;
  server_name zabbix.gg.com;
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

  access_log /data/logs/nginx/ssl.access.log access;
}

SSL双向证书生成
cd /usr/local/nginx/
mkdir ca

cd ca

mkdir newcerts private conf server
newcerts 子目录将用于存放 CA 签署过的数字证书(证书备份目录)
private 用于存放 CA 的私钥
conf 目录用于存放一些简化参数用的配置文件
server 存放服务器证书文件。

创建openssl配置文件
vim conf/openssl.conf
[ ca ]
default_ca      = foo                                     # The default ca section
[ foo ]
dir             = /usr/local/nginx/ca                     # top dir
database        = /usr/local/nginx/ca/index.txt           # index file.
new_certs_dir   = /usr/local/nginx/ca/newcerts            # new certs dir
certificate     = /usr/local/nginx/ca/private/ca.crt      # The CA cert
serial          = /usr/local/nginx/ca/serial              # serial no file
private_key     = /usr/local/nginx/ca/private/ca.key      # CA private key
RANDFILE        = /usr/local/nginx/ca/private/.rand       # random number file
default_days    = 3650                                    # how long to certify for
default_crl_days= 30                                      # how long before next CRL
default_md      = sha1                                    # message digest method to use
unique_subject  = no                                      # Set to ‘no’ to allow creation of
                                                          # several ctificates with same subject.
policy          = policy_any                              # default policy
[ policy_any ]
countryName             = match
stateOrProvinceName     = match
organizationName        = match
organizationalUnitName  = match
localityName            = optional
commonName              = supplied
emailAddress            = optional


生成CA私钥 key 文件 默认1024 可以指定2048
openssl genrsa -out private/ca.key

CSR文件必须在申请和购买SSL证书之前创建
证书申请者只要把CSR文件提交给证书颁发机构后，
证书颁发机构使用其根证书私钥签名就生成了证书公钥文件，也就是颁发给用户的证书

在申请SSL证书之前，您必须先生成证书私钥和证书请求文件(CSR)，CSR是您的公钥证书原始文件，包含了您的服务器信息和您的单位信息，需要提交给 WoSign 。而私钥则保存在您的服务器上，不得对外泄露，当然也不用提交给 WoSign，请妥善保管和备份您的私钥。一个完整的数字证书由一个私钥和一个对应的公钥(证书)组成。在生成CSR文件时会同时生成私钥文件，微软IIS在生成CSR时已经自动生成私钥和存放在安全地方。

生成CSR文件时，一般需要输入以下信息：
Organization Name(O)：申请单位名称法定名称，可以是中文或英文
Organization Unit(OU)：申请单位的所在部门，可以是中文或英文
Country Code(C)：申请单位所属国家，只能是两个字母的国家码，如中国只能是：CN
State or Province(S)：申请单位所在省名或州名，可以是中文或英文
Locality(L)：申请单位所在城市名，可以是中文或英文
Common Name(CN)：申请SSL证书的具体网站域名，支持中文域名(中文.com或中文.cn)

证书续费对CSR要求：为了证书密钥安全，SSL证书续费时，一定要重新生成CSR和私钥。

生成证书请求csr文件
openssl req -new -key private/ca.key -out private/ca.csr -subj /C=CN/ST=Beijing/L=Beijing/O=gco/OU=devops/CN=*gg.com/emailAddress=root@gg.com

生成凭证 crt 文件
openssl x509 -req -days 3655 -in private/ca.csr -signkey private/ca.key -out private/ca.crt

key 设置起始序列号
echo FACE > serial
创建 CA 键库
touch index.txt

为 “用户证书” 的移除创建一个证书撤销列表
openssl ca -gencrl -out private/ca.crl -crldays 7 -config conf/openssl.conf

服务器证书的生成 创建一个 key
openssl genrsa -out server/server.key  

为server key 创建一个证书签名请求 csr 文件
openssl req -new -key server/server.key -out server/server.csr -subj /C=CN/ST=Beijing/L=Beijing/O=gco/OU=devops/CN=*gg.com/emailAddress=root@gg.com

使用私有的 CA key 为刚才的server key 签名
openssl ca -in server/server.csr -cert private/ca.crt -keyfile private/ca.key -out server/server.crt -config conf/openssl.conf


客户端证书的生成
创建存放客户 key 的目录 users

为用户创建key 默认长度1024
openssl genrsa -des3 -out users/client.key
输入 pass phrase 当前 key 的口令，以防止本密钥泄漏后被人盗用

为client key 创建一个证书签名请求 csr 文件 输入客户端密码
openssl req -new -key users/client.key -out users/client.csr -subj /C=CN/ST=Beijing/L=Beijing/O=gco/OU=devops/CN=*gg.com/emailAddress=root@gg.com

使用私有的 CA key 为刚才的 key 签名
openssl ca -in users/client.csr -cert private/ca.crt -keyfile private/ca.key -out users/client.crt -config conf/openssl.conf


将客户端证书转换为大多数浏览器都能识别的 PKCS12 文件
openssl pkcs12 -export -clcerts -in users/client.crt -inkey users/client.key -out users/client.p12
输入 client.key 的 pass phrase
输入 Export Password，这个是客户端证书的保护密码 在客户端安装证书的时候需要输入这个密码 client.p12 专用密码


Nginx 配置

server {
  listen 443 ssl;
  server_name ssl.gg.com gg.com;
  index index.html index.php index.html;
  root /data/htdocs/zabbix;

  ssl on;
  ssl_certificate         /usr/local/nginx/ca/server/server.crt;
  ssl_certificate_key     /usr/local/nginx/ca/server/server.key;
  ssl_client_certificate  /usr/local/nginx/ca/private/ca.crt;
  ssl_session_timeout 5m;
  ssl_verify_client on; #开户客户端证书验证
  ssl_protocols SSLv2 SSLv3 TLSv1;
  ssl_ciphers ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP;
  ssl_prefer_server_ciphers   on;
  charset utf-8;
 
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
  access_log /data/logs/nginx/ssl.access.log access;
}


浏览器端配置
https 双向验证需要客户端安装证书
windows os 下拿到生成的证书 client.p12，直接双击它，进入 “证书导入向导”：
一步一步下一步，最后直接点击 “完成” 按钮完成证书导入。
重启谷歌浏览器
