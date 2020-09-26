#!/usr/bin/bash
#aria2 and gclone.
#Use aria2 and gclone to download or copy files.
color=('\e[1;30m' '\e[1;31m' '\e[1;32m' '\e[1;33m' '\e[1;34m' '\e[1;35m' '\e[1;36m' '\e[1;37m' '\e[0m') #灰、红、绿、黄、蓝、紫、天蓝、白、
aNAME=$(uname -a)
if [ -f /etc/redhat-release ]; then
    if [[ $(cat /etc/redhat-release) =~ "CentOS" ]]; then
        os="CentOS"
    fi
elif [[ $aNAME =~ "Debian" ]]; then
    os="Debian"
elif [[ $aNAME =~ "CentOS" ]]; then
    os="CentOS"
elif [[ $aNAME =~ "Ubuntu" ]]; then
    os="Ubuntu"
else
    os=$aNAME
fi
#安装更新和必备软件
soft=(upgrade git wget curl fuse lrzsz unzip screen python3 python3-pip)
yum -y install ${soft[*]}
if [ -e /usr/bin/gclone -a -e /usr/bin/rclone ]; then
    echo -e "${color[2]}gclone已安装。${color[9]}"
else
    wget https://github.com/mawaya/rclone/releases/download/fwwkr-v0.2b/rclone-v1.52.2-fwwkr-v0.2b-linux-amd64.zip
    unzip rclone-v1.52.2-fwwkr-v0.2b-linux-amd64.zip && \mv -f ~/rclone-v1.52.2-fwwkr-v0.2b-linux-amd64/gclone /usr/bin/gclone && cp /usr/bin/gclone /usr/bin/rclone
fi
[ -e /usr/local/bin/aria2c ] && echo -e "${color[2]}aria2已安装${color[9]}" || bash <(curl https://raw.githubusercontent.com/P3TERX/aria2.sh/master/aria2.sh)
echo -ne "${color[2]}请输入上传的目标团队盘：${color[9]}" && read td
echo -en "${color[2]}请输入上传文件夹路径，例如：上传至团队盘根目录则输入${color[9]}${color[8]}/${color[9]}${color[2]},团队盘的sort文件夹则输入${color[9]}${color[8]}/sort${color[9]}${color[2]}。：${color[9]}" && read path
sed -i 's/clean.sh/upload.sh/g' /root/.aria2c/aria2.conf
sed -i "s|/DRIVEX/Download|$path|g" /root/.aria2c/upload.sh
sed -i "s/Onedrive/$td/g" /root/.aria2c/upload.sh
git clone https://github.com/xyou365/AutoRclone && cd ~/AutoRclone && pip3 install -r requirements.txt
#检查是否生成凭证并放入AutoRclone文件夹
if [ -e /root/AutoRclone/credentials.json ]; then
    echo -e "${color[2]}凭证已存在.${color[9]}"
else
    echo -ne "1.打开下面的链接进行授权和下载：${color[2]}https://developers.google.com/drive/api/v3/quickstart/python ${color[9]} \n2.将下载好的${color[8]}credentials.json${color[9]}文件上传至服务器/root/Autorclone目录下\n"
    echo -ne "${color[8]}完成以上两个步骤请输入y：${color[9]}" && read confirm1
    while :; do
        [ "$confirm1" = y ] && break || echo -e "${color[2]}输入错误，请重新运行脚本。${color[9]}"
    done
fi
echo -ne "${color[2]}1.新建项目并生成SA\n2.在原有项目基础上生成SA\n3.仅在新建项目中生成SA\n4.不需要创建，accounts文件夹已生成SA${color[9]}"
while :; do
    echo -ne "${color[8]}选择上面选项对应数字：${color[9]}" && read num1
    if [ "$num1" -eq 1 ]; then
        echo -ne "${color[8]}请输入新建项目数：${color[9]}" && read num2
        cd /root/AutoRclone && python3 gen_sa_accounts.py --quick-setup $num2 && break
    elif [ "$num1" -eq 2 ]; then
        cd /root/AutoRclone && python3 gen_sa_accounts.py --quick-setup -1 && break
    elif [ "$num1" -eq 3 ]; then
        echo -ne "${color[8]}请输入新建项目数：${color[9]}" && read num3
        cd /root/AutoRclone && python3 gen_sa_accounts.py --quick-setup $num3 --new-only && break
    elif [ "$num1" -eq 4 ]; then
        if [ $(ls -l /root/AutoRclone/accounts/ | wc -l) -gt 1 ]; then
            [ -e ~/AutoRclone/email.txt ] || cat ~/AutoRclone/accounts/*.json | grep "client_email" | awk '{print $2}' | tr -d ',"' | sed 'N;N;N;N;N;N;N;N;N;/^$/d;G' >/root/AutoRclone/email.txt && sz /root/AutoRclone/email.txt && break
        else
            echo -e "${color[3]}请将accounts文件夹上传至服务器/root/AutoRclone/下,并重新输入选项。${color[9]}"
        fi
    else
        echo -e "${color[2]}输入错误！${color[9]}"
    fi
done
echo -e "1.打开右侧网址新建群组：https://groups.google.com \n2.打开刚刚下载的email.txt文件。每10个一组向群组添加成员\n3.将群组账号和邮箱账号添加至团队盘。"
read -p "完成以上三个步骤请输入y：" confirm2
if [ $confirm2 != y ]; then
    echo -e "${color[2]}错误,请重新运行脚本。${color[9]}" && exit
fi
[ -e /root/.config/rclone/rclone.conf ] || gclone config
read -p "请输入用gclone设置的挂载名称:" name
echo 请输入上传路径，例如：根目录填/，根目录下的1文件夹输入/1.以此类推。
read -p "请输入上传路径：" path
mkdir -p /home/$name ~/AutoRclone/LOG/
rclone mount $name: /home/$name --allow-other --allow-non-empty --vfs-cache-mode writes &
sed -i "20s/Onedrive/$name/g" /root/.aria2c/autoupload.sh
sed -i "23s|/DRIVEX/Download|$path|g" /root/.aria2c/autoupload.sh
cd && sh -c "$(curl -fsSL https://raw.githubusercontent.com/vitaminx/gclone-assistant/master/installa.sh)"
