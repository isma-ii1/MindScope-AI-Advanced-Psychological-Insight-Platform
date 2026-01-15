@echo off
echo ============================================
echo MindScope AI - Frontend UI
echo ============================================
echo.

REM Go to project root
cd /d "%~dp0"

REM Set Python path
set PYTHONPATH=%CD%

echo Python path: %PYTHONPATH%
echo.
echo Starting Streamlit frontend...
echo Browser will open automatically
echo.
echo Press Ctrl+C to stop the server
echo.

REM Run Streamlit
streamlit run frontend\app.py

pause
