#!/bin/bash
# 首先要检查是否安装bbr（lsmod | grep bbr），是的话直接开始安装运行screen
yum install updata && yum install wget
wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh && bash bbr.sh           # 此处会重启
lsmod | grep bbr                 # 检查bbr是否启动
# 根据上一指令的输出结果判断：成功的话执行yum install screen && screen -S lnmp，失败的话输出错误并退出脚本
wget http://soft.vpser.net/lnmp/lnmp1.6.tar.gz -cO lnmp1.6.tar.gz && tar zxf lnmp1.6.tar.gz && cd lnmp1.6 && ./install.sh lnmp 
wget https://install.direct/go.sh && sudo bash go.sh  
# read命令写入域名、反代域名，v2的id、传输协议、路径
# 根据read的变量将相关内容写入配置文件。
systemctl restart v2ray  
nginx -s reload