@echo off


set wc="D:\pythonproj\ShellNotes\Windows\wc\wc.exe"
set awk="D:\pythonproj\ShellNotes\Windows\awk\awk.exe"

:: 读取配置
for /f "tokens=1,2 delims==" %%a in (rf_testcase_summary.ini) do (
	if %%a==casepath set casepath=%%b
	if %%a==suitename set suitename=%%b
) 

IF NOT DEFINED casepath SET "casepath=%cd%"

echo %cd%
echo testcase path: %casepath%
echo testsuite name: %suitename%


IF NOT DEFINED suitename goto casecounts
IF DEFINED suitename goto casecount
pause

:casecounts
echo %casepath%
cd.>case_summary.log
for /f "delims=\" %%a in ('dir /b /a-d /o-d "%casepath%"') do (
  echo %%a case number: 
  %awk% -F ' ' "/^test_.*|case_.*/ {print $0}" %casepath%\%%a | %wc% -l
  %awk% -F ' ' "/^test_.*|^tiName_.*|case_.*/ {print $0}{ORS="\n"}" %casepath%\%%a >> case_summary.log
  echo. 
)
goto :EOF

:casecount
echo %suitename% case number: 
%awk% -F ' ' "/^test_.*|case_.*/ {print $0}" %casepath%\%suitename% | %wc% -l
%awk% -F ' ' "/^test_.*|^tiName_.*|case_.*/ {print $0}" %casepath%\%suitename% > case_summary.log
goto :EOF



