@echo off
echo ========================================
echo   Relstone Backend Server Startup
echo ========================================
echo.

cd /d "%~dp0"

echo Checking for running Node.js processes...
taskkill /F /IM node.exe >nul 2>&1
if %errorlevel% equ 0 (
    echo Stopped existing Node.js processes
    timeout /t 2 /nobreak >nul
)

echo.
echo Starting backend server...
echo.
echo Server will be available at:
echo   http://localhost:5000
echo.
echo Press Ctrl+C to stop the server
echo.

npm run dev

