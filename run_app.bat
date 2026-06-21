@echo off
SETLOCAL EnableDelayedExpansion

echo ========================================================
echo   Police Management System - Start Script
echo ========================================================
echo.

:: Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python is not installed or not in system PATH.
    echo Please install Python and try again.
    pause
    exit /b 1
)

:: Install dependencies
echo [INFO] Installing/verifying dependencies...
pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install dependencies.
    pause
    exit /b 1
)
echo [SUCCESS] Dependencies verified.
echo.

:: Ask user if they want to initialize/reset the database
set /p reset_db="[PROMPT] Do you want to re-initialize the database using police.sql? (y/n): "
if /I "!reset_db!"=="y" (
    echo [INFO] Re-initializing database...
    
    :: Attempt to locate mysql.exe
    set "MYSQL_PATH=C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
    if not exist "!MYSQL_PATH!" (
        :: Try finding in PATH
        where mysql.exe >nul 2>&1
        if %errorlevel% equ 0 (
            set "MYSQL_PATH=mysql.exe"
        ) else (
            echo.
            echo [WARNING] mysql.exe was not found at standard path or in system PATH.
            echo Please enter the absolute path to mysql.exe, or press Enter to skip database reset:
            set /p USER_MYSQL_PATH=""
            if not "!USER_MYSQL_PATH!"=="" (
                set "MYSQL_PATH=!USER_MYSQL_PATH!"
            ) else (
                set "MYSQL_PATH="
            )
        )
    )

    if not "!MYSQL_PATH!"=="" (
        :: Read credentials from .env or prompt
        echo [INFO] Using database credentials from .env to initialize.
        
        :: Read DB_USER, DB_PASSWORD, DB_NAME from .env
        for /f "tokens=1,2 delims==" %%A in (.env) do (
            if "%%A"=="DB_USER" set "ENV_USER=%%B"
            if "%%A"=="DB_PASSWORD" set "ENV_PASS=%%B"
            if "%%A"=="DB_NAME" set "ENV_NAME=%%B"
        )
        
        if "!ENV_USER!"=="" set "ENV_USER=root"
        if "!ENV_PASS!"=="" set "ENV_PASS=darsh"
        if "!ENV_NAME!"=="" set "ENV_NAME=police"
        
        echo [INFO] Database configuration: User=!ENV_USER!, Database=!ENV_NAME!
        echo [INFO] Running: !MYSQL_PATH! -u !ENV_USER! -p!ENV_PASS!
        
        :: Execute the database creation and import
        "!MYSQL_PATH!" -u !ENV_USER! -p!ENV_PASS! -e "DROP DATABASE IF EXISTS !ENV_NAME!; CREATE DATABASE !ENV_NAME!; USE !ENV_NAME!; SOURCE police.sql;"
        if !errorlevel! equ 0 (
            echo [SUCCESS] Database initialized successfully.
        ) else (
            echo [ERROR] Database initialization failed. Check your credentials in .env.
        )
    ) else (
        echo [INFO] Skipping database initialization.
    )
)
echo.

:: Start the Flask app
echo [INFO] Starting Flask Application...
echo The app will be available at http://127.0.0.1:5000/
echo Press Ctrl+C in this terminal to stop the server.
echo.

python app.py

pause
