#!/bin/bash

echo_err(){
    echo -e "\E[1;31m""$@ \033[0m"
}

echo_ok(){
    echo -e "\E[1;32m""$@ \033[0m"
}

usage(){
    echo "
    USAGE:
    $0 <lan_ip/netmask> <wan_ip/netmask>

    eg.
    $0 10.10.100.1 117.121.100.1
"
    exit 99
}

create_hosts(){
    hostname=$1
    echo "127.0.0.1   $hostname localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         $hostname localhost localhost.localdomain localhost6 localhost6.localdomain6
" > /tmp/hosts
    return 0
}

create_resolv(){
    cat /etc/resolv.conf > /tmp/resolv.conf
    return 0
}

create_network(){
    hostname=$1
    gateway=$2

    echo "NETWORKING=yes
HOSTNAME=$hostname
GATEWAY=$gateway" > /tmp/network
    return 0
}

create_ethx(){
    lan=$1
    wan=$2

    echo "DEVICE=eth0
BOOTPROTO=static
TYPE=Ethernet
ONBOOT=yes
IPADDR=$lan
NETMASK=255.255.255.0
" > /tmp/ifcfg-eth0

    echo "DEVICE=eth1
BOOTPROTO=static
TYPE=Ethernet
ONBOOT=yes
IPADDR=$wan
NETMASK=255.255.255.0
" > /tmp/ifcfg-eth1

    return 0
}

create_route(){
    echo "10.0.0.0/8 via 10.10.15.254
172.16.0.0/16 via 10.10.15.254
192.168.0.0/16 via 10.10.15.254" > /tmp/route-eth0
    return 0
}

copy_in_kvm(){
    domname=`echo "$1" | sed -r 's/\./-/g'`

    virt-copy-in -d $domname /tmp/ifcfg-eth0 /etc/sysconfig/network-scripts/
    virt-copy-in -d $domname /tmp/ifcfg-eth1 /etc/sysconfig/network-scripts/
#    virt-copy-in -d $domname /tmp/route-eth0 /etc/sysconfig/network-scripts/
    virt-copy-in -d $domname /tmp/network /etc/sysconfig/
    virt-copy-in -d $domname /tmp/resolv.conf /etc
    virt-copy-in -d $domname /tmp/hosts /etc

    return 0
}

clear_tmp(){
    rm /tmp/{hosts,resolv.conf,network,ifcfg-*,route-*} -f
    return 0
}

change_vnc_passwd(){
    domname=`echo "$1" | sed -r 's/\./-/g'`

    sed -r -i "/vnc/s/>/ passwd='0aBy4eN6Dz0cz7N'>/" /etc/libvirt/qemu/$domname.xml

    return 0
}

# ------------------------------------------------------------

if ! echo "$1" | grep -Pq '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$';then
    echo 1
    usage
fi

if [[ ! -z $2 ]] && ! echo "$1" | grep -Pq '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$';then
    echo 2
    usage
fi

if echo "$1" | grep -Pq '^192\.';then
    lan_ip=$1
    if [[ ! -z $2 ]];then
        wan_ip=$2
    else
        wan_ip=`echo "$1" | sed -r 's/^[0-9]+\.[0-9]+\.[0-9]+\./123.30.247./'`
    fi
else
    if [[ ! -z $2 ]];then
        lan_ip=$2
    else
        lan_ip=`echo "$1" | sed -r 's/^[0-9]+\.[0-9]+\.[0-9]+\./192.168.144./'`
    fi
    wan_ip=$1
fi

hostname=`echo "$wan_ip" | sed -r 's/^[0-9]+\.[0-9]+\.([0-9]+)\.([0-9]+)$/YN\1-\2.mofun-inc.com/'`
gateway=`echo "$wan_ip" | sed -r 's/[0-9]+$/1/'`
domname=`echo "$wan_ip" | sed -r 's/\./-/g'`

echo_ok "
    LAN_IP   : $lan_ip
    WAN_IP   : $wan_ip
    GATEWAY  : $gateway
    HOSTNAME : $hostname
    DOMNAME  : $domname
"

while true
do
    echo_ok "it OK ? [y/n]"
    read flag

    if [[ "$flag" == 'y' ]];then
        echo_ok "Begin clone ..."
        break
    elif [[ "$flag" == 'n' ]];then
        echo_ok "Exit clone."
        exit
    else
        continue
    fi
done

echo "test $lan_ip ..."
if ping -c 2 $lan_ip >/dev/null 2>&1; then
    echo_err "$lan_ip is existed !!!"
    exit
fi

echo "test $wan_ip ..."
if ping -c 2 $wan_ip >/dev/null 2>&1; then
    echo_err "$wan_ip is existed !!!"
    exit
fi

if test -d /data/kvm/$domname;then
    echo_err "/data/kvm/$domname is existed !!!"
    exit
else
    mkdir -p /data/kvm/$domname
fi

virt-clone --connect qemu:///system\
 -o KVM-TEMP -n ${domname}\
 -f /data/kvm/${domname}/${domname}-system.img\
 -f /data/kvm/${domname}/${domname}-data.img

clear_tmp

create_hosts $hostname
create_resolv
create_network $hostname $gateway
#create_route
create_ethx $lan_ip $wan_ip
change_vnc_passwd $domname
copy_in_kvm $domname

clear_tmp
