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

#docker配置
#data-rootdocker数据持久化存储的根目录/var/lib/docker 更改为/data/docker
mkdir /data/docker
vim /etc/docker/daemon.json
{
  "registry-mirrors": ["https://d8b3zdiw.mirror.aliyuncs.com"],
  "dns": ["223.5.5.5"],
  "data-root": "/data/docker"
}

#api操作 docker 开启远程端口 默认端口2375
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

#########交互运行
docker run -it --name my_centos centos bash

docker run --cpuset-spus 0 -it --rm -c 2048 image image_name

-m 50M #内存限制
-c 1024 #cpu限制 默认1024  权重


docker ps -a -q status=exited
docker rm $(docker ps -a -q status=exited)


##############################网络#########################
-P 随机端口
-p 指定端口映射 对外端口:容器内端口
-p 81:80/udp  指定udp端口
-p 82:80      指定tcp端口
-p 192.168.1.90:83:80 指定端口绑定到的IP地址


###################Dockerfile############################
基础的操作镜像 ubuntu debian  centos alpine
docker空白镜像 scratch go语言开 发的很多程序会使用此空白镜像来 制作镜像

mkdir d1
cd d1

vim Dockerfile

FROm nginx

RUN echo '<h1>Hello Nginx</h1>' > /usr/share/nginx/html/index.html

#构建镜像 名称nginx:v1
docker build -t nginx:v1 .

#运行 nginx:v1 镜像
docker run -d -p 8080:80 nginx:v1

RUN
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

CMD 容器启动命令
  shell 格式 CMD <命令>
  exec  格式 CMD [”可执行文件”, ”参数1”, ”参数2”]
  一般推荐使用exec格式 这种格式会被解析为json数组 因此一定要使用双引号
  CMD [”nginx”, ”-g”, ”daemon off;”]

  CMD service nginx start 实际执行为 CMD ["sh","-c", "service nginx start"]
  因此主进程实际是 sh 那么当service nginx start命令结束后 sh作为主进程就推出了 容器退出




ENTRYPOINT 入口点



#########docker 网络模式 ####################################
docker network ls

bridge 桥接
host   共享宿主机的IP

#创建桥接网络
docker network create --driver bridge my_net
docker network ls

#以执行的网络运行容器
docker run -it --rm --network=my_net busybox

#指定IP范围的 容器网络创建
docker network create --driver bridge --subnet 172.20.16.0/24 --gateway 172.20.16.1 my_net2

#创建指定容器网络 指定容器内IP地址
docker run -it --rm --network=my_net2 --ip 172.20.16.100 busybox

#用户自定义网络 可以ping通相互的的容器名称
#自定义 容器名不要定义 真实域名  否则容器间不能相互ping通

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
#-v 宿主目录:容器内目录    在容器内/data/目录对应到宿主机的/data/docker_data
#将宿主机目录挂载到 容器指定的目录
#一般不挂载文件 可能因文件更改 inode号改变 而出问题
docker run -it --rm -v /data/docker_data:/data centos bash

#容器目录 和 宿主机目录相同 此时容器内有个 /data/docker_data 目录
docker run -it --rm -v /data/docker_data centos bash

#--volumes-from


##dockerfile


docker-compose

pip install docker-compose



cd /opt/
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



#######################################################
文件系统隔离 每个进程容器运行在一个完全独立的根文件系统里
资源隔离    系统资源 像CPU 内存等可以分配到不同的容器中 cgroup
网络隔离    每个进程容器运行在自己的网络空间 虚拟接口和IP地址
日志记录    Docker将会收集和记录每个进程容器的标准流(stdin stdout stderr)
变更管理    容器文件系统的变更可以提交到新的镜像中 并可重复使用以创建更多的容器 无需使用模板或手动配置
交互shell  分配虚拟终端 关联到任何容器的标准输入上



