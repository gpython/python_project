
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 3650
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem

dd if=/dev/urandom count=2 | openssl dhparam -rand - 512 
#输出内容 追加到 stunnel.pem
