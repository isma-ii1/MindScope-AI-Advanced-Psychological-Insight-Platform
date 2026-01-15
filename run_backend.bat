@echo off
echo Starting MindScope AI Backend...
echo.

REM Activate virtual environment if it exists
if exist venv\Scripts\activate.bat (
    echo Activating virtual environment...
    call venv\Scripts\activate.bat
) else (
    echo Warning: Virtual environment not found. Run setup.bat first.
)

echo.
echo Starting Flask backend on http://localhost:5000
echo.
echo Note: First startup will download AI models (~2-3GB) - may take 5-10 minutes
echo.

REM Set Python path to include parent directory
set PYTHONPATH=%CD%

REM Run from parent directory, not from backend folder
cd backend
python app.py

pause
