MongoDB备份
复制数据文件
避免数据文件的变化 使用fsynclock

>db.fsyncLock()

复制所有文件到备份目录
#cp -R /data/mongodb/data/db /data/backup/mongodb/

复制完成解锁 能够再次写入
> db.fsyncUnlock()

保证mongod 没有在运行 且所有待恢复的数据目录为空
将备份的数据文件复制到数据目录 然后启动Mongod
cp -R /data/backup/mongodb/* /data/mongodb/data/db/



如果使用了--directoryperdb 只需要复制该数据库对应的整个数据目录
保证数据库正常关闭  恢复数据


不要同时使用fsyncLock 和mongodump 
数据库被锁也许会使得mongodump永远处于挂起状态


使用mongodump 备份速度较慢 在处理副本集时存在一些问题
想备份单独数据库 集合 甚至集合的子集合时候 mongodump是很好选择
使用mongodump时甚至无需服务器处于运行状态 使用--dbpath制定数据目录

mongod不再运行时
$ mongodump --dbpath /data/db

mongodb运行时 不应使用--dbpath

如果运行mongod时使用了--replSet选项 则可以使用mongodump的--oplog选项
可以得到源服务器上某一个时间点的数据快照

恢复 
如果备份时使用--oplog备份的数据 
mongorestore时必须使用oplogReplay选项 以得到某一时间点的快照
$mongorestore -p 27017 --oplogReplay dump/

是用相同版本的mongodump 和mongorestore命令

mongoresotre --db NewDB --collection someOtherColl dump/oldDB/oldColl.bson

在集合中 如果存在除_id以外的其他唯一索引 
则应考虑使用 mongodump 和mongorestore以外的备份
应先冻结数据 在使用其他两种备份方法 物理拷贝 和 快照


副本集备
推荐文件系统快照 或 复制数据文件方式 备份

副本集合使用mongodump进行备份 
必须在备份时 使用--oplog选项  得到基于时间点的快照 
否则备份状态不会和任何其他集群成员状态相吻合

恢复时候必须创建一份oplog 否则被恢复的成员不知道该同步到哪里



