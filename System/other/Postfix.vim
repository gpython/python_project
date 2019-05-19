SASL
  cyrus-sasl 实现对stmp的用户认证

MTA 邮件传输代理 smtp服务器 (无法实现用户认证)
  Postfix

MDA 邮件投递代理
  maildrop

MRA (pop3 imap4) 邮件获取代理
  cyrus-imap
  dovecot

MUA 邮件客户代理
  Foxmail
  mutt(文本界面)

Webmail


发送邮件的服务器
  Postfix 作为smtp来使用
  SASL 简单认证程序 (courier-authlib + mysql 实现虚拟用户的认证) 这样就可以实现虚拟用户的认证了

收邮件服务
  dovecot 本身能够实现认证功能
  结合MySQL实现虚拟用户的认证功能

网页端显示
  Extmail + extman + http

默认的Postfix rpm包 可能不支持sasl基于虚拟用户认证的功能
需要手动编译安装 以便支持虚拟用户认证功能

编译安装postfix
wget http://mirror.postfix.jp/postfix-release/official/postfix-2.11.11.tar.gz
yum install cyrus-sasl-plain

yum remove postfix

userdel postfix
groupdel postfix
groupdel postdrop


ln -s /usr/lib64/mysql /usr/lib/mysql
ln -s /usr/lib64/sasl2 /usr/lib/sasl2

groupadd -g 2525 postfix
useradd -g postfix -u 2525 -s /sbin/nologin -M postfix
groupadd -g 2526 postdrop
useradd -g postdrop -u 2526 -s /sbin/nologin -M postdrop


make makefiles 'CCARGS=-DHAS_MYSQL -I/usr/include/mysql -DUSE_SASL_AUTH -DUSE_CYRUS_SASL -I/usr/include/sasl  -DUSE_TLS ' 'AUXLIBS=-L/usr/lib/mysql -lmysqlclient -lz -lm -L/usr/lib/sasl2 -lsasl2  -lssl -lcrypto'

make
make install


按照以下的提示输入相关的路径([]号中的是缺省值，”]”后的是输入值，省略的表示采用默认值)

　　install_root: [/] /
　　tempdir: [/root/postfix-2.9.3] /tmp/postfix
　　config_directory: [/etc/postfix] /etc/postfix
　　daemon_directory: [/usr/libexec/postfix]
　　command_directory: [/usr/sbin]
　　queue_directory: [/var/spool/postfix]
　　sendmail_path: [/usr/sbin/sendmail]
　　newaliases_path: [/usr/bin/newaliases]
　　mailq_path: [/usr/bin/mailq]
　　mail_owner: [postfix]
　　setgid_group: [postdrop]
   html_directory: [no]/var/www/html/postfix
   manpages: [/usr/local/man]
   readme_directory: [no]

#配置文件

  /etc/postfix/master.cf
  /etc/postfix/main.cf
  参数 = 值 参数必须写在行的绝对行首 以空白开头的行被认为是上一行的延续

postconf 配置postfix
  -d 显示默认配置
  -n 显示修改的配置
  -m 显示支持的查找表类型(mysql)
  -A 显示客户端支持的SASL插件类型
  -a 显示服务器端支持的SASl插件类型
  -e parmeter = value 更改某参数配置信息 并保存到main.cf文件中

hello
  询问服务器是否在 连接请求

mail from
  告诉smtpd发件人是谁 默认smtp不验证发件人身份

rcpt to
  告诉smtpd收件人是谁
  若非本机用户 验证是否将要进行中继邮件
  本机用户 不需要中继 直接发送
  根据收件人来验证是否需要中继

data
  邮件正文
   . 正文结束

邮件服务器必须能够反解

邮件状态码
  1xx 纯信息
  2xx 正确信息
  3xx 上一步操作信息处理尚未完成 还需要进一步操作 (重定向)
  4xx 暂时性错误 (客户端错误)
  5xx 永久性错误 (服务器错误)

邮件别名
postfox依赖邮件别名来检测用户是否存在 需要转发
  Hash散列提高检索速度
  /etc/aliases -> hash(newaliases) -> /etc/aliases.db
  更改/etc/aliases 后执行newaliases 更新 散列文件 /etc/aliases.db


2．进行一些基本配置，测试启动postfix并进行发信
# vim /etc/postfix/main.cf
修改以下几项为您需要的配置
myhostname = mail.magedu.com
myorigin = magedu.com
mydomain = magedu.com
mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain
#允许中继的网络 以及后面使用sasl通过认证功能的用户 都可以中继
mynetworks = 127.0.0.0/8

说明:
myorigin
  参数用来指明发件人所在的域名，即做发件地址伪装；
mydestination
  参数指定postfix接收邮件时收件人的域名，即您的postfix系统要接收到哪个域名的邮件；
myhostname
  参数指定运行postfix邮件系统的主机的主机名，默认情况下，其值被设定为本地机器名；
mydomain
  参数指定您的域名，默认情况下，postfix将myhostname的第一部分删除而作为mydomain的值；
mynetworks
  参数指定你所在的网络的网络地址，
  postfix系统根据其值来区别用户是远程的还是本地的，
  如果是本地网络用户则允许其访问；
  开放式中继功能网络限制

inet_interfaces
  参数指定postfix系统监听的网络接口；




postfix+sasl用户认证

/etc/sysconfig/saslauthd

显示当前主机saslauthd服务所支持的认证机制 默认为pam
saslauthd -v



六、实现postfix基于客户端的访问控制

1、基于客户端的访问控制概览

postfix内置了多种反垃圾邮件的机制，其中就包括“客户端”发送邮件限制。客户端判别机制可以设定一系列客户信息的判别条件：
connection: smtpd_client_restrictions
helo:       smtpd_helo_restrictions
mail from:  smtpd_sender_restrictions
rcpt to:    smtpd_recipient_restrictions
data:       smtpd_data_restrictions

真正限制其作用 是在 rcpt to:    smtpd_recipient_restrictions 这一项

上面的每一项参数分别用于检查SMTP会话过程中的特定阶段，即客户端提供相应信息的阶段，
如当客户端发起连接请求时，postfix就可以根据配置文件中定义的smtpd_client_restrictions参数来判别此客户端IP的访问权限。
相应地，smtpd_helo_restrictions则用于根据用户的helo信息判别客户端的访问能力等等。

如果DATA命令之前的所有内容都被接受，客户端接着就可以开始传送邮件内容了。
邮件内容通常由两部分组成，前半部分是标题(header)，其可以由header_check过滤，后半部分是邮件正文(body)，其可以由check_body过滤。这两项实现的是邮件“内容检查”。


postfix的默认配置如下：
smtpd_client_restrictions =
smtpd_data_restrictions =
smtpd_end_of_data_restrictions =
smtpd_etrn_restrictions =
smtpd_helo_restrictions =
smtpd_recipient_restrictions = permit_mynetworks, reject_unauth_destination
smtpd_sender_restrictions =

这限制了只有mynetworks参数中定义的本地网络中的客户端才能通过postfix转发邮件，其它客户端则不被允许，从而关闭了开放式中继(open relay)的功能。

Postfix有多个内置的限制条件，如上面的permit_mynetworks和reject_unauth_destination，
但管理员也可以使用访问表(access map)来自定义限制条件。
自定义访问表的条件通常使用
  check_client_access,
  check_helo_access,
  check_sender_access,
  check_recipient_access进行，
  它们后面通常跟上type:mapname格式的访问表类型和名称。
其中，check_sender_access和check_recipient_access用来检查客户端提供的邮件地址，
因此，其访问表中可以使用完整的邮件地址，如admin@magedu.com；也可以只使用域名，如magedu.com；还可以只有用户名的部分，如marion@。

2、实现示例1

这里以禁止172.16.100.66这台主机通过工作在172.16.100.1上的postfix服务发送邮件为例演示说明其实现过程。访问表使用hash的格式。

(1)首先，编辑/etc/postfix/access文件，以之做为客户端检查的控制文件，在里面定义如下一行：
172.16.100.66		REJECT

(2)将此文件转换为hash格式
# postmap /etc/postfix/access

(3)配置postfix使用此文件对客户端进行检查
编辑/etc/postfix/main.cf文件，添加如下参数：
smtpd_client_restrictions = check_client_access hash:/etc/postfix/access

(4)让postfix重新载入配置文件即可进行发信控制的效果测试了。

3、实现示例2

这里以禁止通过本服务器向microsoft.com域发送邮件为例演示其实现过程。访问表使用hash的格式。
(1)首先，建立/etc/postfix/denydstdomains文件(文件名任取)，在里面定义如下一行：
microsoft.com		REJECT

(2)将此文件转换为hash格式
# postmap /etc/postfix/denydstdomains

(3)配置postfix使用此文件对客户端进行检查
编辑/etc/postfix/main.cf文件，添加如下参数：
smtpd_recipient_restrictions = check_recipient_access hash:/etc/postfix/denydstdomains, permit_mynetworks, reject_unauth_destination

(4)让postfix重新载入配置文件即可进行发信控制的效果测试了。

4、检查表格式的说明

hash类的检查表都使用类似如下的格式：
pattern   action

检查表文件中，空白行、仅包含空白字符的行和以#开头的行都会被忽略。以空白字符开头后跟其它非空白字符的行会被认为是前一行的延续，是一行的组成部分。

(1)关于pattern
其pattern通常有两类地址：邮件地址和主机名称/地址。

邮件地址的pattern格式如下：
user@domain  用于匹配指定邮件地址；
domain.tld   用于匹配以此域名作为邮件地址中的域名部分的所有邮件地址；
user@ 			 用于匹配以此作为邮件地址中的用户名部分的所有邮件地址；

主机名称/地址的pattern格式如下：
domain.tld   用于匹配指定域及其子域内的所有主机；
.domain.tld   用于匹配指定域的子域内的所有主机；
net.work.addr.ess
net.work.addr
net.work
net        用于匹配特定的IP地址或网络内的所有主机；
network/mask  CIDR格式，匹配指定网络内的所有主机；

(2)关于action

接受类的动作：
OK   接受其pattern匹配的邮件地址或主机名称/地址；
全部由数字组成的action   隐式表示OK；

拒绝类的动作(部分)：
4NN text
5NN text
    其中4NN类表示过一会儿重试；5NN类表示严重错误，将停止重试邮件发送；421和521对于postfix来说有特殊意义，尽量不要自定义这两个代码；
REJECT optional text...   拒绝；text为可选信息；
DEFER optional text...    拒绝；text为可选信息；



七、为postfix开启基于cyrus-sasl的认证功能

使用以下命令验正postfix是否支持cyrus风格的sasl认证，如果您的输出为以下结果，则是支持的：
# /usr/local/postfix/sbin/postconf  -a
cyrus
dovecot

#vim /etc/postfix/main.cf
添加以下内容：
############################CYRUS-SASL############################
broken_sasl_auth_clients = yes
#允许中继的条件 本地网络 通过sasl认证的用户
smtpd_recipient_restrictions=permit_mynetworks,permit_sasl_authenticated,reject_invalid_hostname,reject_non_fqdn_hostname,reject_unknown_sender_domain,reject_non_fqdn_sender,reject_non_fqdn_recipient,reject_unknown_recipient_domain,reject_unauth_pipelining,reject_unauth_destination
smtpd_sasl_auth_enable = yes
smtpd_sasl_local_domain = $myhostname
smtpd_sasl_security_options = noanonymous
smtpd_sasl_path = smtpd
smtpd_banner = Welcome to our $myhostname ESMTP,Warning: Version not Available!



# vim /usr/lib/sasl2/smtpd.conf
添加如下内容：
pwcheck_method: saslauthd
mech_list: PLAIN LOGIN

让postfix重新加载配置文件
#/usr/sbin/postfix reload

# telnet localhost 25
Trying 127.0.0.1...
Connected to localhost.localdomain (127.0.0.1).
Escape character is '^]'.
220 Welcome to our mail.magedu.com ESMTP,Warning: Version not Available!
ehlo mail.magedu.com
250-mail.magedu.com
250-PIPELINING
250-SIZE 10240000
250-VRFY
250-ETRN
250-AUTH PLAIN LOGIN
250-AUTH=PLAIN LOGIN               （请确保您的输出以类似两行）
250-ENHANCEDSTATUSCODES
250-8BITMIME
250 DSN



























