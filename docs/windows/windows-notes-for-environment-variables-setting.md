# 通过bat脚本配置系统环境变量

本文介绍使用bat脚本添加系统环境变量

## 添加PATH环境变量
添加PATH环境变量，如果已经存在则不添加。

介绍2种方法来循环搜索路径是否已经存在：

```bash
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
echo %add_path%

SET toAdd=C:\Program Files\Go\bin
SET MYPATHCOPY=%PATH%
call :search2
echo %add_path%

echo add the path: %add_path%
call set xx=%Path%;%add_path%
wmic ENVIRONMENT where "name='Path' and username='<system>'" set VariableValue="%xx%"

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
```

## 新建系统变量
1、使用 `setx` 来设置：

```bash
@echo off

set ENV_Path=%PYTHONPATH%
setx /M PYTHONPATH "D:\Anaconda3"

pause
```
2、使用 `wmic` 命令设置：

```bash
@echo off

::如果存在，先删除PYTHONPATH
wmic ENVIRONMENT where "name='PYTHONPATH'" delete

:: 创建系统变量PYTHONPATH
wmic ENVIRONMENT create name="PYTHONPATH",username="<system>",VariableValue="D:\Anaconda3"
```

