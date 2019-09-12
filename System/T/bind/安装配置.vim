
Master DNS  eth0  192.168.47.9    eth1  10.10.10.9
Slave DNS1  eth0  192.168.47.10   eth1  10.10.10.10
Slave DNS2  eth0  192.168.47.20   eth1  10.10.10.20



软件安装
yum install bind bind-utils bind-chroot 

安装bind-chroot 后 bind的配置环境为 /var/named/chroot/

生成key，用于主从view同步验证
每个视图使用一个key，用于主从直接数据传输的认证、数据加密
dnssec-keygen -a hmac-md5 -b 128 -n HOST liantong
dnssec-keygen -a hmac-md5 -b 128 -n HOST dianxin
dnssec-keygen -a hmac-md5 -b 128 -n HOST any

Master 创建必要的目录
mkdir /var/named/chroot/var/data
mkdir /var/named/chroot/var/log
mkdir /var/named/chroot/var/named/data -p
mkdir /var/named/chroot/var/named/dynamic -p
mkdir /var/named/chroot/var/run/named -p 
mkdir /var/named/chroot/var/tmp

chown -R :named /var/named/chroot/var
chown -R named:named /var/named/chroot/var/named
chown named:named /var/named/chroot/var/named

cp /var/named/named.ca /var/named/chroot/var/named/

rndc-confgen -a
cp /etc/rndc.key /var/named/chroot/etc/

/etc/rndc.key 中rndc可以 与 named.conf 配置文件中的key 一样

Master 配置文件 /var/named/chroot/etc/named.conf
#####################################################################################
options
{
	directory 		        "/var/named";		// "Working" directory
	dump-file 		        "data/cache_dump.db";
  statistics-file 	    "data/named_stats.txt";
  memstatistics-file 	  "data/named_mem_stats.txt";
	listen-on port 53	{ any; };

//	listen-on-v6 port 53	{ ::1; };
  allow-query { any; };
//	allow-query-cache	{ localhost; };
	recursion yes;
  #forward only;
  #forwarders { 202.106.0.20; 8.8.8.8; };

	dnssec-enable yes;
	dnssec-validation yes;
	dnssec-lookaside auto;
};


logging 
{
  channel default_debug {
  file "data/named.run";
  severity dynamic;
  };
};

key "rndc-key" {
  algorithm hmac-md5;
  secret "QyOUMDQSIQXFeZQBkxhQNA==";
};

key "intranet" {
  algorithm hmac-md5;
  secret "wBAlhiBbRO1P0+zkF7w+8g==";
};

key "internet" {
  algorithm hmac-md5;
  secret "SDTQSc8O4HjxEck5EsCj4Q==";
};

controls {
  inet 127.0.0.1 port 953
  allow { 127.0.0.1; } keys { "rndc-key"; };
};

acl "intranet_lan" {

  127.0.0.0/8;

  !10.10.10.9;    #master dns
  !10.10.10.10;   #slave dns1
  !10.10.10.20;   #slave dns2

  10.10.10.0/24;
};
acl "internet_wan" {

  !192.168.47.9;    #master dns
  !192.168.47.10;   #slave dns1
  !192.168.47.20;   #slave dns2

  192.168.47.0/24;
};

view "view_lan" {
  match-clients       { key "intranet"; intranet_lan; };
  allow-transfer      { key "intranet"; 10.10.10.10; 10.10.10.20; };
  server 10.10.10.10  { keys "intranet"; };
  server 10.10.10.20  { keys "intranet"; };
  notify yes;
  allow-recursion { any; };

 zone "." IN {
  type hint;
  file "named.ca";
 };

 zone "g.com" IN {
    type master;
    file "intranet.g.com.zone";
    also-notify {
      10.10.10.10;
      10.10.10.20;
    };
  };
};

view "view_wan" {
  match-clients       { key "internet"; internet_wan; };
  allow-transfer      { key "internet"; 10.10.10.10; 10.10.10.20; };
  server 10.10.10.10  { keys "internet"; };
  server 10.10.10.20  { keys "internet"; };
  notify yes;
  recursion no;

  zone "g.com" IN {
    type master;
    file "internet.g.com.zone";
    also-notify {
      10.10.10.10;
      10.10.10.20;
    };
  };
};
#####################################################################################

区域配置文件创建
每次更改区域配置文件 序列号加1

cd /var/named/chroot/var/named

vim internet.g.com.zone
#####################################################################################
$TTL 86400
$ORIGIN  g.com.
@       IN      SOA       ns1.g.com.       root. (
              1     ; serial
              1D    ; refresh
              1H    ; retry
              1W    ; expire
              3H )  ; minimum

              IN      NS      ns1
              IN      NS      ns2
              IN      NS      ns3
              IN      MX  10  mail
ns1           IN      A       192.168.47.9
ns2           IN      A       192.168.47.10
ns3           IN      A       192.168.47.20
mail          IN      A       192.168.47.10
www           IN      A       192.168.47.9
ftp           IN      A       192.168.47.10
#####################################################################################

vim intranet.g.com.zone
#####################################################################################
$TTL 86400
$ORIGIN  g.com.
@         IN      SOA     ns1.g.com.      root. (
                21                 ; serial
                1D                ; refresh
                1H                ; retry
                1W                ; expire
                3H )              ; minimum

                IN      NS      ns1
                IN      NS      ns2
                IN      NS      ns3
                IN      MX  10  mail
ns1             IN      A       10.10.10.9
ns2             IN      A       10.10.10.10
ns3             IN      A       10.10.10.20
mail            IN      A       10.10.10.10
www             IN      A       10.10.10.9
ftp             IN      A       10.10.10.10
#####################################################################################
以下为localhost zone文件 不一定会使用到
vim localhost.zone
$TTL 86400
@         IN      SOA       localhost.  root (
                        0
                        1D
                        1H
                        1W
                        1D
)

                IN        NS        localhost.
localhost.      IN        A         127.0.0.1        
#####################################################################################

vim localhost.revr
$TTL 86400
@           IN      SOA     localhost. root (
                        0
                        1D
                        1H
                        1W
                        3H
)

            IN        NS        localhost.
1           IN        PTR       localhost. 
#####################################################################################

/etc/rc.d/init.d/named configtest   配置文件检查 
/etc/rc.d/init.d/named start        启动

Slave DNS配置
软件安装
yum install bind bind-utils bind-chroot 

安装bind-chroot 后 bind的配置环境为 /var/named/chroot/

Master 创建必要的目录
mkdir /var/named/chroot/var/data
mkdir /var/named/chroot/var/log
mkdir /var/named/chroot/var/named/slaves
mkdir /var/named/chroot/var/named/data -p
mkdir /var/named/chroot/var/named/dynamic -p
mkdir /var/named/chroot/var/run/named -p 
mkdir /var/named/chroot/var/tmp

chown -R :named /var/named/chroot/var
chown -R named:named /var/named/chroot/var/named
chown named:named /var/named/chroot/var/named

cp /var/named/named.ca /var/named/chroot/var/named/


/etc/rndc.key 中rndc可以 与 named.conf 配置文件中的key 一样

Slave 配置文件 /var/named/chroot/etc/named.conf
options
{
  directory     "/var/named";   // "Working" directory
  dump-file     "data/cache_dump.db";
  statistics-file   "data/named_stats.txt";
  memstatistics-file  "data/named_mem_stats.txt";
  listen-on port 53 { any; };

//  listen-on-v6 port 53  { ::1; };
  allow-query { any; };
//  allow-query-cache { localhost; };
  recursion yes;
  #forward only;
  #forwarders { 202.106.0.20; 8.8.8.8; };

  dnssec-enable yes;
  dnssec-validation yes;
  dnssec-lookaside auto;
};


logging 
{
  channel default_debug {
  file "data/named.run";
  severity dynamic;
  };
};

key "rndc-key" {
  algorithm hmac-md5;
  secret "3B4P5gzHnV4H1pVV5SpaTA==";
};

key "intranet" {
  algorithm hmac-md5;
  secret "wBAlhiBbRO1P0+zkF7w+8g==";
};

key "internet" {
  algorithm hmac-md5;
  secret "SDTQSc8O4HjxEck5EsCj4Q==";
};

controls {
  inet 127.0.0.1 port 953
  allow { 127.0.0.1; } keys { "rndc-key"; };
};

acl "intranet_lan" {
  127.0.0.0/8;

  !10.10.10.9;
  !10.10.10.10;
  !10.10.10.20;

  10.10.10.0/24;
};
acl "internet_wan" {

  !192.168.47.9;
  !192.168.47.10;
  !192.168.47.20;

  192.168.47.0/24;
};

view "view_lan" {
  match-clients   { key "intranet"; intranet_lan; };
  allow-transfer { none; };  //禁止任何人向从服务器请求 zone transfer
  server 10.10.10.9 { keys intranet; };
  recursion yes;

  zone "." IN {
    type hint;
    file "named.ca";
 };

 zone "g.com" IN {
    type slave;
    file "slaves/intranet.g.com.zone";
    masters { 10.10.10.9; };
    allow-notify { 10.10.10.9; };
  };
};

view "view_wan" {
  match-clients   { key "internet"; internet_wan; };
  allow-transfer  { none; };
  server 10.10.10.9 { keys "internet"; };
  recursion no;

  zone "g.com" IN {
    type slave;
    file "slaves/internet.g.com.zone";
    masters { 10.10.10.9; };
    allow-notify { 10.10.10.9; };
  };
};
#####################################################################################

/etc/rc.d/init.d/named configtest
/etc/rc.d/init.d/named start

查看/var/named/chroot/var/named/slaves/ 下区域文件是否传输过来




forward
只当域有一个转发器列表的时候才是有意义的。当配置为”only”时，在转发查询失败和得不到结果时会导致查询失败；在配置为”first”时，则在转发查询失败或没有查到结果时，会在本地发起正常查询。
forwarders
用来代替全局的转发器列表。如果如故不在forward类型的域中设定，就不会有这个域查询的被转发；全局的转发设置则没有起作用。
