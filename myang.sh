#!/usr/bin/bash
#aria2 and gclone.Use aria2 and gclone to download,manage and copy files.
yum -y install updata                                                                            #安装更新
rpm -q git >/dev/null && echo "git已安装." || yum -y install git                                  #安装git
rpm -q wget >/dev/null && echo "wget已安装." || yum -y install wget                               #安装wget
rpm -q fuse >/dev/null && echo "fuse已安装." || yum -y install fuse                               #安装fuse
rpm -q lrzsz >/dev/null && echo "lrzsz已安装." || yum -y install lrzsz                            #安装lrzsz
rpm -q unzip >/dev/null && echo "unzip已安装." || yum -y install unzip                            #安装unzip
rpm -q screen >/dev/null && echo "screen已安装." || yum -y install screen                         #安装screen
rpm -q python3 >/dev/null && echo "python3已安装." || yum -y install python3                      #安装python3
rpm -q python3-pip >/dev/null && echo "python3-pip已安装." || yum -y install python3-pip          #安装python3-pip
[ -e /usr/bin/gclone ] && echo "gclone已安装." || bash <(wget -qO- https://git.io/gclone.sh)      #安装gclone
[ -e /usr/bin/rclone ] && echo "gclone已重命名." || cp /usr/bin/gclone /usr/bin/rclone            #重命名gclone
git clone https://github.com/F-gq/AutoRclone.git && \mv -f /root/AutoRclone/rclone.conf /root/.config/rclone/    #安装AutoRclone
if [ -e /usr/local/bin/aria2c ]; then                                                            #检查aria2是否安装
    echo aria2已安装!
else
    wget https://raw.githubusercontent.com/P3TERX/aria2.sh/master/aria2.sh && chmod +x aria2.sh && ./aria2.sh
fi
\mv -f /root/AutoRclone/aria2.conf /root/.aria2c/aria2.conf                                      #替换aria2配置文件
read -p "请输入用gclone设置的挂载名称:" name
echo 请输入上传路径，例如：根目录填/，根目录下的1文件夹输入/1.以此类推。
read -p "请输入上传路径：" path
mkdir -p /home/$name
rclone mount $name: /home/$name --allow-other --allow-non-empty --vfs-cache-mode writes &        #挂载Googledrive
sed -i "20s/Onedrive/$name/g" /root/.aria2c/autoupload.sh
sed -i "23s|/DRIVEX/Download|$path|g" /root/.aria2c/autoupload.sh
service aria2 restart