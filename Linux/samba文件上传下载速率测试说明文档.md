# Samba文件传输测试说明

本文档介绍生成指定大小文件方法，Samba文件上传、下载速率测试方法。

## 目录

- [背景](#背景)
- [环境](#环境)
- [使用说明](#使用说明)
	- [测试文件创建](#测试文件创建)
	- [下载](#下载)
	- [上传](#上传)
	- [返回值](#返回值)

## 背景
1. Samba服务性能测试

## 环境
在 client （client桥接DUT LAN口）中安装 smbclient：
```sh
yum install -y samba
yum install -y samba-client
```

samba服务登录测试：
```sh
[root@Client ~]# smbclient //192.168.0.1/USB名/ -U admin%admin
Try "help" to get a list of possible commands.
smb: \> 
```
- `//192.168.0.1`：url地址
- `USB名`：USB名称
- `admin%admin`：samba服务用户名、密码


## 使用说明

### 测试文件创建

Samba文件传输测试需要准备测试文件数据，文件创建脚本`multiple_file_generate.sh`使用方法：

```sh
$ sh multiple_file_generate.sh -h
 Usage: sh multiple_file_generate.sh [OPTION]
 Options:
 [ -s | --size SIZE]            -- 总文件大小，eg: -s 5M
 [ -n | --number NUMBER ]       -- 文件数量
 [ -N | --Number FOLDER_NUMBER ] --目录（文件夹）数量
 [ -f | --folder SAVE_FOLDER ] --文件生成路径
 [ -h | --help ]                -- 帮助信息
```


> windows系统下可以使用`fsutil`命令创建指定大小的文件：
> - `fsutil file createNew test.txt 1024`  
> - 文件大小单位为bytes

参数说明：

|  参数  |   说明   |   示例   |
| ---- | ---- | ---- |
| -s, --size  |  总文件大小，支持K、M、和G（1K=1024 bytes）  |  -s 5M   |
| -n, --number  |   要创建的文件数量，创建的文件大小之和等于size   |  -n 100    |
| -N, --Number  |  生成的目录数量，默认10个  |  -N 5    |
| -f, --folder  |  文件保存路径,默认/tmp/smb/testfolder  | -f /tmp/smb/testfolder |
| -h, --help  |  帮助信息    |      |

注意：**如果生成多个目录，目录是随机嵌套的，文件的存放的目录地址也是随机的。**

**示例1：**生成1个大小为1G的文件

```sh
sh multiple_file_generate.sh -s 1G -n 1 -N 1
```

**示例2：**生成包含40个以上文件夹、2000个以上文件、总大小300M左右的文件夹
```sh
sh multiple_file_generate.sh -s 300M -n 2000 -N 40
```

### 下载

关键代码：
```sh
$ smbclient //192.168.0.1/张海勇-b/ -U admin%admin # 登录
$ get testfile5M /tmp/smb/testfile5M # 下载
$ smbclient //192.168.0.1/张海勇-b/ -U admin%admin -c 'prompt OFF; recurse ON; cd /testfolder/; lcd /tmp/smb/testfolder/; mget *' -l /tmp/smb/smbalog # 下载目录
$ smbclient //192.168.0.1/张海勇-b/ -U admin%admin -c 'rm testfolder/*' # 清空testfolder目录下的文件
$ smbclient //192.168.0.1/张海勇-b/ -U admin%admin -c 'del testfile5M' # 删除单个文件
```
### 上传
关键代码：
```sh
$ put /tmp/smb/testfile1G test_file1G # 上传
$ smbclient //192.168.0.1/张海勇-b/ -U admin%admin -c 'prompt OFF; recurse ON; cd /testfolder/; lcd /tmp/smb/testfolder/; mput *' -l /tmp/smb/smbalog # 上传目录
```

###  统计平均速率

统计平均速率关键代码：
```sh
$ cat /tmp/smb/smbalog/log.smbclient | awk -F ' ' '/average/ {print $9,$10}' | sed -e 's/)//g' | awk '{sum+=$1} END {print "Average rate is:", sum/NR, $2}'
```

<center><b>--THE END--<b></center>

