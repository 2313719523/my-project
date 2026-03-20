@echo off
echo WARNING: This will revert all local changes!
pause
git fetch --all
git reset --hard origin/main
git pull
echo.
echo Restore success!
pause