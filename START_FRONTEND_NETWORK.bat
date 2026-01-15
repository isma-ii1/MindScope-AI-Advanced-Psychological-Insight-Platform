@echo off
echo ========================================
echo MindScope AI - Network Access Setup
echo ========================================
echo.

REM Get local IP address
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4"') do (
    set IP=%%a
    goto :found
)
:found
set IP=%IP:~1%

echo Detected Local IP: %IP%
echo.
echo Backend will be accessible at: http://%IP%:5000
echo Frontend will be accessible at: http://%IP%:8501
echo.
echo Setting BACKEND_HOST environment variable...
set BACKEND_HOST=%IP%

echo.
echo Starting Streamlit frontend...
echo.
cd frontend
streamlit run app.py --server.address 0.0.0.0

pause
