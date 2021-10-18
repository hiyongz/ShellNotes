@echo off

set DriveLetter=%~d0
echo %DriveLetter%

set filePath=%~p0
echo %filePath%
 
set filePath=%DriveLetter%%filePath%
echo current path: %filePath%
echo current path: %cd%

for /f "delims=\" %%a in ('dir /b /a-d /o-s "%cd%\*.bat"') do (
  echo %%a
)

pause