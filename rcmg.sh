#!/usr/bin/bash
#rclone manage remote drive
rpm -q unar &>/dev/null
if [ $? -eq 0 ]; then
    echo -e "\e[1;33munar已安装.\e[0m"
else
    yum -y install epel-release && yum -y install unar
fi
rpm -q zip &>/dev/null && echo -e "\e[1;33mzip已安装.\e[0m" || yum -y install zip
#start
echo -e "\e[1;32m1.清空垃圾桶\n2.挂载网盘\n3.查看文件夹大小.\n4.查重\n5.跨网盘转存文件（od-gd）.\n6.打包单个文件夹.\n7.批量打包文件夹.\n8.（批量）解压文件.\n9.卸载网盘\n10.查看压缩包内容(测试确定字符编码，解决乱码问题)\e[0m"
read -p "请输入你的选择:" num
if [ $num -eq 1 ]; then
    read -p "请输入gclone配置的网盘名称：" name
    gclone delete $name: --drive-trashed-only --drive-use-trash=false --verbose=2 --fast-list &
elif [ $num -eq 2 ]; then
    read -p "请输入gclone配置的网盘名称：" name1
    mkdir -p /mnt/$name1
    rclone mount $name1: /mnt/$name1 --allow-other --allow-non-empty --vfs-cache-mode writes &
    sleep 5 && df -h
elif [ $num -eq 3 ]; then
    read -p "请输入文件夹路径:" dirpath
    teampath="${dirpath#/*/}" && remote="${teampath/\//:}"
    gclone size $remote --disable listr --transfers=10
elif [ $num -eq 4 ]; then
    read -p "请输入文件夹路径:" dirpath
    teampath="${dirpath#/*/}" && remote="${teampath/\//:}"
    gclone dedupe newest $remote -vP --dedupe-mode skip
elif [ $num -eq 5 ]; then
    read -p "请输入源文件（夹）路径和目的文件夹路径，用空格隔开：" spath dpath
    teampath1="${spath#/*/}" && remote1="${teampath1/\//:/}"
    teampath2="${dpath#/*/}" && remote2="${teampath2/\//:/}"
    nohup gclone copy $remote1 $remote2 --drive-server-side-across-configs -vP --transfers=20 &
elif [ $num -eq 6 ]; then
    read -p "请输入文件夹路径：" dirpath
    filename="${dirpath##*/}"
    nohup zip -r /mnt/aabc/zip/$filename.zip $dirpath &
elif [ $num -eq 7 ]; then
    echo -e "\e[1;33m注意只会批量压缩指定目录下的一级子文件夹，二级以后不会压缩，压缩前请将文件夹整理规范。\e[0m"
    read -p "请输入文件夹路径：" dirpath
    nohup ls -Al $dirpath | grep "^d" | awk '{print $9}' | xargs -i zip -r /mnt/aabc/zip/{}.zip $dirpath/{} &
elif [ $num -eq 8 ]; then
    read -p "请输入文件（夹）路径：" path && export path
    if [ -d $path ]; then
        nohup ls -Al $path | grep -E '.*zip|.*rar|.*tar|.*gz|.*7z' | awk '{print $9}' | xargs -i unar -f $path/{} -o mnt/scu/sort/unzip &
    else
        read -p "请输入指定编码方式（乱码时使用，无则回车）：" encode
        if [ -z "$encode" ]; then
            unar -f $path -o mnt/scu/sort/unzip1
        else
            unar -e -f $encode $path -o mnt/scu/sort/unzip
        fi
    fi
elif [ $num -eq 9 ]; then
    read -p "请输入gclone配置的网盘名称：" name && fusermount -qzu /mnt/$name
elif [ $num -eq 10 ]; then
    read -p "请输入压缩包路径：" path1
    echo -e "\e[1;32m请输入指定编码，常用编码有UTF-8、GBK、GB18030、BIG5、GB2321。\e[0m"
    read -p "请输入字符编码：" encode
    lsar -e $encode $path1
else
    echo -e "\e[1;31m输入错误！\e[0m" && exit
fi

#ang.sh