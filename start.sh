#!/usr/bin/bash
start_net(){
	ping -w1 -c1 www.baidu.com &> /dev/null
	if [ $? -eq 0 ];then
		echo '网卡已连接'
	else
		ifup ens33
		echo '网络正在连接。。。。'
	fi
}
check_net(){
	ping -w1 -c1 www.baidu.com &> /dev/null
        if [ $? -eq 0 ];then
                echo '网络已连接'
        else
		echo '网络已断开，ens33已打开'
		exit 1
	fi
}
stop_firewalld(){
	systemctl stop firewalld
	systemctl disable firewalld
	setenforce 0
	sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
	echo '防火墙、selinux已关闭'
}
yum_centos(){
	rm -rf /etc/yum.repos.d/*
	curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo &> /dev/null
	if [ $? -eq 0 ];then
		echo 'centos阿里源已下载'
	else
		echo 'centos阿里源下载失败'
		exit 4
	fi
}
install_yum(){
        yum -y install vim wget &> /dev/null
        if [ $? -eq 0 ];then
                echo 'vim wget 已下载'
        else
                echo 'vim wget 下载失败'
                exit 2
        fi
}
yum_epel(){
	wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo &> /dev/null
         if [ $? -eq 0 ];then
                echo 'epel阿里源已下载'
        else
                echo 'epel阿里源下载失败'
                exit 5
        fi

}
start_net
check_net
stop_firewalld
yum_centos
install_yum
yum_epel
