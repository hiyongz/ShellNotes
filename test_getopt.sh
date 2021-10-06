#!/bin/bash

FIELD=unset
DF=unset
COUNT=unset
green='\033[32m'

help()
{
  Usage="Usage: sh test_getopt.sh [OPTION]  \n\
  Options:\n\
        [ -f | --field FIELD]  \t\t-- 字段 \n \
        [ -Y | --display-filter DF] \t-- 条件 \n \
        [ -c | --count COUNT ]  \t-- 计数 \n \
        [ -h | --help ]  \t\t-- 帮助信息  \n \
        "
  echo -e ${green} $Usage
  exit 2
}

ARGS=$(getopt -a -n test_getopt.sh -o f:Y:ch --long field:,display-filter:,count,help -- "$@")
VALID_ARGS=$?
if [ "$VALID_ARGS" != "0" ]; then
  help  
fi

eval set -- "$ARGS"
while :
do
  case "$1" in
    -f | --field)            FIELD="$2"   ; shift 2  ;;
    -Y | --display-filter)   DF="$2"      ; shift 2  ;;
    -c | --count)            COUNT=2      ; shift    ;;
    -h | --help)             help; exit 0 ; shift    ;;    
    --) shift; break ;;
  esac
done

echo "FIELD   : $FIELD"
echo "DF   : $DF "
echo "COUNT : $COUNT"
echo "其余参数: $@"

exit 0