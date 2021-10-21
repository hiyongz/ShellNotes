@echo off

:: 读取配置
for /f "tokens=1,2 delims==" %%a in (config.ini) do (
	if %%a==host set host=%%b
	if %%a==port set port=%%b
) 

echo host: %host%
echo port: %port%

pause