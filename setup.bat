@echo off
echo MindScope AI - Setup Script
echo ===========================

echo Step 1: Creating virtual environment...
python -m venv venv

echo Step 2: Activating virtual environment...
call venv\Scripts\activate

echo Step 3: Installing dependencies...
pip install -r requirements.txt

echo Step 4: Creating .env file...
if not exist .env (
    copy .env.example .env
    echo .env file created. Please edit it with your configuration.
) else (
    echo .env file already exists. Skipping.
)

echo.
echo Setup complete!
echo.
echo Next steps:
echo 1. Make sure MongoDB is running on localhost:27017
echo 2. Edit .env file if needed
echo 3. Run run_backend.bat to start the backend
echo 4. Run run_frontend.bat to start the frontend
echo.
pause
