#时间同步


vim /etc/yum.conf
proxy=http://192.168.10.1:9919

#在此连接寻找合适的源
#https://repo.saltstack.com/yum/redhat/
yum install https://repo.saltstack.com/yum/redhat/salt-repo-2016.3-2.el7.noarch.rpm

yum install salt-master
yum install salt-minion


#启动master
systemctl start satl-master

#/etc/salt目录 pki/master目录新增文件如下
├── pki
│   ├── master
│   │   ├── master.pem
│   │   ├── master.pub
│   │   ├── minions         #接受后 minions公钥存放于此
│   │   ├── minions_autosign
│   │   ├── minions_denied
│   │   ├── minions_pre     #预接收 minion端 公钥 salt-key -A 全部接受后 转移到minions 目录
│   │   │   ├── 10-10-10-50
│   │   │   ├── 10-10-10-51
│   │   │   ├── 10-10-10-52
│   │   │   ├── 10-10-10-53
│   │   │   ├── 10-10-10-54
│   │   │   └── 10-10-10-55
│   │   └── minions_rejected


客户端的主机名要唯一
变动主机名需要清除 /etc/salt/minion_id 文件内容
日志文件
  /var/log/salt/master
  /var/log/salt/minion

#修改minion配置文件 添加master主机地址 salt-minion
vim /etc/salt/minion
  master: 192.168.1.70

#启动minion
systemctl start salt-minion

#/etc/salt目录
  生成minion_id文件 此文件内为 此minion机器的主机名
  pki/minion 目录生成 minion主机的密钥对


#注意 minion 客户端
/etc/salt/minion_id文件 中保存着 minion 机器的 主机名

#master 机器
master识别minion时 pki文件里需要用到此minion_id文件里的标识

master pki/master/minions_pre/以minion_id(默认即minion主机名)作为文件名
minions_pre/minion_id 文件里存储客户端的公钥  通过minion_id 命名公钥文件

master 端操作
远程执行
  salt-key #列出所有类型的key
  salt-key -a 接受某个主机 或通配符接受一类主机
  salt-key -A 接受所有主机
  此时 双向交换公钥
  master机器 将minion公钥由minions_pre目录 转移到 minions目录
  minion机器 在minion 目录中添加 master机器的公钥
├── pki
│   ├── master
│   │   ├── master.pem
│   │   ├── master.pub
│   │   ├── minions         ################
│   │   │   ├── 10-10-10-50
│   │   │   ├── 10-10-10-51
│   │   │   ├── 10-10-10-52
│   │   │   ├── 10-10-10-53
│   │   │   ├── 10-10-10-54
│   │   │   └── 10-10-10-55
│   │   ├── minions_autosign
│   │   ├── minions_denied
│   │   ├── minions_pre     ##################
│   │   └── minions_rejected
│   └── minion
│       ├── minion_master.pub   ###<----
│       ├── minion.pem
│       └── minion.pub

#命令行 执行命令
  salt '*' test.ping为
  salt '*' cmd.run 'w'

#工作原理 消息队列 zeromq
  master监听 4505 4506 端口
  4505为salt的消息发布系统，4506为salt客户端与服务端通信的端口
  salt客户端程序不监听端口，客户端启动后，会主动连接master端注册 然后一直保持该TCP连接
  master通过这条TCP连接对客户端控制，如果连接断开，master对客户端就无能为力了
  客户端若检查到断开后会定期的一直连接master端的。


state状态管理 yaml格式 sls格式结尾
  缩进 2个空格 不能使用tab
  冒号 key:value
  短横线 - list1
        - list2

#创建必要目录
mkdir /srv/salt/{base,dev,test,prod} -p

#salt Master配置文件
vim /etc/salt/master

file_roots:
  base:
    - /srv/salt/base
  dev:
    - /srv/salt/dev
  test:
    - /srv/salt/test
  prod:
    - /srv/salt/prod

state_top: top.sls  #入口文件


minion机器state被下发后存放在
/var/cache/salt/minion/files/base

apache.sls

apache-install:         #自定义名字
  pkg.installed:        #模块.方法 软件安装
    - names:            #相当于字 典 里有个列表 要安装软件的列表
      - httpd
      - httpd-devel

apache-service:         # ID声明 高级状态 ID必须唯一 全局唯一 自定义名字
  service.running:      # 状态声明  模块.名字 服务运行
    - name: httpd       # 选项声明  服务名字
    - enable: Tre       # 服务开机启动

top.sls

base:
  '10-10-10-53':
    - web.apache
  '10-10-10-54':
    - web.apache



top.sls 入口文件 正式环境不要使用 *
salt '*' state.highstate test=True      #先测试无误后再执行
salt '*' state.highstate                #正式执行


ZeroMQ
lsof -i:4505
lsof -i:4506
4505 发布订阅  发消息
4506 接受返回的数据

##jinja
告诉file模块要使用jinja模板
- template: jinja

列出参数列表
- defaults:
  - PORT: 88

模板引用
  {{ PORT }}

模板支持的类型 jinja参数 salt命令 grains静态数据 pillar 进行赋值
nginx.conf
#            grains静态取值          jinja参数
Listen {{ grains['fqdn_ip4'][0] }}:{{ PORT }}

#salt 远程执行模块 数值获取 模块.方法
#MAC_Adress {{ salt['network.hw_addr']('eth0') }}
#PWD: {{ salt['cmd.run']('pwd') }}
#Current Time: {{ salt['cmd.run']('date +"%F %T"') }}


grains静态取值
salt '10-10-10-53' grains.item fqdn_ip4

salt远程执行模块 数值获取 模块.方法
salt '10-10-10-53' network.hw_addr eth0
salt '10-10-10-53' cmd.run pwd
salt '10-10-10-53' cmd.run 'date +"%F %T"'



数据系统

Grains 静态数据
其主要用于记录Minion的一些静态信息，如比：CPU、内存、磁盘、网络等
grains信息是每次客户端启动后自动上报给master的
一旦这些静态信息发生改变需要重启minion 或者 重新同步下 grains
除此之外我们还可以自定义Grains的一些信息 自定义的方法有三种
  1、通过Minion配置文件定义
  2、通过Grains相关模块定义
  3、通过python脚本定义

salt '*' grains.items       #输出机器配置信息
salt '10-10-10-53' grains.item os     #输出机器某一项信息
salt -G 'os:CentOS' test.ping     #-G 目标选择执行
salt -G 'os:CentOS' cmd.run 'w'
salt '*' grains.item os osrelease oscodename
salt '*' grains.ls




自定义grains 在minion机器上 配置文件内 自定义角色
grains:
  roles:
    - webserver

grains 文件内定义

vim /etc/salt/grains
key: value
salt 'vm-1-81' saltutils.sync_grains      #同步刷新grains配置参数
salt 'vm-1-81' grains.item key            #获取独立配置的参数


vim top.sls
base:
  'vm-1-81':
    - web.apache
  'vm-1-82':
    - web.apache
  'roles:apache':       #自定义grain中roles为apache
    - match: grain      #grain 匹配
    - web.apache        #执行web.apache

salt master机器上自定义grains 返回字典

mkdir /srv/salt/_grains
cd !$
vim my_grains.py
  return {key2:value2, key:value}

salt '*' saltutil.sync_grains  #将自定义的grains推送到minion机器 刷新Grains

同步到minion机器上位置查看
tree /var/cache/salt/minion/

Master 执行查看 字典值
salt '*' grains.item key

grains优先级
  系统自带
  grains文件
  minion配置文件
  自己写的

Pillar 动态 类似于top file
给特定的minion指定特定的数据 只有指定的minion能看到自己的数据
敏感数据调用

Master 配置文件中 打开pillar配置
pillar_roots:
  base:
    - /srv/pillar

/srv/pillar
.
├── global.sls
├── secure
│   ├── 51pd.sls
│  
├── top.sls
└── web
    └── soft.sls

#####vim top.sls
base:
  '*':
    - global

  "10-10-10-51":
    - web.nginx
    - secure.51pd

#####vim global.sls
user:
  zabbix: 1000
  nginx: 10001
  www: 1002

#####vim soft.sls
pkg:
  {% if grains['os'] == "CentOS" %}
  nginx: "This is CentOS Nginx"
  apache: httpd
  vim: vim-enhanced
  {% elif grains['os'] == "Debian" %}
  nginx: "This is Debian Nginx"
  apache: apache
  vim: vim
  {% endif %}
  port: 8080
  common: "Something COmmon"

#####vim 51pd.sls
pwd:
  key: "1.1HBHr+NQuZA="



#pillar 变量修改 需要下发参数  使其生效
salt '*' saltutil.sync_all
salt '*' saltutil.refresh_pillar
salt '*' pillar.items
salt -I 'apache:httpd' cmd.run 'w'    #-I 用pillar的key:value来匹配

        类型      数据收集方式      应用场景                        定义位置
Grains  静态  minion启动时收集    数据查询    目标选择     配置管理   minion端
Pillar  动态  master自定义       目标选择     配置管理    敏感数据    master端


主机名 redis-node01-redis04-idc01-soa.domain.com

redis-node01    #redis第一个节点
redis04         #集群
idc04           #机房
soa             #业务


匹配方式 所有的匹配目标方式都可以在top file里指定目标
salt '*' cmd.run 'w'                        #通配符
salt 'vm-1-81' cmd.run 'w'                  #指定
salt -L 'vm-1-81,vm-1-82' cmd.run 'w'       #列表
salt -E 'vm-1-(81|82)' cmd.run 'w'          #正则
salt -G 'os:CentOS' cmd.run 'w'             #Grains 匹配
salt -I 'apache:httpd' cmd.run 'w'          #Pillar的key:value来匹配

/etc/salt/master 里nodegroups 分组标识        #-N master配置文件中分组执行
salt '*' -b 10 cmd.run 'w'                  #指定一次要执行的数量

salt '*' state.show_top     #top files

salt '*' state.single pkg.installed name=nginx

编写模块
位置
mkdir /srv/salt/_modules

命名 文件名就是模块名

vim my_disk.py
def list():
  cmd = 'df -Th'
  ret = __salt__['cmd.run'](cmd)
  return ret

刷新 salt '*' saltutil.sync_modules



pkg.installed       #安装
pkg.latest          #确保最新
pkg.remove          #卸载
pkg.purge           #卸载并删除配置文件


common_packages:
  pkg.installed:
    - pkgs:
      - unzip
      - dos2unix
      - salt-minion: 2016.3.8

LAMP 配置
软件安装 管理配置文件 状态管理
pkg.installed
file.managed
service.running


lamp-pkg:
  pkg.installed:
    - pkgs:
      - httpd
      - php
      - mysql
      - mariadb-server
      - php-mysql
      - php-cli
      - php-mbstring

apache-config:
  file.managed:
    - name: /etc/httpd/conf/httpd.conf
    - source: salt://lamp/files/httpd.conf
    - user: root
    - group: root
    - mode: 644

php-config:
  file.managed:
    - name: /etc/php.ini
    - source: salt://lamp/files/php.ini
    - user: root
    - group: root
    - mode: 644

mysql-config:
  file.managed:
    - name: /etc/my.cnf
    - source: salt://lamp/files/my.cnf
    - user: root
    - group: root
    - mode: 644

apache-service:
  service.running:
    - name: httpd
    - enable: True
    - reload: True

mysql-service:
  service.running:
    - name: mariadb
    - enable: True
    - reload: True



salt:// 以master配置文件的file_roots: base: /srv/salt/ 路径为基准

salt://lamp/files/my.cnf 完整路径表示 /srv/salt/lamp/files/my.cnf

执行单个状态文件
salt 'vm-1-81' state.sls lamp.lamp



apache-service:
  pkg.installed:
    - pkgs:
      - httpd
      - php

  file.managed:
    - name: /etc/httpd/conf/httpd.conf
    - source: salt://lamp/files/httpd.conf
    - user: root
    - group: root
    - mode: 644

   service.running:
     - name: httpd
     - enable: True
     - reload: True

mysql-service:
  pkg.installed:
    - pkgs:
      - mariadb
      - mariadb-server

  file.managed:
    - name: /etc/my.cnf
    - source: salt://lamp/files/my.cnf
    - user: root
    - group: root
    - mode: 644

  service.running:
    - name: mariadb
    - enable: True
    - reload: True
##############################################

lamp-pkg:
  pkg.installed:
    - pkgs:
      - httpd
      - php
      - mysql
      - mariadb-server
      - php-mysql
      - php-cli
      - php-mbstring

apache-config:
  file.managed:
    - name: /etc/httpd/conf/httpd.conf
    - source: salt://lamp/files/httpd.conf
    - user: root
    - group: root
    - mode: 644

apache-service:
  service.running:
    - name: httpd
    - enable: True
    - reload: True
    - require:              #此apache服务运行需要依赖lamp-pkg这个模块
      - pkg: lamp-pkg
    - watch:                #监控当apache配置文件发生改变时候 执行reload 若reload没有执行restart
      - file: apache-config


##########处理状态间关系
require 我依赖谁
  Apache 依赖lamp-pkg 这个模块 并且依赖apapche-config

require_in 我被谁依赖

watch 我监控谁  我关注某个状态
  即是require  也是监控
  如果监控文件修改 需要做出相应动作
  如果apache-config这个id的状态发生改变就reload
  如果没有reload:True 那么就restart

watch_in  我被某个状态关注

我引用谁
我扩展谁

unless  如果后边这条命令返回为False 执行
unless test -L /usr/local/haproxy
如果 haproxy此链接存在则 不执行 cmd.run 中命令
否则每次执行state.sls 都会执行cmd.run下命令

http-service:
  service.running
    - name: nginx
    - enable: True
    - reload: True
    - require:
      - pkg: xxxx
    - watch:
      - file: nginx-config

如果http-service这个ID 状态发生变化 就reload
如果http-service这个ID 没有加reload: True 这个条件 那么状态发生改变 就restart


include:
  - lamp.pkg

 lamp  为top files里定义的文件夹 如/srv/salt/ 下lamp文件夹
 pkg   为lamp文件夹下pkg.sls文件

/srv/salt/lamp/
  |--config.sls
  |--pkg.sls
  |--servie.sls
  |--files
  |--init.sls

#安装
#配置
#启动

vim init.sls
include:
  - lamp.pkg
  - lamp.config
  - lamp.service

#执行  节点        状态      lamp/init.sls
salt 'node-1-1' state.sls lamp.init



JinJa2模板

告知file模块 使用jinja2
- template: jinja2

列出参数列表
- defaults:
  port: 88

模板中引用   xxx.conf
模板支持 salt grain pillar

- template:jinja2
- defaults:
  PORT: 88
  IPADDR: {{ grains['fqdn_ip4'][0] }}




#jinja2 grain
listen {{ grains['fqdn_ip4'][0] }}:{{ PORT }}


#salt远程执行功能 network模块 hw_addr方法 eth0参数
{{ salt['network.hw_addr']('eth0') }}

salt '*' network.hw_addr eth0
  network 模块
  hw_addr 方法
  eth0    为方法中传入的参数

#pillar /srv/pillar
{{ pillar['apache'] }}


所有执行的任务都有一个jid
#列出现在所有在运行的job
salt '*' saltutil.running
#杀死运行的jid
Salt '*' saltuitl.kill_job jid
#master 执行salt 先分发到minion端 minion 再在本地执行




/etc/profile:
  file.append:
    - text:
      - export HISTTIMEFORMAT="%F %T `whoami` "

file.append 文件末尾追加

net.ipv4.ip_local_port_range:
  sysctl.present:
    - value: 10000 65000

sysctl.present   sysctl模块

###################################################################

Haproxy(M)-------------------keepalive-----------------------Haproxy(S)
                                vip
                       Nginx++++++++++++++PHP

         MySQL(master)----------------------------MySQL(salve)


系统初始化

功能模块: 设置单独目录 haproxy nginx php mysql memcached
  尽可能全 独立

业务模块: 所有模块 配置 单独管理 web
  include 功能模块


环境
开发 测试 功能测试 性能测试 预生产 生产

base 基础环境
init目录 环境初始化
  dns配置
  history记录时间
  记录命令操作
  内核参数优化
  安装yum仓库
  安装zabbix agent

vim /etc/salt/master

file_roots:
  base:
    - /srv/salt/base
  prod:
    - /srv/salt/prod

pillar_roots:
  base:
    - /srv/pillar/base
  prod:
    - /srv/pillar/prod

mkdir /srv/salt/base -p
mkdir /srv/salt/prod

mkdir /srv/pillar/base -p
mkdir /srv/pillar/prod

systemctl restart salt-master
mkdir /srv/salt/base/init
cd /srv/salt/base/init/


salt '*' saltuit.refresh_pillar
salt '*' pillar.items
salt '*' pillar.get zabbix-agent:Zabbix-Server

salt '*' grains.items
salt '*' grains.item fqdn
salt '*' grains.item fqdn_ip4

salt '*' state.sls init.epel test=True
salt '*' state.show_top
salt '*' state.highstate



Prod
cd /srv/salt/prod
mkdir haproxy memcached nginx php pkg keepalived

salt '*' state.sls haproxy.install saltenv=prod

#这个模块下主要是描述service状态的函数，running状态函数表示apache在运行，省略-name不在表述，
-require表示依赖系统，依赖系统是state system的重要组成部分，
在该处描述了apache服务的运行需要依赖apache软件的部署，这里就要牵涉到sls文件的执行，
sls文件在salt中执行时无序(如果没有指定顺序，后面会讲到order)，
假如先执行了service这个状态，它发现依赖pkg包的安装，会去先验证pkg的状态有没有满足，
如果没有依赖关系的话，我们可以想象，如果没有安装apache，apache 的service肯定运行会失败的，
我们来看看怎么执行这个sls文件:

#ssh/init.sls 意思是当执行 salt '*' state.sls ssh的时候其实就是执行init.sls

include:
  - ssh
#include表示包含意思，就是把ssh/init.sls直接包含进来





