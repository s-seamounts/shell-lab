#!/usr/bin/bash
mk_file(){
	if [ ! -d /usr/local/java/ ];then
		mkdir /usr/local/java
		echo "文件夹正在为您创建
文件夹已创建成功"
	else
		echo "文件夹已存在"
	fi
}
get_url(){
	if [ ! -d /usr/local/jdk1.8.0_211 ];then	
		wget ftp://10.3.137.100/soft/jdk-8u211-linux-x64.tar.gz
		if [ $? -eq 0 ];then
			echo "JDK包已拉取成功"
		else
			echo "JDK包拉取失败！"
		fi
		tar -xvf /root/jdk-8u211-linux-x64.tar.gz -C /usr/local/ &> /dev/null
		if [ $? -eq 0 ];then
                	echo "JDK包解压成功"
			mv /usr/local/jdk1.8.0_211/* /usr/local/java
        	else
                	echo "JDK包解压失败！"
        	fi
	else
		echo "JDK已拉取解压"
	fi

}
set_path(){
	echo 'export JAVA_HOME=/usr/local/java/
export PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH' >> /etc/profile
	echo "环境配置已成功"
	source /etc/profile
}

mk_file
get_url
set_path
