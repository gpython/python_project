root和alias都可以定义在location模块中，都是用来指定请求资源的真实路径，比如
location /i/ {
  root /data/w3;
}

http://foofish.net/i/top.gif -> /data/w3/i/top.gif

http://foofish.net/i/j/k/top.gif
/data/w3/i/j/k/top.gif

root指定值 + location 指定值 + url之后的值
/data/w3      /i                /top.gif 
/data/w3      /i                /j/k/top.gif

alias指定的路径是location的别名，不管location的值怎么写
资源的真实路径都是 alias 指定的路径
location /i/ {
  alias /data/w3/;
}

http://foofish.net/i/top.gif -> /data/w3/top.gif

alias 只能作用在location中，而root可以存在server、http和location中。
alias 后面必须要用 "/" 结束，否则会找不到文件，而 root 则对 "/" 可有可无





server {
  listen 80 ;
  listen   443  ssl;
  server_name wxmailatest.tom.com;
  
  index index.html index.htm;
  root /data/tomcat/webapps; 
  add_header X-Frame-Options SAMEORIGIN;
  
  ssl_certificate /etc/ssl/private/server.crt;
  ssl_certificate_key /etc/ssl/private/private_wildcard_tom_com.key;
  
  location /tommail/ {
    root /data/tomcat/webapps;
  }

  location ^~ /wxmail/ {
    proxy_redirect   off;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header REMOTE-HOST $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_pass http://127.0.0.1:8090;
  }

  location ~ ^/(WEB-INF)/ {
    deny all;
  }

  location ~* \.war$ {
    deny all;
  }

  error_page   500 502 503 504  /50x.html;
  location = /50x.html {
      root   /usr/share/nginx/www;
  }

