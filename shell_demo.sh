#!/bin/bash

# shell 语法



# # 获取命令行输入参数的个数
# paramnum=$#

# # 获取绝对路径   
# pdir=`cd -P $(dirname /root/jenkins/config.xml); pwd`

# # 获取文件名称
# file_name=`basename /root/jenkins/config.xml`

# # 获取用户名称   
# user=`whoami`

################### 生成随机数 ################### 
:<<EOF
$RANDOM产生的随机数范围是[0, 32767]：2^16-1
1. 生成范围小于32767的随机数：[lower, upper]
2. 生成超过32767的随机数
EOF
## 1. 生成范围小于32767的随机数：[lower, upper]
lower=1
upper=10
max=$(( 32767 / $upper * $upper ))
while (( (rand=$RANDOM) >= max )); do :; done
rand=$(( (rand%$upper)+$lower )) 
echo $rand

## 2. 生成超过32767的随机数
# https://www.cnblogs.com/gaoyuechen/p/8000810.html


# 生成数字和字母的随机字符
# https://stackoverflow.com/questions/2793812/generate-a-random-filename-in-unix-shell
random_filename=`cat /dev/urandom | tr -cd 'a-f0-9' | head -c 32`


################### 数组排序 ################### 
BubbleSort()
{
    # 冒泡排序
    # Performing Bubble sort
    num_length=${#arry[*]}
    
    for (( i = 0; i<$num_length; i++ ))
    do
        for (( j = 0; j<$num_length-i-1; j++ ))
        do
            if [[ ${arry[j]} -gt ${arry[$(( j+1 ))]} ]]
            then
                # swap
                temp=${arry[j]}
                arry[$j]=${arry[$((j+1))]}
                arry[$(( j+1 ))]=$temp
            fi
        done
    done
    
    echo "Array in sorted order :"
    echo -e "\E[1;31m${arry[*]} \033[0m"
}

arry=(9 8 5 6 2 4 7 1)
BubbleSort




################### 打乱顺序 ################### 
# 洗牌算法
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
      echo $i
      # 交换
      tmp=${folder_list[i]} 
      folder_list[i]=${folder_list[rand]} 
      folder_list[rand]=$tmp
   done
}

folder_list=(1 2 3 4 5 6)
shuffle


################### 字符串操作 ################### 

SIZE=10M

if [[ $SIZE == *M* ]]
then
   echo "$SIZE include M"
fi

if [[ $SIZE =~ M ]]
then
   echo "$SIZE include M"
fi