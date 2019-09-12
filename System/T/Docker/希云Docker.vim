Dockerfile 

#基础镜像文件
FROM 
#维护者
MAINTAINER

#环境变量
ENV

#添加
#ADD 可以拷贝文件并解压文件
#CP  只是拷贝文件到容器中

#采用分层技术 每执行一步Dockerfile里一条生成一层
#RUN shell 命令或脚本 安装进程管理工具 管理nginx php mysql等服务
#RUN pip install supervisor
RUN

#暴露22端口
EXPOSE

#Dockerfile中有多条ENTERPOINT指令 只有最后一条ENTERPOINT生效 
#container每次启动的时候需要执行的命令
ENTERPOINT

ENYERPOINT ['executable', 'param1', 'param2'] (the preferred exec form)
ENTERPOINT command param1 param2 (shell form)


CMD 
命令行中 指令可以覆盖dockerfile中的cmd指令
ENTERPOINT
若有多个ENTERPOINT则只有最后一个有效
命令行中指令会成为dockerfile中ENTERPOINT的后续参数
明确指定--enterpoint=/bin/bash 覆盖dockerfile中指令


#ONBUILD
#在当前的build镜像时不会生效 在下一次build镜像时生效
#即FROM 当前build生成的镜像(含有ONBUILD)时 生效 

#VOLUME
指定卷映射
-v host_dir:container_dir

排除文件或目录
.dockerignore
  Dockerfile

#使用Dockerfile生成docker镜像
#完整的命名规则
docker build -t register_url/namespace/iozh/centos6:V1 .

docker build -t iozh/centos6:v1 .
 

#生成docker镜像 通过docker镜像生成docker容器
docker run 
  -it     交互模式在前台启动
  -d      后台启动
  -p      2222:22 将22端口映射成2222 重启此映射也不会变化
  -P      22 随便启动一个端口进行映射 重启后端口会变化
  --name  容器名字
  -e      指定环境变量 环境变量应用在脚本中的变量
  从指定docker 镜像生成docker容器

企业应用中 一般是 基础镜像 中间件镜像 应用镜像


