OpenVPN 服务端简介
CentOS6.5 X64
eth0: 192.168.47.30
eth1: 10.10.10.30

软件存放和编译目录/root/openvpn

开启IP转发功能
sed -i 's/net.ipv4.ip_forward = 0/net.ipv4.ip_forward = 1/' /etc/sysctl.conf
sysctl -p

安装依赖包
yum install -y openssl openssl-devel lzo lzo-devel pam pam-devel automake pkgconfig

wget http://build.openvpn.net/downloads/releases/openvpn-2.3.10.tar.gz
wget http://www.oberhumer.com/opensource/lzo/download/lzo-2.09.tar.gz
wget https://github.com/OpenVPN/easy-rsa/archive/master.zip
mv master easy-rsa_master.zip


编译安装openvpn和lzo
tar zxvf lzo-2.09.tar.gz
cd lzo-2.09
./configure --prefix=/usr/local
make && make install
ldconfig -v | grep lzo

tar zxvf openvpn-2.3.10.tar.gz
cd openvpn-2.3.10
./configure --prefix=/usr/local/openvpn
make && make install
mkdir /etc/openvpn

使用easy-rsa包来制作证书
unzip easy-rsa_master.zip 
mv easy-rsa-master /etc/openvpn/easy-rsa
cd /etc/openvpn/easy-rsa/easyrsa3
mv vars.example vars

适当修改vars文件
vim vars
set_var EASYRSA_REQ_COUNTRY	  "CN"
set_var EASYRSA_REQ_PROVINCE	"Beijing"
set_var EASYRSA_REQ_CITY	    "Beijing"
set_var EASYRSA_REQ_ORG	      "Ju Co"
set_var EASYRSA_REQ_EMAIL	    "z@ju.com"
set_var EASYRSA_REQ_OU		    "Ju"

初始化目录
./easyrsa init-pki

创建根证书 输入根证书密码并输入名称
./easyrsa build-ca
  输入密码PEM pass phrase:
  输入[Easy-RSA CA]: top_ju / hk_ju
    生成文件 pki/ca.crt

创建服务端证书 不要和根证书同名  根证书名(top_ju) 服务端证书名(top_ju_server)
./easyrsa gen-req server nopass
  输入[server]:top_ju_server / hk_ju_server


签约服务端证书 输入根证书密码
./easyrsa sign server server
  输入Confirm request details: yes
  输入根证书密码Enter pass phrase for /etc/openvpn/easy-rsa/easyrsa3/pki/private/ca.key:

创建Diffie-Hellman 确保key穿越不安全网络命令
./easyrsa gen-dh

将生成的ca.crt server.key server.crt dh.pem 拷贝到/etc/openvpn/
cp pki/ca.crt pki/private/server.key pki/issued/server.crt pki/dh.pem /etc/openvpn/

服务端配置完成 配置客户端
客户端
mkdir /root/openvpn_client
cp easy-rsa_master.zip /root/openvpn_client/
cd /root/openvpn_client/
unzip easy-rsa_master.zip
mv easy-rsa-master easy-rsa
cd easy-rsa/easyrsa3/
cp /etc/openvpn/easy-rsa/easyrsa3/vars ./

客户端初始化
./easyrsa init-pki


echo  | md5sum | tr '012abc' '*&^@!#%' | cut -c 1-10
制作客户端key和证书 制作完后再服务端签约
制作过程需要为客户设定密码 Common Name相同即可
./easyrsa gen-req 30_client_01
  创建客户端认证密码Enter PEM pass phrase:
  确认客户端认证密码Verifying - Enter PEM pass phrase:
  Common Name (eg: your user, host, or server name) [30_client_01]:30_client_01

将客户端在服务器端签约
cd /etc/openvpn/easy-rsa/easyrsa3/
./easyrsa import-req /root/openvpn_client/easy-rsa/easyrsa3/pki/reqs/30_client_01.req 30_client_01
./easyrsa sign client 30_client_01
  确认Confirm request details: yes
  输入ca密码Enter pass phrase for /etc/openvpn/easy-rsa/easyrsa3/pki/private/ca.key:

保存客户端证书
mkdir /root/openvpn_client/30_client_01
cp /etc/openvpn/easy-rsa/easyrsa3/pki/ca.crt /root/openvpn_client/30_client_01/
cp /etc/openvpn/easy-rsa/easyrsa3/pki/issued/30_client_01.crt /root/openvpn_client/30_client_01/
cp /root/openvpn_client/easy-rsa/easyrsa3/pki/private/30_client_01.key /root/openvpn_client/30_client_01/

创建服务端配置文件 server.conf
cp /root/openvpn/openvpn-2.3.10/sample/sample-config-files/server.conf /etc/openvpn
mv /etc/openvpn/server.conf{,_`date +"%F"`}

vim /etc/openvpn/server.conf
local 192.168.47.30             #OpenVPN服务器的外网IP
port 9411
proto tcp
dev tun
ca    /etc/openvpn/ca.crt       #服务端证书位置 
cert  /etc/openvpn/server.crt
key   /etc/openvpn/server.key   # This file should be kept secret
dh    /etc/openvpn/dh.pem
server 10.8.0.0 255.255.255.0   #服务器和远端电脑用此网段通信 选择一个没有使用的网段 以防冲突
ifconfig-pool-persist /etc/openvpn/ipp.txt
push "route 10.10.10.0 255.255.255.0"   #将服务器内网网段路由推送到远端客户端电脑
;route 10.8.0.0 255.255.255.0
keepalive 10 120
comp-lzo
max-clients 100
persist-key
persist-tun
status    /data/logs/openvpn-status.log
log-append    /data/logs/openvpn.log                #日志选项，将日志追加到指定的文件中
verb 3

添加服务端地址转换 远端客户电脑可直接连接服务端内网网段的服务器(服务端相当于路由器)
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth1 -j MASQUERADE

启动OpenVPN的服务
/usr/local/openvpn/sbin/openvpn --config /etc/openvpn/server.conf &
/usr/local/openvpn/sbin/openvpn --daemon --config /etc/openvpn/server.conf

windows客户端版本和服务端相同
客户端配置文件
vim client.ovpn
client
dev tun
proto tcp
remote 192.168.47.30 9411 #OpenVPN服务器的公网IP
resolv-retry infinite
nobind
persist-key
persist-tun
ca ca.crt 
cert 30_client_01.crt
key  30_client_01.key
comp-lzo
verb 3


吊销客户端
cd /etc/openvpn/easy-rsa/easyrsa3/
./easyrsa revoke 30_client_01


双网卡设置
eth0 外网
eth1 内网
调试时开启22端口

设置iptables
#!/bin/bash
#modprobe ip_conntrack_ftp
iptables -F
iptables -X
iptables -Z
iptables -t nat -F
iptables -t nat -X
iptables -t nat -Z
iptables -P INPUT DROP
iptables -A INPUT -p tcp -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p udp --sport 53 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -p udp --sport 123 -m state --state ESTABLISHED -j ACCEPT
#内网IP
iptables -A INPUT -i eth1 -j ACCEPT
iptables -A INPUT -p ICMP -j ACCEPT
iptables -A INPUT -i lo  -j ACCEPT
#外网80端口
iptables -A INPUT -p tcp -m tcp -i eth0 --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -m tcp -i eth0 --dport 22 -j ACCEPT
#openvpn端口
iptables -A INPUT -p udp -m udp -i eth0 --dport 9411 -j ACCEPT
iptables -A INPUT -p tcp -m tcp -i eth0 --dport 9411 -j ACCEPT
iptables -A INPUT -i tun+ -j ACCEPT
#信任的外网IP
#iptables -A INPUT -p tcp -m tcp -s 8.8.8.8 -j ACCEPT
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth1 -j MASQUERADE

####
iptables -t nat -A POSTROUTING -s 172.16.234.0/24 -o eth0 -j MASQUERADE







