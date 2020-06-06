#!/usr/bin/bash
cd
#修复ssh断连
sed -i '112s/0/30/g' /etc/ssh/sshd_config
sed -i '113s/3/9/g' /etc/ssh/sshd_config
sed -i '107s/#//g' /etc/ssh/sshd_config
sed -i '112s/#//g' /etc/ssh/sshd_config
sed -i '113s/#//g' /etc/ssh/sshd_config
service sshd restart
yum -y install updata
wget https://raw.githubusercontent.com/F-gq/stools/master/domain.conf
wget https://raw.githubusercontent.com/F-gq/stools/master/v2ray.json
lsmod | grep bbr > /dev/null
if [ $? -eq 0 ];then
echo bbr已安装 && wget http://soft.vpser.net/lnmp/lnmp1.6.tar.gz -cO lnmp1.6.tar.gz && tar zxf lnmp1.6.tar.gz && cd lnmp1.6 && ./install.sh lnmp
else
wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && bash bbr.sh           # 此处会重启
fi
lnmp vhost add
[ -e /etc/systemd/system/v2ray.service ] && echo v2ray已安装 || wget https://install.direct/go.sh && bash go.sh
read -p "请输入设置域名：" domain
read -p "请输入反代域名：" proxydomain
read -p "请输入alterid(数字)：" alterid
read -p "请输入分流路径：" path
read -p "请输入端口：" port
id=$(cat /proc/sys/kernel/random/uuid)
sed -i "s/\$domain/$domain/g" /root/domain.conf
sed -i "s/\$proxydomain/$proxydomain/g" /root/domain.conf
sed -i "s|path|$path|g" /root/domain.conf                      #解决sed中环境变量替换
sed -i "s/\$port/$port/g" /root/domain.conf
sed -i "s/\$port/$port/g" /root/v2ray.json
sed -i "s|path|$path|g" /root/v2ray.json
sed -i "s/\$id/$id/g" /root/v2ray.json
sed -i "s/\$alterid/$alterid/g" /root/v2ray.json
\mv -f /root/domain.conf "/usr/local/nginx/conf/vhost/$domain.conf"
\mv -f /root/v2ray.json /etc/v2ray/config.json
nginx -s reload
systemctl restart v2ray
systemctl status v2ray