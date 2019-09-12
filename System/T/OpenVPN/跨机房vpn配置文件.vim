机房A 
外网地址 eth1 109
内网网段 eth0 10.19.0.0 / 10.10.0.0
VPN 客户端网段 172.16.234.0

server.conf
########################################################
;local 109             #OpenVPN服务器的外网IP
local 0.0.0.0             #OpenVPN服务器的外网IP
port 94
proto tcp
dev tun
;dev tap0

ca    /etc/openvpn/ca.crt       #服务端证书位置 
cert  /etc/openvpn/server.crt
key   /etc/openvpn/server.key   # This file should be kept secret
dh    /etc/openvpn/dh.pem
crl-verify /etc/openvpn/crl.pem

server 172.16.234.0 255.255.255.0   #服务器和远端电脑用此网段通信 选择一个没有使用的网段 以防冲突
;server-bridge 172.16.234.1 255.255.255.0 172.16.234.10 172.16.234.30
ifconfig-pool-persist /etc/openvpn/ipp.txt

push "route 10.10.0.0 255.255.0.0"   #将服务器内网网段路由推送到远端客户端电脑
push "route 10.19.0.0 255.255.0.0"   #将服务器内网网段路由推送到远端客户端电脑
push "route 10.13.0.0 255.255.0.0"   #将服务器内网网段路由推送到远端客户端电脑
;route 10.8.0.0 255.255.255.0
route 10.13.0.0 255.255.0.0
client-to-client
client-config-dir ccd
client-config-dir /etc/openvpn/ccd

keepalive 10 120
comp-lzo
max-clients 100
persist-key
persist-tun
status    /data/logs/openvpn-status.log
log-append /data/logs/openvpn.log
verb 3
################################################
iptables -t nat -A POSTROUTING -s 172.16.234.0/24 -o eth0 -j MASQUERADE
###############################################
 route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         10.19.0.1       0.0.0.0         UG    0      0        0 eth0
10.13.0.0       172.16.234.2    255.255.0.0     UG    0      0        0 tun0
10.19.0.0       0.0.0.0         255.255.0.0     U     0      0        0 eth0
172.16.234.0    172.16.234.2    255.255.255.0   UG    0      0        0 tun0
172.16.234.2    0.0.0.0         255.255.255.255 UH    0      0        0 tun0







机房B 
外网地址 eth1 42
内网网段 eth0 10.13.0.0
client.ovpn 
#########################################
client
dev tun
proto tcp
#script-security 3 system
#auth-user-pass-verify /etc/openvpn/checkpsw.sh via-env
#auth-user-pass psw-file
remote 109 94 #OpenVPN服务器的公网IP
resolv-retry infinite
nobind
persist-key
persist-tun
ca ca.crt
cert IDCGZ@ju.com.crt
key  IDCGZ@ju.com.key
comp-lzo
verb 3
askpass passwd.txt
################################################

checkpsw.sh 
#!/bin/sh
###########################################################
# checkpsw.sh (C) 2004 Mathias Sundman <mathias@openvpn.se>
#
# This script will authenticate OpenVPN users against
# a plain text file. The passfile should simply contain
# one row per user with the username first followed by
# one or more space(s) or tab(s) and then the password.
PASSFILE="/etc/openvpn/psw-file"
LOG_FILE="/var/log/openvpn-password.log"
TIME_STAMP=`date "+%Y-%m-%d %T"`
###########################################################
if [ ! -r "${PASSFILE}" ]; then
echo "${TIME_STAMP}: Could not open password file \"${PASSFILE}\" for reading." >> ${LOG_FILE}
exit 1
fi
CORRECT_PASSWORD=`awk '!/^;/&&!/^#/&&$1=="'${username}'"{print $2;exit}' ${PASSFILE}`
if [ "${CORRECT_PASSWORD}" = "" ]; then
echo "${TIME_STAMP}: User does not exist: username=\"${username}\", password=\"${password}\"." >> ${LOG_FILE}
exit 1
fi
if [ "${password}" = "${CORRECT_PASSWORD}" ]; then
echo "${TIME_STAMP}: Successful authentication: username=\"${username}\"." >> ${LOG_FILE}
exit 0
fi
echo "${TIME_STAMP}: Incorrect password: username=\"${username}\", password=\"${password}\"." >> ${LOG_FILE}
exit 1
 
#当然了,还要建议个记录用户名和密码的文件,脚本标记的文件是psw-file,前面是用户名.空格后是密码
#############################################################
密码文件
psw-file
Pas4wd

iptables -t nat -A POSTROUTING -s 172.16.234.0/24 -o eth0 -j MASQUERADE

###############################################################
route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         10.13.0.1       0.0.0.0         UG    0      0        0 eth0
10.10.0.0       255.255.255.0   255.255.0.0     UG    0      0        0 tun0
10.13.0.0       0.0.0.0         255.255.0.0     U     0      0        0 eth0
10.19.0.0       255.255.255.0   255.255.0.0     UG    0      0        0 tun0
172.16.234.0    255.255.255.0   255.255.255.0   UG    0      0        0 tun0
255.255.255.0   0.0.0.0         255.255.255.255 UH    0      0        0 tun0
