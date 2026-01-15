@echo off
echo ============================================
echo MindScope AI - Backend Server
echo ============================================
echo.

REM Go to project root
cd /d "%~dp0"

REM Set Python path
set PYTHONPATH=%CD%

echo Python path: %PYTHONPATH%
echo.
echo Starting Flask backend...
echo API will be available at: http://localhost:5000
echo.
echo Press Ctrl+C to stop the server
echo.

REM Run Flask
python backend\app.py

pause
