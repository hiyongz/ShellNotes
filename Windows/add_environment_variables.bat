@echo off

echo ---------------------------------------
set pan=%~d0
set filePath=%~p0 
set filePath=%pan%%filePath%
echo current path: %filePath%

REM 添加PATH环境变量：如果已经存在则不添加
echo ---------------------------------------
SET add_path=

SET toAdd=D:\software\Nmap
SET MYPATHCOPY=%PATH%
call :search1
REM if "%flag%"=="0" set add_path=%toAdd%;%add_path%
echo %add_path%

SET toAdd=C:\Program Files\Go\bin
SET MYPATHCOPY=%PATH%
call :search2
REM if "%flag%"=="0" set add_path=%toAdd%;%add_path%
echo %add_path%

echo add the path: %add_path%
REM call set xx=%Path%;%add_path%
REM wmic ENVIRONMENT where "name='Path' and username='<system>'" set VariableValue="%xx%"

REM 新建系统变量
echo ---------------------------------------
set ENV_Path=%PYTHONPATH%
setx /M PYTHONPATH "D:\Anaconda3"

::如果有的话，先删除PYTHONPATH
wmic ENVIRONMENT where "name='PYTHONPATH'" delete
:: 创建系统变量PYTHONPATH
wmic ENVIRONMENT create name="PYTHONPATH",username="<system>",VariableValue="D:\Anaconda3"


pause
REM TIMEOUT /T 10

REM 方法1
:search1
for /f "tokens=1* delims=;" %%a in ("%MYPATHCOPY%") do (
	if "%toAdd%"=="%%a" (
		goto :isFinded
	)
	set MYPATHCOPY=%%b
    goto :search1
)
set add_path=%toAdd%;%add_path%
goto :EOF

REM 方法2
:search2
for /f "delims=; tokens=1,2*" %%p in ("%MYPATHCOPY%") do (
   REM @echo %%~p
   SET MYPATHCOPY=%%~q;%%~r
   if "%toAdd%"=="%%p" (
        set flag=1
        REM echo %%p
	    goto :isFinded
    )
	goto :search2
)
set add_path=%toAdd%;%add_path%
goto :EOF

:isFinded
echo The path already exists: %toAdd%
goto :EOF