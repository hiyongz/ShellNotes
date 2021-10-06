#!/bin/bash

shuffle() {
   local i tmp size max rand
   # 打乱顺序
   # Knuth-Fisher-Yates shuffle algorithm
   size=${#my_array[*]}
   max=$(( 32767 / size * size ))
   # echo "max: $max"
   for ((i=size-1; i>0; i--)); do
      while (( (rand=$RANDOM) >= max )); do :; done
      rand=$(( rand % (i+1) ))    
      # 交换
      tmp=${my_array[i]} 
      my_array[i]=${my_array[rand]} 
      my_array[rand]=$tmp
   done
}

my_array=(1 2 3 4 5 6 7 8 9)
shuffle
echo ${my_array[*]}

