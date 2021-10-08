@echo off

echo start
python -m http.server %1
echo end

pause
