@echo off

echo ---------------------------------------
set pan=%~d0
set filePath=%~p0 
set filePath=%pan%%filePath%
echo current path: %filePath%

REM 添加PATH环境变量：如果已经存在则不添加
echo ---------------------------------------
SET MYPATHCOPY=%PATH%
SET add_path=

SET toAdd=D:\software\Nmap
SET MYPATHCOPY=%PATH%

call :loop
if "%flag%"=="0" set add_path=%toAdd%;%add_path%

SET toAdd=D:\ZENTAO\ztf\ztf.exe
SET MYPATHCOPY=%PATH%

call :loop
if "%flag%"=="0" set add_path=%toAdd%;%add_path%


echo add the path: %add_path%
REM call set xx=%Path%;%add_path%
REM wmic ENVIRONMENT where "name='Path' and username='<system>'" set VariableValue="%xx%"

REM 新建系统变量
echo ---------------------------------------

REM set ENV_Path=%PYTHONPATH%

REM setx /M PYTHONPATH "%filePath%;%filePath%\Scripts"




REM pause
TIMEOUT /T 10

:loop
set flag=0
for /f "delims=; tokens=1,2*" %%p in ("%MYPATHCOPY%") do (
   REM @echo %%~p
   SET MYPATHCOPY=%%~q;%%~r
   if "%toAdd%"=="%%p" (
        set flag=1
        echo %%p
	    goto :isFinded
    )   
)
if "%MYPATHCOPY%"==";" goto :EOF
goto :loop

:isFinded
echo 已存在环境变量:%toAdd%
goto :EOF