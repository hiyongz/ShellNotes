*** Settings ***
Resource              ../02_流程层管理/登录流程.txt
Resource              ../02_流程层管理/系统管理.txt
Resource              ../02_流程层管理/Telnet相关操作.txt
Resource              ../02_流程层管理/外网设置.txt
Resource              ../02_流程层管理/无线设置.txt

*** Test Cases ***
test_system
        Comment        管理页面初始化
        Comment        恢复出厂设置
        Comment        重启路由器
        Comment        WAN口参数        mtu=1500        speed=3
        局域网设置        ip=192.168.2.1        mask=255.255.255.0

test_telnet
        管理页面初始化
        Telnet-打开功能并登录
        ${lan_mac}        Telnet-获取MAC        br0
        ${lan-ipv6}        Telnet-获取IPv6        br0

test_internet
        管理页面初始化
        Comment        动态接入
        Comment        pppoe接入        tenda        tenda
        Comment        静态接入
        断开连接

test_wireless
        管理页面初始化
        Comment        无线信道频宽设置        channel=2        band=40        mode=bgn
        Comment        无线信道频宽设置        channel_5g=40        band_5g=40        mode_5g=ac
        Comment        无线桥接页面
        WEB无线名称与密码设置

test_guest
        管理页面初始化
        访客网络设置
