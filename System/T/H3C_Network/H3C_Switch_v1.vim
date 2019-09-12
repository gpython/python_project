端口聚合 同时作为trunk使用 
必须要配置 trunk  和 聚合 两项都要操作

H3C（LACP协议 ）：
trunk口：

interface  GigabitEthernet 1/0/47
port link-type trunk
port trunk permit vlan all
interface  GigabitEthernet 1/0/48
port link-type trunk
port trunk permit vlan all
聚合口：

link-aggreration group 5 mode manual/dynamic/static
interface ethernet 1/0/1
port link-aggregation group 5
port link-type trunk
port trunk permit vlan all
或者-------------------------------



interface bridge-aggregation 1
link-aggregation mode dynamic
port link-type trunk
port trunk permit vlan all

interface  GigabitEthernet 1/0/47
port link-aggregation group 1
port link-type trunk
port trunk permit vlan all

interface  GigabitEthernet 1/0/48
port link-aggregation group 1
port link-type trunk
port trunk permit vlan all


Vlan
vlan 10
port GigabitEthernet 1/0/1 to GigabitEthernet 1/0/32


主机名配置 
sysname S5120_EC_1

显示配置
display current-configuration


S5500 连接N台二层交换机 需要配置N台
#######################连接 交换机 1#############################
Trunk:------------------------------------->

interface  GigabitEthernet 1/0/23
port link-type trunk
port trunk permit vlan all
interface  GigabitEthernet 1/0/24
port link-type trunk
port trunk permit vlan all

Etherchannel Trunk:------------------------>

interface bridge-aggregation 1
link-aggregation mode dynamic
port link-type trunk
port trunk permit vlan all

interface  GigabitEthernet 1/0/23
port link-aggregation group 1
port link-type trunk
port trunk permit vlan all

interface  GigabitEthernet 1/0/24
port link-aggregation group 1
port link-type trunk
port trunk permit vlan all
#######################连接 交换机 2#############################
Trunk:------------------------------------->

interface  GigabitEthernet 1/0/21
port link-type trunk
port trunk permit vlan all
interface  GigabitEthernet 1/0/22
port link-type trunk
port trunk permit vlan all

================================================
interface  GigabitEthernet 1/0/47
port link-type trunk
port trunk permit vlan all
interface  GigabitEthernet 1/0/48
port link-type trunk
port trunk permit vlan all


Etherchannel Trunk:------------------------>

interface bridge-aggregation 2
link-aggregation mode dynamic
port link-type trunk
port trunk permit vlan all

interface  GigabitEthernet 1/0/21
port link-aggregation group 2
port link-type trunk
port trunk permit vlan all

interface  GigabitEthernet 1/0/22
port link-aggregation group 2
port link-type trunk
port trunk permit vlan all

#===========================
interface  GigabitEthernet 1/0/47
port link-aggregation group 2
port link-type trunk
port trunk permit vlan all

interface  GigabitEthernet 1/0/48
port link-aggregation group 2
port link-type trunk
port trunk permit vlan all
#######################连接 交换机 3#############################
Trunk:------------------------------------->

interface  GigabitEthernet 1/0/19
port link-type trunk
port trunk permit vlan all
interface  GigabitEthernet 1/0/20
port link-type trunk
port trunk permit vlan all

Etherchannel Trunk:------------------------>

interface bridge-aggregation 3
link-aggregation mode dynamic
port link-type trunk
port trunk permit vlan all

interface  GigabitEthernet 1/0/19
port link-aggregation group 3
port link-type trunk
port trunk permit vlan all

interface  GigabitEthernet 1/0/20
port link-aggregation group 3
port link-type trunk
port trunk permit vlan all
#======================================
interface  GigabitEthernet 1/0/47
port link-aggregation group 3
port link-type trunk
port trunk permit vlan all

interface  GigabitEthernet 1/0/48
port link-aggregation group 3
port link-type trunk
port trunk permit vlan all

#######################连接 交换�?4#############################
Trunk:------------------------------------->

interface  GigabitEthernet 1/0/17
port link-type trunk
port trunk permit vlan all
interface  GigabitEthernet 1/0/18
port link-type trunk
port trunk permit vlan all

Etherchannel Trunk:------------------------>

interface bridge-aggregation 4
link-aggregation mode dynamic
port link-type trunk
port trunk permit vlan all

interface  GigabitEthernet 1/0/17
port link-aggregation group 4
port link-type trunk
port trunk permit vlan all

interface  GigabitEthernet 1/0/18
port link-aggregation group 4
port link-type trunk
port trunk permit vlan all
#======================================
interface  GigabitEthernet 1/0/23
port link-aggregation group 4
port link-type trunk
port trunk permit vlan all

interface  GigabitEthernet 1/0/24
port link-aggregation group 4
port link-type trunk
port trunk permit vlan all

DHCP#--------------------------------------->
dhcp enable
dhcp relay server-group 1 ip 192.168.9.55 #DHCP 服务器IP 9.55
interface vlan 9
dhcp select relay
dhcp relay server-select 1
