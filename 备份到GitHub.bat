@echo off
echo 正在备份代码到 GitHub...
git add .
git commit -m "毕设自动更新备份"
git push
echo.
echo 备份完成！按任意键退出
pause > nul