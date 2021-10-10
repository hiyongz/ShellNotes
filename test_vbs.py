#!/usr/bin/python3
# -*-coding:utf-8-*-
# @Time:    2021/9/30 17:02
# @Author:  haiyongz
# @File:    test_vbs.py

import os
from time import sleep

class TestBat():
    def start_bat(self, port):
        """启动 HTTP server
        :port: 服务端口号
        """
        self.stop_process(port)
        dir_path = os.path.dirname(os.path.realpath(__file__))  # 当前路径
        print(dir_path)

        os.system(f'{dir_path}/test_bat.vbs "{dir_path}/test_bat.bat" " {port}"')

        for l in range(3):
            sleep(3)
            if self.check_process(port):
                print("http server successfully")
                return True
        print("http server started failed")
        return False

    def check_process(self, port):
        """检查端口号对应服务是否启动
        :port: 服务端口号
        """
        pids = os.popen("netstat -nao | findstr %s" % port)
        pid = pids.read()
        if len(pid) == 0:
            print("no process with port %s" % port)
            return False
        else:
            pids2 = pid.split("\n")
            for p in pids2:
                p1 = p.split(" ")
                new_pid = [x for x in p1 if x != '']
                process = os.popen("tasklist | findstr %s" % new_pid[4]).read()
                if "python" in process:
                    return True

    def stop_process(self, port):
        """停止port对应进程
        :port: 端口号
        :return:
        """
        pids = os.popen("netstat -nao | findstr %s" % port)
        pid = pids.read()
        if len(pid) == 0:
            print("no process with port %s" % port)
            return True
        else:
            pids2 = pid.split("\n")
            for p in pids2:
                p1 = p.split(" ")
                new_pid = [x for x in p1 if x != '']
                process = os.popen("tasklist | findstr %s" % new_pid[4]).read()
                if "python" in process:
                    res = os.popen("taskkill -pid %s -f -t" % new_pid[4]).read()
                    if "SUCCESS" in res:
                        print(res)
                        return True
            raise AssertionError("wda terminated failed")
if __name__ == "__main__":
    bat = TestBat()
    port = "8100"
    bat.start_bat(port)
    bat.stop_process(port)
