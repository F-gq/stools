#!/usr/bin/bash
#use aria2 and gclone to download or copy files.
yum -y install updata          #安装更新
rpm -q wget> /dev/null         #检查wget是否安装
if [ $? -eq 0 ];then
echo wget已安装!
else
yum -y install wget
fi
rpm -q fuse> /dev/null         #检查fuse是否安装
if [ $? -eq 0 ];then
echo fuse已安装!
else
yum -y install fuse
fi
rpm -q unzip> /dev/null        #检查unzip是否安装
if [ $? -eq 0 ];then
echo unzip已安装!
else
yum -y install unzip
fi
rpm -q git> /dev/null          #检查git是否安装
if [ $? -eq 0 ];then
echo git已安装!
else
yum -y install git
fi
rpm -q screen> /dev/null       #检查screen是否安装
if [ $? -eq 0 ];then
echo screen已安装!
else
yum -y install screen
fi
rpm -q python3> /dev/null      #检查python3是否安装
if [ $? -eq 0 ];then
echo python3已安装!
else
yum -y install python3
fi
rpm -q python3-pip> /dev/null  #检查python3-pip是否安装
if [ $? -eq 0 ];then
echo python3-pip已安装!
else
yum -y install python3-pip
fi
rpm -q lrzsz> /dev/null  #检查lrzsz是否安装
if [ $? -eq 0 ];then
echo lrzsz已安装!
else
yum -y install lrzsz
fi
ls -l /usr/local/bin/aria2c > /dev/null      #检查aria2是否安装
if [ $? -eq 0 ];then
echo aria2已安装!
else
wget https://raw.githubusercontent.com/P3TERX/aria2.sh/master/aria2.sh
chmod +x aria2.sh && ./aria2.sh
fi
ls -l /usr/bin/gclone > /dev/null      #检查gclone是否安装
if [ $? -eq 0 ];then
echo gclone已安装!
else
bash <(wget -qO- https://git.io/gclone.sh)
fi
ls -l /usr/bin/rclone > /dev/null      #检查gclone是否重命名
if [ $? -eq 0 ];then
echo gclone已重命名!
else
cp /usr/bin/gclone /usr/bin/rclone
fi
#安装AutoRclone、获取授权、生成SA、加入groups
git clone https://github.com/xyou365/AutoRclone && cd AutoRclone && pip3 install -r requirements.txt
echo -e '1.打开下面的链接进行授权和下载：\nhttps://developers.google.com/drive/api/v3/quickstart/python \n2.将下载好的credentials.json文件上传至服务器/root/Autorclone目录下\n'
read -p "完成以上两个步骤请输入y：" confirm1
if [ $confirm1 = y ];then
cd /root/AutoRclone
else
echo '错误！请重新输入~' && read -p "完成以上两个步骤请输入y：" confirm1
fi
ls -l /root/AutoRclone/credentials.json > /dev/null      #检查是否生成凭证并放入AutoRclone文件夹
if [ $? -eq 0 ];then
echo -e '1.新建项目并生成SA\n2.在原有项目基础上生成SA\n3.仅在新建项目中生成SA\n4.不需要创建，accounts文件夹已生成SA'
fi
read -p "选择上面选项对应数字：" num1
if [ $num1 -eq 1 ];then
read -p "请输入新建项目数：" num2 && python3 gen_sa_accounts.py --quick-setup $num2
elif [ $num1 -eq 2 ];then
python3 gen_sa_accounts.py --quick-setup -1
elif [ $num1 -eq 3 ];then
read -p "请输入新建项目数：" num3
python3 gen_sa_accounts.py --quick-setup $num3 --new-only
elif [ $num1 -eq 4 ];then
ls -d /root/AutoRclone/accounts
else
echo "输入错误请重新输入" && exit
fi
cat ~/AutoRclone/accounts/*.json | grep "client_email" | awk '{print $2}'| tr -d ',"' | sed 'N;N;N;N;N;N;N;N;N;/^$/d;G' > /root/AutoRclone/email.txt
sz /root/AutoRclone/email.txt
echo -e "1.打开右侧网址新建群组：https://groups.google.com \n2.打开刚刚下载的email.txt文件。每10个一组向群组添加成员\n3.注意群组每天做多添加100个，每次最多添加10个"
read -p "完成以上三个步骤请输入y：" confirm2
if [ $confirm2 = y ];
then
cd && rclone config
else
echo '错误！请完成以上两个步骤。' && exit 0
fi
echo 请输入刚刚挂载的网盘名称
read -p "请输入刚刚用rclone设置的挂载名称:" name
echo 请输入上传路径，例如：根目录填/，根目录下的1文件夹输入/1.以此类推。
read -p "请输入上传路径：" path
mkdir -p /home/$name
rclone mount $name: /home/$name --allow-other --allow-non-empty --vfs-cache-mode writes &
sed -i "20s/Onedrive/$name/g" /root/.aria2c/autoupload.sh
sed -i "23s|/DRIVEX/Download|$path|g" /root/.aria2c/autoupload.sh
sed -i '193s/delete.aria2.sh/autoupload.sh/g' /root/.aria2c/aria2.conf
service aria2 restart
service aria2 status
sh -c "$(curl -fsSL https://raw.githubusercontent.com/vitaminx/gclone-assistant/master/installb.sh)"