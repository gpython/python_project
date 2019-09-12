1 系统安装 CentOS5.8 X64
分区
/boot 	256M
swap 	内存大小x1.5
/		200G
/data	剩余所有空间
安装开发库 开发包 基础包 

双网卡 
	eth0 外网
	eth1 内网

2 系统安装完成 

关闭不必要服务器 只开启sshd|network|crond|irqbalance|syslog
for loop in `chkconfig  --list | grep 3:on | awk '{print $1}' | grep -P -v 'sshd|network|crond|irqbalance|syslog'`
do
chkconfig ${loop} off
[ -f /etc/rc.d/init.d/${loop} ] && /etc/rc.d/init.d/${loop} stop
done

控制台标识
vim /etc/profile
# 	PS1='[-$?- \u@\h \W]\$ '
PS1='\[\e]0;\w\a\][-$?- \[\e[32m\]\u@\[\e[31m\]\h\[\e[0m\] \[\e[33m\]\w\[\e[0m\]]\$ '
export MYSQL_PS1="\u@-`echo -e "\033[31m线上SlaveDB谨慎操作\033[0m"`-[\d]> "

PS1='[-$?- \[\e[32m\]\u@\[\e[31m\]\h\[\e[33m\] \w\[\e[0m\]]\$ '
export MYSQL_PS1="\u@-DB-[\d]> "
	
source /etc/profile

主机名设置
时间设置 
ntpdate stdtime.gov.hk
cronteb -e
00 * * * * /sbin/ntpdate stdtime.gov.hk

文件打开数
ulimit -n

vim /etc/security/limits.conf
* soft nofile 51200
* hard nofile 51200 

ulimit -Hn 51200
ulimit -Sn 51200
	

vim编辑器设置
vim ~/.vimrc
	syntax enable
	syntax on
	set nu
	set ai
	set shiftwidth=2
	set tabstop=2
	set nobackup
  set expandtab

设置nginx配置文件高亮
1. 进入vim的语法目录
cd /usr/share/vim/vim70/syntax/

2. 放入nginx语法定义文件nginx.vim
wget http://www.lsanotes.cn/linux/nginx.vim

3. 编辑文件类型定义
vim /usr/share/vim/vim70/filetype.vim

4. 在接近末尾（其它类似语法的位置）添加以下两行（注意：包括首行的双引号）

" nginx configuration
au BufRead,BufNewFile /usr/local/nginx/* set ft=nginx


配置YUM源
rpm -Uvh http://mirrors.yun-idc.com/epel/5/x86_64/epel-release-5-4.noarch.rpm

wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el5.rf.x86_64.rpm
rpm -Uvh rpmforge-release-0.5.3-1.el5.rf.x86_64.rpm

yum install sysstat iptraf


禁用ipv6
可以修改下面两个文件以阻止IPv6内核模块的加载：
/etc/modprobe.conf – 内核模块配置文件
/etc/sysconfig/network – 网络配置文件

1. # vim /etc/modprobe.conf
在其中加入下面这一行，

install ipv6 /bin/true

保存并退出。

2. # vim /etc/sysconfig/network
在其中加入下面配置项：

NETWORKING_IPV6=no
IPV6INIT=no

保存并退出文件，重启网络与服务器：

# service network restart
# rmmod ipv6
# reboot

如果想检查当前IPv6是否已禁用，可以使用下列命令：

# lsmod | grep ipv6
# ifconfig -a

系统内核参数优化 提高系统IP欺骗及DOS攻击
仅供参考
# Add
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
#net.ipv4.tcp_tw_len = 1
net.ipv4.tcp_tw_reuse = 1

net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_max_orphans = 3276800

#net.ipv4.tcp_fin_timeout = 30
#net.ipv4.tcp_keepalive_time = 120
net.ipv4.ip_local_port_range = 1024  65535

#net.ipv4.netfilter.ip_conntrack_max = 655360
#net.ipv4.netfilter.ip_conntrack_tcp_timeout_established = 10800


开启iptables
限制端口扫描；
针对业务开启相应端口；
针对来源ip限制访问；
内网eth1无限制
iptables -F
iptables -X
iptables -P INPUT DROP
iptables -A INPUT -p tcp -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p udp --sport 53 -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth1 -j ACCEPT
iptables -A INPUT -p ICMP -j ACCEPT
iptables -A INPUT -i lo  -j ACCEPT
#iptables -A INPUT -p tcp -m tcp -i eth0 --dport 22 -j ACCEPT
#iptables -A INPUT -p tcp -m tcp -i eth0 --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -m tcp -s 124.207.211.34 -j ACCEPT

Nginx
隐藏版本号
server_tokens off;

MySQL
修改root用户口令，删除空口令
使用独立用户运行MySQL
禁止远程连接数据库（根据需要开通特定IP）
严格控制用户权限：仅给予用户完成其工作所需的最小的权限;禁止授予PROCESS, SUPER, FILE 权限给非管理帐户；
禁止将MySQL数据目录的读写权限授予给MySQL用户外的其它OS 用户；




