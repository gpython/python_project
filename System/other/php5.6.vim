yum install gcc gcc-c++ libxml2 libxml2-devel libjpeg-devel libpng-devel freetype-devel openssl-devel libcurl-devel libmcrypt-devel mysql-devel
tar zxvf php-5.6.9.tar.gz
cd php-5.6.9
./configure --prefix=/usr/local/php \
--with-pdo-mysql=mysqlnd \
--with-mysqli=mysqlnd \
--with-mysql=mysqlnd \
--with-jpeg-dir \
--with-png-dir \
--with-zlib \
--enable-xml  \
--with-libxml-dir \
--with-curl \
--enable-bcmath \
--enable-shmop \
--enable-sysvsem \
--enable-inline-optimization \
--enable-mbregex \
--with-openssl \
--enable-mbstring \
--with-gd \
--enable-gd-native-ttf \
--with-freetype-dir=/usr/lib64 \
--with-gettext=/usr/lib64 \
--enable-sockets \
--with-xmlrpc \
--enable-zip \
--enable-soap \
--disable-debug \
--enable-opcache \
--enable-zip \
--with-config-file-path=/usr/local/php/etc \
--enable-fpm \
--with-fpm-user=www \
--with-fpm-group=www

make
make install

#pdo
cd ext/pdo
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config
make
make install
