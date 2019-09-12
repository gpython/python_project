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

DHCP#--------------------------------------->
dhcp enable
dhcp relay server-group 1 ip 192.168.9.55 #DHCP 服务器IP 9.55
interface vlan 9
dhcp select relay
dhcp relay server-select 1



二层聚合：

一、静态聚合
[SW]int Bridge-Aggregation 1 
[SW-Ethernet1/0/1]port link-aggregation group 1
[SW-Ethernet1/0/2]port link-aggregation group 1
[SW-Bridge-Aggregation1]port link-type trunk
[SW-Bridge-Aggregation1]port  trunk permit vlan all 必须先加入端口再起Trunk，要不然会出错

二、动态聚合
[SW]int Bridge-Aggaregation 1 
[SW-Bridge-Aggregation1]link-aggregation mode dynamic 
[SW-Ethernet1/0/1]port link-aggregation group 1
[SW-Ethernet1/0/2]port link-aggregation group 1
[SW-Bridge-Aggregation1]port link-type trunk
[SW-Bridge-Aggregation1]port trunk permit vlan all

查看命令：
display link-aggregation summary
[S1]display link-aggregation verbose


负载分担：
[S1]link-aggregation load-sharing mode destination-mac  两端都配置（貌似接口也可以配置）

三层聚合：
[R2]int Route-Aggregation 1
[R2-Route-Aggregation1]ip add 12.1.1.2 24
[R2]int g0/0
[R2-GigabitEthernet0/0]port link-aggregation group 1
[R2-GigabitEthernet0/0]int g0/1
[R2-GigabitEthernet0/1]port link-aggregation group 1

负载分担：
[R1]link-aggregation global load-sharing mode source-ip destination-ip基于源IP，目的IP



华3层交换机vlan隔离
192.168.1.0---------g1/0/1 S    SW   g1/0/2 -------192.168.2.0
192.168.3.0-----------------------|
192.168.4.0-----------------------|
    禁止1.0、3.0、4.0与2.0互访                                         

[H3C]acl num 3000
[H3C-acl-adv-3000]rule 10 deny ip source 192.168.1.0 0.0.0.255 destination 192.168.2.0 0.0.0.255   //禁止1.0访问2.0
[H3C-acl-adv-3000]rule 20 deny ip source 192.168.3.0 0.0.0.255 destination 192.168.2.0 0.0.0.255   //禁止1.0访问2.0
[H3C-acl-adv-3000]rule 30 deny ip source 192.168.4.0 0.0.0.255 destination 192.168.2.0 0.0.0.255   //禁止1.0访问2.0
[H3C-acl-adv-3000]quit
[H3C]int  g1/0/2
[H3C-GigabitEthernet1/0/2]packet-filter 3000 outbound    //下发acl
以上是端口隔离  在3层交换机 vlan接口下packet-filter 这个命令也有 也可以做隔离的。



版本是Release 2208的可以直接在接口下packet-filter acl_number inbound/outbound，如果版本低于R2208，则需要通过QOS方式下发ACL



#wifi_guest
vlan 30
acl num 3000
rule 1 permit ip source 192.168.30.0 0.0.0.255 destionation 192.168.10.0 0.0.0.255
rule 5 deny ip source 192.168.30.0 0.0.0.255 destionation 192.168.0.0 0.0.255.255

interface vlan 30
packet-filter vlan 30 inbound 3000

packet-filter inbound 3000


https://blog.csdn.net/qq_30852577/article/details/79074915
