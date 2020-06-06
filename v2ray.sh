cd
yum -y install updata
rpm -q wget > /dev/null && echo wget已安装! || yum -y install wget
rpm -q vim > /dev/null && echo vim已安装! || yum -y install vim
rpm -q screen > /dev/null && echo screen已安装! || yum -y install screen
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
read -p "请输入id：" id
read -p "请输入分流路径：" path
read -p "请输入端口：" port
alterid=$(cat /proc/sys/kernel/random/uuid)
sed -i "s/\$domain/$domain/g" domain.conf
sed -i "s/\$proxydomain/$proxydomain/g" domain.conf
sed -i "s/\$path/$path/g" domain.conf
sed -i "s/\$port/$port/g" domain.conf
sed -i "s/\$port/$port/g" v2ray.json
sed -i "s/\$id/$id/g" v2ray.json
sed -i "s/\$alterid/$alterid/g" v2ray.json
\mv -f /root/domain.conf "/usr/local/nginx/conf/vhost/$domain.conf"
\mv -f /root/v2ray.json /etc/v2ray/config.json
nginx -s reload
systemctl restart v2ray
systemctl status v2ray