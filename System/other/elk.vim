#日志收集 存储 查询 展示

logstash(收集)
elasticsearch(存储+搜索)
kibana(展示)



Logstash -|
          |
          |                                   Search        |       Web Interface
Logstash -|->Broker(Redis)->Index(Logstash) ->Storage       |<------Kibana
          |                                   Elasticsearch |
          |
Logstash -|


#ELK需要安装java环境
yum install java-1.8.0-openjdk java-1.8.0-openjdk-devel


#安装 ELK6.x
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

cat > /etc/yum.repos.d/elasticsearch.repo << EOF
[elasticsearch-6.x]
name=Elasticsearch repository for 6.x packages
baseurl=https://artifacts.elastic.co/packages/6.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
EOF

yum install elasticsearch logstash kibana -y


##########################Elasticsearch####################
vim /etc/elasticsearch/elasticsearch.yml
#集群名称
cluster.name: myes
#节点名称
node.name: es-node-1
#存储路径
path.data: /data/es-data
#日志路径
path.logs: /data/logs/elasticsearch
#锁住内存 不使用swap
bootstrap.mlockall: true
#主机地址
#network.host: 192.168.56.11
network.host: 0.0.0.0
#端口
http.port: 9200


#######安装nodejs


#插件 elasticsearch-head 安装
git clone git://github.com/mobz/elasticsearch-head.git
mv elasticsearch-head /usr/local/

#安装grunt-cli
npm install -g grunt-cli

#安装 grunt
cd /usr/local/elasticsearch-head
npm install grunt --save

#安装依赖的npm包
npm install

#修改启动文件 增加hostname: '0.0.0.0'

connect: {
    server: {
        options: {
            hostname: '0.0.0.0',
            port: 9100,
            base: '.',
            keepalive: true
        }
    }
}

#修改 Elasticsearch 配置文件 elasticsearch.yml 末尾增加如下两行
http.cors.enabled: true
http.cors.allow-origin: "*"


#重启Elasticsearch

#启动 elasticsearch-head
grunt server


######################Logstash###############
#Logstash 日志收集 (插件)
INPUT FILTER OUTPUT

#记录读取读取的log文件的inode值 ls -lai
,sincedb_*

#logstash中 一行日志 为一个事件
#input output
#

#标准输入 logstash输出
cd /usr/share/logstash/bin/
./logstash -e "input {stdin{}} output { stdout{} }"
./logstash -e 'input {stdin{}} output{ elasticsearch { hosts => ["10.10.10.50:9200"] index => "logstash-%{+YYYY.MM.dd}" }}'
./logstash -e 'input {stdin{}} output{ stdout{} elasticsearch { hosts => ["10.10.10.50:9200"] index => "logstash-%{+YYYY.MM.dd}" }}'

#rsyslog - es
#file    - es
#tcp     - es

#logstash 配置文件

cd /etc/logstash/conf.d/
vim daemon.conf

input{
  stdin{}
}

filter{

}

ouput{
  elasticsearch {
    hosts => ["10.10.10.50:9200"]
    index => "logstash-%{+YYYY.MM.dd}"
  }
  stdout{
  }
}

######
file.conf

input{
  file{
    path => ["/var/log/messages", "/var/log/secure"]
    type => "system-log"
    start_position => "beginning"
  }
}

filter{

}

output{
  elasticsearch{
    hosts => ["10.10.10.50:9200"]
    index => "system-log-%{+YYYY.MM}"
  }
}
#########
input{
  file{
    path => ["/var/log/messages", "/var/log/secure"]
    type => "system-log"
    start_position => "beginning"
  }
  file{
    path => "/var/log/elasticsearch/my-es.log"
    type => "es-log"
    start_position => "beginning"
  }
  file{
    path => "/var/log/jenkins/jenkins.log"
    type => "jenkins-log"
    start_position => "beginning"
  }
}

filter{
}

output{
  if [type] == "system-log"{
    elasticsearch{
      hosts => ["10.10.10.50:9200"]
      index => "system-log-%{+YYYY.MM}"
    }
  }
  if [type] == "es-log"{
    elasticsearch{
      hosts => ["10.10.10.50:9200"]
      index => "es-log-%{+YYYY.MM}"
    }
  }
  if [type] == "jenkins-log"{
    elasticsearch{
      hosts => ["10.10.10.50:9200"]
      index => "jenkins-log-%{+YYYY.MM}"
    }
  }

}


#########多行匹配#######
input{
  stdin{
    codec => multiline{
      #多行匹配
      #只要遇到 ^[ 开头的行就认为是一个新的事件
      #只要遇到 [ 就把上边之前的行合并起来
      pattern => "^\["
      negate => true
      what => "previous"
    }
  }
}

filter{
}

output{
  stdout{

  }
}
############rsyslog#####
input{
  syslog{
    type => "system-syslog"
    port => 514
  }
}

filter{
}

output{
  stdout{
    elasticsearch{
      hosts => ['10.10.10.10:9200']
      index => "system-syslog-%{+YYYY.MM}"
    }
  }
}

#logstash 指定监听 514 端口
#rsyslog 默认向 514端口发送日志信息
#rsyslog 日志文件前 - 代表 经过 系统缓冲区 后 再写入文件 而非立即写入磁盘日志文件

vim /etc/rsyslog.conf
#任意类型.任意日志级别 写入到指定IP:514端口
*.* @@10.10.10.50:514

#logger 命令 手动 产生日志
logger hello world

########### TCP ############
input{
  tcp{
    type => "tcp"
    port => "6666"
    mode => "server"
  }
}

filter{
}

output{
  stdout{
  }
}

#指定 logstash 监听 6666 端口

#nc 向指定 IP 端口 发送信息
echo "Hello World" | nc 10.10.10.50 6666
nc 10.10.10.10 6666 < /etc/resolv.conf

#伪设备 发送信息 到指定 IP 端口
echo "Hello World" > /dev/tcp/10.10.10.50/6666

##########################
#nginx日志json格式收集
log_format access_json '{"user_ip": "$http_x_real_ip","lan_ip": "$remote_addr","log_time": "$time_iso8601","user_req": "$request","http_code": "$status","body_bytes_sent": "$body_bytes_sent","req_time": "$request_time","user_ua": "$http_user_agent","referer": "$http_referer","url": "$scheme://$host$request_uri"}';
#存入redis
#python读取redis 中json数据 进行分析

################ MQ/Redis #####################
#数据 -> logstash -> ES
#数据 -> logstash -> MQ/redis -> logstash -> ES

#
input{
  stdin{

  }
}

output{
  redis{
    host => "10.10.10.50"
    port => "6379"
    db => 1
    data_type => "list"
    key => "demo"
  }
}

#redis
> info
> llen demo
> lindex demo -1


################ Start Logstash #################
/usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/file.conf


###########
访问日志 nginx tomcat php
错误日志 error log
系统日志 /var/log/* syslog rsyslog
运行日志 程序日志
网络日志
防火墙 交换机 路由器 syslog

标准化
  日志存放目录 /data/logs
  日志格式 json
  命名规则 access_log error_log runtime_log
  日志切割 天 小时
  所有日志rsync到NAS 删除最近三天的
  日志使用logstash收集

Redis作为ELK消息队列 监控list key的长度 超过10W需要报警
llen key_name







