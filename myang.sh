#!/usr/bin/bash
#aria2 and gclone.Use aria2 and gclone to download,manage and copy files.
yum -y install updata
yum install readline-devel.x86_64 libconfig-devel.x86_64 jansson-devel.x86_64                                                                     #安装更新
rpm -q git &>/dev/null && echo -e "\e[1;32mgit已安装.\e[0m" || yum -y install git                                  #安装git
rpm -q wget &>/dev/null && echo -e "\e[1;32mwget已安装.\e[0m" || yum -y install wget                               #安装wget
rpm -q fuse &>/dev/null && echo -e "\e[1;32mfuse已安装.\e[0m" || yum -y install fuse                               #安装fuse
rpm -q lrzsz &>/dev/null && echo -e "\e[1;32mlrzsz已安装.\e[0m" || yum -y install lrzsz                            #安装lrzsz
rpm -q unzip &>/dev/null && echo -e "\e[1;32munzip已安装.\e[0m" || yum -y install unzip                            #安装unzip
rpm -q screen &>/dev/null && echo -e "\e[1;32mscreen已安装.\e[0m" || yum -y install screen                         #安装screen
rpm -q python3 &>/dev/null && echo -e "\e[1;32mpython3已安装.\e[0m" || yum -y install python3                      #安装python3
rpm -q python3-pip &>/dev/null && echo -e "\e[1;32mpython3-pip已安装.\e[0m" || yum -y install python3-pip          #安装python3-pip
[ -e /usr/bin/gclone ] && echo -e "\e[1;32mgclone已安装.\e[0m" || bash <(wget -qO- https://git.io/gclone.sh)      #安装gclone
[ -e /usr/bin/rclone ] && echo -e "\e[1;32mgclone已重命名.\e[0m" || cp /usr/bin/gclone /usr/bin/rclone            #重命名gclone
git clone https://github.com/F-gq/AutoRclone.git;\mv -f /root/AutoRclone/rclone.conf /root/.config/rclone/    #安装AutoRclone
[ -e /usr/local/bin/aria2c ] && echo aria2已安装! || bash <(curl https://raw.githubusercontent.com/P3TERX/aria2.sh/master/aria2.sh)
\mv -f /root/AutoRclone/autoupload.sh /root/.aria2c/autoupload.sh
\mv -f /root/AutoRclone/aria2.conf /root/.aria2c/aria2.conf                                     #替换aria2配置文件
read -p "请输入用gclone设置的挂载名称:" name
echo 请输入上传路径，例如：根目录填/，根目录下的1文件夹输入/1.以此类推。
read -p "请输入上传路径：" path
mkdir -p /mnt/$name
rclone mount $name: /mnt/$name --allow-other --allow-non-empty --vfs-cache-mode writes &        #挂载Googledrive
service aria2 restart
