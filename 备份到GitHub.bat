@echo off
echo Backup to GitHub...
git add .
git commit -m "bishe auto backup"
git push
echo.
echo Backup success!
pause >nul