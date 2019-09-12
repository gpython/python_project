MongoDB3.2.1


tar zxvf mongodb-linux-x86_64-3.2.1.tgz  -C /usr/local/
ln -s /usr/local/mongodb-linux-x86_64-3.2.1 /usr/local/mongodb

vim /etc/profile
PATH=$PATH:/usr/local/mongodb/bin

source /etc/profile

mkdir /data/mongodb/data -p
mkdir /data/mongodb/data/m_27017 -p
mkdir /data/mongodb/data/m_27018 -p
mkdir /data/mongodb/logs -p
mkdir /data/mongodb/pid -p
mkdir /data/mongodb/key -p
mkdir /data/mongodb/conf -p


单实例 配置文件
vim /data/mongodb/conf/mongod_27017.conf
#############################################################################
systemLog:
  destination: file                    #指定是一个文件
  path: "/data/mongodb/logs/mongod_27017.log"          #日志存放位置
  logAppend: true                      #产生日志内容追加到文件
storage:
  dbPath: "/data/mongodb/data/m_27017"            #数据文件存放路径
  engine: wiredTiger                    #数据引擎
  journal:
    enabled: true                       #记录操作日志，防止数据丢失。
  directoryPerDB: true                  #指定存储每个数据库文件到单独的数据目录。如果在一个已存在的系统使用该选项，需要事先把存在的数据文件移动到目录。
processManagement:
  fork: true
  pidFilePath: "/data/mongodb/pid/mongod_27017.pid"
net:
  port: 27017
  bindIp: 127.0.0.1,10.10.10.10                     #绑定ip
#security:                               #打开认证
#  authorization: enabled

replication:
  oplogSizeMB: 128                       #默认为磁盘的5%,指定oplog的最大尺寸。对于已经建立过oplog.rs的数据库，指定无效
  replSetName: "juzhong_rs"              #指定副本集的名称
  secondaryIndexPrefetch: "all"         #指定副本集成员在接受oplog之前是否加载索引到内存。默认会加载所有的索引到内存。none不加载;all加载所有;_id_only仅加载_id

#############################################################################
单实例启动
mongod --config /data/mongodb/conf/mongod_27017.conf

use admin 
db.createUser({user:'admin', pwd:'admin', roles:['root']})

主从配置
生成key文件 主从机器相同
cd /data/mongodb/key
openssl rand -base64 512 > mongo_27017.key

chmod 600 mongo_27017.key

主从 启动
主
mongod --master -f /data/mongodb/conf/mongod_27017.conf --keyFile /data/mongodb/key/mongo_27017.key
mongo --host 10.10.10.10
use admin
db.auth('admin','admin')
show dbs

从
mongod --slave --source 10.10.132.25:27017 -f /data/mongodb/conf/mongod_27017.conf --keyFile /data/mongodb/key/mongo_27017.key
mongod --slave --source 10.10.10.20:27017 -f /data/mongodb/conf/mongod_27017.conf --keyFile /data/mongodb/key/mongo_27017.key
mongo --host 10.10.10.10
use admin
db.auth('admin','admin')
rs.slaveOk()
show dbs


关闭
kill 2 `cat /data/mongodb/pid/mongod_27017.pid`
kill -2 pid 
db.shutdownServer()

mongod -f /data/mongodb/conf/mongod_27017.conf
rs.initiate() 
rsconf = {
	"_id" : "juzhong_rs",
	"members" : [
		{
			"_id" : 0,
			"host" : "10.10.10.20:27017"
		},
		{
			"_id" : 1,
			"host" : "10.10.10.30:27017"
		},
		{
			"_id" : 2,
			"host" : "10.10.10.30:27018"
		}
	]
}

rs.initiate(rsconf)
rs.status()












备份
mongodump -h IP --port 端口 -u 用户名 -p 密码 -d 数据库 -o 文件存在路径 

备份指定的库 test 到 dumps/目录
mongodump -d test -o /data/mongodb/dumps/ 
-h:
MongDB所在服务器地址，例 127.0.0.1，当然也可以指定端口号127.0.0.1:27017
-d:
需要备份的数据库实例，例test
-o:
备份的数据存放位置，例 /data/dump，当然该目录需要提前建立，在备份完成后，系统自动在dump目录下建立一个test目录，这个目录里面存放该数据库实例的备份数据。

备份所有的库 不指定数据库 备份所有的库 到 all/目录里
mongodump -o all/

恢复
mongorestore -h IP --port 端口 -u 用户名 -p 密码 -d 数据库 --drop 文件存在路径 

/data/mongodb/dumps
恢复备份的test库到 test库
mongorestore -d test ./test/
恢复 备份的test库到 test_01 库
mongorestore -d test_01 ./test/

恢复所有库到mongodb
mongorestore /data/mongodb/dumps/all/



删除用户： db.removeUser("用户名")
删除数据库： db.dropDataBase() ，这个操作会删除你当前正在使用的数据库
删除集合： db.集合名.drop()








注
systemLog:
  destination: file                    #指定是一个文件
  path: "/data/mongodb/logs/mongod_27017.log"          #日志存放位置
  logAppend: true                      #产生日志内容追加到文件
#  quiet: true                         #在quite模式下会限制输出信息
#  timeStampFormat: iso8601-utc        #默认是iso8601-local，日志信息中还有其他时间戳格式：ctime,iso8601-utc,iso8601-local
storage:
  dbPath: "/data/mongodb/data/m_27017"            #数据文件存放路径
  engine: wiredTiger                    #数据引擎
  journal:
    enabled: true                       #记录操作日志，防止数据丢失。
  directoryPerDB: true                  #指定存储每个数据库文件到单独的数据目录。如果在一个已存在的系统使用该选项，需要事先把存在的数据文件移动到目录。
processManagement:
  fork: true
net:
  port: 27017
  bindIp: 127.0.0.1                     #绑定ip

#operationProfiling:
#  slowOpThresholdMs: 100                #指定慢查询时间，单位毫秒，如果打开功能，则向system.profile集合写入数据
#  mode: "slowOp"                        #off、slowOp、all，分别对应关闭，仅打开慢查询，记录所有操作。

#security:
#  keyFile: "/data/mongodb-keyfile"     #指定分片集或副本集成员之间身份验证的key文件存储位置
#  clusterAuthMode: "keyFile"           #集群认证模式，默认是keyFile
#  authorization: "disabled"            #访问数据库和进行操作的用户角色认证

#security:                               #打开认证
#  authorization: enabled
