rand() {
  local seeds
  local count
  count=0
  seeds=`while read line;do echo ${line// /..}; done<test.txt`
  while [[ $count != 1 ]];do
    seeds=`for seed in $seeds;do (($RANDOM%2==0)) && echo $seed;done`
    count=`echo "$seeds" | wc -l`
  done
  if [[ $seeds == "" ]];then
    rand
  fi
  if [[ $seeds != "" ]];then
   echo $seeds
  fi

}

res() {
 for i in `eval echo {1..$1}`;do
  tmp=`rand`
   while [[ `is_repeat $tmp` == 0  ]];do
     tmp=`rand`
   done
   arrs[$i]=$tmp
 done
 echo ${arrs[@]}
}

is_repeat() {
  for arr in ${arrs[@]};do
    if [[ $arr == $1  ]];then
      #此处需要有echo，因为子进程只能捕获echo的输出，不能捕获return的值
      echo 0
      return 0
    fi
  done
#输出1的逻辑在这里，因为需要遍历完整的数组后，才能输出1
  echo 1
}
res $1