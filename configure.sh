#!/bin/sh

cat << EOF > /etc/nginx/nginx.conf
worker_processes  4;
events {
    worker_connections  1024;
}
http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  300;
    server {
      listen 443;
      ssl on;
      ssl_certificate /etc/nginx/ssl.crt;
      ssl_certificate_key /etc/nginx/ssl.key;
      ssl_session_timeout 60m;
      ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
      server_name  127.0.0.1;
      gzip on;
      gzip_min_length 1k;
      gzip_comp_level 9;
      gzip_types text/plain application/javascript application/x-javascript text/css application/xml text/javascript application/x-httpd-php image/jpeg image/gif image/png;
      gzip_vary on;
      gzip_disable "MSIE [1-6]\.";
      location / {
        proxy_pass  "$TARGET";
      }
      error_page   500 502 503 504  /50x.html;
      location = /50x.html {
        root   html;
      }
    }
}
EOF

nginx -g 'daemon off;'