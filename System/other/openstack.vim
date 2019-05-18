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


MySQL    各个服务提供数据存储
RabbitMQ 各个服务之间通信提供交通枢纽
KeyStone 各个服务器之间通信提供认证和服务注册
Glance   为虚拟机提供镜像管理
Nova     为虚拟机提供计算资源
Neutron  为虚拟机提供网络资源

##############################
在两个节点都安装：

时间同步

关闭NetworkManager

主机名确定好不许再修改


1.安装仓库：
yum install centos-release-openstack-ocata

2.安装 OpenStack 客户端：
yum install python-openstackclient
yum install openstack-selinux

################ Node1 192.168.40.10 Controller节点 ##############

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
create database nova_cell0;

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

grant all on nova_cell0.* to 'nova'@'localhost' identified by 'nova';
grant all on nova_cell0.* to 'nova'@'%' identified by 'nova';

grant all on neutron.* to 'neutron'@'localhost' identified by 'neutron';
grant all on neutron.* to 'neutron'@'%' identified by 'neutron';

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


###创建域、项目、用户和角色
#创建 项目 名称为service
openstack project create --domain default \
  --description "Service Project" service

#常规（非管理）任务应该使用无特权的项目和用户。本指南创建 demo 项目和用户
#创建``demo`` 项目
openstack project create --domain default \
  --description "Demo Project" demo

#创建``demo`` 用户：
openstack user create --domain default \
  --password-prompt demo

#创建 user 角色 (默认此user角色属于keystone)
openstack role create user


#将demo用户添加到demo项目 并赋予user角色
openstack role add --project demo --user demo user

#可以重复此过程来创建额外的项目和用户
#创建用户 用户属于什么项目 拥有什么样的角色

创建所需要的所有用户 并 赋予相关的角色
#创建glance
openstack user create --domain default --password-prompt glance
#将glance用户添加到service项目并赋予admin角色
openstack role add --project service --user glance admin

openstack user create --domain default --password-prompt nova
#将nova用户添加到service项目并赋予admin角色
openstack role add --project service --user nova admin

openstack user create --domain default --password-prompt neutron
#将neutron用户添加到service项目并赋予admin角色
openstack role add --project service --user neutron admin

openstack user create --domain default --password-prompt cinder
#将cinder用户添加到service项目并赋予admin角色
openstack role add --project service --user cinder admin

#若填写错误 删除操作
openstack user delete some_user_id
openstack project delete some_project_id
openstack role delete some_role_id

#service 和endpoint有关联关系 删除需要删除关联关系
openstack endpoint delete some_endpoint_id
openstack service delete some_service_id

###验证操作
#安装完成keystone 并启动 创建了相关用户和项目 验证keystone
#验证刚才创建用户是否可用

#撤销临时环境变量``OS_AUTH_URL``和``OS_PASSWORD``
unset OS_AUTH_URL OS_PASSWORD

#作为 admin 用户，请求认证令牌
openstack --os-auth-url http://10.10.10.10:35357/v3 \
  --os-project-domain-name default --os-user-domain-name default \
  --os-project-name admin --os-username admin token issue

##创建 OpenStack 客户端环境脚本
vim admin-openstack
export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=admin
export OS_AUTH_URL=http://10.10.10.10:35357/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2

vim demo-openstack
export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=demo
export OS_USERNAME=demo
export OS_PASSWORD=demo
export OS_AUTH_URL=http://10.10.10.10:5000/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2

#请求认证令牌:
. admin-openstack
openstack token issue

. demo-openstack
openstack token issue


############Glance 镜像服务#################
Glance-api 
  接受云系统镜像的创建 删除 读取请求
  接收镜像API的调用，诸如镜像发现、恢复、存储，查找 上传 删除等操作 
  api默认监听端口 9292

Glance-Registry 
  云系统镜像注册服务
  存储、处理和恢复镜像的元数据，元数据包括项诸如大小和类型
  用于与MySQL数据库交互 用于存储或获取镜像的元数据
  提供镜像元数据相关的rest接口 通过glance-registry可以向数据库中写入或获取镜像的各种数据
  glance-registry监听端口9191 
  glance数据库中有两张表 一张image表 另一张image propety表
  image表保存了镜像格式 大小等信息
  image property表则保存镜像的定制化信息

image store
  是一个存储的接口层 通过这个接口 glance可以获取镜像 
  image store支持的存储有S3 Swift ceph GlusterFS等分布式存储
  image store是镜像保存与获取的接口 它仅仅是一个接口层
  具体实现需要外部支持

#Glance相关的用户和角色在上边已经创建
#创建glance 服务实体
#创建服务 名称glance 描述 类型为image
openstack service create --name glance \
  --description "OpenStack Image" image

#创建镜像服务的endpoint API端点
openstack endpoint create --region RegionOne \
  image public http://10.10.10.10:9292
openstack endpoint create --region RegionOne \
  image internal http://10.10.10.10:9292
openstack endpoint create --region RegionOne \
  image admin http://10.10.10.10:9292

#openstack-glance服务已经在先前安装过 
#glance服务配置

/etc/glance/glance-api.conf
/etc/glance/glance-registry.conf 
[database]
connection = mysql+pymysql://glance:glance@10.10.10.10/glance

#同步数据库
su -s /bin/sh -c "glance-manage db_sync" glance
#查看glance库已经创建表
mysql -uroot -p -e "use glance; show tables;"

#glance要连接到keystone进行认证
#有需求 需要镜像 先到keystone进行认证 确认身份
#在 [keystone_authtoken] 和 [paste_deploy] 部分，配置认证服务访问：
#以下两个文件添加
/etc/glance/glance-api.conf
/etc/glance/glance-registry.conf
[keystone_authtoken]
# ...
auth_uri = http://10.10.10.10:5000
auth_url = http://10.10.10.10:35357
memcached_servers = 10.10.10.10:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = glance
password = glance

[paste_deploy]
# ...
flavor = keystone

#继续配置glance-api
/etc/glance/glance-api.conf
[glance_store]
# ...
stores = file,http
default_store = file
filesystem_store_datadir = /var/lib/glance/images/

####Glance#启动镜像服务并将其配置为随机启动
systemctl enable openstack-glance-api.service \
  openstack-glance-registry.service
systemctl start openstack-glance-api.service \
  openstack-glance-registry.service

#验证glance启动成功
openstack image list

#执行环境变量
. admin-openstack

#下载源镜像：
wget http://download.cirros-cloud.net/0.3.5/cirros-0.3.5-x86_64-disk.img

#使用 QCOW2 磁盘格式， bare 容器格式上传镜像到镜像服务并设置公共可见，
#这样所有的项目都可以访问它 注意镜像路径 
openstack image create "cirros" \
  --file cirros-0.3.5-x86_64-disk.img \
  --disk-format qcow2 --container-format bare \
  --public

openstack image list


########################### Nova 计算服务 ####################
API
  负责接收和响应外部请求 支持Openstack API， EC2 API
Cert 
  负责身份认证EC2
Scheduler
  用于云主机调度
Conductor
  计算节点访问数据库的中间件
Consoleauth
  用于控制台的授权验证
Novncproxy
  VNC代理


Nova-Api 
组件实现了restful api的功能 是外部访问nova的唯一途径
接受外部的请求并通过MessageQueue将请求发送给其他的服务组件 
同时兼容EC2 API 也可用EC2管理工具对nova进行日常管理

Nova Scheduler
  nova scheduler模块在openstack中的作用就是决策虚拟机创建在那个主机 计算节点上
  决策一个虚拟机应该调度到某物理节点 需要分两个步骤
  过滤
  计算权重

Nova Compute
nova-compute 运行nova-compute的节点称为 计算节点
通过Message Queue 接受并管理VM的生命周期

nova-compute 通过Libvirt管理kvm 通过xenAPi管理Xen

#Nova组件 之前操作 已经安装过这些包
  nova-api        -> 整个nova组件
  nova-conductor  -> 数据库服务 
  nova-console    -> 
  nova-novncproxy -> web界面
  nova-scheduler  -> 创建虚拟机

#创建 nova 服务实体
openstack service create --name nova \
  --description "OpenStack Compute" compute

#Create the Compute API service endpoints

openstack endpoint create --region RegionOne \
  compute public http://10.10.10.10:8774/v2.1

openstack endpoint create --region RegionOne \
  compute internal http://10.10.10.10:8774/v2.1

openstack endpoint create --region RegionOne \
  compute admin http://10.10.10.10:8774/v2.1

#Create a Placement service user using your chosen PLACEMENT_PASS
openstack user create --domain default --password-prompt placement

#Add the Placement user to the service project with the admin role
openstack role add --project service --user placement admin

#Create the Placement API entry in the service catalog
openstack service create --name placement --description "Placement API" placement

#Create the Placement API service endpoints
openstack endpoint create --region RegionOne placement public http://10.10.10.10:8778
openstack endpoint create --region RegionOne placement internal http://10.10.10.10:8778
openstack endpoint create --region RegionOne placement admin http://10.10.10.10:8778


#配置文件/etc/nova/nova.conf
#在``[DEFAULT]``部分，只启用计算和元数据API
[DEFAULT]
# ...
enabled_apis = osapi_compute,metadata

#在``[api_database]``和``[database]``部分，配置数据库的连接
[api_database]
# ...
connection = mysql+pymysql://nova:nova@10.10.10.10/nova_api

[database]
# ...
connection = mysql+pymysql://nova:nova@10.10.10.10/nova

#在``[DEFAULT]``部分，配置``RabbitMQ``消息队列访问权限
[DEFAULT]
# ...
transport_url = rabbit://openstack:openstack@10.10.10.10

#在 [api] 和 [keystone_authtoken] 部分，配置认证服务访问
[api]
# ...
auth_strategy = keystone

[keystone_authtoken]
# ...
auth_uri = http://10.10.10.10:5000
auth_url = http://10.10.10.10:35357
memcached_servers = 10.10.10.10:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = nova
password = nova

#在 ``[DEFAULT]``部分，启用网络服务支持
[DEFAULT]
# ...
use_neutron = True
firewall_driver = nova.virt.firewall.NoopFirewallDriver

#在``[vnc]``部分，配置VNC代理使用控制节点的管理接口IP地址
[vnc]
enabled = true
# ...
vncserver_listen = 0.0.0.0
vncserver_proxyclient_address = 10.10.10.10

#在 [glance] 区域，配置镜像服务 API 的位置
[glance]
# ...
api_servers = http://10.10.10.10:9292

#在 [oslo_concurrency] 部分，配置锁路径：
[oslo_concurrency]
# ...
lock_path = /var/lib/nova/tmp

#In the [placement] section, configure the Placement API:
[placement]
# ...
os_region_name = RegionOne
project_domain_name = Default
project_name = service
auth_type = password
user_domain_name = Default
auth_url = http://10.10.10.10:35357/v3
username = placement
password = placement


###同步Compute 数据库：
su -s /bin/sh -c "nova-manage api_db sync" nova
su -s /bin/sh -c "nova-manage db sync" nova

###启动 Compute 服务并将其设置为随系统启动
systemctl enable openstack-nova-api.service \
  openstack-nova-consoleauth.service openstack-nova-scheduler.service \
  openstack-nova-conductor.service openstack-nova-novncproxy.service
systemctl start openstack-nova-api.service \
  openstack-nova-consoleauth.service openstack-nova-scheduler.service \
  openstack-nova-conductor.service openstack-nova-novncproxy.service

#验证
openstack host list
+------------------+-------------+----------+
| Host Name        | Service     | Zone     |
+------------------+-------------+----------+
| open-node1.g.com | consoleauth | internal |
| open-node1.g.com | conductor   | internal |
| open-node1.g.com | scheduler   | internal |
+------------------+-------------+----------+

#安装和配置计算节点
nova service-list

#把安装nova-compute节点的机器定义为计算节点
#计算节点会自动去注册
#主机名称非常重要 更改后会认为是新节点
################# node2 安装nova-compute ######################
yum install openstack-nova-compute

#编辑``/etc/nova/nova.conf``文件并完成下面的操作
#在``[DEFAULT]``部分，只启用计算和元数据API
[DEFAULT]
...
enabled_apis = osapi_compute,metadata

#在``[DEFAULT]``部分，配置``RabbitMQ``消息队列访问权限
[DEFAULT]
...
transport_url = rabbit://openstack:openstack@10.10.10.10

#在 [api] 和 [keystone_authtoken] 部分，配置认证服务访问
[api]
# ...
auth_strategy = keystone

[keystone_authtoken]
# ...
auth_uri = http://10.10.10.10:5000
auth_url = http://10.10.10.10:35357
memcached_servers = 10.10.10.10:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = nova
password = nova

#在 ``[DEFAULT]``部分，启用网络服务支持
[DEFAULT]
# ...
use_neutron = True
firewall_driver = nova.virt.firewall.NoopFirewallDriver

在``[vnc]``部分，启用并配置远程控制台访问：

[vnc]
# ...
enabled = True
vncserver_listen = 0.0.0.0
vncserver_proxyclient_address = 10.10.10.20
novncproxy_base_url = http://10.10.10.10:6080/vnc_auto.html

#在 [glance] 区域，配置镜像服务 API 的位置
[glance]
# ...
api_servers = http://10.10.10.10:9292

#在 [oslo_concurrency] 部分，配置锁路径：
[oslo_concurrency]
# ...
lock_path = /var/lib/nova/tmp

#In the [placement] section, configure the Placement API:
[placement]
# ...
os_region_name = RegionOne
project_domain_name = Default
project_name = service
auth_type = password
user_domain_name = Default
auth_url = http://10.10.10.10:35357/v3
username = placement
password = placement


#确定您的计算节点是否支持虚拟机的硬件加速
egrep -c '(vmx|svm)' /proc/cpuinfo

在 /etc/nova/nova.conf 文件的 [libvirt] 区域做出如下的编辑
[libvirt]
# ...
virt_type=kvm

grep -Pv '^#|^$' /etc/nova/nova.conf

#启动计算服务及其依赖，并将其配置为随系统自动启动
systemctl enable libvirtd.service openstack-nova-compute.service
systemctl start libvirtd.service openstack-nova-compute.service

####node1 节点查看服务列表
. admin-openstack

nova service-list

openstack compute service list

nova image-list

openstack image list

openstack hypervisor list

openstack catalog list

#Discover compute hosts
su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova

#When you add new compute nodes, you must run nova-manage cell_v2 discover_hosts on the controller node to register those new compute nodes. Alternatively, you can set an appropriate interval in /etc/nova/nova.conf:

[scheduler]
discover_hosts_in_cells_interval = 300
########################node1

################ Neutron 网络 #######################
网络
  实际物理环境下 使用交换机或集线器将多个计算机连接起来形成网络
  neutron 网络是将多个不同的云主机链接起来
子网
  实际物理环境下 一个网络中 可以将网络划分成为逻辑子网
  neutron世界中 子网也是隶属于网络下
端口
  实际物理环境下 每个子网或者每个网络都有很多端口 比如交换机端口来供计算机连接
  neutron世界里 端口也是隶属于子网下 云主机的网卡会对应到一个端口上
路由器
  实际网络环境 不同网络或者不同逻辑子网之间如果需要进行通信需要通过路由器进行路由
  neutron实际里路由也是这个作用 用来连接不同的网络或者子网
 
#编辑/etc/neutron/neutron.conf文件并完成如下操作
#在 [database] 部分，配置数据库访问
[database]
# ...
connection = mysql+pymysql://neutron:neutron@10.10.10.10/neutron

#在``[DEFAULT]``部分，启用ML2插件并禁用其他插件
[DEFAULT]
# ...
core_plugin = ml2
service_plugins =

#在``[DEFAULT]``部分，配置``RabbitMQ``消息队列访问权限
[DEFAULT]
# ...
transport_url = rabbit://openstack:openstack@10.10.10.10

#在 “[DEFAULT]” 和 “[keystone_authtoken]” 部分，配置认证服务访问
[DEFAULT]
# ...
auth_strategy = keystone

[keystone_authtoken]
# ...
auth_uri = http://10.10.10.10:5000
auth_url = http://10.10.10.10:35357
memcached_servers = 10.10.10.10:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = neutron
password = neutron


#在``[DEFAULT]``和``[nova]``部分，配置网络服务来通知计算节点的网络拓扑变化
[DEFAULT]
# ...
notify_nova_on_port_status_changes = True
notify_nova_on_port_data_changes = True

[nova]
# ...
auth_url = http://10.10.10.10:35357
auth_type = password
project_domain_name = default
user_domain_name = default
region_name = RegionOne
project_name = service
username = nova
password = nova

#在 [oslo_concurrency] 部分，配置锁路径：
[oslo_concurrency]
...
lock_path = /var/lib/neutron/tmp


#### 配置 Modular Layer 2 (ML2) 插件 ######
##ML2插件使用Linuxbridge机制来为实例创建layer－2虚拟网络基础设施
#编辑``/etc/neutron/plugins/ml2/ml2_conf.ini``文件并完成以下操作
#在``[ml2]``部分，
[ml2]
#启用flat和VLAN网络
type_drivers = flat,vlan

#禁用私有网络
tenant_network_types =

#启用Linuxbridge机制
mechanism_drivers = linuxbridge

#启用端口安全扩展驱动
extension_drivers = port_security


#在``[ml2_type_flat]``部分，配置公共虚拟网络为flat网络：
[ml2_type_flat]
flat_networks = public

#在 ``[securitygroup]``部分，启用 ipset 增加安全组的方便性：
[securitygroup]
enable_ipset = True


## 配置Linuxbridge代理¶
#Linuxbridge代理为实例建立layer－2虚拟网络并且处理安全组规则。
#/etc/neutron/plugins/ml2/linuxbridge_agent.ini

#将公共虚拟网络和公共物理网络接口对应起来
#替换为底层的物理公共网络接口
#ref:environment-networking for more information
[linux_bridge]
physical_interface_mappings = public:eth0

#禁止VXLAN覆盖网络：
[vxlan]
enable_vxlan = False

#启用安全组并配置 Linux 桥接 iptables 防火墙驱动：
[securitygroup]
enable_security_group = True
firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver


##配置DHCP代理
#The DHCP agent provides DHCP services for virtual networks.
#/etc/neutron/dhcp_agent.ini
#配置Linuxbridge驱动接口，DHCP驱动并启用隔离元数据
#这样在公共网络上的实例就可以通过网络来访问元数据
[DEFAULT]
interface_driver = neutron.agent.linux.interface.BridgeInterfaceDriver
dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
enable_isolated_metadata = True



#### 配置元数据代理 ######
#/etc/neutron/metadata_agent.ini
#配置元数据主机以及共享密码：
[DEFAULT]
nova_metadata_ip = 10.10.10.10
metadata_proxy_shared_secret = meta_secret

####配置计算服务来使用网络服务
#/etc/nova/nova.conf
#配置访问参数，启用元数据代理并设置密码：

[neutron]
url = http://10.10.10.10:9696
auth_url = http://10.10.10.10:35357
auth_type = password
project_domain_name = default
user_domain_name = default
region_name = RegionOne
project_name = service
username = neutron
password = neutron
service_metadata_proxy = true
metadata_proxy_shared_secret = meta_secret


###网络服务初始化脚本需要一个超链接 /etc/neutron/plugin.ini``指向ML2插件配置文件/etc/neutron/plugins/ml2/ml2_conf.ini``。如果超链接不存在，使用下面的命令创建它：

ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini

#同步数据库：
su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf \
  --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron

#重启计算API 服务：
systemctl restart openstack-nova-api.service

#当系统启动时，启动 Networking 服务并配置它启动
systemctl enable neutron-server.service \
  neutron-linuxbridge-agent.service neutron-dhcp-agent.service \
  neutron-metadata-agent.service
systemctl start neutron-server.service \
  neutron-linuxbridge-agent.service neutron-dhcp-agent.service \
  neutron-metadata-agent.service


##创建``neutron``服务实体
openstack service create --name neutron \
  --description "OpenStack Networking" network

#创建网络服务API端点
openstack endpoint create --region RegionOne \
  network public http://10.10.10.10:9696
openstack endpoint create --region RegionOne \
  network internal http://10.10.10.10:9696
openstack endpoint create --region RegionOne \
  network admin http://10.10.10.10:9696


  ### 验证
neutron agent-list

################## node2 安装neutron-linuxbridge############
## 安装和配置计算节点
yum install openstack-neutron-linuxbridge ebtables ipset

/etc/neutron/neutron.conf
#消息队列访问权限
[DEFAULT]
transport_url = rabbit://openstack:openstack@10.10.10.10

#配置认证服务访问
[DEFAULT]
auth_strategy = keystone

[keystone_authtoken]
auth_uri = http://10.10.10.10:5000
auth_url = http://10.10.10.10:35357
memcached_servers = 10.10.10.10:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = neutron
password = neutron

#配置锁路径
[oslo_concurrency]
lock_path = /var/lib/neutron/tmp

### 网络选项1：提供者网络 
/etc/neutron/plugins/ml2/linuxbridge_agent.ini

#将公共虚拟网络和公共物理网络接口对应起来
[linux_bridge]
physical_interface_mappings = public:eth0 

#禁止VXLAN覆盖网络
[vxlan]
enable_vxlan = false

#启用安全组并配置 Linux 桥接 iptables 防火墙驱动
[securitygroup]
enable_security_group = true
firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver

## 配置计算服务来使用网络服务 
/etc/nova/nova.conf
#配置访问参数
[neutron]
url = http://10.10.10.10:9696
auth_url = http://10.10.10.10:35357
auth_type = password
project_domain_name = default
user_domain_name = default
region_name = RegionOne
project_name = service
username = neutron
password = neutron

#重启计算服务
systemctl restart openstack-nova-compute.service

#启动Linuxbridge代理并配置它开机自启动：
systemctl enable neutron-linuxbridge-agent.service
systemctl start neutron-linuxbridge-agent.service

#在controller 节点检测
nova service-list
neutron agent-list



####################### Controller #######
#创建提供者网络
. admin-openstack

openstack network create  --share --external \
  --provider-physical-network public \
  --provider-network-type flat public

neutron net-list
