#!/usr/bin/bash
#rclone manage remote drive
#检查p7zip是否安装
rpm -qc p7zip > /dev/null
if [ $? -eq 0 ]; then
     echo "p7zip is installed."
else
     install -y install epel-release && yum -y install p7zip p7zip-plugins
fi
#start
echo -e "1.清空垃圾桶\n2.解压文件（无密码无乱码）\n3.解压文件（有密码有乱码）\n4.打包文件\n5.转移文件"
read -p "请输入你的选择:" num
if [ $num = 1 ]; then
     read -p "请输入rclone配置的硬盘名称：" name1 && rclone delete $name1: --drive-trashed-only --drive-use-trash=false
elif [ $num = 2 ]; then
     read -p "请输入文件（夹）路径：" spath
     read -p "请输入解压路径：" dpath
     
else
     # body
fi
