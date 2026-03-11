@echo off
chcp 65001 > nul
color 0A

echo =========================================
echo       VEX IQ Scout GitHub 上傳小幫手
echo =========================================
echo.

:: 切換到批次檔所在的目錄，避免路徑錯誤
cd /d "%~dp0"

:: 檢查 git 是否有安裝
git --version >nul 2>nul
if %errorlevel% neq 0 (
    color 0C
    echo [錯誤] 找不到 Git 命令！
    echo 請確認您的電腦是否有安裝 Git。
    echo.
    pause
    exit /b
)

:: 檢查是否為初次使用
if not exist ".git" (
    echo [提示] 這是您第一次執行，正在為您自動初始化設定...
    git init
    git branch -M main
    git remote add origin https://github.com/hsien0529-oss/IQscout.git
    echo [完成] 已經幫您與 hsien0529-oss/IQscout 連結！
    echo.
)

echo [1/3] 將所有檔案變更加入追蹤...
git add .
if %errorlevel% neq 0 (
    echo [錯誤] 加入追蹤失敗。
    pause
    exit /b
)

echo.
echo [2/3] 記錄這些變更...
git commit -m "Auto Update VEX IQ Scout Dashboard" >nul 2>nul
:: 如果沒有東西可以 commit，Git 會報錯，但不影響運行

echo.
echo [3/3] 開始推送到 GitHub 伺服器...
git push -u origin main
if %errorlevel% neq 0 (
    color 0C
    echo.
    echo [警告] 推送過程發生錯誤，若是第一次執行可能會跳出瀏覽器要求您登入 GitHub 帳號，請依照指示登入。
    echo.
    pause
    exit /b
)

echo.
echo =========================================
echo   [大成功] 您的網站已經順利推送到 GitHub 上了！
echo =========================================
echo.
pause
