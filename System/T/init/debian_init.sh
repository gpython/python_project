#!/bin/bash

#系统更新
mv /etc/apt/sources.list{,_}

cat > /etc/apt/sources.list << EOF
deb http://mirrors.tuna.tsinghua.edu.cn/debian/ stretch main
deb-src http://mirrors.tuna.tsinghua.edu.cn/debian/ stretch main

deb http://security.debian.org/debian-security stretch/updates main
deb-src http://security.debian.org/debian-security stretch/updates main

# stretch-updates, previously known as 'volatile'
deb http://mirrors.tuna.tsinghua.edu.cn/debian/ stretch-updates main
deb-src http://mirrors.tuna.tsinghua.edu.cn/debian/ stretch-updates main
EOF

#同步 /etc/apt/sources.list 和 /etc/apt/sources.list.d 中列出的源的索引
apt-get update 
#升级已安装的所有软件包，升级之后的版本就是本地索引里的
apt-get upgrade 

#安装系统必要的库
apt install -y build-essential gcc g++ libtool automake automake net-tools vim tree unzip  sysstat openssl ntpdate iptraf iptraf-ng curl dnsutils xfsprogs
#apt install rsync rdate bzip2 xinetd flex bison sysstat nmap rpcbind make psmisc lrzsz gdb libxml2-dev libncurses5-dev \
#automake libtool dnsutils libdb-dev resolvconf libsqlite3-dev libmcrypt-dev libmcrypt-dev openssl apt-file mailutils alien libstdc++6 nfs-common libcrack2-dev libcrack2-dev dh-make fakeroot
#apt install ntpdate libjpeg8-dev libjpeg8 libpng12-dev libfreetype6-dev libcurl4-openssl-dev libgdbm-dev libmcrypt-dev

#关闭不必要的系统服务
while read loop
do 
  item=`echo ${loop} | cut -d' ' -f1`
  echo ${item}
  systemctl stop ${item}
  systemctl disable ${item}
done< <(systemctl list-unit-files | grep enabled | grep -Pv 'ssh|sshd|networking|^cron|syslog|mysql|redis')
systemctl list-unit-files | grep enabled 

#profile文件终端显示
cat >> /etc/profile << EOF
export EDITOR=vim
export PS1='[-\$?- \[\e[32m\]\u@\[\e[31m\]\h\[\e[33m\] \w\[\e[0m\]]\\$ '
export MYSQL_PS1="\u@-DB-[\d]> "
EOF
source /etc/profile

#File open limit 
cat >> /etc/security/limits.conf << EOF
* soft nofile 655350
* hard nofile 655350
* soft nproc 655350 
* hard nproc 655350
EOF
echo "ulimit -HSn 655350" >>/etc/rc.local
echo "ulimit -HSn 655350" >>/root/.bashrc
  
#rc.local
cat <<EOF >/etc/rc.local
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

exit 0
EOF
chmod +x /etc/rc.local
systemctl start rc-local
systemctl status rc-local

#时区
timedatectl set-timezone Asia/Shanghai

echo "00 00 * * * /usr/sbin/ntpdate hk.pool.ntp.org >/dev/null 2>&1" >>/var/spool/cron/crontabs/root
#echo "* */1 * * * /usr/sbin/ntpdate 172.25.16.157 >/dev/null 2>&1" >>/var/spool/cron/crontabs/root

alias ls='ls --color=auto'
alias ll='ls -l'

cat << EOF >>/etc/sysctl.conf 
net.ipv4.ip_forward = 0
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.default.accept_source_route = 0
kernel.sysrq = 0
kernel.core_uses_pid = 1
net.ipv4.tcp_syncookies = 1
kernel.msgmnb = 65536
kernel.msgmax = 65536
kernel.shmmax = 68719476736
kernel.shmall = 4294967296
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.tcp_sack = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_rmem = 4096        87380   4194304
net.ipv4.tcp_wmem = 4096        16384   4194304
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.netdev_max_backlog = 262144
net.core.somaxconn = 262144
net.ipv4.tcp_max_orphans = 3276800
net.ipv4.tcp_max_syn_backlog = 262144
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_fin_timeout = 1
net.ipv4.tcp_keepalive_time = 30
fs.file-max = 6553600
net.ipv4.tcp_sack = 0
net.ipv4.ip_local_port_range = 1024    65000
net.ipv4.conf.default.rp_filter = 0
net.core.optmem_max = 65535
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
net.ipv6.conf.eth0.disable_ipv6 = 1
EOF
sysctl -p



#ssh 使用密钥认证 关闭密码认证和root登录
grep -Pv '^$|^#' /etc/ssh/sshd_config
Port 10033
PermitRootLogin no
PubkeyAuthentication yes
PasswordAuthentication no
ChallengeResponseAuthentication no
UsePAM yes
X11Forwarding yes
PrintMotd no
UseDNS no
AcceptEnv LANG LC_*
Subsystem	sftp	/usr/lib/openssh/sftp-server

#公钥查看
cat ~/.ssh/authorized_keys

#host文件添加下载服务器域名IP对应
cat /etc/hosts
cat >> /etc/hosts << EOF
172.25.18.93 93-soft
EOF
cat /etc/hosts

