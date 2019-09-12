wget http://nginx.org/download/nginx-1.11.3.tar.gz

git clone https://github.com/arut/nginx-rtmp-module.git
git clone https://github.com/vivus-ignis/nginx_mod_h264_streaming.git
git clone https://github.com/yaoweibin/nginx_upstream_check_module.git



./configure --prefix=/usr/local/nginx --error-log-path=/data/logs/nginx/error.log --http-log-path=/data/logs/nginx/access.log --user=www --group=www --with-http_ssl_module --with-http_flv_module --with-http_gzip_static_module --with-http_stub_status_module --http-client-body-temp-path=/data/tmp/nginx/client --http-proxy-temp-path=/data/tmp/nginx/proxy --http-fastcgi-temp-path=/data/tmp/nginx/fcgi --add-module=../ngx_cache_purge-2.3 --add-module=../nginx_mod_h264_streaming --add-module=../nginx-rtmp-module --add-module=../nginx_upstream_check_module


yum install libavformat-dev


