#!/usr/bin/bash
#aria2 and gclone.
#Use aria2 and gclone to download or copy files.
#安装更新和必备软件
#ssh修复断联脚本
sed -i '112s/0/30/g' /etc/ssh/sshd_config
sed -i '113s/3/9/g' /etc/ssh/sshd_config
sed -i '107s/#//g' /etc/ssh/sshd_config
sed -i '112s/#//g' /etc/ssh/sshd_config
sed -i '113s/#//g' /etc/ssh/sshd_config
service sshd restart
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
#安装AutoRclone、获取授权、生成SA、加入groups
git clone https://github.com/xyou365/AutoRclone && cd AutoRclone && pip3 install -r requirements.txt
#检查是否生成凭证并放入AutoRclone文件夹
if [ -e /root/AutoRclone/credentials.json ]; then
    cd /root/AutoRclone
else
    echo -e '1.打开下面的链接进行授权和下载：\nhttps://developers.google.com/drive/api/v3/quickstart/python \n2.将下载好的credentials.json文件上传至服务器/root/Autorclone目录下\n'
    read -p "完成以上两个步骤请输入y：" confirm1
    if [ $confirm1 != y ]; then
        echo "输入错误，请重新运行脚本。" && exit
    fi
fi
#生成SA
echo -e '1.新建项目并生成SA\n2.在原有项目基础上生成SA\n3.仅在新建项目中生成SA\n4.不需要创建，accounts文件夹已生成SA'
read -p "选择上面选项对应数字：" num1
if [ $num1 -eq 1 ]; then
    read -p "请输入新建项目数：" num2
    cd /root/AutoRclone && python3 gen_sa_accounts.py --quick-setup $num2
elif [ $num1 -eq 2 ]; then
    cd /root/AutoRclone && python3 gen_sa_accounts.py --quick-setup -1
elif [ $num1 -eq 3 ]; then
    read -p "请输入新建项目数：" num3
    cd /root/AutoRclone && python3 gen_sa_accounts.py --quick-setup $num3 --new-only
elif [ $num1 -eq 4 ]; then
    num7=$(ls -l /root/AutoRclone/accounts/ | wc -l)
    if [ $num7 -gt 1 ]; then
        [ -e ~/AutoRclone/email.txt ] || cat ~/AutoRclone/accounts/*.json | grep "client_email" | awk '{print $2}' | tr -d ',"' | sed 'N;N;N;N;N;N;N;N;N;/^$/d;G' >/root/AutoRclone/email.txt && sz /root/AutoRclone/email.txt
    else
        echo "请将accounts文件夹上传至服务器/root/AutoRclone/下,并重新运行脚本。" && exit
    fi
else
    echo "输入错误请重新执行脚本" && exit 0
fi
#添加SA到群组
echo -e "1.打开右侧网址新建群组：https://groups.google.com \n2.打开刚刚下载的email.txt文件。每10个一组向群组添加成员\n3.将群组账号和邮箱账号添加至团队盘。"
read -p "完成以上三个步骤请输入y：" confirm2
if [ $confirm2 != y ]; then
    echo '错误！请重新运行脚本。' && exit 0
fi
#检查rclone（gclone）配置文件是否存在
[ -e /root/.config/rclone/rclone.conf ] || rclone config
read -p "请输入用gclone设置的挂载名称:" name
echo 请输入上传路径，例如：根目录填/，根目录下的1文件夹输入/1.以此类推。
read -p "请输入上传路径：" path
mkdir -p /home/$name
rclone mount $name: /home/$name --allow-other --allow-non-empty --vfs-cache-mode writes &
sed -i "20s/Onedrive/$name/g" /root/.aria2c/autoupload.sh
sed -i "23s|/DRIVEX/Download|$path|g" /root/.aria2c/autoupload.sh
mkdir ~/AutoRclone/LOG/ && cd
wget https://raw.githubusercontent.com/F-gq/stools/master/other.sh && chmod u+x other.sh
wget https://raw.githubusercontent.com/F-gq/stools/master/av.sh && chmod u+x av.sh
wget https://raw.githubusercontent.com/F-gq/stools/master/film.sh && chmod u+x film.sh
wget https://raw.githubusercontent.com/F-gq/stools/master/film.txt
wget https://raw.githubusercontent.com/F-gq/stools/master/aria2.conf && \cp -f /root/aria2.conf /root/.aria2c/aria2.conf && rm -rf /root/aria2.conf
service aria2 restart