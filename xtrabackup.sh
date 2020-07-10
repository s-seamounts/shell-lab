week=`date +%a`
full_file=`ls -tr /root/xtrabackup/full | tail -1`
incre_file=`ls -tr /root/xtrabackup/increse | tail -1`
mk_file(){
if [ ! -d /root/xtrabackup ];then 
	mkdir -p /root/xtrabackup/{full,increse}
	echo '备份目录创建成功'
else
	echo '备份目录已创建'
fi
}
mk_file2(){
if [ ! -d /root/xtrabackup/full ];then
        mkdir -p /root/xtrabackup/full
	echo '完整备份目录创建成功'
else
        echo '完整备份目录已创建'
fi
}

mk_file3(){
if [ ! -d /root/xtrabackup/increse ];then
        mkdir -p /root/xtrabackup/increse
	echo '增量备份目录创建成功'
else
        echo '增量备份目录已创建'
fi
}

main(){
if [ $week = Mon ];then
	rm -rf /root/xtrabackup/full/*
	if [ $? -eq 0 ];then
		innobackupex --user=root --password='Haishan@123' /root/xtrabackup/full
		if [ $? -eq 0 ];then
			echo '完整备份成功'
		else
			echo '完整备份失败'
			exit 1
		fi
	else
		echo '删除完整备份文件失败'
		echo '完整备份因删除文失败件而失败'
		exit 2
	fi		
elif [ $week = Tue ];then
	rm -rf /root/xtrabackup/increse/*
	if [ $? -eq 0 ];then
		innobackupex --user=root --password='Haishan@123' --incremental /root/xtrabackup/increse --incremental-basedir=/root/xtrabackup/full/$full_file
		echo '周二的增量备份成功'
	else
		echo '删除增量备份失败'
		echo '增量备份因删除文失败件而失败'
		exit 3
	fi
else
	innobackupex --user=root --password='Haishan@123' --incremental /root/xtrabackup/increse --incremental-basedir=/root/xtrabackup/increse/$incre_file
	if [ $? -eq 0 ];then
		echo "星期：$week ，备份成功 "
	else
		echo "星期：$week ，备份失败"
		exit 4
	fi
fi
}
mk_file
mk_file2
mk_file3
main
