#########CentOS6#######
#YUM Setting
rpm -ivh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
yum install sysstat iptraf ntop iftop expect setuptool ntsysv iptables system-config-securitylevel-tui system-config-network-tui dbus-python dbus-python-devel -y


####hostname###
#!/bin/bash
echo -n "Enter The Hostname: "
read Hostname
if [ -z ${Hostname} ]
then
  Hostname='localhost.localdomain'
  echo "Your Hostname is ${Hostname}"
else
  echo "Your Hostname is ${Hostname}"
fi

cat > /etc/sysconfig/network << EOF
NETWORKING=yes
HOSTNAME=${Hostname}
EOF

###关闭不必要服务
#Shutdown unnessicry Service and only such Service sshd|network|crond|irqbalance|syslog is running
for loop in `chkconfig  --list | grep 3:on | awk '{print $1}' | grep -P -v 'sshd|network|crond|irqbalance|syslog'`
do
  chkconfig ${loop} off
  [ -f /etc/rc.d/init.d/${loop} ] && /etc/rc.d/init.d/${loop} stop
done

#############CentOS7#######################
#CentOS7
yum -y install epel-release
yum update
yum install net-tools vim tree unzip lsof sysstat iptraf ntop iftop htop iotop openssl openssl-devel gcc gcc-c++ autoconf libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel libidn libidn-devel openssl openssl-devel openldap openldap-devel nss_ldap openldap-clients openldap-servers gd-devel libXpm-devel wget unzip pcre pcre-devel ntpdate


#关闭不必要服务
while read loop
do
  item=`echo ${loop} | cut -d' ' -f1`
  echo ${item}
  systemctl stop ${item}
  systemctl disable ${item}
done< <(systemctl list-unit-files | grep enabled | grep -Pi -v 'sshd|network|crond|irqbalance|syslog')


#编辑器 终端提示符 MySQL提示符 history记录格式详情
#Prompt Setting
cat >> /etc/profile << EOF
export EDITOR=vim
PS1='[-\$?- \[\e[32m\]\u@\[\e[31m\]\h\[\e[33m\] \w\[\e[0m\]]\\$ '
export MYSQL_PS1="\u@-DB-[\d]> "
USER_IP=\`who -u am i 2>/dev/null| awk '{print \$NF}'|sed -e 's/[()]//g'\`
export HISTTIMEFORMAT="[%F %T][\`whoami\`][\${USER_IP}] "
#export PROMPT_COMMAND='{ msg=\$(history 1 | { read x y; echo \$y; });logger "[euid=\$(whoami)]":\$(who am i):[\`pwd\`]"\$msg"; }'

#USER_IP=`who -u am i 2>/dev/null| awk '{print $NF}'|sed -e 's/[()]//g'`
#export HISTTIMEFORMAT="[%F %T][`whoami`][${USER_IP}] "
#export PROMPT_COMMAND='{ msg=$(history 1 | { read x y; echo $y; });logger "[euid=$(whoami)]":$(who am i):[`pwd`]"$msg"; }'
EOF


#VIM Setting
cat > ~/.vimrc << EOF
syntax enable
syntax on
set nobackup
set tabstop=2
set shiftwidth=2
set expandtab
set ff=unix
set nobomb
set fileencoding=utf-8
set nocompatible
set ai
set hls
set nu
EOF


#File open limit
cat >> /etc/security/limits.conf << EOF
* soft nofile 51200
* hard nofile 51200
* soft nproc 65535
* hard nproc 65535
EOF


#shutdown selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
setenforce 0

#DNS Setting

cat > /etc/resolv.conf << EOF
search localdomain
nameserver 202.106.0.20
nameserver 8.8.8.8
EOF


#Ntpdate Setting
timedatectl set-timezone Asia/Shanghai
#/usr/sbin/ntpdate stdtime.gov.hk
/usr/sbin/ntpdate time1.aliyun.com
echo "00 * * * *  /usr/sbin/ntpdate time1.aliyun.com" >> /var/spool/cron/root


#System Kernel Parameters
cat >> /etc/sysctl.conf << EOF
net.ipv4.tcp_max_syn_backlog = 65536
net.core.netdev_max_backlog =  32768
net.core.somaxconn = 32768

net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216

net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 2

net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1

EOF
/sbin/sysctl -p


#VIM for Nginx
cd /usr/share/vim/vim74/syntax/
wget http://www.vim.org/scripts/download_script.php?src_id=19394 -O nginx.vim

cat >> /usr/share/vim/vim74/filetype.vim << EOF
" nginx configuration
au BufRead,BufNewFile /usr/local/nginx/* set ft=nginx
EOF





