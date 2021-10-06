#!/bin/bash
# ---------------------------------------------------------------------#
# FileName:     testcase_edit.sh
# Author:   hiyongz
# Version:  V1.0
# Date:     2021-03-08
# Description:   用例名处理
# ---------------------------------------------------------------------#



#定义公共变量
normal='\033[0m';red='\033[31m';green='\033[32m';yellow='\033[33m'

#定义选项变量
argv=`getopt -a -o n:,f:,h -l casenumber:,filename:,help -- $@`

help()
{
    Usage="Usage: sh testcase_edit.sh -n [casenumber] -f [filename] \n\
Options:\n\
        [-n | casenumber] \t-- 用例序号\n \
        [-f | filename] \t-- 文件名\n       
        [-h | --help] \t\t-- 帮助信息\n \
        "
        echo -e ${green} $Usage
}

if [ "$?" != "0" ]
then
        help
        exit 127
fi

eval set -- $argv

while true
do
        case "$1" in
                -n | --casenumber)
			CaseNum=$2
			shift 2
			;;
                -f | --filename)
                        FileName=$2
                        shift 2
                        ;;
                -h | --help)
                        help
                        exit 0
                        shift
                        ;;
                --)
                        break
                        ;;
        esac
done

if [ "$FileName" = "" ]
then
    FileName='testcase_name.txt'
fi

echo -e ${green} "casenumber: $CaseNum"
echo -e ${green} "filename: $FileName"
echo -e ${normal}

if [ "$CaseNum" = "" ]
then
    echo -e ${red} "请输入用例序号~"
    help
    exit
fi

# 处理用例名
if [ ! -f $FileName ]
then
    echo -e ${red} 文件$FileName不存在
    help
    exit 0
else
    sed -i '/^$/d' $FileName # 删除空行
    sed -i 's/ *//g' $FileName # 删除空格
    
    IFS=$'\n'  # linux分隔符，默认是空格
    i=1
    for lines in `cat $FileName`
    do
        num=`echo ${lines} | awk -F ')' '{print $1}'`

        if grep '^[[:digit:]]*$' <<< "${num}"
        then
                # sed -ri "${i}s;[0-9]+\)\* |[0-9]+\)\*;case_$CaseNum.${num}_;g" testcase_name.txt
                sed -ri "${i}s;${num}\)\*|${num}\);case_$CaseNum.${num}_;g" $FileName                
        fi
        i=$[$i+1] 
    done
    echo "替换成功！"
    
fi

exit 0

