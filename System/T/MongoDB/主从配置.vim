tar zxvf mongodb-linux-x86_64-3.2.1.tgz  -C /usr/local/
ln -s /usr/local/mongodb-linux-x86_64-3.2.1 /usr/local/mongodb

vim /etc/profile
PATH=$PATH:/usr/local/mongodb/bin

source /etc/profile

mkdir /data/mongodb/data -p
mkdir /data/mongodb/data/rs_27017 -p
mkdir /data/mongodb/logs -p
mkdir /data/mongodb/pid -p
#mkdir /data/mongodb/key -p

mkdir /usr/local/mongodb/conf/27017 -p

单实例 配置文件
vim /usr/local/mongodb/conf/27017/mongod.conf
#############################################################################
systemLog:
  destination: file                    #指定是一个文件
  path: "/data/mongdb/logs/mongod_27017.log"          #日志存放位置
  logAppend: true                      #产生日志内容追加到文件
storage:
  dbPath: "/data/mongdb/data/m_27017"            #数据文件存放路径
  engine: wiredTiger                    #数据引擎
  journal:
    enabled: true                       #记录操作日志，防止数据丢失。
  directoryPerDB: true                  #指定存储每个数据库文件到单独的数据目录。如果在一个已存在的系统使用该选项，需要事先把存在的数据文件移动到目录。
processManagement:
  fork: true
  pidFilePath: "/data/mongdb/pid/mongod_27017.pid"
net:
  port: 27017
  bindIp: 127.0.0.1,10.10.10.10                     #绑定ip
#security:                               #打开认证
#  authorization: enabled
#  keyFile: "密钥文件路径"

#############################################################################
单实例启动
mongod --config /usr/local/mongodb/conf/27017/mongod.conf

use admin 
db.createUser({user:'admin', pwd:'admin', roles:['root']})

主从配置
生成key文件 主从机器相同
cd /data/mongdb/key
openssl rand -base64 512 > mongo_27017.key

chmod 600 mongo_27017.key

主从 启动
主
mongod --master -f /usr/local/mongodb/conf/27017/mongod.conf --keyFile /data/mongdb/key/mongo_27017.key
mongo --host 10.10.10.10
use admin
db.auth('admin','admin')
show dbs

cong
mongod --slave --source 10.10.10.20:27017 -f /usr/local/mongodb/conf/27017/mongod.conf --keyFile /data/mongdb/key/mongo_27017.key
mongo --host 10.10.10.10
use admin
db.auth('admin','admin')
rs.slaveOk()
show dbs
