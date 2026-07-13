@echo off
setlocal

set "SERVER_LOCATION=C:\DayZServer"
set "DAYZ_SERVER_ID=223350"

:: Require STEAM_USER env var
:: e.g. setx STEAM_USER cooluser
if "%STEAM_USER%"=="" (
    echo ERROR: STEAM_USER environment variable is not set
    exit /b 1
)

call "%~dp0common\steam_app_install.bat" %DAYZ_SERVER_ID% "%SERVER_LOCATION%"
if errorlevel 1 (
    echo ERROR: steam_app_install.bat failed.
    exit /b 1
)

echo DayZ Server update completed successfully
