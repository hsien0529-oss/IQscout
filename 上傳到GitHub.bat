@echo off
chcp 65001 >nul
echo ===================================
echo   VEX IQ Scout - 上傳到 GitHub
echo ===================================
echo.

:: 檢查是否已經初始化 git
if not exist ".git" (
    echo [錯誤] 尚未初始化 Git 儲存庫。
    echo 請先在資料夾中執行 git init 並設定遠端數據庫 (git remote add origin ...)
    echo.
    pause
    exit /b
)

echo [1/3] 將所有變更加入追蹤...
git add .

echo.
echo [2/3] 建立提交紀錄...
:: 使用目前的日期時間作為提交訊息
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set YYYY=%datetime:~0,4%
set MM=%datetime:~4,2%
set DD=%datetime:~6,2%
set HH=%datetime:~8,2%
set MIN=%datetime:~10,2%
set COMMIT_MSG=Auto update: %YYYY%-%MM%-%DD% %HH%:%MIN%

git commit -m "%COMMIT_MSG%"

echo.
echo [3/3] 開始推送到 GitHub...
git push -u origin main || git push

echo.
echo ===================================
echo   操作完成！您的網站已經上傳。
echo ===================================
pause
