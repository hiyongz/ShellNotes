#!/bin/bash

if test 2==2; then	
    echo "true"; 
fi

if [ 2 -gt 1 ]; then 
    echo "true"; 
fi

if [[ 2 -gt 1 ]]; then
    echo "true"; 
fi

# 多个条件
echo "多个条件"
a=1
b=2
c=3
echo "方法1"
if [ $a -lt $b ] && [ $b -lt $c ]; then 
    echo "$a < $c"; 
fi
echo "方法2"
if [ $a -lt $b -a $b -lt $c ]; then 
    echo "$a < $c"; 
fi
echo "方法3"
if [[ $a -lt $b && $b -lt $c ]]; then 
    echo "$a < $c"; 
fi
