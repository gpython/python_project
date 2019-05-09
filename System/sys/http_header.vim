

stat some_file.html
  File: ‘some_file.html’
  Size: 6         	Blocks: 8          IO Block: 4096   regular file
Device: 803h/2051d	Inode: 33903500    Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2019-04-11 11:13:25.633588831 +0800
Modify: 2019-04-11 11:13:25.633588831 +0800
Change: 2019-04-11 11:13:25.633588831 +0800
 Birth: -

Access  查看过文件的访问时间
Modify  文件内容修改时间            (数据文件 block)
change  文件内容 权限 用户 组修改时间 (权限 node)


####Http_Header
Last-modified (需要发送请求 协商)
  基于最后修改时间的HTTP缓存协商
  (304状态码 客户端发送请求 询问 服务器文件的修改时间否变动 无变动 返回304 读取浏览器缓存数据)
  web服务器文件 change时间 频繁变动 文件内容无变动

Etag (需要发送请求 协商)
  基于打标签的HTTP缓存协商
  客户端 轮询请求 多台服务器 文件 每台服务器上文件change时间可能不一样 last-modified 可能就出问题
  给服务器上文件打标签 响应时 在浏览器返回有Etag标签 每次请求检查etag标签内容

Expires Cache-control (直接本地浏览器缓存获取)
  基于过期时间的http缓存协商
  直接告诉浏览器 资源保存多长时间 在此时间周期内不需要发送请求 直接使用浏览器缓存即可
  nginx 内静态文件 expire 过期时间
  Expire 缓存在本机过期时间 (用户浏览器可能会存在时间不一致情况)
  cache-control: max-age 最大生存周期 根据 用户本地时间 推算而来
  Expires与Cache-control配合使用 推算 浏览器缓存过期时间

浏览器刷新
  回车
  所有没有过期的内容直接使用本地缓存

  F5
  浏览器会在请求头部 附加缓存协商 不允许浏览器直接使用本地缓存
  过期时间不受影响 只要response 在 expires cache-control 过期时间之内 都从本地缓存获取内容

  Ctrl + F5
  重新发送新的请求 所有缓存都不生效

  内容更改后 浏览器生效
  更改名字

  增加时间戳
  some.js?12345678

302调度
  电信用户 要访问 网易的web服务器 用户在电脑主机上填写了 联通的DNS服务器地址
  请求时会得到 网易的联通的服务器IP地址 (应该是网易的电信IP)
  用户访问网易的联通服务器IP时 此服务器会获取用户的真实IP地址  判断为电信用户 则返回302请求
  让电信用户 去网易的电信服务器 访问此web站点内容


软连接 + opcache 需要重启php-fpm


HTTP 链接无状态
  session id 放在cookie中 web端写的好多内容会放在cookie中
  cookie是有作用域的 (在某个域名下生效) 图片不需要携带cookie 单独域名

客户端 发送SYN=1 标志位设置为1的SYN 和随机序列号
  SYN=1 标志位设置为1 (control bits) seq=x序列号 随机数
服务端接收到后 SYN 和 ACK标志位都置为1 同时自己初始化一个seq序列号 返回ack=客户端seq+1 表示接收到客户端的包
  SYN=1 ACk=1，|| seq=1， ack=x+1
客户端响应 ACk=1 继续发送序列号 seq=x+1 并回复服务器序列号 ack=y+1
  ACk=1, seq=x+1, ack=y+1

#socket tcp四元组
  占用端口 占用socket
  每个IP的端口socket数量是一定的 连接占用端口
  当端口不够用时 可以使用多个IP的方式 (haproxy)

/proc/sys/net/ipv4/tcp_tw_reuse     #time_wait重用
/proc/sys/net/ipv4/tcp_timestamps   #time_wait重用 依据此时间戳来重用

/proc/sys/net/ipv4/tcp_tw_recycle   #快速回收time_wait 负载均衡器nat环境打开此选项会出现问题

#长连接
  建立连接时间 keep-alive时间 time-wait时间
  Connection: keep-alive
  节省tcp 链接的建立和销毁时间


#####Nginx
sendfile
  内存拷贝
  不通过内核缓冲区 用户缓冲区 直接通过网卡将文件发送出去
  默认从磁盘读文件 内核缓冲区 用户缓冲区 地址空间 写到网卡的地址空间 然后在发出去

tcp_nopush
tcp_nodelay


路由检测工具
mtr -n baidu.com

/proc/sys/vm/swappiness

#IO调度算法
/sys/block/sda//queue/scheduler
  noop [deadline] cfq
  ssd 推荐调度算法noop

四层负载均衡 (转发)
  修改报头目标地址
  修改源地址

七层 (代理)
  反向代理
  负载均衡器可以根据用户的 IP Session 健康检查 应用层信息做判断


轮询
加权轮询
最小连接
加权最小连接
目标地址hash
源地址hash


####################
73->76
100.100.100.100 访问 200.200.200.200 的 8888 端口

#直接访问站点
curl http://200.200.200.200:8888/
  remoteAddress: 100.100.100.100
  x-forwarded-for: undefined
  x-real-ip; undefined

#直接访问站点并伪造http头部
curl http://200.200.200.200:8888/ -H "X-Forwarded-For: 1.1.1.1" -H "X-Real-IP:2.2.2.2"
  remoteAddress: 100.100.100.100
  x-forwarded-for: 1.1.1.1
  x-real-ip; 2.2.2.2

#增加nginx反向代理



###################
LVS-Nat
本质是多目标IP的DNAT 通过将请求报文中的目标地址和目标端口修改为某挑选出的RS的RIP和PORT实现转发
  RIP和DIP应在同一个IP网络 且应使用私网地址 RS网关要指向DIP
  请求报文和响应报文都必须经由Director转发 Director易成为系统瓶颈
  支持端口映射 可修改请求报文的目标PORT
  VS必须为linux系统 RS可以是任意OS


LVS-DR
  请求报文 都经过lvs
  三次握手
    客户端 SYN 先经过LVS LVS更改客户端的数据报文的目的MAC地址 到RS 同步请求
    RS RS直接将返回 SYN+ACk 报文到客户端
    客户端 发送ACK 再次经过LVS LVS更改客户端数据报文的目的MAC地址 转发到RS

  Director和各RS都配置有VIP
  确保前端路由器将目标IP为VIP的请求报文发往Director
    方法1 前端网关做静态绑定VIP和Directory的MAC地址
    方法2 arptables工具
    方法3 修改内核参数 限制arp通告和应答级别
         /proc/sys/net/ipv4/conf/all/arp_ignore
         /proc/sys/net/ipv4/conf/all/arp_announce
   RS的RIP可以使用私网地址 也可以是公网地址 RIP和DIP在同一网络 RIP网关不能指向DIP 以确保响应报文不经过Director
   RS和Director要在同一个物理网络
   请求报文要经过Director 但响应报文不经过Director 而由RS直接发往Client
   不支持端口映射 端口不能修改




























