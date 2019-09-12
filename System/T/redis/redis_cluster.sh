#!/bin/bash
###############Redis集群###########
#架构细节:
#所有的redis节点彼此互联(PING-PONG机制),内部使用二进制协议优化传输速度和带宽.
#节点的fail是通过集群中超过半数的节点检测失效时才生效.
#客户端与redis节点直连,不需要中间proxy层.客户端不需要连接集群所有节点,连接集群中任何一个可用节点即可
#redis-cluster把所有的物理节点映射到[0-16383]slot上,cluster 负责维护node<->slot<->key
#Redis集群预分好16384个桶，当需要在 Redis 集群中放置一个 key-value 时，根据 CRC16(key) mod 16384的值，决定将一个key放到哪个桶中。

#环境准备
#Redis集群中要求奇数节点，所以至少要有三个节点，并且每个节点至少有一备份节点，所以至少需要6个redis服务实例。

#--replicas 1 表示主从复制比例为 1:1，即一个主节点对应一个从节点；
#默认给我们分配好了每个主节点和对应从节点服务，以及 solt 的大小，
#因为在 Redis 集群中有且仅有 16383 个 solt ，默认情况会给我们平均分配，
#当然你可以指定，后续的增减节点也可以重新分配

wget http://download.redis.io/releases/redis-5.0.4.tar.gz
mv redis-5.0.4 /usr/local/
ln -s /usr/local/redis-5.0.4 /usr/local/redis
cd /usr/local/redis
make 
make install

mkdir /data/redis-cluster/{7000,7001,7002,7003,7004,7005}/{logs,data} -p

##################
vim create_conf.sh
#!/bin/bash
REDIS_IP=0.0.0.0
for((loop=0; loop<=5; loop++))
do
  cat >> /data/redis-cluster/700${loop}/redis.conf << EOF
port 700${loop}
bind ${REDIS_IP}
daemonize yes
cluster-enabled yes

#集群的配置，配置文件首次启动自动生成 7000，7001，7002
cluster-config-file nodes_700${loop}.conf

#请求超时，默认15秒，可自行设置
cluster-node-timeout 8000

#开启aof持久化模式，每次写操作请求都追加到appendonly.aof文件中
appendonly yes
appendfilename "appendonly_700${loop}.aof"

#每次有写操作的时候都同
appendfsync always

dbfilename dump-700${loop}.rdb
dir /data/redis-cluster/700${loop}/data

logfile /data/redis-cluster/700${loop}/logs/redis.log 
pidfile /var/run/redis_700${loop}.pid
EOF
done

#####################
vim start_redis.sh
#!/bin/bash

REDIS_IP=172.25.15.56

for((loop=0; loop<6; loop++))
do
  cd /data/redis-cluster/700${loop}/
  echo "Start redis port: 700${loop}"
  /usr/local/bin/redis-server redis.conf
done

echo 
redis-cli -c -h ${REDIS_IP} -p 7000 cluster info
echo
redis-cli -c -h ${REDIS_IP} -p 7000 cluster nodes

echo "waiting ..."
sleep 2
echo "首次创建redis集群执行以下脚本"
echo /usr/local/bin/redis-cli --cluster create $REDIS_IP:7000 $REDIS_IP:7001 $REDIS_IP:7002 $REDIS_IP:7003 $REDIS_IP:7004 $REDIS_IP:7005 --cluster-replicas 1

####################
vim stop_redis.sh
#!/bin/bash
REDIS_IP=172.25.15.56
echo "Stop Redis.."
for((loop=0; loop<6; loop++))
do
  /usr/local/bin/redis-cli -h ${REDIS_IP} -p 700${loop} shutdown
done
ps axu | grep redis
