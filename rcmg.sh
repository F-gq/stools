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
echo -e "\e[1;32m1.清空垃圾桶\n2.挂载网盘\n3.查看文件夹大小.\n4.查重\n5.跨网盘转存文件（od-gd）.\n6.打包单个文件夹.\n7.批量打包文件夹.\n8.（批量）解压文件.\n9.卸载网盘\n10.查看压缩包内容(测试确定字符编码，解决乱码问题).\n11.删除指定路径下的空目录。\e[0m"
read -p "请输入你的选择:" num
if [ $num -eq 1 ]; then
    read -p "请输入gclone配置的网盘名称：" name
    gclone delete $name: --drive-trashed-only --drive-use-trash=false --verbose=2 --fast-list &
elif [ $num -eq 2 ]; then
    read -p "请输入gclone配置的网盘名称,以空格隔开：" n1 n2 n3 n4 n5 n6 n7 n8 n9
    mkdir -p /mnt/$n1 /mnt/$n2 /mnt/$n3 /mnt/$n4 /mnt/$n5 /mnt/$n6 /mnt/$n7 /mnt/$n8 /mnt/$n9
    rclone mount $n1: /mnt/$n1 --allow-other --allow-non-empty --vfs-cache-mode writes 2>error.log &
    rclone mount $n2: /mnt/$n2 --allow-other --allow-non-empty --vfs-cache-mode writes 2>error.log &
    rclone mount $n3: /mnt/$n3 --allow-other --allow-non-empty --vfs-cache-mode writes 2>error.log &
    rclone mount $n4: /mnt/$n4 --allow-other --allow-non-empty --vfs-cache-mode writes 2>error.log &
    rclone mount $n5: /mnt/$n5 --allow-other --allow-non-empty --vfs-cache-mode writes 2>error.log &
    rclone mount $n6: /mnt/$n6 --allow-other --allow-non-empty --vfs-cache-mode writes 2>error.log &
    rclone mount $n7: /mnt/$n7 --allow-other --allow-non-empty --vfs-cache-mode writes 2>error.log &
    rclone mount $n8: /mnt/$n8 --allow-other --allow-non-empty --vfs-cache-mode writes 2>error.log &
    rclone mount $n9: /mnt/$n9 --allow-other --allow-non-empty --vfs-cache-mode writes 2>error.log &
    sleep 5 && df -h
elif [ $num -eq 3 ]; then
    read -p "请输入文件夹路径:" dirpath
    teampath="${dirpath#/*/}" && remote="${teampath/\//:}"
    gclone size $remote --disable listr --transfers=10
elif [ $num -eq 4 ]; then
    read -p "请输入文件夹路径:" dirpath
    teampath="${dirpath#/*/}" && remote="${teampath/\//:}"
    gclone dedupe newest $remote -vP --disable listr --transfers=10
elif [ $num -eq 5 ]; then
    read -p "请输入源文件（夹）路径和目的文件夹路径，用空格隔开：" spath dpath
    teampath1="${spath#/*/}" && remote1="${teampath1/\//:}"
    teampath2="${dpath#/*/}" && remote2="${teampath2/\//:}"
    nohup gclone copy $remote1 $remote2 --drive-server-side-across-configs -vP --transfers=1 &
elif [ $num -eq 6 ]; then
    read -p "请输入文件夹路径：" dirpath
    filename="${dirpath##*/}"
    nohup zip -r /mnt/aabc/zip/$filename.zip $dirpath &>/dev/null &
elif [ $num -eq 7 ]; then
    echo -e "\e[1;33m注意只会批量压缩指定目录下的一级子文件夹，二级以后不会压缩，压缩前请将文件夹整理规范。\e[0m"
    read -p "请输入文件夹路径：" dirpath
    nohup ls -Al $dirpath | grep "^d" | awk '{print $n9}' | xargs -i zip -r /mnt/aabc/zip/{}.zip $dirpath/{} &>/dev/null &
elif [ $num -eq 8 ]; then
    read -p "请输入文件（夹）路径：" path && export path
    if [ -d $path ]; then
        nohup ls -Al $path | grep -E '.*zip|.*rar|.*tar|.*gz|.*7z' | awk '{print $n9}' | xargs -i unar -f $path/{} -o mnt/scu/sort/unzip &>/dev/null &
    else
        read -p "请输入指定编码方式（乱码时使用，无则回车）：" encode
        if [ -z "$encode" ]; then
            nohup unar $path -o mnt/scu/sort/unzip &
            echo -e "\e[1;32m请先输入回车，再输入tail -f nohup.out查看解压详情\e[0m"
        else
            nohup unar -e $encode $path -o mnt/scu/sort/unzip &
            echo -e "\e[1;32m请先输入回车，再输入tail -f nohup.out查看解压详情\e[0m"
        fi
    fi
elif [ $num -eq 9 ]; then
    read -p "请输入gclone配置的网盘名称：" name && fusermount -qzu /mnt/$name
elif [ $num -eq 10 ]; then
    read -p "请输入压缩包路径：" path1
    echo -e "\e[1;32m请输入指定编码，常用编码有UTF-8、GBK、GB18030、BIG5、GB2321。\e[0m"
    read -p "请输入字符编码：" encode
    lsar -e $encode $path1
elif [ $num -eq 11 ]; then
    echo -en "\e[1;32m请输入指定路径：\e[0m" && read path
    teampath="${path#/*/}" && remote="${teampath/\//:}"
    gclone rmdirs $remote --leave-root -vP --transfers=10
else
    echo -e "\e[1;31m输入错误！\e[0m" && exit
fi

#ang.sh