@echo off
echo ========================================
echo Starting MindScope AI with Network IP
echo ========================================
echo.

REM Your backend is running on: http://192.168.2.254:5000
REM Setting BACKEND_HOST to match

set BACKEND_HOST=192.168.2.254

echo Backend Host: %BACKEND_HOST%
echo Frontend will connect to: http://%BACKEND_HOST%:5000/api
echo.
echo Starting Streamlit...
echo.

cd frontend
start http://192.168.2.254:8501
streamlit run app.py --server.address 0.0.0.0

pause
