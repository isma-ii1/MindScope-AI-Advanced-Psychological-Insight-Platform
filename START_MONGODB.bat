@echo off
echo Starting MongoDB...
echo.
echo If you see "Access Denied", right-click this file and select "Run as Administrator"
echo.
net start MongoDB
if %errorlevel% neq 0 (
    echo.
    echo MongoDB failed to start. Trying alternative method...
    echo.
    "C:\Program Files\MongoDB\Server\7.0\bin\mongod.exe" --dbpath "C:\data\db"
)
pause
