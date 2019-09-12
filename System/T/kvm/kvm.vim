CentOS6.6

yum install -y kvm libvirt python-virtinst qemu-kvm bridge-utils virt-manager libvirt openssh-askpass libguestfs-tools qemu-kvm-tools  virt-viewer virt-v2v

service libvirtd start

cd /etc/sysconfig/network-scripts/
cp ifcfg-eth0 ifcfg-br0
桥接模式
vim ifcfg-eth0 
-------------------------------------------------
DEVICE=eth0
TYPE=Ethernet               #<-
UUID=7d08765c-c03c-4fe9-a725-a9765bf0097a
ONBOOT=yes                  #<-
NM_CONTROLLED=yes
BOOTPROTO=none
IPV6INIT=no
USERCTL=no
BRIDGE=br0                  #<- 
#NETWORK=192.168.0.0
#IPADDR=192.168.0.33
#NETMASK=255.255.252.0
#DNS2=202.106.0.20
#GATEWAY=192.168.1.254
#DNS1=192.168.1.6
-------------------------------------------------

vim ifcfg-br0
-------------------------------------------------
DEVICE=br0
TYPE=Bridge               #<-
UUID=7d08765c-c03c-4fe9-a725-a9765bf0097a
ONBOOT=yes                #<-
NM_CONTROLLED=yes
BOOTPROTO=none
IPV6INIT=no
USERCTL=no
NETWORK=192.168.0.0
IPADDR=192.168.0.33
NETMASK=255.255.252.0
DNS2=202.106.0.20
GATEWAY=192.168.1.254
DNS1=192.168.1.6
-------------------------------------------------
/etc/rc.d/init.d/network restart
brctl show



ln -s /usr/libexec/qemu-kvm /usr/bin/qemu-kvm
qemu-img create -f qcow2 /data/vms/CentOS_65_X64/CentOS-6.5_X64.img 20G

#光盘安装
virt-install --name=CentOS_6.5_X64 \
--os-variant=rhel6 \
-r 2048 \ 
--vcpu=2 \
--disk path=/data/vms/CentOS_65_X64/CentOS-6.5_X64.img,format=qcow2,size=40,bus=virtio \
--cdrom /data/IOS/CentOS-6.5-x86_64-bin-DVD1.iso \
--graphics vnc,port=5910,listen=0.0.0.0 \
--accelerate \
--force \
--network bridge=br0,model=virtio


qemu-img create -f qcow2 /data/vms/CentOS_65_X64_KS/CentOS-6.5_X64_KS.img 20G
ks自动安装
virt-install --name=CentOS_6.5_X64_KS --os-variant=rhel6 -r 2048 --vcpu=2 \
--disk path=/data/vms/CentOS_65_X64_KS/CentOS-6.5_X64_KS.img,format=qcow2,size=20,bus=virtio \
--graphics vnc,port=5911,listen=0.0.0.0 \
--accelerate \
--force \
--network bridge=br0,model=virtio \
-x "ks=http://192.168.0.33/ks.cfg" \
-l "http://192.168.0.33/cdrom/"


添加磁盘
CentOS_6.5_X64 虚拟机为关闭状态

qemu-img create -f qcow2 /data/vms/CentOS_65_X64/CentOS-6.5_X64-data.img 50G

vim /etc/libvirt/qemu/CentOS_6.5_X64.xml
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2' cache='none'/>
      <source file='/data/vms/CentOS_65_X64/CentOS-6.5_X64.img'/>
      <target dev='vda' bus='virtio'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x05' function='0x0'/>
    </disk>
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2' cache='none'/>
      <source file='/data/vms/CentOS_65_X64/CentOS-6.5_X64-data.img'/>
      <target dev='vdb' bus='virtio'/>
    </disk>

virsh define /etc/libvirt/qemu/CentOS_6.5_X64.xml

virsh start CentOS_6.5_X64
fdisk -l
fdisk /dev/vdb
n
p
1

w

mkfs.ext4 /dev/vdb1
blkid /dev/vdb1 | sed 's/"//g'
vim /etc/fstab






























参数说明：     
   
--name指定虚拟机名称     
--ram分配内存大小。     
--vcpus分配CPU核心数，最大与实体机CPU核心数相同     
--disk指定虚拟机镜像，size指定分配大小单位为G。     
--network网络类型，此处用的是默认，一般用的应该是bridge桥接。可以指定两次也就是两块网卡     
--accelerate加速     
--cdrom指定安装镜像iso     
--location 从ftp,http,nfs启动     
--vnc启用VNC远程管理     
--vncport指定VNC监控端口，默认端口为5900，端口不能重复。     
--vnclisten指定VNC绑定IP，默认绑定127.0.0.1，这里改为0.0.0.0。     
--os-type=linux,windows     
--extra-args指定额外的安装参数     
--os-variant= [win7 vista winxp win2k8 rhel6 rhel5]     
--force 如果有yes或者no的交互式，自动yes     

#--extra-args "linux ip=192.168.73.22 netmask=255.255.255.224 gateway=192.168.73.1 ks=http://192.168.130.4/ks/xen63.ks"
启用console
#--extra-args "linux ip=59.151.73.22 netmask=255.255.255.224 gateway=59.151.73.1 ks=http://111.205.130.4/ks/xen63.ks console=ttyS0  serial"     




命令行：
virsh list                                                  #显示本地活动虚拟机
virsh list –all                                           #显示本地所有的虚拟机（活动的+不活动的）
virsh define ubuntu.xml                      #通过配置文件定义一个虚拟机（这个虚拟机还不是活动的）
virsh start ubuntu                                #启动名字为ubuntu的非活动虚拟机
virsh create ubuntu.xml                     #创建虚拟机（创建后，虚拟机立即执行，成为活动主机）
virsh suspend ubuntu                          #暂停虚拟机
virsh resume ubuntu                           #启动暂停的虚拟机
virsh shutdown ubuntu                       #正常关闭虚拟机
virsh destroy ubuntu                           #强制关闭虚拟机
virsh dominfo ubuntu                          #显示虚拟机的基本信息
virsh domname 2                                 #显示id号为2的虚拟机名
virsh domid ubuntu                              #显示虚拟机id号
virsh domuuid ubuntu                         #显示虚拟机的uuid
virsh domstate ubuntu                       #显示虚拟机的当前状态
virsh dumpxml ubuntu                        #显示虚拟机的当前配置文件（可能和定义虚拟机时的配置不同，因为当虚拟机启动时，需要给虚拟机分配id号、uuid、vnc端口号等等）
virsh setmem ubuntu 512000           #给不活动虚拟机设置内存大小
virsh setvcpus ubuntu 4                      #给不活动虚拟机设置cpu个数
virsh edit ubuntu                                  #编辑配置文件（一般是在刚定义完虚拟机之后）

















##############################################
#!/bin/bash

if [[ "$1" == "" ]];then
    echo "need a ip argv"
    exit
fi

if ping -c 1 $1 ;then
    echo "$1 is alive !!"
    exit
fi

vhost_name=`echo $1 | sed -r 's/\./-/g'`

if [[ -d "/data/kvm/$vhost_name" ]];then
    echo "/data/kvm/$vhost_name is existed !!"
    exit
else
    mkdir /data/kvm/$vhost_name && echo "create /data/kvm/$vhost_name OK."
fi

virt-clone --connect qemu:///system -o 192-168-1-7 -n $vhost_name -f /data/kvm/$vhost_name/$vhost_name-system.img -f /data/kvm/$vhost_name/$vhost_name-data.img

hostname=`echo $1 | sed -r 's/192\.168\.([0-9]+)\.([0-9]+)/GS\1-\2/'`
echo $hostname

sed -r 's/GS1-7/'"$hostname"'/' /data/kvm/temp/hosts > /data/kvm/hosts
sed -r 's/GS1-7/'"$hostname"'/' /data/kvm/temp/network > /data/kvm/network
sed -r 's/192.168.1.7/'"$1"'/' /data/kvm/temp/ifcfg-eth0 > /data/kvm/ifcfg-eth0

virt-copy-in -d $vhost_name ifcfg-eth0 /etc/sysconfig/network-scripts/
virt-copy-in -d $vhost_name hosts /etc/
virt-copy-in -d $vhost_name network /etc/sysconfig/

sed -i -r "/vnc/s/>/ passwd='v5id12n'>/" /etc/libvirt/qemu/$vhost_name.xml
virsh define /etc/libvirt/qemu/$vhost_name.xml

virsh start $vhost_name
virsh autostart $vhost_name
virsh list --all
################################################################
