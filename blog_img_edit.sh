#!/bin/bash

FIELD=unset
DF=unset
COUNT=unset
normal='\033[0m';green='\033[32m'

help()
{
  Usage="Usage: sh blog_img_edit.sh [OPTION]  \n\
  Options:\n\
        [ -t | --type TYPE]  \t\t-- 0:cnblogs 博客园图片设置，1：CSDN， 2：cnblogs和CSDN \n \
        [ -h | --help ]  \t\t-- 帮助信息  \n \
        "
  echo -e ${green} $Usage
  exit 2
}

ARGS=$(getopt -a -n test_getopt.sh -o t:h --long type:,help -- "$@")
VALID_ARGS=$?
if [ "$VALID_ARGS" != "0" ]; then
  help  
fi

eval set -- "$ARGS"
while :
do
  case "$1" in
    -t | --type)            TYPE="$2"   ; shift 2  ;;
    -h | --help)             help; exit 0 ; shift    ;;    
    --) shift; break ;;
  esac
done

raw_file='blog.txt'

if [ "$TYPE" = "0" ]
then
  file_name=('blog_cnblogs.txt')
  :> $file_name # 清空 filename，如果文件不存在，则创建文件
elif [ "$TYPE" = "1" ]
then
  file_name=('blog_csdn.txt')
  :> $file_name  
else
  file_name=('blog_cnblogs.txt' 'blog_csdn.txt')
  :> ${file_name[0]}
  :> ${file_name[1]}
fi

IFS=$'\n'  # linux分隔符，默认是空格
for file in ${file_name[*]}; do
  echo -e ${green} "#########开始替换#########"
  echo "文件名：$file"
  for lines in `cat $raw_file` # 按行读取文本内容
  do    
      pic=`echo $lines | grep -E '\!\[\]\(|\!\[image\]\('` # 正则表达式查找图片

      if [ "$pic" != "" ] # 找到图片所在行后进行替换操作
      then 
        src=`echo $lines | grep -Po '(?<=\().*?(?=\))'` # 提取图片地址
        echo -e ${normal} $pic
        # 指定替换的内容：csdn和cnblogs格式不一样
        if [ "$file" = "blog_cnblogs.txt" ]
        then
          img_html='<div align=center> <img src="'$src'" width="70%" height="70%"> </div>'
        elif [ "$file" = "blog_csdn.txt" ]
        then
          img_html="![]($src#pic_center =500x)"        
        fi       
        echo $img_html >> $file

      else
        # 如果没有图片，不替换直接复制
        echo $lines >> $file
      fi
  done
done
echo "替换成功！"

exit 0