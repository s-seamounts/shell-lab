#!/bin/bash
#备份策略：周一做完整备份，周二到周日做增量备份，周一再次做完整备份，并且删除上次的完整备份。增量备份文件存在$back_dir目录下，完整备份文件存在/back/full目录下。
#脚本作者： 石宇飞（youngfit）
#后期脚本升级方案：将备份好的文件，写计划任务，每天将备份发送到另外一台或者几台服务器上。以确保数据的高度安全性。也可以在接受备份的几台服务器上写计划任务，删除备份策略。
week=`date +%a`
back_dir=/back/full/
incre_dir=/back/increment/
increment1=`ls -tr /back/full | tail -1`
	shopt -s extglob
increment3 () {
	cd $back_dir
	rm -rf !(`ls -rt |tail -1`)
}
increment2=`ls -tr /back/increment |head -1`
#判断备份目录是否存在
if [ ! -d /back ];then
  mkdir -p $back_dir
  mkdir -p $incre_dir
fi
case $week in
一|Monday|Mon)
    innobackupex --user=root --password='123' /back/full
	if [ $? -eq 0 ];then
	shopt -s extglob
    	        increment3
			if [ $? -eq 0 ];then
				rm -rf $incre_dir\*
			else
				echo "删除所有增量备份失败"
			fi
	else
		echo "周一完整备份失败"
	fi
    ;;
二|Tuesday|Tue)
	if [ ! -d $incre_dir ];then
		mkdir -p $incre_dir
	fi
    innobackupex --user=root --password='123' --incremental $incre_dir --incremental-basedir=$back_dir${increment1}
    ;;
三|Wednesday|Wed)
    innobackupex --user=root --password='123' --incremental $incre_dir --incremental-basedir=$incre_dir${increment2}
    ;;
四|Thursday|Thu)
    innobackupex --user=root --password='123' --incremental $incre_dir --incremental-basedir=$incre_dir${increment2}
    ;;
五|Friday|Fri)
    innobackupex --user=root --password='123' --incremental $incre_dir --incremental-basedir=$incre_dir${increment2}
    ;;
六|Saturday|Sat)
    innobackupex --user=root --password='123' --incremental $incre_dir --incremental-basedir=$incre_dir${increment2}
    ;;
日|Sunday|Sun)
    innobackupex --user=root --password='123' --incremental $incre_dir --incremental-basedir=$incre_dir${increment2}
    ;;
esac
