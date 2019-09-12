
#
ES_USER=tom

wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.1.1-linux-x86_64.tar.gz
#
echo "vm.max_map_count=262144" >> /etc/sysctl.conf
sysctl -p

cat >> /etc/security/limits.conf << EOF
* soft nofile 655350
* hard nofile 655350
* soft nproc 655350 
* hard nproc 655350
EOF
echo "ulimit -HSn 655350" >>/etc/rc.local
echo "ulimit -HSn 655350" >>/root/.bashrc

mkdir /data/es/data
mkdir /data/es/logs
chown ${ES_USER}.${ES_USER} /data/es -R

tar zxvf elasticsearch-7.1.1-linux-x86_64.tar.gz -C /data/
chown ${ES_USER}.${ES_USER}  /data/elasticsearch-7.1.1 -R
ln -s /data/elasticsearch-7.1.1 /data/elasticsearch


###单机 
#IP 192.168.40.50

vim /data/elasticsearch/config/elasticsearch.yml
cluster.name: Elasticsearch-cluster-tominc
node.name: d50
path.data: /data/es/data
path.logs: /data/es/logs
network.host: 0.0.0.0
http.port: 9200
discovery.seed_hosts: ["192.168.40.50"]
cluster.initial_master_nodes: ["d50"]
http.cors.enabled: true
http.cors.allow-origin: "*"

#普通用户启动ES
cd /data/elasticsearch/bin
#前台执行
./elasticsearch
#后台执行
./elasticsearch -d

#jps查看
jps

#日志
tail -f /data/es/logs/Elasticsearch-cluster-tominc.log

#访问
http://192.168.40.50:9200/


#安装ik分词器 与ES版本相对应
wget https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v7.1.1/elasticsearch-analysis-ik-7.1.1.zip


