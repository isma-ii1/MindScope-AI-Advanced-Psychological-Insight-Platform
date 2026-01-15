@echo off
echo Starting MindScope AI Frontend...
echo.

REM Activate virtual environment if it exists
if exist venv\Scripts\activate.bat (
    echo Activating virtual environment...
    call venv\Scripts\activate.bat
) else (
    echo Warning: Virtual environment not found. Run setup.bat first.
)

echo.
echo Starting Streamlit frontend...
echo Browser will open automatically to http://localhost:8501
echo.

REM Set Python path to include parent directory
set PYTHONPATH=%CD%

REM Run streamlit
cd frontend
streamlit run app.py

pause
