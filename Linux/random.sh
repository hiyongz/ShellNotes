#!/bin/bash
# random_number=`echo "scale=4 ; ${RANDOM}/32767" | bc -l` # 生成0-1的随机数
random_number=`bc -l <<< "scale=4 ; ${RANDOM}/32767"`
# echo $random_number

number=`echo "$random_number*100" | bc`
# echo $number
number_round1=`echo $number | xargs printf "%.*f\n" 0`
# echo $number_round1

number_round2=`echo $number | xargs printf "%.*f\n" 1`
# echo $number_round2

size=10
max=$(( 32767 / size * size ))
while (( (rand=$RANDOM) >= max )); do :; done
rand=$(( rand % (size+1) )) 
echo $rand

while (( (rand=$RANDOM) >= max )); do :; done
rand=$(( rand % (size) + 1 )) 
echo $rand

# exit 0