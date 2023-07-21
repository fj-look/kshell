#! /bin/bash
# https://github.com/fj-look/kshell


#彩色
red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}
green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
yellow(){
    echo -e "\033[33m\033[01m$1\033[0m"
}
blue(){
    echo -e "\033[34m\033[01m$1\033[0m"
}


#获取本机IP
function getip(){
echo  
curl ip.p3terx.com
echo
}


#网络配置优化
function networksh(){
	sed -i '/net.ipv4.tcp_retries2/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_slow_start_after_idle/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_fastopen/d' /etc/sysctl.conf
	sed -i '/fs.file-max/d' /etc/sysctl.conf
	sed -i '/fs.inotify.max_user_instances/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_syncookies/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_fin_timeout/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_tw_reuse/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_max_syn_backlog/d' /etc/sysctl.conf
	sed -i '/net.ipv4.ip_local_port_range/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_max_tw_buckets/d' /etc/sysctl.conf
	sed -i '/net.ipv4.route.gc_timeout/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_synack_retries/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_syn_retries/d' /etc/sysctl.conf
	sed -i '/net.core.somaxconn/d' /etc/sysctl.conf
	sed -i '/net.core.netdev_max_backlog/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_timestamps/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_max_orphans/d' /etc/sysctl.conf
	sed -i '/net.ipv4.ip_forward/d' /etc/sysctl.conf


echo "net.ipv4.tcp_retries2 = 8
net.ipv4.tcp_slow_start_after_idle = 0
fs.file-max = 1000000
fs.inotify.max_user_instances = 8192
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_tw_reuse = 1
net.ipv4.ip_local_port_range = 1024 65000
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.route.gc_timeout = 100
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.core.somaxconn = 32768
net.core.netdev_max_backlog = 32768
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_max_orphans = 32768
# forward ipv4
#net.ipv4.ip_forward = 1">>/etc/sysctl.conf
sysctl -p
	echo "*               soft    nofile           1000000
*               hard    nofile          1000000">/etc/security/limits.conf
	echo "ulimit -SHn 1000000">>/etc/profile
	read -p "需要重启VPS后，才能生效系统优化配置，是否现在重启 ? [Y/n] :" yn
	[ -z "${yn}" ] && yn="y"
	if [[ $yn == [Yy] ]]; then
		echo -e "${Info} VPS 重启中..."
		reboot
	fi
}


#SWAP一键安装/卸载脚本
function swapsh(){
wget -O "/root/swap.sh" "https://raw.githubusercontent.com/fj-look/kshell/master/swap.sh" --no-check-certificate -T 30 -t 5 -d
chmod +x "/root/swap.sh"
chmod 777 "/root/swap.sh"
blue "下载完成"
blue "你也可以输入 bash /root/swap.sh 来手动运行"
bash "/root/swap.sh"
}


#F2B一键安装脚本
function f2bsh(){
red "卸载请 运行 wget https://raw.githubusercontent.com/fj-look/kshell/master/fail2ban-uninstall.sh && bash fail2ban-uninstall.sh"
wget https://raw.githubusercontent.com/fj-look/kshell/master/fail2ban.sh && bash fail2ban.sh 2>&1 | tee fail2ban.log
red "卸载请 运行 wget https://raw.githubusercontent.com/fj-look/kshell/master/fail2ban-uninstall.sh && bash fail2ban-uninstall.sh"
}


#主菜单
function start_menu(){
    clear
    green " FROM: https://github.com/fj-look/kshell "
    green " USE:  wget -O menu.sh https:raw.githubusercontent.com/fj-look/kshell/main/menu.sh && chmod +x menu.sh && clear && ./menu.sh "
    yellow " ==================================================" 
    green " 1.  swap one-click install/uninstall script"
    green " 2.  fail2ban one-click installation script"
    green " 3.  Get the native IP"
    green " 4.  Network configuration optimization"
    yellow " --------------------------------------------------"
    green " 0. Exit Script"
    echo
    read -p "Please enter a number:" menuNumberInput
    case "$menuNumberInput" in
        1 )
           swapsh
	;;
        2 )
           f2bsh
	;;
        3 )
           getip
	;;
        4 )
           networksh
	;;
        0 )
            exit 1
        ;;
        * )
            clear
            red "Please enter the correct number!"
            start_menu
        ;;
    esac
}
start_menu "first"
