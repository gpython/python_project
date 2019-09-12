#!/bin/bash

Docker_Dir='/data/docker_data/'

function color(){
  echo -e "\033[33m $@ \033[0m"
}

function USAGE() {
  color "Usage:
    `basename $0` -n IP_Address -i Dokcer_Image
    `basename $0` -n 10.10.10.10 -i centos:6.6
  "
  exit
}

while getopts "n:i:h" arg
do
  case ${arg} in
    n)
      IP=${OPTARG}
      ;;
    i)
      IMAGE=${OPTARG}
      ;;
    *|h)
      USAGE=1
      ;;
  esac
done

if [[ $# == 0 ]] || [[ ${USAGE} == 1 ]]
then
  usage
fi

if ! echo ${IP} | grep -Pq '(\d+\.){3}\d+'
then
  echo "IP Address ${IP} Format Error"
  exit
fi

if ping ${IP} -c 3 > /dev/null 2>&1
then
  echo "IP Address ${IP} In Used"
  exit
fi

container_netmask=24
container_gw=192.168.47.9
container_ip=${IP}/${container_netmask}
Domain=`echo ${IP} | tr '.' '-'`

if [[ -d ${Docker_Dir}${Domain} ]]
then
  echo "Docker Dir ${Docker_Dir}${Domain} Exists Error"
  exit
fi

if [[ -z ${IMAGE} ]]
then
  echo "Docker Image is Null"
  exit
fi

docker run --hostname ${Domain} --name="${Domain}" -it --net=none -v ${Docker_Dir}${Domain}:/data ${IMAGE}
container_id=`docker ps -a | grep ${Domain} | awk '{print $1}'`
pid=`docker inspect -f '{{.State.Pid}}' ${container_id}`
bridge_if="veth_`echo ${container_id} | cut -c 1-10`"
if [[ ! -d /var/run/netns ]]
then
  mkdir -p /var/run/netns
fi
ln -s /proc/${pid}/ns/net /var/run/netns/${pid}

ip link add A type veth peer name B
ip link set A name $bridge_if
brctl addif docker0 $bridge_if
ip link set $bridge_if up
ip link set B netns $pid
ip netns exec $pid ip link set dev B name eth0
ip netns exec $pid ip link set eth0 up
ip netns exec $pid ip addr add $container_ip dev eth0
ip netns exec $pid ip route add default via $container_gw

