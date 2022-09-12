---
title: Nginx basic configuration
date: 2022-09-12
---

Install

```bash
sudo apt update
sudo apt install nginx -y

nginx -t # check syntax

# Default: /etc/nginx/sites-enabled/default
sudo service nginx restart
```

1. Point to a port

```bash
server {
	listen 80 default_server;
	listen [::]:80 default_server;

	index index.html index.htm index.nginx-debian.html;

	server_name _;

	location / {
		proxy_pass http://127.0.0.1:8080;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host $host;
	}
}
```

2. Config SSL

```bash
server {
  listen 80 default_server;
  server_name api-tps-singapore.com;

  return 301 https://api-tps-singapore.com$request_uri;
}


server {
  listen 443 ssl;
  #ssl on;
  ssl_certificate /home/ubuntu/new-ssl/k.crt;
  ssl_certificate_key /home/ubuntu/new-ssl/k.key;
  server_name api-tps-singapore.com;

  location / {
     proxy_pass http://127.0.0.1:9090;
     proxy_set_header Host $host;
     proxy_set_header X-Real-IP $remote_addr;
     proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
     proxy_set_header X-Forwarded-Proto $scheme;
  }
}
```
