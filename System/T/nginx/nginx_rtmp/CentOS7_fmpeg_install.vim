centos7编译安装ffmpeg

系统:centos 7.x(64位)
软件:ffmpeg 3.3.2
1.下载ffmpeg 3.3.2
wget http://www.ffmpeg.org/releases/ffmpeg-3.3.2.tar.gz

2.下载第三方源
yum -y install epel-release
wget https://www.mirrorservice.org/sites/dl.atrpms.net/el7-x86_64/atrpms/stable/atrpms-repo-7-7.el7.x86_64.rpm
wget http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-1.el7.nux.noarch.rpm
rpm -ivh atrpms-repo-7-7.el7.x86_64.rpm
rpm -ivh nux-dextop-release-0-1.el7.nux.noarch.rpm

vi /etc/yum.repos.d/atrpms.repo
[atrpms]
name=Red Hat Enterprise Linux $releasever - $basearch - ATrpms
failovermethod=priority
#baseurl=http://dl.atrpms.net/el$releasever-$basearch/atrpms/stable
baseurl=https://www.mirrorservice.org/sites/dl.atrpms.net/el7-x86_64/atrpms/stable
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-atrpms
 
[atrpms-debuginfo]
name=Red Hat Enterprise Linux $releasever - $basearch - ATrpms - Debug
failovermethod=priority
baseurl=http://dl.atrpms.net/debug/el$releasever-$basearch/atrpms/stable
enabled=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-atrpms
 
[atrpms-source]
name=Red Hat Enterprise Linux $releasever - $basearch - ATrpms - Source
failovermethod=priority
baseurl=http://dl.atrpms.net/src/el$releasever-$basearch/atrpms/stable
enabled=0
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-atrpms

3.安装依赖包
yum install automake autoconf make gcc gcc-c++ libtool zlib zlib-devel curl curl-devel alsa-lib alsa-lib-devel gettext gettext-devel expat expat-devel nasm pkgconfig yasm yasm-devel gnutls gnutls-devel  lame lame-devel  fdk-aac fdk-aac-devel x264 x264-devel bzip2 bzip2-devel -y

4.安装ffmpeg
tar zxf ffmpeg-3.3.2.tar.gz && cd ffmpeg-3.3.2
./configure --prefix=/usr/local/ffmpeg --enable-gpl --enable-version3 --enable-nonfree --enable-shared --enable-zlib --enable-bzlib --enable-libmp3lame --enable-libx264 --enable-pic --enable-libfdk-aac
make && make install

echo "/usr/local/ffmpeg/lib" >> /etc/ld.so.conf
ldconfig
echo 'export PATH=/usr/local/ffmpeg/bin:$PATH' >> /etc/profile
source /etc/profile

ffmpeg -version

可以看到ffmpeg已安装成功,好了,剩下的还需要什么就要看你们自己去折腾了.
