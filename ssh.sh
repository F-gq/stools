#!/usr/bin/bash
#ssh修复断联脚本
sed -i '112s/0/30/g' /etc/ssh/sshd_config
sed -i '113s/3/9/g' /etc/ssh/sshd_config
sed -i '107s/#//g' /etc/ssh/sshd_config
sed -i '112s/#//g' /etc/ssh/sshd_config
sed -i '113s/#//g' /etc/ssh/sshd_config
service sshd restart