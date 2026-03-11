@echo off
chcp 65001 > nul
echo =========================================
echo       VEX IQ Scout GitHub 上傳腳本
echo =========================================
echo.

:: 切換到批次檔所在的目錄
cd /d "%~dp0"

:: 檢查是否為初次使用
if exist ".git" goto :StartPush

echo [提示] 偵測到尚未初始化，正在自動幫您設定...
git init
git remote add origin https://github.com/hsien0529-oss/IQscout.git
echo.

:StartPush
echo [1/3] 將所有檔案變更加入追蹤...
git add .
echo.

echo [2/3] 建立提交紀錄...
git commit -m "Auto Update VEX IQ Scout Dashboard"
echo.

echo [3/3] 開始推送到 GitHub...
:: 確保目前的分支名稱為 main，然後推送到遠端
git branch -M main
git push -u origin main

echo.
echo =========================================
echo   執行完畢！請檢視上方是否有錯誤訊息。
echo =========================================
echo.
pause
