yum -y install updata                                                                            #安装更新
rpm -q git &>/dev/null && echo -e "\e[1;32mgit已安装.\e[0m" || yum -y install git                                  #安装git
rpm -q zip &>/dev/null && echo -e "\e[1;32mzip已安装.\e[0m" || yum -y install zip
rpm -q unar &>/dev/null && echo -e "\e[1;32munar已安装.\e[0m" || yum -y install unar
rpm -q curl &>/dev/null && echo -e "\e[1;32mcurl已安装.\e[0m" || yum -y install curl                               #安装curl
rpm -q wget &>/dev/null && echo -e "\e[1;32mwget已安装.\e[0m" || yum -y install wget                               #安装wget
rpm -q fuse &>/dev/null && echo -e "\e[1;32mfuse已安装.\e[0m" || yum -y install fuse                               #安装fuse
rpm -q lrzsz &>/dev/null && echo -e "\e[1;32mlrzsz已安装.\e[0m" || yum -y install lrzsz                            #安装lrzsz
rpm -q unzip &>/dev/null && echo -e "\e[1;32munzip已安装.\e[0m" || yum -y install unzip                            #安装unzip
rpm -q screen &>/dev/null && echo -e "\e[1;32mscreen已安装.\e[0m" || yum -y install screen                         #安装screen
rpm -q python3 &>/dev/null && echo -e "\e[1;32mpython3已安装.\e[0m" || yum -y install python3                      #安装python3
rpm -q python3-pip &>/dev/null && echo -e "\e[1;32mpython3-pip已安装.\e[0m" || yum -y install python3-pip          #安装python3-pip
lsmod | grep bbr &> /dev/null && echo -e "\e[1;32mbbr已安装\e[0m" || bash <(curl https://github.com/teddysun/across/raw/master/bbr.sh)
