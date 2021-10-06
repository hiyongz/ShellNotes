#!/usr/bin/python3
# -*-coding:utf-8-*-
# @Time:    2021/9/30 17:02
# @Author:  haiyong
# @File:    test_vbs.py
import os
from time import sleep


class TestBat():
    def start_bat(self):
        dir_path = os.path.dirname(os.path.realpath(__file__))  # 当前路径
        print(dir_path)
        # os.popen(f'{dir_path}/test_bat.bat')
        res = os.system(f'{dir_path}/test_bat.bat')

    # def _check_wda_port(self, port):
    #     """检查是否启动wda
    #
    #     :port: 侦听的 WDA 端口号
    #
    #     """
    #     pid = os.popen("netstat -nao | findstr %s" % port)
    #     pids = pid.read()
    #     if len(pids) == 0:
    #         logger.info("no process with port %s" % port)
    #         return False
    #     else:
    #         pids2 = pids.split("\n")
    #         for p in pids2:
    #             p1 = p.split(" ")
    #             new_pid = [x for x in p1 if x != '']
    #             process = os.popen("tasklist | findstr %s" % new_pid[4]).read()
    #             if "python" in process:
    #                 return True
    #
    #
    # def _start_wda(self, udid, wdaId, port):
    #     """启动wda
    #
    #     :udid: iOS 设备的 uuid
    #
    #     :wdaId: WDA应用的 bundle id
    #
    #     :port: 侦听的 WDA 端口号
    #
    #     """
    #
    #     dir_path = os.path.dirname(os.path.realpath(__file__))  # 当前路径
    #
    #     os.system(f'{dir_path}\start_wda.vbs "{dir_path}\start_wda.bat" " {udid}" " {wdaId}" " {port}"')
    #
    #     for l in range(3):
    #         sleep(3)
    #         if self._check_wda_port(port):
    #             logger.info("WebDriverAgent start successfully")
    #             return True
    #     logger.info("wda started failed")
    #     return False
    #
    #
    # def stop_wda(self, port):
    #     """停止wda
    #
    #     :port: 侦听的WDA端口号
    #
    #     :return:
    #     """
    #     pid = os.popen("netstat -nao | findstr %s" % port)
    #     pids = pid.read()
    #     if len(pids) == 0:
    #         logger.info("no process with port %s" % port)
    #         return True
    #     else:
    #         pids2 = pids.split("\n")
    #         for p in pids2:
    #             p1 = p.split(" ")
    #             new_pid = [x for x in p1 if x != '']
    #             process = os.popen("tasklist | findstr %s" % new_pid[4]).read()
    #             if "python" in process:
    #                 res = os.popen("taskkill -pid %s -f -t" % new_pid[4]).read()
    #                 if "SUCCESS" in res:
    #                     logger.info(res)
    #                     return True
    #         raise AssertionError("wda terminated failed")
if __name__ == "__main__":
    bat = TestBat()
    bat.start_bat()