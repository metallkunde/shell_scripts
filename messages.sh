#首先初始化所需变量，分别为一分钟前/现在所收/发/总包数
#再用前后相减得到一分钟内的收发数
#flag为了格式美观，用来初始化第一行收发的包全为零
#!/bin/bash
symbol=' '
receive_before='0'
receive_now='0'
send_before='0'
send_now='0'
pack_now='0'
pack_before='0'
dif='0'
send_dif='0'
receive_dif='0'
last_pack='0'
pack='0'
flag='1'
#核心部分为六十秒一次循环
while(true)
do
#得到当前时间
  time=$(date "+%Y-%m-%d %H:%M")
#一分钟前的包保存到对应变量
	receive_before=$receive_now
	send_before=$send_now
	pack_before=$pack_now
  last_pack=$pack
#使用grep提取出有用信息
	temp=$(netstat -s | grep "[0-9]*[0-9] segments received")
	receive_now=$(echo $temp | tr -cd "[0-9]")
	temp1=$(netstat -s | grep "[0-9]*[0-9] segments send out")
	send_now=$(echo $temp1 | tr -cd "[0-9]")
 
	pack_now=`expr $receive_now + $send_now`
 #算出一分钟内收发的包
  send_dif=`expr $send_now - $send_before`
  receive_dif=`expr $receive_now - $receive_before`
  
  pack=`expr $pack_now - $pack_before`
  dif=`expr $pack - $last_pack`
  
#判断后缀符号
if [ $dif -ge 10 ]
then 
    symbol='+'
  elif [ $dif -ge 0 ]
  then 
    symbol=' '
  else
    symbol='-'
  fi
#判断当前是否为第一行
  if [ $flag == 1 ]
  then
    send_dif='0'
    receive_dif='0'
    pack='0'
    symbol=''
    flag='0'
  fi
  printf "%s %s %4s %4s %4s %4s\n" $time $send_dif $receive_dif $pack $symbol
	sleep 60
done
