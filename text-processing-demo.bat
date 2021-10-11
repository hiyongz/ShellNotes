@echo off

color 02
set grep="D:/ProgramWorkspace/ShellNotes/grep/grep.exe"
set wc="D:/ProgramWorkspace/ShellNotes/wc/wc.exe"




:: TODO:配置android sdk环境变量
echo Please input the file path
echo Press Enter key to use the current path: %cd%
SET /P file_Dir=

IF NOT DEFINED file_Dir SET "file_Dir=%cd%"

echo Please input the file path
SET /P file_name=

set file=%file_Dir%\%file_name%

echo file name: %file%

%grep% -n "case_.*" %file% | %wc% -l > %file_Dir%\result.log

pause