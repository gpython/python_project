主DNS服务器
从DNS服务器
缓存DNS服务器
转发器


SOA
  可以理解为一段为自己dns做备注说明的文本 一般与ns一致
NS
  域的授权名称服务器
MX
  域的邮件交换器 要跟一个优先级 越小越高
A
  IPV4 主机地址 IP 到域名的对应
PTR
  反向解析
CNAME
  定义别名记录

host baidu.com
  host命令是大多数系统 软件库调用的解析命令

nslookup baidu.com

dig baidu.com


yum install bind-utils bind bind-devel bind-chroot















