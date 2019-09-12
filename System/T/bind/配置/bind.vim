yum install bind


named-checkconf /var/named/chroot/etc/named.conf
named-checkzone "localhost" /var/named/chroot/var/named/localhost.zone
service named configtest        检查语法错误
dig -t NS .                     获取ca 根记录
dig +trace -t A www.163.com     详细信息
dig +trace -t A www.163.com @127.0.0.1    本机为DNS服务器
service named reload            重载
host -t A  www.163.com
dig -x IP                     反向解析
dig +recurse -t A www.163.com @127.0.0.1    递归查询

gethostip www.163.com         先查询hosts 再查询DNS
  
dig -t axfr g.com             完全区域传送



nslookup
set q=A
www.163.com

set q=NS
.

set q=MX
163.com

只有允许递归的DNS服务器才可以写在/etc/resolv.conf中





allow-transfer { host_list; };          #区域传输 主从
allow-recursion { host_list; };
listen-on port 53 { ip; };

zone "zone_name" IN {
  type forward;
  forwarders { ip; };
  forward first|only;
};

options {
  forward only;
  forwarders { ip; };
};

zone "g.com" IN {
  type master;
  forwarders {};
  file "";
};

区域授权

tech.g.com        IN      NS      ns.tech.g.com.
ns.tech.g.com     IN      A       10.10.10.10
