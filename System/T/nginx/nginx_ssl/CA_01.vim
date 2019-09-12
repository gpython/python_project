Nginx SSL 双向认证 



1 easy-rsa证书生成工具安装
Nginx目录
mkdir /usr/local/nginx/ssl/ca -p
mkdir /usr/local/nginx/ssl/client -p
mkdir /usr/local/nginx/ssl/crl -p
mkdir /usr/local/nginx/ssl/server -p


mkdir /root/CA
cd /root/CA
git clone https://github.com/OpenVPN/easy-rsa.git
cd easy-rsa/easyrsa3

cp vars.example vars
vim vars
取消掉以下行的注释，并修改引号中的内容
set_var EASYRSA_REQ_COUNTRY   "CN"
set_var EASYRSA_REQ_PROVINCE  "Beijing"
set_var EASYRSA_REQ_CITY      "Beijing"
set_var EASYRSA_REQ_ORG       "Ju Co"
set_var EASYRSA_REQ_EMAIL     "z@ju.com"
set_var EASYRSA_REQ_OU        "DevOps"

2 初始化自签名证书环境
./easyrsa init-pki

生成pki/private私钥 pki/reqs 证书请求 目录

3 生成根证书
./easyrsa build-ca

生成pki/private/ca.key CA私钥
输入私钥密码
Enter PEM pass phrase:
Verifying - Enter PEM pass phrase:

"输入根证书的网址（是否真实存在无所谓）
Common Name (eg: your user, host, or server name) [Easy-RSA CA]:ca.g.com
根证书才可以给服务器证书 和 客户端签名 

4 生成服务器证书
"zabbix.g.com" 证书的文件名，"nopass"表示不需要密码
./easyrsa gen-req zabbix.g.com nopass

"生成key pki/private/zabbix.g.com.key
"生成req pki/reqs/zabbix.g.com.req

"必须和要发布的服务器域名相同 DNS可解析的域名(host文件指向的也可以)
"Common Name (eg: your user, host, or server name) [zabbix.g.com]:

5.为服务器证书签名
./easyrsa sign server zabbix.g.com

生成crt pki/issued/zabbix.g.com.crt

确认
Confirm request details: yes
输入根证书密码

至此 nginx服务端ssl 已配置完成 
访问https会有大叉 可将ca.crt导入到指定位置 位置CA认证的制定位置
mkdir /usr/local/nginx/ssl/server -pv
cp pki/private/zabbix.g.com.key /usr/local/nginx/ssl/server 
cp pki/issued/zabbix.g.com.crt  /usr/local/nginx/ssl/server 

nginx配置增加
  ssl on;
  ssl_certificate     /usr/local/nginx/ssl/server/zabbix.g.com.crt;
  ssl_certificate_key /usr/local/nginx/ssl/server/zabbix.g.com.key;
  # GitLab needs backwards compatible ciphers to retain compatibility with Java IDEs
  ssl_ciphers "ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:ECDHE-RSA-DES-CBC3-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!MD5:!PSK:!RC4";
  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_prefer_server_ciphers on;
  ssl_session_cache shared:SSL:10m;
  ssl_session_timeout 5m;

双向认证
生成客户端证书
./easyrsa gen-req client_01 nopass

"生成客户端私钥 pki/private/client_01.key
"生成客户端req  pki/reqs/client_01.req

签署客户端请求
./easyrsa sign client client_01

"生成客户端  pki/issued/client_01.crt


生成客户浏览器可以导入的P12文件
./easyrsa export-p12 client_01
输入密码

生成p12文件  pki/private/client_01.p12



吊销客户端认证
./easyrsa revoke client_01

更新CRL数据库
./easyrsa gen-crl

CRL文件  pki/crl.pem
cp pki/crl.pem /usr/local/nginx/ssl/crl/


cp pki/private/zabbix.g.com.key /usr/local/nginx/ssl/server 
cp pki/issued/zabbix.g.com.crt  /usr/local/nginx/ssl/server 
cp pki/ca.crt  /usr/local/nginx/ssl/ca


nginx双向认证配置
  ssl on;
  ssl_certificate        /usr/local/nginx/ssl/server/zabbix.g.com.crt;
  ssl_certificate_key    /usr/local/nginx/ssl/server/zabbix.g.com.key;
  ssl_client_certificate /usr/local/nginx/ssl/ca/ca.crt;
  ssl_crl                /usr/local/nginx/ssl/crl/crl.pem;

  ssl_session_timeout    5m;
  ssl_verify_client      on; #开户客户端证书验证

  ssl_protocols          SSLv2 SSLv3 TLSv1;
  ssl_ciphers            ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP;
  ssl_prefer_server_ciphers   on;

客户端导入client_01.p12 输入密码










