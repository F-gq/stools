#!/bin/bash
#echo "输入分享链接"
read -p "请输入分享链接后按回车键:" link
link=${link#*id=};
link=${link#*folders/}
#echo $link
link=${link#*d/}
link=${link%?usp*}
id=$link
j=$(gclone lsd team:{$id} --dump bodies -vv 2>&1 | grep '^{"id"' | grep $id) rootName=$(echo $j | grep -Po '(?<="name":")[^"]*')
#echo "请输入分类文件夹ID"
folderid=15H8WMhKNpA_eg6s5omTp4sUldCdqUOfR
j=$(gclone lsd team:{$id} --dump bodies -vv 2>&1 | grep '^{"id"' | grep $id) folderName=$(echo $j | grep -Po '(?<="name":")[^"]*')
echo "文件将拷贝入分类目录："$folderName/$rootName
echo '拷贝日志文件将保存在：/root/AutoRclone/LOG/'"$rootName"'.txt'
echo '查漏日志文件将保存在：/root/AutoRclone/LOG/'"$rootName"'_check.txt'
echo '去重日志文件将保存在：/root/AutoRclone/LOG/'"$rootName"'_dedupe.txt'
echo 【开始拷贝】......
#echo gclone copy team:{$link} "team:{$folderid}/$rootName" --drive-server-side-across-configs -vvP --transfers=20 --log-file=/root/AutoRclone/LOG/"$rootName"'.txt'
gclone copy team:{$link} "team:{$folderid}/$rootName" --drive-server-side-across-configs -vvP --transfers=20 --log-file=/root/AutoRclone/LOG/"$rootName"'.txt'
echo 【查缺补漏】......
#echo gclone copy team:{$link} "team:{$folderid}/$rootName" --drive-server-side-across-configs -vvP --transfers=20 --log-file=/root/AutoRclone/LOG/"$rootName"'_check.txt'
gclone copy team:{$link} "team:{$folderid}/$rootName" --drive-server-side-across-configs -vvP --transfers=20 --log-file=/root/AutoRclone/LOG/"$rootName"'_check.txt'
echo 【去重检查】......
#echo gclone dedupe newest "team:{$folderid}/$rootName" --drive-server-side-across-configs -vvP --log-file=/root/AutoRclone/LOG/"$rootName"'_dedupe.txt'
gclone dedupe newest "team:{$folderid}/$rootName" --drive-server-side-across-configs -vvP --log-file=/root/AutoRclone/LOG/"$rootName"'_dedupe.txt'

if [[ ! -d "gclone lsd team:{0AEb0Xiyv-80MUk9PVA}" ]]; then
  gclone mkdir "team:{0AEb0Xiyv-80MUk9PVA}/$folderName"
else
  echo "$folderName"
fi
id=0AEb0Xiyv-80MUk9PVA
j=$(gclone lsd team:{$id} --dump bodies -vv 2>&1 | grep '^{"id"' | grep $id) BackupfolderName1=$(echo $j | grep -Po '(?<="name":")[^"]*')
echo "备份1将存入分类目录："$BackupfolderName1/$folderName/$rootName
echo '备份1拷贝日志文件将保存在：/root/AutoRclone/LOG/'"$rootName"'_backup1.txt'
echo '备份1查漏日志文件将保存在：/root/AutoRclone/LOG/'"$rootName"'_check_backup1.txt'
echo '备份1去重日志文件将保存在：/root/AutoRclone/LOG/'"$rootName"'_dedupe_backup1.txt'
echo 【开始拷贝】......
#echo gclone copy team:{$link} "team:{0AEb0Xiyv-80MUk9PVA}/$folderName/$rootName" --drive-server-side-across-configs -vvP --transfers=20 --log-file=/root/AutoRclone/LOG/"$rootName"'_backup1.txt'
gclone copy team:{$link} "team:{0AEb0Xiyv-80MUk9PVA}/$folderName/$rootName" --drive-server-side-across-configs -vvP --transfers=20 --log-file=/root/AutoRclone/LOG/"$rootName"'_backup1.txt'
echo 【查缺补漏】......
#echo gclone copy team:{$link} "team:{0AEb0Xiyv-80MUk9PVA}/$folderName/$rootName" --drive-server-side-across-configs -vvP --transfers=20 --log-file=/root/AutoRclone/LOG/"$rootName"'_check_backup1.txt'
gclone copy team:{$link} "team:{0AEb0Xiyv-80MUk9PVA}/$folderName/$rootName" --drive-server-side-across-configs -vvP --transfers=20 --log-file=/root/AutoRclone/LOG/"$rootName"'_check_backup1.txt'
echo 【去重检查】......
#echo gclone dedupe newest "team:{0AEb0Xiyv-80MUk9PVA}/$folderName/$rootName" --drive-server-side-across-configs -vvP --log-file=/root/AutoRclone/LOG/"$rootName"'_dedupe_backup1.txt'
gclone dedupe newest "team:{0AEb0Xiyv-80MUk9PVA}/$folderName/$rootName" --drive-server-side-across-configs -vvP --log-file=/root/AutoRclone/LOG/"$rootName"'_dedupe_backup1.txt'

if [[ ! -d "gclone lsd team:{0APiVGMdIpoc-Uk9PVA}" ]]; then
  gclone mkdir "team:{0APiVGMdIpoc-Uk9PVA}/$folderName"
else
  echo "$folderName"
fi
id=0APiVGMdIpoc-Uk9PVA
j=$(gclone lsd team:{$id} --dump bodies -vv 2>&1 | grep '^{"id"' | grep $id) BackupfolderName2=$(echo $j | grep -Po '(?<="name":")[^"]*')
echo "备份2将存入分类目录："$BackupfolderName2/$folderName/$rootName
echo '备份2拷贝日志文件将保存在：/root/AutoRclone/LOG/'"$rootName"'_backup2.txt'
echo '备份2查漏日志文件将保存在：/root/AutoRclone/LOG/'"$rootName"'_check_backup2.txt'
echo '备份2去重日志文件将保存在：/root/AutoRclone/LOG/'"$rootName"'_dedupe_backup2.txt'
echo 【开始拷贝】......
#echo gclone copy team:{$link} "team:{0APiVGMdIpoc-Uk9PVA}/$folderName/$rootName" --drive-server-side-across-configs -vvP --transfers=20 --log-file=/root/AutoRclone/LOG/"$rootName"'_backup2.txt'
gclone copy team:{$link} "team:{0APiVGMdIpoc-Uk9PVA}/$folderName/$rootName" --drive-server-side-across-configs -vvP --transfers=20 --log-file=/root/AutoRclone/LOG/"$rootName"'_backup2.txt'
echo 【查缺补漏】......
#echo gclone copy team:{$link} "team:{0APiVGMdIpoc-Uk9PVA}/$folderName/$rootName" --drive-server-side-across-configs -vvP --transfers=20 --log-file=/root/AutoRclone/LOG/"$rootName"'_check_backup2.txt'
gclone copy team:{$link} "team:{0APiVGMdIpoc-Uk9PVA}/$folderName/$rootName" --drive-server-side-across-configs -vvP --transfers=20 --log-file=/root/AutoRclone/LOG/"$rootName"'_check_backup2.txt'
echo 【去重检查】......
#echo gclone dedupe newest "team:{0APiVGMdIpoc-Uk9PVA}/$folderName/$rootName" --drive-server-side-across-configs -vvP --log-file=/root/AutoRclone/LOG/"$rootName"'_dedupe_backup2.txt'
gclone dedupe newest "team:{0APiVGMdIpoc-Uk9PVA}/$folderName/$rootName" --drive-server-side-across-configs -vvP --log-file=/root/AutoRclone/LOG/"$rootName"'_dedupe_backup2.txt'

#./gd.sh
