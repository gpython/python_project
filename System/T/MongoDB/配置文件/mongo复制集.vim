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
