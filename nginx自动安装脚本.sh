#!/usr/bin/bash
stop_firewalld(){
systemctl stop firewalld
systemctl disable firewalld
setenforce 0 &> /dev/null
sed -i 's/enforcing/disabled/' /etc/selinux/config
echo "防火墙与selinux已关闭"
}
check_net(){
ping -w1 -c1 www.baidu.com &> /dev/null
if [ $? -eq 0 ];then
	echo "网络已连接"
else
	echo "网络连接失败，请手动配置"
	exit 1
fi
}


stop_httpd(){
httpd &> /dev/null
if [ $? -eq 0 ];then
	echo "关闭httpd中。。。。"
	systemctl stop httpd
	systemctl disable httpd
else
	echo "httpd已关闭"
fi
}


install_nginx(){
echo '[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true' > /etc/yum.repos.d/nginx.repo
yum -y install nginx &> /dev/null
if [ $? -eq 0 ];then
	echo "nginx安装成功"
	return 2
else
	echo "nginx安装失败"
	exit 3
fi

}
start_nginx(){

if [ $? -eq 2 ];then
        systemctl start nginx
        systemctl enable nginx
        echo "已自动帮您开启nginx服务"
	nginx -v
fi
}
stop_firewalld
sleep 1
check_net
sleep 1
stop_httpd
sleep 1
install_nginx
start_nginx


