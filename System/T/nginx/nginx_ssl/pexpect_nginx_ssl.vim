./easyrsa gen-req client_01 nopass
  --> Common Name (eg: your user, host, or server name) [client_yahoo@g.com]:  <------
  req: /root/CA/easyrsa3/pki/reqs/client_yahoo@g.com.req  
  key: /root/CA/easyrsa3/pki/private/client_yahoo@g.com.key


./easyrsa sign client client_yahoo@g.com
  --->  Type the word 'yes' to continue, or any other input to abort.
        Confirm request details:   yes <------
  ---> Enter pass phrase for /root/CA/easyrsa3/pki/private/ca.key:  CA_PASSWD <---
  Certificate created at: /root/CA/easyrsa3/pki/issued/client_yahoo@g.com.crt


./easyrsa export-p12 client_yahoo@g.com
  ---> Enter Export Password:  p12_Passwd  <----
  ---> Verifying - Enter Export Password: p12_Passwd   <---
  location: /root/CA/easyrsa3/pki/private/client_yahoo@g.com.p12


######################
./easyrsa revoke client_yahoo@g.com
  ---> Continue with revocation: yes   <---
  ---> Enter pass phrase for /root/CA/easyrsa3/pki/private/ca.key: CA_PAsswd <---

./easyrsa gen-crl
  ---> Enter pass phrase for /root/CAis_/easyrsa3/pki/private/ca.key: CA_PAsswd <---
  CRL file: /root/CA/easyrsa3/pki/crl.pem


sqlite3 nginx_ssl.db

create table p12_userinfo (
  id INTEGER PRIMARY KEY NOT NULL,
  username VARCHAR(150) not null,
  password VARCHAR(150) not null,
  is_crled int not null default 0,
  timestamp integer not null,
  datetime text not null,
  uptime text not null
);
