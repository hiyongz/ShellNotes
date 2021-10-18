@echo off

set pan=%~d0
set filePath=%~p0
set filePath=%filePath:~-0,-24%

set filePath=%pan%%filePath%

echo %filePath%

set add_path=
set finded=false
set ENV_Path=%PYTHONPATH%
setx /M PYTHONPATH "%filePath%;%filePath%\Scripts"

REM python环境变量-查重
SET MYPATHCOPY=%PATH%
set pyPath=C:\Program Files\Python37
set toAdd=%pyPath%

call :loop
if "%flag%"=="0" set add_path=%toAdd%;%add_path%

REM webdriverPath环境变量-查重
SET MYPATHCOPY=%PATH%
set webdriverPath=%filePath%\tool\webdriver
set toAdd=%webdriverPath%

call :loop
if "%flag%"=="0" set add_path=%toAdd%;%add_path%

REM xacs_Path环境变量-查重
SET MYPATHCOPY=%PATH%
set xacs_Path=%filePath%\tool\xacs_server
set toAdd=%xacs_Path%

call :loop
if "%flag%"=="0" set add_path=%toAdd%;%add_path%

REM System32环境变量-查重
SET MYPATHCOPY=%PATH%
set SysPath=C:\Windows\System32
set toAdd=%SysPath%

call :loop
if "%flag%"=="0" set add_path=%toAdd%;%add_path%

echo ----------------------------------------
echo Path：%Path%;%add_path%

::将返回显的字符重新赋值到path中
call set xx=%Path%;%add_path%
wmic ENVIRONMENT where "name='Path' and username='<system>'" set VariableValue="%xx%"
echo ---------------------------------------
echo ""

REM 生成pybot.bat文件
@echo @echo off > %filePath%\tool\attrobot3_install\pybot.bat

REM 写入数据至pybot.bat文件
@echo %filePath%\Scripts\python -m robot.run %%* >> %filePath%\tool\attrobot3_install\pybot.bat

REM 将以下文件复制到Scripts路径
copy /y %filePath%\tool\attrobot3_install\pybot.bat "%pyPath%\Scripts"
copy /y %filePath%\Scripts\rebot.exe "%pyPath%\Scripts"
copy /y %filePath%\Scripts\rebot-script.py "%pyPath%\Scripts"

REM 复制string.py至python安装目录，解决导入string包缺失部分关键字问题
copy /y %filePath%\tool\attrobot3_install\string.py "%pyPath%\Lib"

REM 复制serial 和 pyserial-3.5.dist-info文件夹至python路径
echo d | xcopy /y /s %filePath%\tool\attrobot3_install\serial "%pyPath%\Lib\site-packages\serial"
echo d | xcopy /y /s %filePath%\tool\attrobot3_install\pyserial-3.5.dist-info "%pyPath%\Lib\site-packages\pyserial-3.5.dist-info"

REM 执行安装numpy-1.19.3-cp37-cp37m-win_amd64.whl的命令
cd %filePath%\Scripts
REM 激活attrobot3虚拟环境
call activate
REM 进入 attrobot3\tool\attrobot3_install目录
cd %filePath%\tool\attrobot3_install
echo "now install numpy-1.19.3"
pip install numpy-1.19.3-cp37-cp37m-win_amd64.whl
echo "install numpy-1.19.3 success"

REM 等待10s后退出
pause
REM TIMEOUT /T 10
goto :eof

:loop
set flag=0
for /f "delims=; tokens=1,2*" %%p in ("%MYPATHCOPY%") do (
   SET MYPATHCOPY=%%~q;%%~r   
   if "%toAdd%"=="%%p" (
        set flag=1
        goto :isFinded
   )   
)
if "%MYPATHCOPY%"==";" goto :EOF
goto :loop

:isFinded
echo 已存在环境变量:%toAdd%
goto :EOF