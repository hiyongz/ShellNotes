# Windows 网络管理命令
本文列出一些常用的 Windows 网络管理命令。
<!--more-->

## ping
ping: 测试网络连接情况
* `-n`：要发送的回显请求数
* `-t`：ping 主机直到中断
* `-i`：生存时间ttl
* `-6`：IPv6

```bash
$ ping 192.168.20.8 -n 3

Pinging 192.168.20.8 with 32 bytes of data:
Reply from 192.168.20.8: bytes=32 time<1ms TTL=64
Reply from 192.168.20.8: bytes=32 time<1ms TTL=64
Reply from 192.168.20.8: bytes=32 time<1ms TTL=64

Ping statistics for 192.168.20.8:
    Packets: Sent = 3, Received = 3, Lost = 0 (0% loss),
Approximate round trip times in milli-seconds:
    Minimum = 0ms, Maximum = 0ms, Average = 0ms
```
## 网络信息查询
### netstat
netstat: 协议统计和当前 TCP/IP 网络连接
* `-t` 列出所有tcp连接
* `-a`：显示所有连接和侦听端口
* `-n`：以数字形式显示地址和端口号
* `-o`：显示进程 ID
* `-p proto`：显示指定的协议的连接，TCP、UDP、TCPv6 或 UDPv6
* `-s`：显示每个协议的统计。默认情况下，显示IP、IPv6、ICMP、ICMPv6、TCP、TCPv6、UDP 和 UDPv6的统计信息，可使用`-p` 选项指定协议。
* `-e`：显示以太网统计。此选项可以与 -s 选项结合使用。
* `-r`：显示路由信息

```bash
$ netstat -ano -p tcp
Active Connections

  Proto  Local Address          Foreign Address        State           PID
  TCP    0.0.0.0:21             0.0.0.0:0              LISTENING       4896
  TCP    0.0.0.0:135            0.0.0.0:0              LISTENING       1032
  TCP    0.0.0.0:445            0.0.0.0:0              LISTENING       4
  TCP    0.0.0.0:902            0.0.0.0:0              LISTENING       10388
  TCP    0.0.0.0:912            0.0.0.0:0              LISTENING       10388
  TCP    0.0.0.0:1080           0.0.0.0:0              LISTENING       11476
  TCP    0.0.0.0:2425           0.0.0.0:0              LISTENING       7728
  TCP    0.0.0.0:5040           0.0.0.0:0              LISTENING       7940
  TCP    0.0.0.0:5357           0.0.0.0:0              LISTENING       4
```

查询5037端口占用：

```sh
$ netstat -ano | findstr 5037 
TCP    0.0.0.0:5037           0.0.0.0:0              LISTENING       34212
```
找到对应进程（也可以在任务管理器中查看）：
```sh
$ tasklist | findstr 34212
adb.exe                      34212 Console                    1     10,692 K
```
通过PID或者进程名杀死进程：
```sh
$ taskkill -pid 34212 -f -t # taskkill /pid 34212 /f /t
$ taskkill -f -im adb.exe # taskkill /f /im adb.exe
```

### 网卡信息

```bash
$ ipconfig
$ ipconfig /all
$ netsh interface ipv4 show config
$ netsh interface ipv6 show config
$ wmic nic list brief
```

查看IP地址：
```bash
$ netsh interface ip show address WAN

Configuration for interface "WAN"
    DHCP enabled:                         Yes
    IP Address:                           192.168.3.98
    Subnet Prefix:                        192.168.3.0/24 (mask 255.255.255.0)
    Default Gateway:                      192.168.3.252
    Gateway Metric:                       0
    InterfaceMetric:                      25
$ 
$ netsh interface ipv4 show dnsservers WAN

Configuration for interface "WAN"
    DNS servers configured through DHCP:  192.168.3.252
    Register with which suffix:           Primary only
```
更多命令：
```bash
$ netsh interface ipv4 show /?

The following commands are available:

Commands in this context:
show addresses - Shows IP address configurations.
show compartments - Shows compartment parameters.
show config    - Displays IP address and additional information.
show destinationcache - Shows destination cache entries.
show dnsservers - Displays the DNS server addresses.
show dynamicportrange - Shows dynamic port range configuration parameters.
show excludedportrange - Shows all excluded port ranges.
show global    - Shows global configuration parameters.
show icmpstats - Displays ICMP statistics.
show interfaces - Shows interface parameters.
show ipaddresses - Shows current IP addresses.
show ipnettomedia - Displays IP net-to-media mappings.
show ipstats   - Displays IP statistics.
show joins     - Displays multicast groups joined.
show neighbors - Shows neighbor cache entries.
show offload   - Displays the offload information.
show route     - Shows route table entries.
show subinterfaces - Shows subinterface parameters.
show tcpconnections - Displays TCP connections.
show tcpstats  - Displays TCP statistics.
show udpconnections - Displays UDP connections.
show udpstats  - Displays UDP statistics.
show winsservers - Displays the WINS server addresses.
```

无线网卡信息：`netsh wlan show interface`

```bash
$ netsh wlan show interface

There is 1 interface on the system:

    Name                   : WLAN 3
    Description            : Realtek 8832AU Wireless LAN WiFi 6 USB NIC
    GUID                   : 96c31aeb-d8c6-4d28-8327-444aa5dd04f6
    Physical address       : c8:3a:35:c1:11:14
    State                  : connected
    SSID                   : test_5G
    BSSID                  : 50:2b:73:c3:72:06
    Network type           : Infrastructure
    Radio type             : 802.11ax
    Authentication         : WPA2-Personal
    Cipher                 : CCMP
    Connection mode        : Profile
    Channel                : 64
    Receive rate (Mbps)    : 1201
    Transmit rate (Mbps)   : 1201
    Signal                 : 100%
    Profile                : test_5G

    Hosted network status  : Not available
```

断开无线WiFi：

```bash
$ netsh wlan disconnect
```

更多`netsh wlan`命令：

```bash
$ netsh wlan /?

The following commands are available:

Commands in this context:
?              - Displays a list of commands.
add            - Adds a configuration entry to a table.
connect        - Connects to a wireless network.
delete         - Deletes a configuration entry from a table.
disconnect     - Disconnects from a wireless network.
dump           - Displays a configuration script.
export         - Saves WLAN profiles to XML files.
help           - Displays a list of commands.
IHV            - Commands for IHV logging.
refresh        - Refresh hosted network settings.
reportissues   - Generate WLAN smart trace report.
set            - Sets configuration information.
show           - Displays information.
start          - Start hosted network.
stop           - Stop hosted network.
```

## 路由配置

`route add [Destination] mask [netmask] [gw] metric [测量值]`
* -p：添加永久路由
* Destination： 指定该路由的网络目标。
* mask：当添加一个网络路由时，需要使用网络掩码。
* gw：路由数据包通过网关。注意，你指定的网关必须能够达到。
* metric：设置路由跳数。

```bash
# ipv4
$ route -p add 23.23.23.0 mask 255.255.255.0 192.168.97.60
route delete 23.23.23.0
# ipv6
$ netsh interface ipv6 add/del route 2001::/64 "Local Area Connection 2" 2001::2
```
### 查看路由表
```bash
$ netstat -r
$ route print
$ route print -4
$ route print -6
$ netsh interface ipv4 show route
$ netsh interface ipv6 show route
```

### 禁用启用网卡
```bash
$ netsh interface set interface eth0 disabled # 禁用网卡
$ netsh interface set interface name="接口名称" admin=DISABLE

$ netsh interface set interface eth0 enabled #启用网卡
$ netsh interface set interface name="接口名称" admin=ENABLE

$ netsh interface ipv6 set interface name="接口名称"  disable/enable

$ netsh interface show interface #显示接口

```
通过python脚本自动化控制：
```python
import os
os.popen('netsh interface set interface name="接口名称" admin=DISABLE')
```

### 释放、更新地址
```bash
# ipv4
$ ipconfig /release
$ ipconfig /renew
# ipv6
$ ipconfig /release6
$ ipconfig /renew6
```
### 添加、删除IP地址
```bash
# ipv4
$ netsh interface ip add address "本地连接" 192.168.1.100 255.255.255.0
$ netsh interface ip delete address "本地连接" 192.168.1.100
## 设置静态IP地址
$ netsh interface ip set address name="eth1" source=static address=192.168.5.125 mask=255.255.255.0

# ipv6
$ netsh interface ipv6 delete address 本地连接 2001::1
$ netsh interface ipv6 add/del address 本地连接 2001::1
```



