


#####
bind 0.0.0.0
protected-mode yes
requirepass pas4wd
port 6379
tcp-backlog 511
timeout 0
tcp-keepalive 300
daemonize yes
supervised no
pidfile /var/run/redis_6379.pid
loglevel notice
logfile /var/log/redis/redis.log
databases 16
save 900 1
save 300 10
save 60 10000
stop-writes-on-bgsave-error yes
rdbcompression yes
rdbchecksum yes
dbfilename dump.rdb
dir /data/redis/6379/data
slave-serve-stale-data yes
slave-read-only yes
repl-diskless-sync no
repl-diskless-sync-delay 5
repl-disable-tcp-nodelay no
slave-priority 100
appendonly no
appendfilename "appendonly.aof"
appendfsync everysec
no-appendfsync-on-rewrite no
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb
aof-load-truncated yes
lua-time-limit 5000
slowlog-log-slower-than 10000
slowlog-max-len 128
latency-monitor-threshold 0
notify-keyspace-events ""
hash-max-ziplist-entries 512
hash-max-ziplist-value 64
list-max-ziplist-size -2
list-compress-depth 0
set-max-intset-entries 512
zset-max-ziplist-entries 128
zset-max-ziplist-value 64
hll-sparse-max-bytes 3000
activerehashing yes
client-output-buffer-limit normal 0 0 0
client-output-buffer-limit slave 256mb 64mb 60
client-output-buffer-limit pubsub 32mb 8mb 60
hz 10
aof-rewrite-incremental-fsync yes


#####运行配置#####

#获取当前配置
config get *
config get dir

#变更运行配置
config set loglevel "notice"

redis数据存储
 redis所有数据都在内存中
 持久化到 硬盘 数据文件->rdb 更新日志->aof

RDB
  fork一个新进程 进行IO操作
  持久化 可以在指定的 时间间隔内 生成数据集的时间点快照

  bgsave 后台手动备份

  redis使用fork() 同时拥有父进程和子进程
  子进程将数据集写入到一个临时rdb文件中 (.tmp)
  当子进程完成对rdb文件的写入时 redis用最新的rdb文件替换原来的rdb文件 删除旧rdb文件


AOF
  持久化记录服务器执行的所有写操作命令 并在服务器启动时
  通过重新执行这些命令来还原数据集
  AOF文件中的命令全部以reidis协议格式来保存 新命令会追加到文件的末尾
  Redis还可以在后台对aof文件进行重写
  使得aof文件体积不会超过保存数据集状态所需的实际大小

  Redis 可以同时使用AOF 和 RDB 持久化 当redis重启时
  它会优先使用AOF文件来还原数据集
  因为AOF文件保存的数据通常比RDB文件所保存的数据集更完整

同步
  appendfsync everysec
  no        等操作系统进行数据缓存同步到磁盘 linux约30秒 (快)
  always    每次更新操作后调用fsync() 将数据写道磁盘 (慢 安全)
  everysec  每秒同步一次 (折中 默认值)


info
client list
client kill ip:port
config get *
dbsize
monitor 实时监控指令
save 将当前数据库保存
shutdown 关闭服务器

slaveof host port 主从配置
salveof no one
sync 主从同步
role 返回主从角色

####慢日志查询
  slowlog-log-slower-than 10000 超过多少微秒
  slowlog-max-len 1000          保存多少条慢日志
  config get slow*


####备份
  #获取当前rdb目录
  config get dir
  save


###复制原理
原理
  无论初次链接还是重新连接 当建立一个从服务器时 从服务器将向主服务器发送一个PSync命令

  接收到sync命令的主服务器 (根据Pysync runid offset判断是否实行bgsave)  将执行bgsave
  并在保存操作执行期间 将所有新执行的写入命令都保存在一个缓冲区文里面 (坑 超越缓冲区/积压空间大小 )

  当bgsave执行完毕后 主服务器将执行保存操作所得的.rdb文件发送给从服务器
  从服务器接收到这个.rdb文件 并将文件中的数据载入到内存中

  之后主服务器会以redis命令协议的格式 将写命令缓冲区中积累的所有内容都发送给从服务器

  即便多个从服务器同时向主服务器发送Psync 主服务器也只需执行一次bgsave命令
  就可以处理所有这些从服务器的同步请求了


  redis key大小 使用中 不建议超过2M

配置
  从机器配置文件中
  slaveof redis_master_ip port
  slaveof 10.10.10.50 6379

  从机器命令终端中输入 slaveof 主服务器IP 端口 然后同步
  > slaveof 10.10.10.50 6379

  从机器默认变成 slave-read-only=1 只读

  主从切换 将从提升为主 -> 独立的主服务器
  slaveof no one





#####数据类型

字符串
  set name "google"
  get name

  append name "yahoo"
  mset foo bar name googke

  set age 10
  incr age
  incrby age 100

  decr age
  decrby age 5

  exists name
  setnx name gooooo


列表
  简单字符串列表

  #将一个或多个值插入到列表的头部 LPUSH
  lpush list1 google yahoo python linux
  lrange list1 0 10

  #将一个或多个值插入到列表的尾部 RPUSH
  RPUSH

  #LPOP/RPOP 移除表头/尾的元素
  LLEN 返回列表长度
  LRANGE 返回指定的元素

  Lindex 返回列表key 中下标为index的元素
  LSET key index value 将列表key下标为index的元素的值设置为value

  LREM greet 2 morning 删除前两个morning
  LREM greet -1 morning 删除后一个morning
  LREm greet 0 hello 删除所有的hello

  linsert key before/after before_or_after_value new_value




有序集合


哈希(HASH) 键值的集合
  redis哈希是一个string类型的field和value的映射表
  hash特别适合存储对象

  hset user:1 name google
  HSET user:1 age 30
  HSET user:1 gender 1
  type user:1

  hgetall user:1
  HMGET user:1 name age
  HMGET user:1 name gender
  HGET user:1 name
  HGET user:1 age

  #列出hash的所有key
  HKEYS user:1

  #整个user:1全部删除
  del user:1

  #删除hash中某个指定key
  hdel user:1 age

  #自增
  hincrby user:1 1



集合









