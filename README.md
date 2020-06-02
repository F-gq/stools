# stools

## some tools for myself.
· include aria2c,gclone,fix ssh of digital ocean and so on.
## install v2ray

1. check system time and set time.
2. `yum -y install wget && https://raw.githubusercontent.com/F-gq/stools/master/v2ray.sh && bash v2ray.sh`
3. `vim /usr/local/nginx/conf/vhost/$domain.conf && nginx -s reload`
4. `vim /etc/v2ray.conf && sudo systemctl restart v2ray  && sudo systemctl status v2ray`

