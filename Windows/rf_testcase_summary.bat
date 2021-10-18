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
SET /P case_Dir=


IF NOT DEFINED case_Dir SET "case_Dir=%casepath%"

echo Please input the testsuite name: 
echo Press Enter key to calculate all of the testsuite file: %casepath%

SET /P suite_name=

IF NOT DEFINED suite_name goto casecounts
IF DEFINED suite_name goto casecount

:casecounts
for /f "delims=\" %%a in ('dir /b /a-d /o-d "%casepath%\*.bat"') do (
  echo %%a
  awk.exe -F ' ' "/^test_.*|^tiName_.*|case_.*/ {print $0}" %casepath%\%%a | wc -l
  awk.exe -F ' ' "/^test_.*|^tiName_.*|case_.*/ {print $0}" test.robot > case_summary.log | wc -l
)
exit

:casecount
awk.exe -F ' ' "/^test_.*|^tiName_.*|case_.*/ {print $0}" %casepath%\%suite_name% | wc -l
exit

REM set file=%file_Dir%\%file_name%

REM echo file name: %file%

pause