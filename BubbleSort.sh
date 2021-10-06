#!/bin/bash

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