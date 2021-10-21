@echo off

:: 读取配置
for /f "tokens=1,2 delims==" %%a in (rf_testcase_summary.ini) do (
	if %%a==casepath set casepath=%%b
	if %%a==suitename set suitename=%%b
) 
echo %casepath%
echo %suitename%
echo %cd%
:: 设置测试用例路径
echo Please input the testcase path
echo Press Enter key to use the default path: %casepath%
SET /P casepath=


IF NOT DEFINED casepath SET "casepath=%casepath%"

echo Please input the testsuite name: 
echo Press Enter key to summary all of the testsuite file: %suitename%

SET /P suitename=

IF NOT DEFINED suitename goto casecounts
IF DEFINED suitename goto casecount

:casecounts
echo 1111
echo %casepath%
cd.>case_summary.log
for /f "delims=\" %%a in ('dir /b /a-d /o-d "%casepath%"') do (
  echo %%a case number: 
  awk.exe -F ' ' "/^test_.*|^tiName_.*|case_.*/ {print $0}" %casepath%\%%a | wc -l
  awk.exe -F ' ' "/^test_.*|^tiName_.*|case_.*/ {print $0}" %casepath%\%%a >> case_summary.log
  echo. 
)

goto :EOF

:casecount
cd.>case_summary.log
echo %suitename% case number: 
awk.exe -F ' ' "/^test_.*|^tiName_.*|case_.*/ {print $0}" %casepath%\%suitename% | wc -l
awk.exe -F ' ' "/^test_.*|^tiName_.*|case_.*/ {print $0}" %casepath%\%suitename% > case_summary.log
goto :EOF

pause