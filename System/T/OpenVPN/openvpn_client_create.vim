#!/bin/bash
username=$1
if [[ -z ${username} ]]
then
  echo "Input a Username Error !!!"
  exit 1
fi

client_dir='/root/openvpn_client/clients'
if [[ -d ${client_dir}/${username} ]]
then
  echo "username exists Error!!!"
  exit 1
else
  mkdir ${client_dir}/${username} -p
fi

openvpn_client_dir='/root/openvpn_client/easy-rsa/easyrsa3'
openvpn_server_dir='/etc/openvpn/easy-rsa/easyrsa3'
passwd=`echo ${username} | md5sum | tr '012abc' '*&^@!#%' | cut -c 1-10`

echo "#Input Client Passwd ${passwd}" 
echo "cd ${openvpn_client_dir}; ./easyrsa gen-req ${username}"
echo 
echo "cd ${openvpn_server_dir}"
echo "./easyrsa import-req ${openvpn_client_dir}/pki/reqs/${username}.req ${username}"
echo "#Input yes and Input ca.key's Passwd"
echo "./easyrsa sign client ${username}"
echo 
echo "cp ${openvpn_server_dir}/pki/ca.crt ${client_dir}/${username}/"
echo "#Client's Crt file '${username}.crt' is Used to Revoke "
echo "cp ${openvpn_server_dir}/pki/issued/${username}.crt ${client_dir}/${username}/"
echo "mv ${openvpn_client_dir}/pki/private/${username}.key ${client_dir}/${username}/"

echo "cp ${client_dir}/client.ovpn ${client_dir}/${username}"
echo "sed -i 's/xxx/${username}/g' ${client_dir}/${username}/client.ovpn"

echo "cd ${client_dir}"
echo "tar czvf - ${username} | openssl des3 -salt -k ${passwd} -out ${username}_des3.tar.gz"
echo 
echo "openssl des3 -d -k ${passwd} -salt -in ${username}_des3.tar.gz | tar zxvf -"
