@echo off
echo ========================================
echo    MindScope AI - Complete Startup
echo ========================================
echo.

REM Check if MongoDB is running
echo [1/4] Checking MongoDB...
sc query MongoDB | find "RUNNING" >nul
if %errorlevel% neq 0 (
    echo MongoDB is not running. Starting MongoDB...
    echo This requires Administrator privileges.
    net start MongoDB
    if %errorlevel% neq 0 (
        echo.
        echo ERROR: Failed to start MongoDB.
        echo Please run this script as Administrator or start MongoDB manually:
        echo   net start MongoDB
        echo.
        pause
        exit /b 1
    )
    echo MongoDB started successfully.
) else (
    echo MongoDB is already running.
)

echo.
echo [2/4] Starting Flask Backend...
start "MindScope Backend" cmd /k "cd backend && python app.py"

REM Wait for backend to start
timeout /t 3 /nobreak >nul

echo.
echo [3/4] Getting local IP address...
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4"') do (
    set IP=%%a
    goto :found
)
:found
set IP=%IP:~1%

echo Local IP detected: %IP%
echo.

echo [4/4] Choose access mode:
echo   [1] Localhost only (http://localhost:8501)
echo   [2] Network access (http://%IP%:8501)
echo.
choice /c 12 /n /m "Enter choice (1 or 2): "

if %errorlevel%==1 (
    echo.
    echo Starting frontend in LOCALHOST mode...
    cd frontend
    streamlit run app.py
) else (
    echo.
    echo Starting frontend in NETWORK mode...
    echo Backend will be accessible at: http://%IP%:5000
    echo Frontend will be accessible at: http://%IP%:8501
    set BACKEND_HOST=%IP%
    cd frontend
    streamlit run app.py --server.address 0.0.0.0
)

pause
