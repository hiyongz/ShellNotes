#!/bin/bash
# ---------------------------------------------------------------------#
# FileName:     multiple_file_generate.sh
# Author:   haiyong zhang
# Version:  V1.0
# Date:     2021-07-09
# Description:   批量生成文件、目录
# ---------------------------------------------------------------------#

# 定义公共变量
green='\033[32m'
SIZE=unset
NUMBER=unset
FOLDER_NUMBER=10  # 创建目录个数
SAVE_FOLDER=/tmp/smb/testfolder  # 文件生成路径

help()
{
  Usage="Usage: sh multiple_file_generate.sh [OPTION]  \n\
  Options:\n\
        [ -s | --size SIZE]  \t\t-- 总文件大小，eg: -s 5M \n \
        [ -n | --number NUMBER ]  \t-- 文件数量 \n \
        [ -N | --Number FOLDER_NUMBER ]  --目录（文件夹）数量 \n       
        [ -f | --folder SAVE_FOLDER ]  --文件生成路径 \n \
        [ -h | --help ]  \t\t-- 帮助信息  \n \
        "
  echo -e ${green} $Usage
  exit 2
}

#定义选项变量
ARGS=`getopt -a -n multiple_file_generate.sh -o s:n:N:f:h -l size:,number:,Number:,folder:,help -- $@`

VALID_ARGS=$? # 判断输入

echo "参数个数     : $#"

if [[ "$VALID_ARGS" != "0" || "$#" == "0" ]]
then
  help
fi

eval set -- "$ARGS" # 参数处理

# 读取参数
while :
do
  case "$1" in
    -s | --size)        SIZE="$2"    ; shift 2  ;;
    -n | --number)      NUMBER="$2"  ; shift 2  ;;
    -N | --Number)      FOLDER_NUMBER="$2"  ; shift 2  ;;
    -f | --folder)      SAVE_FOLDER="$2"  ; shift 2  ;;
    -h | --help)        help; exit 0 ; shift    ;;
    --) shift; break ;;
  esac
done

# 判断必选参数是否输入
if [[ "$SIZE" == "unset" || "$NUMBER" == "unset" ]]
then
  help
fi

# 计算文件个数和大小
SIZE_NUM=`echo $SIZE | tr -cd "[0-9]" `  # 提取数字

if [[ $SIZE == *K* ]]
then
  let SIZE_BYTES=$SIZE_NUM*1024
elif [[ $SIZE == *M* ]]
then
  let SIZE_BYTES=$SIZE_NUM*1024*1024
elif [[ $SIZE == *G* ]]
then
  let SIZE_BYTES=$SIZE_NUM*1024*1024*1024
fi

echo "总文件大小   : $SIZE"
echo "总文件大小   : $SIZE_BYTES Bytes"
echo "文件个数     : $NUMBER "
echo "目录个数     : $FOLDER_NUMBER "
echo "文件生成路径 : $SAVE_FOLDER "
echo "其余参数: $@"


BubbleSort()
{
    # 冒泡排序
    # Performing Bubble sort
    for (( i = 0; i<$num_length; i++ ))
    do
        for (( j = 0; j<$num_length-i-1; j++ ))
        do
            if [[ ${num_list[j]} -gt ${num_list[$(( j+1 ))]} ]]
            then
                # swap
                temp=${num_list[j]}
                num_list[$j]=${num_list[$((j+1))]}
                num_list[$(( j+1 ))]=$temp
            fi
        done
    done
    
    # echo "Array in sorted order :"
    # echo -e "\E[1;31m${num_list[*]} \033[0m"
}

SplitInteger()
{
    # 将总文件大小$SIZE_BYTES分割$NUMBER个小文件
    
    let SIZE_BYTES=$SIZE_BYTES-$NUMBER*$minNum
    # echo "SIZE_BYTES666   : $SIZE_BYTES"
    declare -a num_list
    num_list[0]=0
    num_list[1]=$SIZE_BYTES
    let num=$NUMBER
    for i in $(seq 2 $num); do
        random_rate=`echo "scale=4 ; ${RANDOM}/32767" | bc -l` # 生成0-1的随机数 
        # let random_bytes=$(( SIZE_BYTES*random_rate ))
        random_bytes=`echo "$SIZE_BYTES*$random_rate" | bc` # 字符类型转换为数字类型进行运算
        # echo "$random_bytes"
        num_list[$i]=`echo $random_bytes | xargs printf "%.*f\n" 0` # 对结果进行四舍五入计算
    done

    # echo "Array in unsorted order :"
    # echo ${num_list[*]}

    num_length=${#num_list[*]}
    BubbleSort   # 排序

    # 计算差值
    # declare -a new_list
    let rand_len=$num_length-2
    for i in $(seq 0 $rand_len); do
        new_list[$i]=`echo "${num_list[$(( i+1 ))]}-${num_list[$i]}+$minNum" | bc`
    done

    # echo "Diff Array:"
    # echo "${new_list[*]}"

    sum=0
    for (( i=0;i<${#new_list[*]};i++ ))
    do
        let sum=sum+${new_list[$i]}
    done

    echo "总文件大小   :$sum"

}

shuffle() {
   local i tmp size max rand
   # 打乱顺序
   # Knuth-Fisher-Yates shuffle algorithm
   size=${#folder_list[*]}
   max=$(( 32767 / size * size ))
   # echo "max: $max"
   for ((i=size-1; i>0; i--)); do
      while (( (rand=$RANDOM) >= max )); do :; done
      rand=$(( rand % (i+1) ))
      
      # 交换
      tmp=${folder_list[i]} 
      folder_list[i]=${folder_list[rand]} 
      folder_list[rand]=$tmp
   done
}

FoldersGenerte()
{
    # 生成文件夹
    # declare -a folder_list     
    var1=1
    folder_list[0]=$SAVE_FOLDER    
    while test $var1 -lt $FOLDER_NUMBER
    do
        shuffle
        folder=${folder_list[0]}
        folders=$folder/test_$var1
        folder_list[var1]=$folders
        mkdir $folders
        var1=`expr $var1 + 1`
    done
}


declare -a new_list # 声明一个数组存放分割的文件大小
declare -a folder_list # 目录数组

minNum=100     # 最小文件大小
SplitInteger   # 分割
# echo "Diff Array:"
# echo "${new_list[*]}"

# 在$SAVE_FOLDER目录下生成目录，目录随机嵌套

rm -rf $SAVE_FOLDER # 删除文件生成路径
mkdir $SAVE_FOLDER # 创建文件生成路径
FoldersGenerte # 生成目录

echo ${folder_list[*]}
size=${#folder_list[*]}
echo "长度: $size"


# 创建文件，文件存放目录随机
for s in ${new_list[@]}
do  
  random_filename=`cat /dev/urandom | tr -cd 'a-f0-9' | head -c 32` # 产生随机文件名

  shuffle
  folder=${folder_list[0]}
  
  fallocate -l $s $folder/testfile$s\_$random_filename  # 创建文件

done

exit 0