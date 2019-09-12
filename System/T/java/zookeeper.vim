vim zoo_1.cfg
tickTime=2000
initLimit=10
syncLimit=5
dataDir=/data/zookeeper/zoo_1
dataLogDir=/data/logs/zookeeper/zoo_1
clientPort=2181
server.1=172.25.16.195:2111:3111
server.2=172.25.16.195:2112:3112
server.3=172.25.16.195:2113:3113

########
vim zoo_2.cfg
tickTime=2000
initLimit=10
syncLimit=5
dataDir=/data/zookeeper/zoo_2
dataLogDir=/data/logs/zookeeper/zoo_2
clientPort=2182
server.1=172.25.16.195:2111:3111
server.2=172.25.16.195:2112:3112
server.3=172.25.16.195:2113:3113

#######
vim zoo_3.cfg
tickTime=2000
initLimit=10
syncLimit=5
dataDir=/data/zookeeper/zoo_3
dataLogDir=/data/logs/zookeeper/zoo_3
clientPort=2183
server.1=172.25.16.195:2111:3111
server.2=172.25.16.195:2112:3112
server.3=172.25.16.195:2113:3113


echo 1 >> /data/zookeeper/zoo_1/myid
echo 2 >> /data/zookeeper/zoo_2/myid
echo 3 >> /data/zookeeper/zoo_3/myid


./bin/zkServer.sh start conf/zoo_1.cfg
./bin/zkServer.sh start conf/zoo_2.cfg
./bin/zkServer.sh start conf/zoo_3.cfg

./bin/zkServer.sh status conf/zoo_1.cfg
./bin/zkServer.sh status conf/zoo_2.cfg
./bin/zkServer.sh status conf/zoo_3.cfg



########################################
vim server-1.properties
broker.id=1
listeners=PLAINTEXT://:9093
num.network.threads=3
num.io.threads=8
socket.send.buffer.bytes=102400
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600
log.dirs=/data/logs/kafka-logs-1
num.partitions=1
num.recovery.threads.per.data.dir=1
offsets.topic.replication.factor=1
transaction.state.log.replication.factor=1
transaction.state.log.min.isr=1
log.retention.hours=168
log.segment.bytes=1073741824
log.retention.check.interval.ms=300000
zookeeper.connect=172.25.16.195:2181,172.25.16.195:2182,172.25.16.195:2183
zookeeper.connection.timeout.ms=6000
group.initial.rebalance.delay.ms=0

################
vim server-2.properties
broker.id=2
listeners=PLAINTEXT://:9094
num.network.threads=3
num.io.threads=8
socket.send.buffer.bytes=102400
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600
log.dirs=/data/logs/kafka-logs-2
num.partitions=1
num.recovery.threads.per.data.dir=1
offsets.topic.replication.factor=1
transaction.state.log.replication.factor=1
transaction.state.log.min.isr=1
log.retention.hours=168
log.segment.bytes=1073741824
log.retention.check.interval.ms=300000
zookeeper.connect=172.25.16.195:2181,172.25.16.195:2182,172.25.16.195:2183
zookeeper.connection.timeout.ms=6000
group.initial.rebalance.delay.ms=0

######################
vim server-3.properties
broker.id=3
listeners=PLAINTEXT://:9095
num.network.threads=3
num.io.threads=8
socket.send.buffer.bytes=102400
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600
log.dirs=/data/logs/kafka-logs-3
num.partitions=1
num.recovery.threads.per.data.dir=1
offsets.topic.replication.factor=1
transaction.state.log.replication.factor=1
transaction.state.log.min.isr=1
log.retention.hours=168
log.segment.bytes=1073741824
log.retention.check.interval.ms=300000
zookeeper.connect=172.25.16.195:2181,172.25.16.195:2182,172.25.16.195:2183
zookeeper.connection.timeout.ms=6000
group.initial.rebalance.delay.ms=0

###################################


./bin/kafka-server-start.sh -daemon config/server-1.properties
./bin/kafka-server-start.sh -daemon config/server-2.properties
./bin/kafka-server-start.sh -daemon config/server-3.properties

#测试
jps


#创建一个名称为my-replicated-topic5的Topic，1个分区，并且复制因子为3
./bin/kafka-topics.sh --zookeeper 172.25.16.214:2181,172.25.16.214:2182,172.25.16.214:2183 --create --topic my-topic --partitions 1 --replication-factor 3 --config max.message.bytes=64000 --config flush.messages=1

#查看创建的Topic
./bin/kafka-topics.sh --describe --zookeeper  172.25.16.214:2181,172.25.16.214:2182,172.25.16.214:2183 --topic my-topic

1. Partition： 分区 
2. Leader ： 负责读写指定分区的节点 
3. Replicas ： 复制该分区log的节点列表 
4. Isr: "in-sync" replicas，当前活跃的副本列表（是一个子集），并且可能成为Leader 
