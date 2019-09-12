


web服务器安装
#wget http://files.sumix.com/java/jdk-6u25/jdk-6u25-linux-x64.bin
wget http://jacob-liang-platform-uus.googlecode.com/files/jdk-6u25-linux-x64.bin
wget http://nginx.org/download/nginx-1.2.8.tar.gz
wget ftp://ftp.uwsg.indiana.edu/pub/FreeBSD/ports/distfiles/resin-3.1.8.tar.gz
wget ftp://ftp.mirrorservice.org/sites/ftp.mysql.com/Downloads/Connector-J/mysql-connector-java-3.1.14.tar.gz
wget http://blog.s135.com/soft/linux/nginx_php/pcre/pcre-8.10.tar.gz



WEB Java 服务器软件安装

yum -y install gcc gcc-c++ autoconf automake libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel libidn libidn-devel openssl openssl-devel openldap openldap-devel nss_ldap openldap-clients openldap-servers

1 安装JDK1.6
chmod 755 jdk-6u25-linux-x64.bin
./jdk-6u25-linux-x64.bin
mv jdk1.6.0_25 /usr/local/
ln -s /usr/local/jdk1.6.0_25 /usr/local/java

vim /etc/profile
	export JAVA_HOME=/usr/local/java
	export CLASS_PATH=$JAVA_HOME/lib:$JAVA_HOME/jre/lib
	PATH=$PATH:$JAVA_HOME/bin
	export PATH

source /etc/profile
java -version	

2. 安装resin
tar zxvf resin-3.1.8.tar.gz -C /usr/local/
mv /usr/local/resin-3.1.8 /usr/local/resin
cd /usr/local/resin/
./configure 
make
make install

cp contrib/init.resin /etc/rc.d/init.d/resin
chmod 755 /etc/rc.d/init.d/resin 
vim /etc/rc.d/init.d/resin
将以下行注释
#	log_daemon_msg "Starting resin"
#	log_end_msg $?
#	log_daemon_msg "Stopping resin"
#	log_end_msg $?

cp /usr/local/resin/conf/resin.conf{,_`date +"%F"`}

Cd /usr/local/resin/conf/

> resin.conf
将resin.conf 模板文件拷贝进去

数据库连接
	<database>
           <jndi-name>jdbc/artupdb</jndi-name>
           <driver type="com.mysql.jdbc.Driver">
	    <url>jdbc:mysql://10.10.10.30:3306/artup2</url> 
             <user>artup2</user>
             <password>artup2</password>
            </driver>
            <prepared-statement-cache-size>8</prepared-statement-cache-size>
            <max-connections>140</max-connections>
            <max-idle-time>30s</max-idle-time>
	</database>

配置虚拟主机
<host id="www.artup-t2.com" root-directory="/data/htdocs/www.artup-t2.com/">
      <web-app id="/" document-directory="webapps/www_artup/webapps"/>
      <host-alias>www.artup-t2.com</host-alias>
      <stdout-log path="/data/logs/www.artup-t2/www.artup-t2.com_stdout.log"/>
      <stderr-log path="/data/logs/www.artup-t2/www.artup-t2.com_stderr.log"/>
      <access-log path="/data/logs/www.artup-t2/www.artup-t2.com-access.log"
            format='%h %l %u %t "%r" %s %b "%{Referer}i" "%{User-Agent}i"'
            rollover-period="1W"/>
</host>


web程序文件存放
mkdir /data/htdocs
日志文件存放
mkdir /data/logs

数据库连接jar包 
将解压出来的mysql-connector-java-3.1.14-bin.jar 包拷贝到resin 的lib目录下
tar zxvf mysql-connector-java-3.1.14.tar.gz
cp mysql-connector-java-3.1.14-bin.jar /usr/local/resin/lib/

resin正式使用时 更改resin.conf配置文件 修改Xmx Xms等值 以及连接数 超时等参数
以及web目录位置等作相应更改 日志 错误日志 访问日志 端口使用 目录更改等参数调整

3.
安装Nginx做为代理服务器

安装Nginx所需的pcre库：
tar zxvf pcre-8.10.tar.gz
cd pcre-8.10/
./configure
make && make install
cd ../

/usr/sbin/groupadd www
/usr/sbin/useradd -g www www

tar zxvf nginx-1.2.8.tar.gz
cd  nginx-1.2.8

mkdir /data/logs/nginx

./configure --prefix=/usr/local/nginx \
--error-log-path=/data/logs/nginx/error.log \
--http-log-path=/data/logs/nginx/access.log \
--user=www \
--group=www \
--with-http_ssl_module \
--with-http_flv_module \
--with-http_gzip_static_module \
--with-http_stub_status_module

make
make install

cp /usr/local/nginx/conf/nginx.conf{,_`date +"%F"`}
mkdir /usr/local/nginx/conf/vhost

将nginx.conf 配置文件模板拷贝进去

添加启动开机项目
vim /etc/rc.local
	ntpdate stdtime.gov.hk
	/etc/rc.d/init.d/resin start
	/usr/local/nginx/sbin/nginx


mkdir /data/tmp/nginx/client -p
mkdir /data/tmp/nginx/proxy -p
mkdir /data/tmp/nginx/fcgi -p
mkdir /data/logs/nginx -p

--prefix=/usr/local/nginx --error-log-path=/data/logs/nginx/error.log --http-log-path=/data/logs/nginx/access.log --user=www --group=www --with-http_ssl_module --with-http_flv_module --with-http_gzip_static_module --with-http_stub_status_module --http-client-body-temp-path=/data/tmp/nginx/client --http-proxy-temp-path=/data/tmp/nginx/proxy --http-fastcgi-temp-path=/data/tmp/nginx/fcgi --add-module=../ngx_cache_purge-2.0	
=================================================================================

tar zxvf gperftools-2.0.tar.gz 
cd gperftools-2.0
./configure --prefix=/usr/local --enable-frame-pointers
make
ldconfig 
make install
ldconfig 
echo "/usr/local/lib" > /etc/ld.so.conf.d/usr_local_lib.conf




wget http://pkgs.repoforge.org/geoip/geoip-1.4.6-1.el5.rf.i386.rpm
wget http://pkgs.repoforge.org/geoip/geoip-devel-1.4.6-1.el5.rf.i386.rpm
rpm -ivh geoip-1.4.6-1.el5.rf.i386.rpm 
rpm -ivh geoip-devel-1.4.6-1.el5.rf.i386.rpm 



./configure --prefix=/usr/local/nginx --user=nginx --group=nginx --with-http_ssl_module --with-http_flv_module --with-http_gzip_static_module --with-http_stub_status_module --http-client-body-temp-path=/data/tmp/nginx/client --http-proxy-temp-path=/data/tmp/nginx/proxy --http-fastcgi-temp-path=/data/tmp/nginx/fcgi --add-module=../ngx_cache_purge-2.0 --with-google_perftools_module --add-module=../naxsi-core-0.50/naxsi_src/ --with-http_geoip_module --with-http_realip_module --with-http_sub_module --with-http_flv_module --with-http_dav_module --with-http_addition_module




#############################################################################
wget http://tengine.taobao.org/download/tengine-1.5.2.tar.gz
wget http://luajit.org/download/LuaJIT-2.0.2.tar.gz
wget https://github.com/openresty/lua-nginx-module/archive/v0.9.4.tar.gz
wget https://codeload.github.com/simpl/ngx_devel_kit/tar.gz/v0.2.19
wget http://www.grid.net.ru/nginx/download/nginx_upload_module-2.2.0.tar.gz

mv v0.2.19 ngx_devel_kit-0.2.19.tar.gz
mv v0.9.4 lua-nginx-module-0.9.4.tar.gz

tar zxvf lua-nginx-module-0.9.4.tar.gz -C /usr/local/src/
tar zxvf nginx_upload_module-2.2.0.tar.gz -C /usr/local/src/
tar zxvf ngx_devel_kit-0.2.19.tar.gz -C /usr/local/src/
tar zxvf ngx_cache_purge-2.0.tar.gz -C /usr/local/src/

/usr/sbin/groupadd www
/usr/sbin/useradd -g www www
mkdir /data/logs/nginx

mkdir /data/tmp/nginx/client -p
mkdir /data/tmp/nginx/proxy -p
mkdir /data/tmp/nginx/fcgi -p
mkdir /data/logs/nginx -p



tar zxvf LuaJIT-2.0.2.tar.gz 
cd LuaJIT-2.0.2
make
make install PREFIX=/usr/local/luajit
ll /usr/local/luajit/lib/
export LUAJIT_LIB=/usr/local/luajit/lib
export LUAJIT_INC=/usr/local/luajit/include/luajit-2.0

echo '/usr/local/luajit/lib/' >> /etc/ld.so.conf
ldconfig


tar zxvf tengine-1.5.2.tar.gz 
cd tengine-1.5.2
./configure --prefix=/usr/local/tengine --error-log-path=/data/logs/nginx/error.log --http-log-path=/data/logs/nginx/access.log --user=www --group=www --with-http_ssl_module --with-http_flv_module --with-http_gzip_static_module --with-luajit-lib=/usr/local/luajit/lib --with-lua-inc=/usr/local/luajit/include/luajit-2.0 --with-lua-lib=/usr/local/lib/ --add-module=/usr/local/src/ngx_devel_kit-0.2.19 --add-module=/usr/local/src/lua-nginx-module-0.9.4 --add-module=/usr/local/src/ngx_cache_purge-2.0 --add-module=/usr/local/src/nginx_upload_module-2.2.0
make
make install

