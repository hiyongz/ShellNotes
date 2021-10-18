#!/bin/bash

wantype=static
inputintf=eth1
outputintf=eth2
serip=$(ifconfig $inputintf | grep 'inet ' | cut -d: -f2 | awk '{ print $2}')

help()
{
  Usage="Usage: 自动配置iptables规则 \n\
Options:\n\
        [-c close] \t\t-- 清空iptables规则，断开与Internet的连接 \n \
        [-t type] \t\t-- 拨号类型\tdhcp | pppoe | static | l2tp | pptp | rupppoe \n \
        [--intf] \t\t-- 规则进入接口,默认eth1 \n \
        [--outf] \t\t-- 规则去向接口,默认eth2 \n \
        [-h help] \t\t-- 显示帮助信息  \n \
    "
    echo -e $Usage
}

Disconnect()
{
  Usage="Usage: 清空iptables规则，断开$input_intf与Internet的连接 \n\
  "
    echo "Delete iptables rules ..."
    echo -e $Usage
    iptables -t nat -F
    service iptables save
    systemctl restart iptables.service
    # dhclient $outputintf -r
    # ifconfig $outputintf down
    echo "****************************************************************"
    iptables -t nat -nvL
}

Connect_Dhcp()
{
  ip1=$(cat /tmp/dhcpd.conf|grep routers |awk -F ' ' '{print $3}'|awk -F ';' '{print $1}')
  echo "_intf $ip1"
  s1=$(echo $ip1 | awk -F '.' '{print $1}')
  s2=$(echo $ip1 | awk -F '.' '{print $2}')
  s3=$(echo $ip1 | awk -F '.' '{print $3}')
  sip2=$s1.$s2.$s3.0/24
  echo "iptables -t nat -A POSTROUTING -s $sip2 -o $outputintf -j MASQUERADE"
  iptables -t nat -A POSTROUTING -s $sip2 -o $outputintf -j MASQUERADE
}

Connect_Static()
{
  ip1=$(ifconfig $inputintf | grep 'inet ' | cut -d: -f2 | awk '{ print $2}')
  echo "_intf $ip1"
  s1=$(echo $ip1 | awk -F '.' '{print $1}')
  s2=$(echo $ip1 | awk -F '.' '{print $2}')
  s3=$(echo $ip1 | awk -F '.' '{print $3}')
  sip2=$s1.$s2.$s3.0/24
  echo "iptables -t nat -A POSTROUTING -s $sip2 -o $outputintf -j MASQUERADE"
  iptables -t nat -A POSTROUTING -s $sip2 -o $outputintf -j MASQUERADE
}

Connect_Pppoe()
{
  ip1=$(ps ax |grep 'pppoe-server '|grep -v grep |awk -F '-L' '{print $2}'|awk -F ' ' '{print $1}')
  echo "_intf $ip1"
  s1=$(echo $ip1 | awk -F '.' '{print $1}')
  s2=$(echo $ip1 | awk -F '.' '{print $2}')
  s3=$(echo $ip1 | awk -F '.' '{print $3}')
  sip2=$s1.$s2.$s3.0/24
  echo "iptables -t nat -A POSTROUTING -s $sip2 -o $outputintf -j MASQUERADE"
  iptables -t nat -A POSTROUTING -s $sip2 -o $outputintf -j MASQUERADE
}

Connect_L2tp()
{
  ip1=$(cat /etc/xl2tpd/xl2tpd.conf| grep 'local ip' |awk -F ' ' '{print $4}')
  echo "_intf $ip1"
  s1=$(echo $ip1 | awk -F '.' '{print $1}')
  s2=$(echo $ip1 | awk -F '.' '{print $2}')
  s3=$(echo $ip1 | awk -F '.' '{print $3}')
  sip2=$s1.$s2.$s3.0/24
  echo "iptables -t nat -A POSTROUTING -s $sip2 -o $outputintf -j MASQUERADE"
  iptables -t nat -A POSTROUTING -s $sip2 -o $outputintf -j MASQUERADE
}

Connect_Pptp()
{
  ip1=$(cat /etc/pptpd.conf|grep localip |awk -F ' ' '{print $2}')
  echo "_intf $ip1"
  s1=$(echo $ip1 | awk -F '.' '{print $1}')
  s2=$(echo $ip1 | awk -F '.' '{print $2}')
  s3=$(echo $ip1 | awk -F '.' '{print $3}')
  sip2=$s1.$s2.$s3.0/24
  echo "iptables -t nat -A POSTROUTING -s $sip2 -o $outputintf -j MASQUERADE"
  iptables -t nat -A POSTROUTING -s $sip2 -o $outputintf -j MASQUERADE
}

Connect_RuPppoe()
{
  ip1=$(ps ax |grep 'pppoe-server '|grep -v grep |awk -F '-L' '{print $2}'|awk -F ' ' '{print $1}')
  echo "_intf $ip1"
  s1=$(echo $ip1 | awk -F '.' '{print $1}')
  s2=$(echo $ip1 | awk -F '.' '{print $2}')
  s3=$(echo $ip1 | awk -F '.' '{print $3}')
  sip2=$s1.$s2.$s3.0/24
  echo "iptables -t nat -A POSTROUTING -s $sip2 -o $outputintf -j MASQUERADE"
  iptables -t nat -A POSTROUTING -s $sip2 -o $outputintf -j MASQUERADE
}

argv=`getopt -a -o c,t:,h -l type:,intf:,outf:,help,close -- $@`

if [ "$?" != "0" ]
then
    help
    exit 127
fi

echo "$*"

eval set -- $argv
while true
do
    case "$1" in
        -t | --type)
            wantype=$2
            shift 2
            ;;
        --intf)
            inputintf=$2
            shift 2
            ;;
        --outf)
            outputintf=$2
            shift 2
            ;;
        -h | --help)
            help
            exit 0
            shift
            ;;
        -c | --close)
            Disconnect
            exit 0
            ;; 
        -- | -)
            break
            ;;  
    esac
done

echo "wantype $wantype"
echo "inputintf $inputintf"
echo "outputintf $outputintf"

echo "Delete iptables rules ...first"
iptables -t nat -F
iptables -t filter -F

echo '1' >> /proc/sys/net/ipv4/ip_forward

echo " "
if [ $wantype = "dhcp" ];
then
    echo "DHCP"
	Connect_Dhcp
elif [ $wantype = "pppoe" ];
then
    echo "PPPoE"
    Connect_Pppoe
elif [ $wantype = "l2tp" ];
then
    echo "L2TP"
    Connect_L2tp
    Connect_Static
elif [ $wantype = "pptp" ];
then
    echo "PPTP"
    Connect_Pptp
    Connect_Static
elif [ $wantype = "rupppoe" ];
then
    echo "Russia PPPoE"
    Connect_RuPppoe
    Connect_Static
else
    echo "STATIC"
    Connect_Static
fi

echo "****************************************************************"
echo " "
echo " "
iptables -t nat -nvL
echo " "
echo " "
echo "****************************************************************"  

echo "Save iptables rules ..."
service iptables save
systemctl restart iptables.service
echo " "
echo " "
exit 0
