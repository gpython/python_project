容器 就是在隔离的环境里运行的一个进程 进程退出容器就会消失 隔离环境拥有自己的系统文件 ip地址 主机名

linux开机启动流程
bios开机硬件自检
根据bios设置的优选启动项boot 网卡 硬盘 u盘 光驱
读取mbr引导 2T UEFI gpt分区 mbr硬盘分区信息 内核加载路径
加载内核
启动第一个sbin/init(6) systemd(7)
系统初始化完成
运行服务

容器启动
公用宿主机内核
容器第一个进程直接启动服务
轻量级 损耗少 启动快 性能高


#镜像 导出 导入
docker image save alpine:latest > docker_alpine.tar.gz
docker rmi alpine:latest
docker load -i docker_alpine.tar.gz

#查看镜像分层信息 文件有变化的层数
docker image history nginx
镜像分层 一条指令一层 yum安装 yum clean 放在一行执行 减小镜像空间
文件系统overlay

docker镜像加速

vim /etc/docker/daemon.json
{
  ""registry-mirrors":": ["https://registry.docker-cn.com"],
}


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

#安装docker-ce
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

#查看可用版本的docker-ce
yum list docker-ce --showduplicates | sort -r

yum install docker-ce-<VERSION STRING>

#selinux报错执行
yum install https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-selinux-17.03.2.ce-1.el7.centos.noarch.rpm

yum install docker-ce-17.03.2.ce-1.el7.centos

#docker配置
#data-rootdocker数据持久化存储的根目录/var/lib/docker 更改为/data/docker/data
mkdir /data/docker/data -p
mkdir /etc/docker
cat > /etc/docker/daemon.json << EOF
{
  "registry-mirrors": ["https://d8b3zdiw.mirror.aliyuncs.com"],
  "dns": ["223.5.5.5"],
  "graph": "/data/docker/data"
}
EOF


#api操作 docker 开启远程端口 默认端口2376
vim /usr/lib/systemd/system/docker.service
ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2376 -H unix:///var/run/docker.sock -H fd://

systemctl daemon-reload
systemctl restart docker

docker -H 127.0.0.1:2376 info

#拉取centos镜像
docker pull centos
docker pull busybox
docker pull nginx
docker pull mysql
docker pull

#########交互运行
docker run -it --name my_centos centos bash

docker run --cpuset-spus 0 -it --rm -c 2048 image image_name

-m 50M #内存限制
-c --cpu-share 1024
  #cpu限制 默认1024  权重


docker ps -a -q status=exited
docker rm $(docker ps -a -q status=exited)


##############################网络#########################
源地址(宿主机):目标地址(容器)

-P 随机端口
-p 指定端口映射 对外端口:容器内端口
-p 81:80/udp  指定udp端口
-p 82:80      指定tcp端口
-p 192.168.1.90:83:80 指定端口绑定到的IP地址

docker exec    #启动新进程 进入容器
docker attach  #作为主进程进入容器
#容器内主进程关闭后 exec attach 进入的容器都会推出


###################Dockerfile############################
基础的操作镜像 ubuntu debian  centos alpine
docker空白镜像 scratch go语言开 发的很多程序会使用此空白镜像来 制作镜像

mkdir d1
cd d1

vim Dockerfile

FROM nginx

RUN echo '<h1>Hello Nginx</h1>' > /usr/share/nginx/html/index.html

#构建镜像 名称nginx:v1
docker build -t nginx:v1 .

#运行 nginx:v1 镜像
docker run -d -p 8080:80 nginx:v1

RUN
  RUN 执行命令并创建新的镜像层，RUN 经常用于安装软件包

  shell 格式 RUN <命令>
  exec  格式 RUN [“可执行文件", "参数1”, ”参数2"]

COPY 复制文件
  <源路径> 可以是多个 甚至是通配符
  源文件各种元数据都会保留 读 写 执行 文件变更时间
  <目标路径> 可以使用容器的绝对路径 也可以是相对于工作目录的相对路径 工作目录使用WORKDIR 指令指定
  <目标路径> 不需要实现创建 如果目录不存在 会在复制文件前先行创建缺失目录
  COPY [--chown=<user>:<group>] <源路径(宿主机路径)> <目标路径(容器内路径)>
  COPY hom* /container/dir/
  copy hom?.txt /container/dir/

ADD 更高级复制文件
  <源路径>为tar压缩文件 压缩格式为gzip bzip2 xz情况 ADD指令将自动解压这个压缩文件到 <目标路径>
  COPY不会解压

CMD 容器启动命令
  CMD 设置容器启动后默认执行的命令及其参数，
  但 CMD 能够被 docker run 后面跟的命令行参数替换

  shell 格式 CMD <命令>
  exec  格式 CMD [”可执行文件”, ”参、、



  数1”, ”参数2”]
  一般推荐使用exec格式 这种格式会被解析为json数组 因此一定要使用双引号
  CMD [”nginx”, ”-g”, ”daemon off;”]

  CMD service nginx start 实际执行为 CMD ["sh","-c", "service nginx start"]
  因此主进程实际是 sh 那么当service nginx start命令结束后 sh作为主进程就推出了 容器退出

  CMD 指令允许用户指定容器的默认执行的命令。
    此命令会在容器启动且 docker run 没有指定其他命令时运行。
    如果 docker run 指定了其他命令，CMD 指定的默认命令将被忽略。
    如果 Dockerfile 中有多个 CMD 指令，只有最后一个 CMD 有效。

ENTRYPOINT 入口点
  ENTRYPOINT 指令可让容器以应用程序或者服务的形式运行。
    ENTRYPOINT 看上去与 CMD 很像，它们都可以指定要执行的命令及其参数。不同的地方在于 ENTRYPOINT 不会被忽略，一定会被执行，即使运行 docker run 时指定了其他命令。
    ENTRYPOINT 有两种格式：
      Exec 格式：ENTRYPOINT ["executable", "param1", "param2"] 这是 ENTRYPOINT 的推荐格式。
      Shell 格式：ENTRYPOINT command param1 param2
      在为 ENTRYPOINT 选择格式时必须小心，因为这两种格式的效果差别很大。
    Exec 格式
      ENTRYPOINT 的 Exec 格式用于设置要执行的命令及其参数，同时可通过 CMD 提供额外的参数。
      ENTRYPOINT 中的参数始终会被使用，而 CMD 的额外参数可以在容器启动时动态替换掉。

      比如下面的 Dockerfile 片段：
      ENTRYPOINT ["/bin/echo", "Hello"]
      CMD ["world"]

    *->  当容器通过 docker run -it [image] 启动时，输出为：
      Hello world

    *->  而如果通过 docker run -it [image] CloudMan 启动，则输出为：
      Hello CloudMan

    FROM centos
    ENV name Docker
    ENTRYPOINT ["echo", "hello $name"]
    ----->#hello $name
    ENTRYPOINT ["/bin/bash", "-c", "echo", "hello $name"]
    ----->#null
    ENTRYPOINT ["/bin/bash", "-c", "echo hello $name"]
    ----->#hello Docker

    Shell 格式
    *->  ENTRYPOINT 的 Shell 格式会忽略任何 CMD 或 docker run 提供的参数

ENV 设置环境变量
  ENV <key> <Vlaue>
  ENV <key>=<Value> <key>=<value>

VOLUME 挂载匿名卷
 docker volume ls 显示创建的随机卷
 启动容器随机创建不同卷 将VOLUME指定目录里内容持久化

EXPOSE 声明端口
  仅仅声明容器打算使用什么端口 并不会自动在宿主机进行端口映射
  容器运行时 使用随机端口映射时 也就是 docker run -P时 会自动随机映射EXPOSE的端口
  要将EXPOSE和运行时使用 -p<宿主端口>:<容器端口>区分开

WORKDIR 指定工作目录 (切换目录)
  以后各层的当前目录就被改为指定的目录 如果目录不存在 WORKDIR会帮你建立目录
  WORKDIR /data
  RUN ...
  使用 docker run -it 进入容器时 pwd显示的路径就是WORKDIR指定的目录

USER 指定当前用户

健康检查
将当前文件添加到容器内
ADD test.sh /test.sh

健康检查周期10s 超时3s 重试3次 健康检查运行的进程是否有异常 退出码 0 或 非0
HEALTHCHECK --interval=10s --timeout=3s --retries=3 CMD /bin/bash /test.sh

#########以脚本方式启动 传入变量
#!/bin/bash
echo "$SSH_PWD" | password --stdin root
service sshd restart
nginx -g "daemon off;"


容器间互访
docker run -it --link 容器B名称:容器B别名 image_A:tag /bin/bash
进入image_A:tag容器内 容器hosts文件中有   容器B ip 和 容器B别名

hosts文件 每次启动容器时挂载进容器里边的
通过主机名或别名就能连接到 --link 指定的容器
--link为单向 原理就是hosts内加一条主机的解析


docker run -it --link mysql:mysql nginx_web:v1 /bin/bash
ping mysql



#########docker 网络模式 ########################
#######network namespace 网络命名空间
#创建 两个 网络命名空间
ip netns add ns1
ip netns add ns2

#在 ns1 这个网络命名空间内 exec 执行 ip a命令
ip netns exec ns1 ip a
ip netns exec ns1 ip link

#添加一对ip link
ip link add veth-ns1 type veth peer name veth-ns2

#将 veth-ns1/ns2 这个接口添加到 网络命名空间 ns1/ns2 中
ip link set veth-ns1 netns ns1
ip link set veth-ns2 netns ns2

#查看主机ip link 发现 veth-ns1 veth-ns2都不存在
ip link

#查看 网络命名空间 ns1/ns2 的ip link
#此时状态为DOWN 并且没有IP 地址
ip netns exec ns1 ip link
ip netns exec ns2 ip link

#网络命名空间 ns1/ns2 中的网卡设备veth-ns1/ns2分配 IP地址
ip netns exec ns1 ip addr add 192.168.10.1/24 dev veth-ns1
ip netns exec ns2 ip addr add 192.168.10.2/24 dev veth-ns2

#网络命名空间 ns1/ns2 中的网卡设备veth-ns1/ns2 UP
ip netns exec ns1 ip link set dev veth-ns1 up
ip netns exec ns2 ip link set dev veth-ns2 up

#查看 网络命名空间 ns1/ns2 中网卡设备 状态
ip netns exec ns1 ip link
ip netns exec ns2 ip link

#网络命名空间 ns1/ns2 连通性测试
ip netns exec ns1 ping 192.168.10.2
ip netns exec ns2 ping 192.168.10.1


#############
docker network ls
docker network inspect bridge

brctl show

bridge 桥接
host   共享宿主机的IP

#创建桥接网络
docker network create --driver bridge my_bridge
docker network ls

#以执行的网络运行容器
docker run -it --rm --network=my_bridge busybox

#指定IP范围的 容器网络创建
docker network create --driver bridge --subnet 172.20.16.0/24 --gateway 172.20.16.1 my_beidge_2

#创建指定容器网络 指定容器内IP地址
docker run -it --rm --network=my_bridge_2 --ip 172.20.16.100 busybox

#将容器 container_name 连接到 网络 my_bridge_2 可连接多个 即有多个网卡 IP
docker network connect my_bridge_2 container_name

#用户自定义网络 可以ping通相互的的容器名称
#自定义 容器名不要定义 真实域名  否则容器间不能相互ping通


################### 跨主机网络通信 之 macvlan (手动指定IP)
#跨主机容器之间通信 Maclan网络 (需手动指定IP地址)

#默认一个物理网卡只有一个物理地址 虚拟多个mac地址
#与宿主机网卡在同一个物理网络中

#创建macvlan网络
docker network create --driver macvlan --subnet 192.168.1.0/24 --gateway 192.168.1.254 -o parent=eth0 macvlan_1

#设置eth0网卡为混杂模式 (centos可以不用设置)
ip link set eth1 promisc on

#创建使用macvlan网络的容器 (手动指定IP地址 IP不能冲突)
docker run -it --network macvlan_1 --ip=192.168.1.100 centos7:v1 /bin/bash

Maclan 公用宿主机网络

##############跨主机网络通信 之 overlay consul数据库存储(自动分配IP)
# 192.168.1.91 操作
#-h, --hostname string     Container host name
#-server -bootstrap     作为参数跟在entrypoint指定命令后边启动
#IP 地址分配都集中的consul数据库中

docker run -d -p 8500:8500 --restart=always --name consul -h consul progrium/consul -server -bootstrap

cat /etc/docker/daemon.json
{
  "registry-mirrors": ["https://d8b3zdiw.mirror.aliyuncs.com"],
  "dns": ["223.5.5.5"],
  "data-root": "/data/docker",

  #监听端口 又启动socket systemd中可能有配置 两处配置更改一处即可
  "hosts": ["tcp://0.0.0.0:2376", "unix:///var/run/docker.sock"],
  #集群存储信息Ip地址
  "cluster-store": "consul://192.168.1.91:8500",
  #区分每一个节点的唯一标识
  "cluster-advertise": "192.168.1.91:2376"
}

#192.168.1.90 操作
cat /etc/docker/daemon.json
{
  "registry-mirrors": ["https://d8b3zdiw.mirror.aliyuncs.com"],
  "dns": ["223.5.5.5"],
  "data-root": "/data/docker",

  #监听端口 又启动socket systemd中可能有配置
  "hosts": ["tcp://0.0.0.0:2376", "unix:///var/run/docker.sock"],
  #集群存储信息IP地址 同一个
  "cluster-store": "consul://192.168.1.91:8500",
  #区分每一个节点的唯一标识
  "cluster-advertise": "192.168.1.90:2376"
}

systemctl restart docker

#创建网络 在一台机器上执行即可
#创建网络 不指定IP范围 -d --driver
docker network create -d overlay ov_net1
docker run -it --rm --network ov_net1 busybox

#创建网络 指定不存在的网段 -d --driver
docker network create -d overlay --subnet 10.10.0.0/16 --gateway 10.10.0.254 ov_net2


docker network ls

#启动容器测试 每个容器有两块网卡 eth0实现容器间通信 eth1实现容器访问外网
docker run -it --rm --network ov_net2 busybox

eth0 为宿主机之间建立隧道 容器见相互连接
eth1 通过docker_gwbridge网桥 nat转换 通过宿主机网卡 访问外网

访问sonsul http://192.168.1.91:8500

##############跨主机网络通信 之 overlay network (etcd)###
#跨宿主机 docker容器间通信
tar zxvf etcd-v3.3.12-linux-amd64.tar.gz -C /usr/local/
chown root.root /usr/local/etcd-v3.3.12-linux-amd64/ -R
ln -s /usr/local/etcd-v3.3.12-linux-amd64 /usr/local/etcd

#10-10-10-50
nohup /usr/local/etcd/etcd --name infra-50 \
--initial-advertise-peer-urls http://10.10.10.50:2380 \
--listen-peer-urls http://10.10.10.50:2380 \
--listen-client-urls http://10.10.10.50:2379,http://127.0.0.1:2379 \
--advertise-client-urls http://10.10.10.50:2379 \
--initial-cluster-token etcd-cluster \
--initial-cluster infra-50=http://10.10.10.50:2380,infra-51=http://10.10.10.51:2380 \
--initial-cluster-state new &

#10-10-10-51
nohup /usr/local/etcd/etcd --name infra-51 \
--initial-advertise-peer-urls http://10.10.10.51:2380 \
--listen-peer-urls http://10.10.10.51:2380 \
--listen-client-urls http://10.10.10.51:2379,http://127.0.0.1:2379 \
--advertise-client-urls http://10.10.10.51:2379 \
--initial-cluster-token etcd-cluster \
--initial-cluster infra-50=http://10.10.10.50:2380,infra-51=http://10.10.10.51:2380 \
--initial-cluster-state new &

#状态检查
/usr/local/etcd/etcdctl cluster-health

vim /usr/lib/systemd/system/docker.service
#10-10-10-50
ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2376 -H fd:// --containerd=/run/containerd/containerd.sock --cluster-store=etcd://10.10.10.50:2379 --cluster-advertise=10.10.10.50:2376
#10-10-10-51
ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2376 -H fd:// --containerd=/run/containerd/containerd.sock --cluster-store=etcd://10.10.10.51:2379 --cluster-advertise=10.10.10.51:2376


#创建overlay 网络
#10-10-10-50 在一台机器上执行 即可
docker network create -d overlay demo

#50 51机器上 都会显示 demo
docker network ls

#显示
/usr/local/etcd/etcdctl ls

docker network inspect demo

docker run -it --rm --net demo busybox /bin/sh
ip add ls


# 此时网络情况 demo(跨主机docker容器通信) docker_gwbridge(连接到宿主机 对外通信)
docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
227e49917d5d        bridge              bridge              local
32204dee8680        demo                overlay             global  <-----
3e74aa28e68f        docker_gwbridge     bridge              local   <-----
50ce37ff1486        host                host                local
b974af85a29f        none                null                local


##########Volume 目录挂载################################
#受管理的data volume 由docker后台自动创建
#绑定挂载的volume 具体挂载位置可以由用户指定

mkdir /data/docker_data
#-v 宿主目录:容器内目录    在容器内/data/目录对应到宿主机的/data/docker_data
#将宿主机目录挂载到 容器指定的目录
#一般不挂载文件 可能因文件更改 inode号改变 而出问题
docker run -it --rm -v /data/docker_data:/data centos bash

#容器目录 和 宿主机目录相同 此时容器内有个 /data/docker_data 目录
docker run -it --rm -v /data/docker_data centos bash

#--volumes-from


##dockerfile

#### 数据持久化方式1 Data Volume
VOLUME ["/var/lib/mysql"]

#使用mysql默认的volume 名称为一串 随机数
docker run -d --name mysql -e MYSQL_ALLOW_EMPTY_PASSWORD=true mysql:5.7

#将mysql默认volume 名称 指定为 mysql
docker run -d --name mysql -v mysql:/var/lib/mysql -e MYSQL_ALLOW_EMPTY_PASSWORD=true mysql:5.7
docker run -it mysql /bin/bash
docker stop mysql
docker run -d --name mysql2 -v mysql:/var/lib/mysql mysql:5.7

docker volume ls
docker volume inspect xxxxx
docker volume rm  xxxxx

#### 数据持久化方式2 Bind Mouting
docker run -v /home/aaa:/root/aaa

#将 宿主机 当前目录 映射到 docker /usr/share/nginx/html 目录
docker run -d --name nginx_2 -v $(pwd):/usr/share/nginx/html -p 8082:80 nginx:v4
docker exec -it nginx_2 /bin/bash

####wordpress
docker run -d --name mysql -v mysql-data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=wordpress mysql:5.7

docker run -d -e WORDPRESS_DB_HOST=mysql:3306 --link mysql -p 8082:80 wordpress


#指定目录卷
docker run -d -p 80:80 -v /data/volume/nginx:/usr/share/nginx/html nginx

#docker自动创建卷
docker run -d --name nginx_v -p 81:80 -v nginx:/usr/share/nginx/html nginx

docker volume inspect nginx

docker volume ls

################################
一个容器里可以运行多个进程，所以总是可以运行新的进程去看看里面发生了什么。

运行在容器中的进程是运行在主机操作系统上的

进程的ID在容器中与主机上不同。容器使用独立的PIDLinux命名空间并且
有着独立的系列号，完全独立于进程树。

应用不仅拥有独立的文件系统，还有进程、用户、主机名和网络接口
docker top container_name
docker stats



#####################docker-compose######################
yum install python-pip

mkdir ~/.pip
cat > .pip/pip.conf << EOF
[global]
timeout = 60
index-url = http://pypi.douban.com/simple
trusted-host = pypi.douban.com
EOF

pip install docker-compose

Service

一个service代表一个container 这个container可以从dockerhub的image来创建
或者从本地dockerfile build出来的的image来创建

service的启动类似docker run 可以指定network 和 volume
可以给service指定network 和volume的引用

cd /data/docker-compose/web
vim docker-compose.yml

web1:
  image: nginx
  volumes:
    - /opt/index1.html:/usr/share/nginx/html/index.html
  expose:
    - 80

web2:
  image: nginx
  volumes:
    - /opt/index2.html:/usr/share/nginx/html/index.html
  expose:
    - 80

haproxy:
  image: haproxy
  volumes:
    - /opt/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg
  links:
    - web1
    - web2
  ports:
    - "7777:1080"
    - "80:80"


###############
vim docker-compose.yml
version: '3'

services:
  db:
    image: mysql:5.7
    volumes:
      - db_data: /var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: pas4wd
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress

  wordpress:
    depends_on:
      - db
    image: wordpress:lastest
    volumes:
      - web_data:/var/www/html
    ports:
      - "80"
    restart: always
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress

volumes:
  db_data:
  web_data:
#####################################

#ports:
  - "80:80" 宿主机端口:容器端口
  - "80"    宿主机随机端口 映射到容器80端口 scale时候使用随机端口映射


##############
#docker-compose.yml

#启动方式 -d 后台启动
#指定配置文件方式启动
docker-compose -f docker-compose.yml up -d
#不指定配置文件 默认读取当前路径下 docker-compose.yml配置文件
docker-sompose up -d

#启动顺序 被依赖的镜像 先启动 顺序如下
web1_1
web2_1
haproxy_1



#volumes 挂载  本机路径:容器内路径
volumes:
    - /opt/haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg
    #本机路径配置文件:挂载到容器的相应路径的文件
    #默认haproxy容器内 读取的配置文件是 /usr/local/etc/haproxy/haproxy.cfg
    #将本地的配置文件路径 挂载 到容器内读取配置文件的相应路径

#expose 镜像提供的端口 不是暴露端口
#告诉系统  容器内部开放的端口为多少
#只被链接的服务访问 内部调用
expose:
  - 80

#ports 暴露端口(-p)
#  - "本机宿主机端口:镜像提供的端口"
#宿主机端口 映射到 镜像的端口
ports
  - ”7777:1080”
  - "80:80"

#links 依赖 先后顺序 依赖
#以来web1 web2先启动后 在启动当前镜像
links:
  - web1
  - web2

#
docker-compose up -d
docker-compose ps
docker-compose images
docker-compose exec compose-container-name /bin/bash


#scale 扩容
docker-compose up -d --scale web=10

#缩减
docker-compose up -d --scale web=5

docker volume ls
docker network ls

#有需要通过Dockerfile build 可以先build
docker-compose build

#######################################################
文件系统隔离 每个进程容器运行在一个完全独立的根文件系统里
资源隔离    系统资源 像CPU 内存等可以分配到不同的容器中 cgroup
网络隔离    每个进程容器运行在自己的网络空间 虚拟接口和IP地址
日志记录    Docker将会收集和记录每个进程容器的标准流(stdin stdout stderr)
变更管理    容器文件系统的变更可以提交到新的镜像中 并可重复使用以创建更多的容器 无需使用模板或手动配置
交互shell  分配虚拟终端 关联到任何容器的标准输入上

##########私有仓库 Harbor###########
Harbor依赖docker 和docker-compose

wget https://storage.googleapis.com/harbor-releases/release-1.7.0/harbor-offline-installer-v1.7.1.tgz
tar zxvf harbor-offline-installer-v1.7.1.tgz -C /data
cd /data/harbor

#配置
vim harbor.cfg
hostname=192.168.1.91

#安装
./install.sh

#登录进http://192.168.1.74/harbor/projects 创建项目

#上传镜像到harbor
#1)添加白名单
vim /etc/docker/daemon.json
"insecure-registries": ["192.168.1.91"],

#2)登录harbor
docker login 192.168.1.91

#3)打标签
docker tag nginx:lastest 192.168.1.91/registry/nginx:v1

#4)push
docker 192.168.1.91/registry/nginx:v1



##################Dcoker Swarm###############################
#三个节点
Manager 节点 10.10.10.50
Worker  节点 10.10.10.51
Worker  节点 10.10.10.52

#初始化swarm manager节点 会输出添加worker 节点的命令
#在worker机器上执行输出的命令 即可

docker swarm init --advertise-addr=10.10.10.50

  #输出如下 信息
  #Swarm initialized: current node (1pytxcdezr1nplte7zr5xk3g7) is now a manager.
  #To add a worker to this swarm, run the following command:
  docker swarm join --token SWMTKN-1-31an26ivzjax5ehuvewjfb36kn7xyo3zz5nr3k6q7wfev5nplg-6o4olx7d13d56ifjk726pwmj4 10.10.10.50:2377
  #To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.

  #将docker swarm join 信息在woeker机器上执行 即可

docker node ls
  #显示docker swarm 节点信息


docker service create
  #在docker swarm 模式下使用docker service create 创建 容器

#通过docker service 创建container  容器名称demo
docker service create --name demo busybox sh -c "while true; do sleep 3600; done"

#显示 service  REPLICAS 扩展信息
docker service ls
#横向扩展service demo为容器名称 5为扩展的数量
docker service scale demo=5


#显示service 所运行的节点信息
docker service ps demo


#多应用环境
manager节点操作
创建overlay网络
docker network create -d overlay demo

#MySQl
docker service create --name mysql --env MYSQL_ROOT_PASSWORD=root --env MYSQL_DATABASES=wordpress --network demo --mount type=volume,source=mysql-data,destination=/var/lib/mysql mysql:5.7

#Wordpress
docker service create --name wordpress -p 80:80 --env WORDPRESS_DB_PASSWORD=root --env WORDPRESS_DB_HOST=mysql --network demo wordpress

DNS服务发现
docker swarm 内置DNS服务发现功能
创建service的时候 如果此service是连接到overlay网络环境下
此时会为链接到overlay网络环境下的service添加DNS记录 VIP
每个service 创建后都会 为此service分配一个vip service分配到不同的主机上 但是vip不会变

#运行whoami service
docker service create --name whoami -p 8000:8000 --network demo -d jwilder/whoami

#查看whoami所在的主机
docker service ps whoami

#在whoami所在的主机上查看运行容器的 container id
docker ps

curl http://127.0.0.1:8000

docker service create --name client -d --network demo busybox sh -c "while true; do sleep 3600; done"

docker service scale whoami=5

#进入某个容器内进行测试
docker exec -it contain_id /bin/sh
 #ping whoami
 #nslookup whoami
 #nslookup tasks.whoami

###Routing Mesh的两种体现####

Internal
  Container 与Container 之间的访问通过overlay网络 (通过vip虚拟ip)

Ingress
  如果服务有绑定接口 则此服务可以通过任意swarm节点相应的接口访问


#################Ingress Network##################
yum install ipvsadm

iptables -t nat -nvxL
ifconfig
brctl show
docker network ls
docker network inspect docker_gwbridge

#查看network namespace
ll /var/run/docker/netns/

#进入ingress_sbox 这个network namespace 查看其IP信息
nsenter --net=/var/run/docker/netns/ingress_sbox

ip add ls

iptables -t mangle -nL

ipvsadm -l

#退出ingress_box network namespace
exit



#####################Kubernetes###################
kubectl config get-contexts

Pod
    一个pod是一组紧密相关的容器，它们总是一起运行在同一个工作节点上，以
及同一个 Linux 命名空间中。每个pod 就像一个独立的逻辑机器，拥有自己的 IP
主机名、进程等，运行一个独立的应用程序。应用程序可以是单个进程，运行在单
个容器中，也可以是一个主应用进程或者其他支持进程，每个进程都在自己的容器
中运行。一个pod 的所有容器都运行在同一个逻辑机器上，而其他 pod 中的容器，
即使运行在同一个工作节点上，也会出现在不同的节点上
  术语调度（ scheduling ）的意思是将 pod 配给 个节 ，点 pod 立即运行，
而不是将要运行

  kubemetes 基本构
件是 pod 。但是，你并没有真的创建出任何 pod 少不是直接创建 通过运行
kubectl run 命令，创建了 ReplicationController ，它用于创建 pod 实例 为
了使该 pod 能够从集群外部访问，需要让 kubernetes ReplicationController 管理
的所有 pod 由一个服务对外暴露。

  pod 由 一个 ReplicationController 管理
  —个pod的所有容器都运行在同—个节点上； 一个pod绝不跨越两个节点
  Kubemetes 通过配置 Docker 来让一个 pod 内的
所有容器共享相同的 Linux 命名空间， 而不是每个容器都有自己的一组命名空间

  kubectl get pod kubia-687774d787-652qf -o yaml


  查看应用程序日志
    docker logs <container id>

    使用 kubectl logs 命令获取 pod 日志
    kubec七1 logs kubia-manual

    获取多容器 pod 的日志时指定容器名称
    kubec七l logs kubia-manual -c kubia

  向pod发送请求
    将本地网络端口转发到 pod 中的端口
    kubectl port-forward kubia-manual 8888:8080
    curl localhost 8888

  使用标签组织pod
    标签是可以附加到资源的任意键值对
    只要标签的key在资源内是唯一的， 一个资源便可以拥有多个标签
    app, 它指定pod属于哪个应用、 组件或微服务。
    rel, 它显示在pod中运行的应用程序版本是stable、beta还是canary

    pod并不是唯一可以附加标签的Kubemetes资源。 标签可以附加到
    任何Kubemetes对象上， 包括节点。

    kubectl get pod -l app=nginx

    使用标签分类工作节点
      kubectl label node gke-kubia-85f6-node-Orrx gpu=true
      kubectl ge七 nodes -1 gpu=true

    将pod调度到特定节点
apiVersion: vl
kind: Pod
metadata:
  name: kubia-gpu
spec:
  #node节点选择
  nodeSelector:
    gpu: "true"
  containers:
    - image: luksa/kubia
      name: kubia

    发现其他命名空间及其 pod
      kubectl get ns
      kubectl get pod --namespace kube-system

      kubectl create namespace custom-namespace
      kubectl create -f kubia-manual.ya -n custom-na espace
    要想快速切换到不 同的命 名空 可以设 直以 下别名： alias
kcd="kubectl config set context $ (kubectl config currentcontext) -- namespace" 然后，可以使用 kcd some-namespace 在命名空
间之间进行切

  停止和移除pod
    按名称删除 pod
    使用标签选择器删除 pod
    通过删除整个命名空间来删除 pod

  HTTPGET探针对容器的 IP 地址（你指定的端口和路径）执行 HTTP GET 请求
  如果探测器收到响应，并且响应状态码不代表错误（换句话说，如果HTTP
  响应状态码是2xx或3xx), 则认为探测成功。如果服务器返回错误响应状态
  码或者根本没有响应，那么探测就被认为是失败的，容器将被重新启动。

  TCP套接字探针尝试与容器指定端口建立TCP连接。如果连接成功建立，则
  探测成功。否则，容器重新启动。

  Exec探针在容器内执行任意命令，并检查命令的退出状态码。如果状态码
  是 o, 则探测成功。所有其他状态码都被认为失败。

  要设置初始延迟 initialDelaySeconds属性添加到存活探针的配置中
  务必记得设置一个初始延迟未说明应用程序的启动时间

  退出代码137表示进程被外部信号终止， 退出代码为128+9 (SIGKILL)。
  退出代码143对应于128+15 (SIGTERM)

  是k8s的调度最小单元
  每个Pod共享一个namespace (用户 网络 存储)
  假设一个Pod 内有3个容器 则三个容器共享一个网络namespace 可通过localhost通信

  kubectl get pods
  kubectl get pods -o wide

  kubectl exec -h
  kubectl exec -it nginx sh

  kubectl api-resources
  kubectl describe pods
  kubectl describe pods nginx

  使用 DaemonSet在每个节点上运行一个pod
  使用 DaemonSet 只在特定的节点上运行 pod node标签选择

  安排Job定期运行或在将来运行一次
  运行执行单个任务的pod
    #Job属于batch API组 版本为v1
    apiVersion: batch/vl
    kind: Job


ReplicationController
  一个ReplicationController有三个主要部分（如图4.3所示）：
  • label selector ( 标签选择器）， 用于确定ReplicationController作用域中有哪些pod
  • replica count (副本个数）， 指定应运行的pod 数量
  • pod template (pod模板）， 用于创建新的pod 副本

  将 pod 移入或移出 ReplicationController 的作用域
    由ReplicationController创建的pod并不是绑定到ReplicationController。 在任
    何时刻， ReplicationController管理与标签选择器匹配的pod。 通 过更改pod的标
    签， 可以将它 从ReplicationController的作用域中添加或删除。 它甚至可以从一个
    ReplicationController 移动到另一个

  通过编辑定义来缩放ReplicationController
  用kubectl scale命令缩容
    所有这些命令都会修改ReplicationController定 义的spec.rep巨cas字段，
    就像通过kubectl ed江进行更改一 样。


#replicasets  rs

  kubectl get rs -o wide
  kubectl delete pods pod_name
  kubectl scale rs nginx --replicas=2

Deployments
  描述一个期待的deployment状态
  deployment controller 可以更改到期待的状态
  通过deployment创建的replicasets 或 pod 只能通过deployments来操作改变replicasets 或pod的状态
  kubectl get deploy -o wide
  kubectl get deployment
  kubectl get rs
  kubectl get pods

  kubectl create deployment kubia --image=kubia:v3
  kubectl get deployment
  kubectl get rs
  kubectl get pod

  kubectl set image deployment kubia kubia=kubia:v4

  #通过deployment 设置nginx的镜像版本为1.13 nginx-deployment为deploy名称
  kubectl set image deployment nginx-deployment nginx=nginx:1.13
  kubectl get deploy -o wide
  kubectl get rs -o wide
  kubectl get pods -o wide

  #查看deploy名称为nginx-deployment的历史版本
  kubectl rollout history deploy nginx-deployment

  #回到之前的版本
  kubectl rollout undo deploy nginx-deployment

Service
  kubectl expose 给pod创建一个Service 供外部访问
  Service主要有三种类型 一种ClusterIP 一种NodePort 一种叫做外部的LoadBalancer
  也可以使用DNS 需要DNS 的add-on

  环境变量是获得服务 IP 地址和端口号的一种方式，
  kubectl exec kubia-3inly env

  通过 FQDN 连接服务
  backend-database.default.svc.cluster.local
   backend database 对应于服务名称， default 表示服务在其中定义的名称
   间，而 svc.cluster.l ocal 是在所有集群本地服务名称 中使用的可配置集群
   域后缀。
   如果前端 pod 和数据库 pod 在同一个命名
   空间下，可以省略 svc.cluster local 后缀，甚至命名空间 因此可以使用
   backend database 来指代服务



  kubectl expose deployment kubia --port=8080 --target-port=8080

  kubectl expose pods nginx-pod
  kubectl get svc -o wide

数据卷
  Kubemetes 通过定义存储卷来满足这个需求， 它们不像 pod 这样的顶级资源，
而是被定义为 pod 的一部分， 并和 pod 共享相同的生命周期。 这意味着在 pod 启动
时创建卷， 并在删除 pod时销毁卷。 因此， 在容器重新启动期间， 卷的内容将保持
不变， 在重新启动容器之后， 新容器可以识别前一个容器写入卷的所有文件。 另外，
如果一个 pod 包含多个容器， 那这个卷可以同时被所有的容器使用。