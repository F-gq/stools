#!/usr/bin/bash
#aria2 and gclone.
#Use aria2 and gclone to download or copy files.
#安装更新和必备软件
yum -y install updata
rpm -q git >/dev/null && echo "git已安装." || yum -y install git
rpm -q wget >/dev/null && echo "wget已安装." || yum -y install wget
rpm -q curl >/dev/null && echo "curl已安装." || yum -y install curl
rpm -q fuse >/dev/null && echo "fuse已安装." || yum -y install fuse
rpm -q lrzsz >/dev/null && echo "lrzsz已安装." || yum -y install lrzsz
rpm -q unzip >/dev/null && echo "unzip已安装." || yum -y install unzip
rpm -q screen >/dev/null && echo "screen已安装." || yum -y install screen
rpm -q python3 >/dev/null && echo "python3已安装." || yum -y install python3
rpm -q python3-pip >/dev/null && echo "python3-pip已安装." || yum -y install python3-pip
[ -e /usr/bin/gclone ] && echo "gclone已安装." || bash <(wget -qO- https://git.io/gclone.sh)
[ -e /usr/bin/rclone ] && echo "gclone已重命名." || cp /usr/bin/gclone /usr/bin/rclone
#检查aria2是否安装
if [ -e /usr/local/bin/aria2c ]; then
    echo aria2已安装!
else
    wget https://raw.githubusercontent.com/P3TERX/aria2.sh/master/aria2.sh && chmod +x aria2.sh && ./aria2.sh
    curl -fsSL https://raw.githubusercontent.com/F-gq/stools/master/aria2.conf >aria2.conf
    \cp -f /root/aria2.conf /root/.aria2c/ 
fi
#安装AutoRclone
git clone https://github.com/F-gq/Auto-Rclone.git
#检查rclone（gclone）配置文件是否存在
[ -e /root/.config/rclone/rclone.conf ] || rclone config
read -p "请输入用gclone设置的挂载名称:" name
echo 请输入上传路径，例如：根目录填/，根目录下的1文件夹输入/1.以此类推。
read -p "请输入上传路径：" path
mkdir -p /home/$name
rclone mount $name: /home/$name --allow-other --allow-non-empty --vfs-cache-mode writes &
sed -i "20s/Onedrive/$name/g" /root/.aria2c/autoupload.sh
sed -i "23s|/DRIVEX/Download|$path|g" /root/.aria2c/autoupload.sh && cd
service aria2 restart