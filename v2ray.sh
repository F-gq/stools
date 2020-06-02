#!/bin/bash
yum -y install updata
#检查wget是否安装
rpm -q wget > /dev/null
if [ $? -eq 0 ];then
echo wget已安装!
else
yum -y install wget
fi
#检查vim是否安装
rpm -q vim > /dev/null
if [ $? -eq 0 ];then
echo vim已安装!
else
yum -y install vim
fi
#检查screen是否安装
rpm -q screen > /dev/null
if [ $? -eq 0 ];then
echo screen已安装!
else
yum -y install screen
fi
# 首先要检查是否安装bbr
lsmod | grep bbr > /dev/null
if [ $? -eq 0 ];then
echo bbr已安装
else
wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && bash bbr.sh           # 此处会重启
fi
lsmod | grep bbr > /dev/null
if [ $? -eq 0 ];then
screen -S lnmp
wget http://soft.vpser.net/lnmp/lnmp1.6.tar.gz -cO lnmp1.6.tar.gz && tar zxf lnmp1.6.tar.gz && cd lnmp1.6 && ./install.sh lnmp 
else
echo 请重新运行脚本安装bbr && exit
if
wget https://install.direct/go.sh && sudo bash go.sh
read -p "请输入域名" domain
read -p "qi"
#生成uuid：cat /proc/sys/kernel/random/uuid
# read命令写入域名、反代域名，v2的id、传输协议、路径
# 根据read的变量将相关内容写入配置文件。
systemctl restart v2ray  
nginx -s reload