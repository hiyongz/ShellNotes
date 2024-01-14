#!/bin/bash


JAVA_OPTIONS="-server -Xmx256m -Xms256m"

this_dir="$( cd "$( dirname "$0"  )" && pwd )"
log_file="${this_dir}/catalina.out"
jar_file="${this_dir}/${Jenkins}"
green='\033[32m'

help()
{
  Usage="Usage: sh test_getopt.sh [OPTION]  \n\
    Options:\n\
        \t[start]  \t\t--   启动xxx \n \
        \t[stop]   \t\t\t--   停止xxx \n \
        \t[restart] \t\t--  重启xxx \n \
        \t[status]  \t\t--  xxx状态  \n \
    Example: \n\
        \tsh $0 start \n\
    "
  echo -e ${green} $Usage
  exit 2
}

if [ "$1" = "" ];
then
    help
    exit 1
fi


function start()
{
    count=`ps -ef |grep java|grep $Jenkins|grep -v grep|wc -l`
    if [ $count != 0 ];then
        echo "$Jenkins is running..."
    else
        nohup java $JAVA_OPTIONS -jar  ${jar_file}  --httpPort=22354> "${log_file}" 2>&1 &
        echo -e "Start $Jenkins success..."
    fi
}
 
function stop()
{
    echo "Stop $Jenkins"
    boot_id=`ps -ef |grep java|grep $Jenkins|grep -v grep|awk '{print $2}'`
    count=`ps -ef |grep java|grep $Jenkins|grep -v grep|wc -l`
 
    if [ $count != 0 ];then
        kill $boot_id
        count=`ps -ef |grep java|grep $Jenkins|grep -v grep|wc -l`
 
        boot_id=`ps -ef |grep java|grep $Jenkins|grep -v grep|awk '{print $2}'`
        kill -9 $boot_id
    fi
}
 
function restart()
{
    stop
    sleep 2
    start
}
 
function status()
{
    count=`ps -ef |grep java|grep $Jenkins|grep -v grep|wc -l`
    if [ $count != 0 ];then
        echo "$Jenkins is running..."
    else
        echo "$Jenkins is not running..."
    fi
}
 
case $1 in
    start)
        start;;
    stop)
        stop;;
    restart)
        restart;;
    status)
        status;;
    *) 
    help
esac