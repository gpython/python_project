10TB文件分区

fdisk -l

parted /dev/sdb
(parted) p                                                                
(parted) mklabel gpt
(parted) mkpart primary 0% 100%                                           
(parted) p  
Model: DELL PERC H710 (scsi)
Disk /dev/sdb: 10.9TB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start   End     Size    File system  Name     Flags
 1      17.4kB  10.9TB  10.9TB               primary     

(parted) quit                                                             
Information: Don't forget to update /etc/fstab, if necessary.

安装XFS文件系统

rpm -qa | grep elfutils
rpm -qa | grep elfutils-libs
rpm -qa | grep libgomp

wget http://centos.ustc.edu.cn/centos/5/extras/x86_64/RPMS/dmapi-2.2.8-1.el5.centos.x86_64.rpm;
wget http://centos.ustc.edu.cn/centos/5/extras/x86_64/RPMS/dmapi-devel-2.2.8-1.el5.centos.x86_64.rpm
wget ftp://ftp.muug.mb.ca/mirror/centos/5.9/centosplus/x86_64/RPMS/kmod-xfs-0.4-2.x86_64.rpm
wget ftp://ftp.muug.mb.ca/mirror/centos/5.9/extras/x86_64/RPMS/xfsprogs-2.9.4-1.el5.centos.x86_64.rpm
wget http://centos.ustc.edu.cn/centos/5/extras/x86_64/RPMS/xfsprogs-devel-2.9.4-1.el5.centos.x86_64.rpm;
wget http://centos.ustc.edu.cn/centos/5/extras/x86_64/RPMS/xfsdump-2.2.46-1.el5.centos.x86_64.rpm

dmapi-2.2.8-1.el5.centos.x86_64.rpm
dmapi-devel-2.2.8-1.el5.centos.x86_64.rpm
dmapi是向上层提供数据管理接口的软件包

kmod-xfs-0.4-2.x86_64.rpm

xfsdump-2.2.46-1.el5.centos.x86_64.rpm
xfsdump对xfs文件系统备份和恢复的工具，主要包括/sbin/xfsdump和/sbin/xfsrestore工具

xfsprogs-2.9.4-1.el5.centos.x86_64.rpm
xfsprogs-devel-2.9.4-1.el5.centos.x86_64.rpm
xfs的管理工具包，包含了很多xfs工具，以xfs_打头的，基本都在这个包里，本段最重要的工具mkfs.xfs就在这个包里


groupadd mockbuild
useradd -g mockbuild mockbuild
yum install dmapi dmapi-devel xfsdump xfsprogs xfsprogs-devel

安装好这些rpm包以后，我们就可以对我们的磁盘分区来构建xfs文件系统了
modprobe xfs
lsmod | grep xfs

mkfs.xfs -f -i size=512 -l size=128m,lazy-count=1 -d agcount=16 /dev/sdb1

meta-data=/dev/sdb1              isize=512    agcount=16, agsize=166707204 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=2667315255, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096  
log      =internal log           bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0


mkdir /data
blkid /dev/sdb1

vim /etc/fstab
UUID=68c05d3a-01fc-4b66-973c-4d49afc9062c /data xfs		defaults 		0 0

mount -a
 
注意
构建xfs文件系统：
mkfs.xfs -f -i size=512,attr=2 -l size=128m,lazy-count=1 -d su=64k,sw=5 -L /data /dev/sdb1
就这么一个命令。你可以指定日志，inode和数据文件，分配组的各个参数。
具体的参数请man mkfs.xfs来查看。比较重要的是数据文件的两个参数：su和sw










