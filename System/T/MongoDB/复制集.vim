MongoDB3.2.1


tar zxvf mongodb-linux-x86_64-3.2.1.tgz  -C /usr/local/
ln -s /usr/local/mongodb-linux-x86_64-3.2.1 /usr/local/mongodb

vim /etc/profile
PATH=$PATH:/usr/local/mongodb/bin

source /etc/profile

mkdir /data/mongodb/data -p
mkdir /data/mongodb/data/rs_27017 -p
mkdir /data/mongodb/data/rs_27018 -p
mkdir /data/mongodb/logs -p
mkdir /data/mongodb/pid -p
mkdir /data/mongodb/conf -p

生成key文件 主从机器相同
cd /data/mongdb/key
openssl rand -base64 512 > mongo_repl.key

复制集 配置文件
更改绑定的端口 和IP地址

vim /data/mongodb/conf/mongod_27017.conf
#############################################################################
systemLog:
  destination: file                                    #指定是一个文件
  path: "/data/mongodb/logs/mongod_27017.log"          #日志存放位置
  logAppend: true                                      #产生日志内容追加到文件
storage:
  dbPath: "/data/mongodb/data/rs_27017"                 #数据文件存放路径
  engine: wiredTiger                    #数据引擎
  journal:
    enabled: true                       #记录操作日志，防止数据丢失。
  directoryPerDB: true                  #指定存储每个数据库文件到单独的数据目录。如果在一个已存在的系统使用该选项，需要事先把存在的数据文件移动到目录。
processManagement:
  fork: true
  pidFilePath: "/data/mongodb/pid/mongod_27017.pid"
net:
  port: 27017
  bindIp: 127.0.0.1,10.10.132.25         #绑定ip
#security:                               #打开认证
#  authorization: enabled
#  keyFile: /data/mongdb/key/mongo_repl.key

replication:
  oplogSizeMB: 2048                       #默认为磁盘的5%,指定oplog的最大尺寸。对于已经建立过oplog.rs的数据库，指定无效
  replSetName: "juzhong_rs"               #指定副本集的名称
  secondaryIndexPrefetch: "all"           #指定副本集成员在接受oplog之前是否加载索引到内存。默认会加载所有的索引到内存。none不加载;all加载所有;_id_only仅加载_id

#############################################################################
:% s/27017/27018/g

单实例启动
mongod --config /data/mongodb/conf/mongod_27017.conf

use admin 
db.createUser({user:'admin', pwd:'admin', roles:['root']})

安全认证
先登录到主MongoDB的服务器中，执行use admin
进入到admin数据库中（如果账户不是admin下会没权控制副本集啥的）
然后执行创建一个管理员
use admin
db.createUser({user: "root",pwd: "123456",roles: [{ role: "root", db: "admin" }]}); 

mongod -f /data/mongodb/conf/mongod_27017.conf
mongo --host 10.10.132.25 --port 27017
#use admin
#db.auth('admin','admin')
#show dbs

ulimit -s 4096 && ulimit -m 16777216 & numactl --interleave=all 

mongod -f /data/mongodb/conf/mongod_27017.conf 
mongod -f /data/mongodb/conf/mongod_27018.conf 
mongo --host 10.10.118.177 --port 27017
mongo --host 10.10.118.177 --port 27018
#use admin
#db.auth('admin','admin')
#rs.slaveOk()
#show dbs

rs.initiate() 
rsconf = {
	"_id" : "juzhongTexas_rs",
	"members" : [
		{
			"_id" : 0,
			"host" : "10.8.106.3:27017"
		},
		{
			"_id" : 1,
			"host" : "10.8.46.42:27017"
		},
		{
			"_id" : 2,
			"host" : "10.8.46.42:27018",
      "arbiterOnly": true,
		}
	]
}

rs.initiate(rsconf)
rs.status()
rs.add("10.8.46.42:27017")
rs.addArb("10.8.46.42:27018")



###########################True#################################
rsconf = {
	"_id" : "juzhongDDZ_rs",
	"members" : [
		{
			"_id" : 0,
			"host" : "10.10.50.39:27017",
      "priority": 2
		},
		{
			"_id" : 1,
			"host" : "10.10.59.51:27017",
      "priority": 1
		},
		{
			"_id" : 2,
			"host" : "10.10.59.51:27018",
      "arbiterOnly": true,
		}
	]
}
rs.initiate(rsconf)
rs.status()
rs.add("10.10.59.51:27017")
rs.addArb("10.10.59.51:27018")

Mongo主库
mongo --host 10.10.50.39    
Mongo从库
mongo --host 10.10.59.51

提升优先级
修改第一个的权重为10
cfg = rs.conf()
cfg.members[0].priority = 10
cfg.members[1].priority = 5
cfg.members[2].priority = 2
rs.reconfig(cfg)

关闭
kill 2 `cat /data/mongodb/pid/mongod_27017.pid`
kill -2 pid 
db.shutdownServer()

mongod -f /data/mongodb/conf/mongod_27017.conf





备份所有的库 不指定数据库 备份所有的库 到 all/目录里
mongodump -o /data/mongodb/dumps/all/

恢复所有库到mongodb
mongorestore /data/mongodb/dumps/all/
