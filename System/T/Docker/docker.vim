################################################
通过yum快速升级CentOS 6.x内核到3.10：
# rpm -ivh http://www.elrepo.org/elrepo-release-6-5.el6.elrepo.noarch.rpm
# yum --enablerepo=elrepo-kernel install kernel-lt -y
在grub.conf中确认装好的内核在哪个位置：
# vi /etc/grub.conf
default=0
重启系统，后查看内核信息：
# uname -r
3.10.65-1.el6.elrepo.x86_64
#----------
系统默认的iproute 没有 netns 子命令
这个可以不用升级内核 2.6.32/3.10.5版本内核下载安装即可

wget https://repos.fedorapeople.org/openstack/EOL/openstack-grizzly/epel-6/iproute-2.6.32-130.el6ost.netns.2.x86_64.rpm
rpm -ivh --replacefiles ./iproute-2.6.32-130.el6ost.netns.2.x86_64.rpm 
###############################################


######################Docker#########################
CentOS6.5 yum安装带aufs模块的3.10内核
cd /etc/yum.repos.d 
wget http://www.hop5.in/yum/el6/hop5.repo
yum install kernel-ml-aufs kernel-ml-aufs-devel
重启 
yum upgrade device-mapper-libs device-mapper-event-libs
yum install docker-io

/etc/rc.d/init.d/docker start
docker search centos6
docker pull centos:6.6
docker images
docker rmi
docker ps -a

docker run --name mydocker -it centos:6.6 /bin/bash
docker inspect --format "{{.State.Pid}}" mydocker
docker inspect mydocker

进入容器
nsenter --target 13180 --mount --uts --ipc --net --pid

端口映射
-P 随机映射
-p 指定端口映射
-p HostPort:ContainerPort
-p ip:hostPort:ContainPort

数据
-v /data
-v src_dir:container_dir
docker run -it --name docker_volumes_01 -v /data centos:6.6 /bin/bash
docker inspect -f {{.Volumes}} docker_volumes_01

  物理机上创建目录
  mkdir /data/docker/container_01 -pv 
docker run -it --name docker_container_01 -v /data/docker/container_01:/data centos:6.6 /bin/bash
docker run -it --name docker_container_02 --volumes-from docker_container_01 centos:6.6 /bin/bash

删除关闭的容器
docker ps -a | grep Exited | awk '{print $1}' | xargs -I {} docker rm {}

Dockerfile
FROM centos:6.6
MAINTAINER "iozh"
ADD pcre



创建镜像 From Dockerfile
docker build -t iozh/centos:6.7 .

根据镜像创建容器
docker run -d -p 2222:22 --name base iozh/centos:6.6 

#docker run -d -p 3306:3306 --name mysql -v host_dir:container_dir iozh/mysql:5.5

docker run -d -p 3306:3306 --name mysql -v /data/docker_data/mysql/v1:/data/mysql iozh/mysql:5.5_v1


进入容器
docker exec -it base /bin/base 

查看容器信息
docker ps           #运行状态的container
docker ps -a        #所有状态的container


基础镜像 iozh/centos:6.5 
中间件镜像
应用镜像

删除容器
docker ps -a | grep "Exited" | awk '{print $1 }'|xargs docker stop
docker ps -a | grep "Exited" | awk '{print $1 }'|xargs docker rm

创建容器
docker run -d -p 2222:22 --name base iozh/centos:6.7

默认显示处于running状态 container
docker ps
退出或非up状态的container
docker ps -a


基础镜像 中间件镜像 应用镜像


ENTRYPOINT 
多条ENTRYPOINT最后一条生效 执行

ENTRYPIONT ["executable", 'param1', 'param2'] 
ENTRYPOINT command param1 param2 


CMD
CMD ['executable', 'param1', 'param2'] #执行可执行文件并提供参数 
CMD ['param1', 'param2'] #为ENTRYPOINT指定参数
CMD command param1 param2 #shell形式

docker run -it iozh/t:0.1 /bin/bash #带命令参数 覆盖Dockerfile中CMD指令 /ENTRYPOINT 不会被覆盖
构建镜像 启动容器 带命令参数 覆盖Dockerfile中CMD指令 不会覆盖Dockerfile中的ENTRYPOINT指令
docker run -it --entrypoint=/bin/bash iozh/t:0.1 
够将镜像 启动容器 明确指定--entrypoint=cmd 可覆盖Dockerfile中的ENTRYPOINT指令


查找和删除失效的软链接
find -L /var/run/netns/ -type l -delete
