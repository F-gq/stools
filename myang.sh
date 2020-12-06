#!/usr/bin/bash
#aria2 and gclone.Use aria2 and gclone to download,manage and copy files.
export copy.sh=/root/AutoRclone/copy.sh
export rcmg.sh=/root/AutoRclone/rcmg.sh
mkdir /data
yum -y install updata                                                                   #安装更新
rpm -q git &>/dev/null && echo -e "\e[1;32mgit已安装.\e[0m" || yum -y install git                                  #安装git
rpm -q wget &>/dev/null && echo -e "\e[1;32mwget已安装.\e[0m" || yum -y install wget                               #安装wget
rpm -q fuse &>/dev/null && echo -e "\e[1;32mfuse已安装.\e[0m" || yum -y install fuse                               #安装fuse
rpm -q unzip &>/dev/null && echo -e "\e[1;32munzip已安装.\e[0m" || yum -y install unzip                            #安装unzip
rpm -q screen &>/dev/null && echo -e "\e[1;32mscreen已安装.\e[0m" || yum -y install screen                         #安装screen
[ -e /usr/bin/gclone ] && echo -e "\e[1;32mgclone已安装.\e[0m" || bash <(wget -qO- https://git.io/gclone.sh)      #安装gclone
[ -e /usr/bin/rclone ] && echo -e "\e[1;32mgclone已重命名.\e[0m" || cp /usr/bin/gclone /usr/bin/rclone            #重命名gclone
git clone https://github.com/F-gq/AutoRclone.git;\mv -f /root/AutoRclone/rclone.conf /root/.config/rclone/     #安装相关软件、配置
[ -e /usr/local/bin/aria2c ] && echo -e "\e[1;32maria2已安装。\e[0m" || bash <(curl https://raw.githubusercontent.com/P3TERX/aria2.sh/master/aria2.sh)
\mv -f /root/AutoRclone/autoupload.sh /root/.aria2c/autoupload.sh;\mv -f /root/AutoRclone/aria2.conf /root/.aria2c/aria2.conf                                #替换aria2配置文件
\mv -f /root/AutoRclone/copy.sh /root/;\mv -f /root/AutoRclone/rcmg.sh /root/
chmod a+x /root/.aria2c/autoupload.sh
echo -ne "\e[1;33m请输入用gclone设置的挂载名称:\e[0m" && read name
echo -e "\e[1;32m请输入上传路径，例如：根目录填/，根目录下的1文件夹输入/1.以此类推。\e[0m"
echo -ne "\e[1;33m请输入上传路径：\e[0m" && read path
mkdir -p /mnt/$name
rclone mount $name: /mnt/$name --allow-other --allow-non-empty --vfs-cache-mode writes &        #挂载Googledrive
service aria2 restart
