docker-ce 社区版

若已安装docker 清除如下
yum remove docker \
  docker-client \
  docker-client-latest \
  docker-common \
  docker-latest \
  docker-latest-logrotate \
  docker-logrotate \
  docker-selinux \
  docker-engine-selinux \
  docker-engine

rm -rf /var/lib/docker/
安装docker-ce
yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
yum-config-manager \
  --add-repo \
  https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
查看可用版本的docker-ce
yum list docker-ce --showduplicates | sort -r

yum install docker-ce-<VERSION STRING>

docker配置
#data-rootdocker数据持久化存储的根目录/var/lib/docker 更改为/data/docker
mkdir /data/docker
vim /etc/docker/daemon.json
{
  "registry-mirrors": ["https://d8b3zdiw.mirror.aliyuncs.com"],
  "dns": ["223.5.5.5"],
  "data-root": "/data/docker"
}

api操作 docker 开启远程端口 默认端口2375
vim /usr/lib/systemd/system/docker.service
ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:4000 -H unix:///var/run/docker.sock -H fd://

systemctl daemon-reload
systemctl restart docker

docker -H 127.0.0.1:4000 info

#拉取centos镜像
docker pull centos
docker pull busybox
docker pull nginx
docker pull mysql
docker pull

#交互运行
docker run -it --name my_centos centos bash

docker run --cpuset-spus 0 -it --rm -c 2048 image image_name

-m 50M #内存限制
-c 1024 #cpu限制 默认1024  权重

网络
-P 随机端口
-p 指定端口映射 对外端口:容器内端口
-p 81:80/udp  指定udp端口
-p 82:80      指定tcp端口
-p 192.168.1.90:83:80 指定端口绑定到的IP地址

docker 网络模式

docker network ls

bridge 桥接
host   共享宿主机的IP

创建桥接网络
docker network create --driver bridge my_net
docker network ls
#以执行的网络运行容器
docker run -it --rm --network=my_net busybox

#指定IP范围的 容器网络创建
docker network create --driver bridge --subnet 172.20.16.0/24 --gateway 172.20.16.1 my_net2
创建指定容器网络 指定容器内IP地址
docker run -it --rm --network=my_net2 --ip 172.20.16.100 busybox

用户自定义网络 可以ping通相互的的容器名称
自定义 容器名不要定义 真实域名  否则容器间不能相互ping通

# 192.168.1.91 操作
docker run -d -p 8500:8500 --name consul progrium/consul -server -bootstrap

cat /etc/docker/daemon.json
{
  "registry-mirrors": ["https://d8b3zdiw.mirror.aliyuncs.com"],
  "dns": ["223.5.5.5"],
  "data-root": "/data/docker",
  "cluster-store": "consul://192.168.1.91:8500",
  "cluster-advertise": "192.168.1.91:4000"
}

docker run -it --rm --network ov_net1 busybox

#192.168.1.90 操作
cat /etc/docker/daemon.json
{
  "registry-mirrors": ["https://d8b3zdiw.mirror.aliyuncs.com"],
  "dns": ["223.5.5.5"],
  "data-root": "/data/docker",
  "cluster-store": "consul://192.168.1.91:8500",
  "cluster-advertise": "192.168.1.90:4000"
}

#创建网络 不指定IP范围
docker network create -d overlay ov_net1
docker run -it --rm --network ov_net1 busybox

#创建网络 指定IP范围
docker network create -d overlay --subnet 10.10.0.0/16 ov_net2
docker run -it --rm --network ov_net2 busybox


#####目录挂载
mkdir /data/docker_data
docker run -it --rm -v /data/docker_data:/data centos bash