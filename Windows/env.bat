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

REM python��������-����
SET MYPATHCOPY=%PATH%
set pyPath=C:\Program Files\Python37
set toAdd=%pyPath%

call :loop
if "%flag%"=="0" set add_path=%toAdd%;%add_path%

REM webdriverPath��������-����
SET MYPATHCOPY=%PATH%
set webdriverPath=%filePath%\tool\webdriver
set toAdd=%webdriverPath%

call :loop
if "%flag%"=="0" set add_path=%toAdd%;%add_path%

REM xacs_Path��������-����
SET MYPATHCOPY=%PATH%
set xacs_Path=%filePath%\tool\xacs_server
set toAdd=%xacs_Path%

call :loop
if "%flag%"=="0" set add_path=%toAdd%;%add_path%

REM System32��������-����
SET MYPATHCOPY=%PATH%
set SysPath=C:\Windows\System32
set toAdd=%SysPath%

call :loop
if "%flag%"=="0" set add_path=%toAdd%;%add_path%

echo ----------------------------------------
echo Path��%Path%;%add_path%

::�������Ե��ַ����¸�ֵ��path��
call set xx=%Path%;%add_path%
wmic ENVIRONMENT where "name='Path' and username='<system>'" set VariableValue="%xx%"
echo ---------------------------------------
echo ""

REM ����pybot.bat�ļ�
@echo @echo off > %filePath%\tool\attrobot3_install\pybot.bat

REM д��������pybot.bat�ļ�
@echo %filePath%\Scripts\python -m robot.run %%* >> %filePath%\tool\attrobot3_install\pybot.bat

REM �������ļ����Ƶ�Scripts·��
copy /y %filePath%\tool\attrobot3_install\pybot.bat "%pyPath%\Scripts"
copy /y %filePath%\Scripts\rebot.exe "%pyPath%\Scripts"
copy /y %filePath%\Scripts\rebot-script.py "%pyPath%\Scripts"

REM ����string.py��python��װĿ¼���������string��ȱʧ���ֹؼ�������
copy /y %filePath%\tool\attrobot3_install\string.py "%pyPath%\Lib"

REM ����serial �� pyserial-3.5.dist-info�ļ�����python·��
echo d | xcopy /y /s %filePath%\tool\attrobot3_install\serial "%pyPath%\Lib\site-packages\serial"
echo d | xcopy /y /s %filePath%\tool\attrobot3_install\pyserial-3.5.dist-info "%pyPath%\Lib\site-packages\pyserial-3.5.dist-info"

REM ִ�а�װnumpy-1.19.3-cp37-cp37m-win_amd64.whl������
cd %filePath%\Scripts
REM ����attrobot3���⻷��
call activate
REM ���� attrobot3\tool\attrobot3_installĿ¼
cd %filePath%\tool\attrobot3_install
echo "now install numpy-1.19.3"
pip install numpy-1.19.3-cp37-cp37m-win_amd64.whl
echo "install numpy-1.19.3 success"

REM �ȴ�10s���˳�
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
echo �Ѵ��ڻ�������:%toAdd%
goto :EOF