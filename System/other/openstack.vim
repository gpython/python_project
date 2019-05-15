Ocata
https://docs.openstack.org/ocata/zh_CN/install-guide-rdo/environment.html

keystone
用户认证
  用户权限与用户行为跟踪

目录服务
  提供一个服务目录 包含所有服务项 与相关API的端点

SOA


User    用户
  创建用户
  共有云 注册用户

project 项目
  公司->项目->多个用户
  一个用户组
  老版本 租户tenant

Token   令牌
  来keystone进行验证用户名 密码正确后发放令牌token 有效期
  以后再访问使用令牌即可 不需要每次都验证账号密码

Role    角色
  权限
  一组用户可以访问的资源权限
  Noval中虚拟机 Glacne中镜像

Service 服务
  创建服务 服务类型 ID
  如Nova Glance Swift 根据前三个概念(User Role Tenant) 
  一个服务可以确认当前用户是否具有访问其资源的权限
  但是当一个user尝试访问其租户内的service时 他必须知道这个service是否存在以及如何访问这个service

Endpoint 端点
  可以理解为是一个服务暴露出来的访问点 如果需要访问一个服务 则必须知道他的endpoint
  endpoint的每个URL都对应一个服务实例的访问地址 并且具有public private admin这三种权限
  public url可以被全局访问 private url只能被局域网内访问 admin url被从常规的访问中分离

在两个节点都安装：

时间同步


1.安装仓库：
yum install centos-release-openstack-ocata

2.安装 OpenStack 客户端：
yum install python-openstackclient
yum install openstack-selinux

#################在Node上安装 192.168.40.10 ########################

3.安装数据库：
yum install mariadb mariadb-server python2-PyMySQL
vim /etc/my.cnf.d/openstack.cnf
[mysqld]
bind-address = 192.168.56.11

default-storage-engine = innodb
innodb_file_per_table
max_connections = 4096
collation-server = utf8_general_ci
character-set-server = utf8

4.消息队列：
yum install rabbitmq-server
systemctl enable rabbitmq-server.service
systemctl start rabbitmq-server.service

#添加 openstack 用户 配置密码openstack
rabbitmqctl add_user openstack openstack

#给``openstack``用户配置写和读权限
rabbitmqctl set_permissions openstack ".*" ".*" ".*"

#插件列表
rabbitmq-plugins list
rabbitmq-plugins enable rabbitmq_management

lsof -i:15672
http://192.168.40.10:15672
guest
guest

5.其它服务提前安装：
yum install openstack-keystone httpd mod_wsgi
yum install openstack-glance
yum install openstack-nova-api openstack-nova-conductor \
  openstack-nova-console openstack-nova-novncproxy \
  openstack-nova-scheduler
yum install openstack-neutron openstack-neutron-ml2 \
  openstack-neutron-linuxbridge ebtables  

#数据库操作
create database keystone;
create database glance;
create database nova;
create database nova_api;
create database neutron;
create database cinder;

grant all on keystone.* to 'keystone'@'localhost' identified by 'keystone';
grant all on keystone.* to 'keystone'@'%' identified by 'keystone';

grant all on glance.* to 'glance'@'localhost' identified by 'glance';
grant all on glance.* to 'glance'@'%' identified by 'glance';

grant all on nova.* to 'nova'@'localhost' identified by 'nova';
grant all on nova.* to 'nova'@'%' identified by 'nova';

grant all on nova_api.* to 'nova'@'localhost' identified by 'nova';
grant all on nova_api.* to 'nova'@'%' identified by 'nova';

grant all on neutron.* to 'neutorn'@'localhost' identified by 'neutron';
grant all on neutron.* to 'neutorn'@'%' identified by 'neutron';

grant all on cinder.* to 'cinder'@'localhost' identified by 'cinder';
grant all on cinder.* to 'cinder'@'%' identified by 'cinder';


########### Keystone 用户权限认证管理##################
#编辑文件 /etc/keystone/keystone.conf 并完成如下动作
[database]
connection = mysql+pymysql://keystone:keystone@10.10.10.10/keystone


#初始化身份认证服务的数据库：
su -s /bin/sh -c "keystone-manage db_sync" keystone

#查看表创建情况
mysql -ukeystone -pkeystone -e "use keystone; show tables;"

#开启memcache
[memcache]
servers = 10.10.10.10:11211

#安装memcached
yum install memcached python-memcached -y

#编辑/etc/sysconfig/memcached 更改监听端口
OPTIONS="-l 0.0.0.0,::1"

systemctl enable memcached
systemctl start memcached

#编辑文件 /etc/keystone/keystone.conf 
#在``[token]``部分，配置Fernet UUID令牌的提供者
[token]
# ...
provider = fernet
driver = memcache

#查看grep '^[a-z]' /etc/keystone/keystone.conf 
connection = mysql+pymysql://keystone:keystone@10.10.10.10/keystone
servers = 10.10.10.10:11211
provider = fernet
driver = memcache

#grep -Pv '^#|^$' /etc/keystone/keystone.conf

#初始化Fernet key 在/etc/keystone/ 目录下创建fernet-keys文件夹
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone

#Bootstrap the Identity service 生成管理账号
keystone-manage bootstrap --bootstrap-password admin \
  --bootstrap-admin-url http://10.10.10.10:35357/v3/ \
  --bootstrap-internal-url http://10.10.10.10:5000/v3/ \
  --bootstrap-public-url http://10.10.10.10:5000/v3/ \
  --bootstrap-region-id RegionOne

#数据库中查看
use keystone;
select * from role;
select * from endpoint;

#配置HTTP服务器
编辑``/etc/httpd/conf/httpd.conf`` 文件，配置``ServerName`` 选项为控制节点
ServerName controller

创建一个链接到``/usr/share/keystone/wsgi-keystone.conf``文件
ln -s /usr/share/keystone/wsgi-keystone.conf /etc/httpd/conf.d/

systemctl enable httpd.service
systemctl start httpd.service

配置admin账户 放入环境变量 简化查询
export OS_USERNAME=admin
export OS_PASSWORD=admin
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://10.10.10.10:35357/v3
export OS_IDENTITY_API_VERSION=3


#查询
openstack user list
openstack role list
openstack project list
openstack service list
openstack endpoint list
