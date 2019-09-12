#目的主机配置

vim /etc/rsyncd.conf 
#Rsync server
#uid gid 表示对后面模块中的path路径拥有什么样的权限
uid = root
gid = root
#如果"use chroot"指定为true，那么rsync在传输文件以前首先chroot到path参数所指定的目录下。
#这样做的原因是实现额外的安全防护，但是缺 点是需要以roots权限，
#并且不能备份指向外部的符号连接所指向的目件。默认情况下chroot值为true。
use chroot = no
max connections = 2000
timeout = 600

pid file = /var/run/rsyncd.pid
lock file = /var/run/rsync.lock
log file = /var/log/rsyncd.log
# 忽略错误
#ignore errors
# false才能上传文件，true不能上传文件
read only = false
list = false

#允许的 源站IP地址
#hosts allow = 172.25.18.84,172.25.18.95,172.25.18.77

hosts allow = 172.25.18.97
hosts deny = 0.0.0.0/0

# 虚拟用户，同步时需要用这个用户
auth users = tom
# 密码文件 格式(虚拟用户名:密码）
secrets file = /etc/rsync.password

#####################################
# 模块名称
[41_mysql]
comment = backup from IP:172.25.18.97 DIR:/backup/mysql_backup
#path指 模块的路径必须填写，且真实存在
path = /data/backup

#密码
cat > /etc/rsync.password << EOF
tom:2460d5ca8a01fa885703e5cb32644b24
EOF
chown root.root /etc/rsync.password
chmod 600 /etc/rsync.password

#启动
rsync --daemon --config=/etc/rsyncd.conf

####源站
cat > /etc/rsync.password << EOF
2460d5ca8a01fa885703e5cb32644b24
EOF
chmod 600 /etc/rsync.password

#示例
#rsync -avz --password-file=/etc/rsync.password /backup/mysql_backup/2019-06-20_19-14-12.tar.gz tom@172.25.18.41::41_mysql



