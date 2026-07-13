@echo off
setlocal enabledelayedexpansion

set "SERVER_LOCATION=C:\DayZServer"
set "DAYZ_SERVER_ID=223350"

:: Require STEAM_USER env var
:: e.g. setx STEAM_USER=cooluser
if "%STEAM_USER%"=="" (
    echo ERROR: STEAM_USER environment variable is not set
    exit /b 1
)

cd /d "C:\steamcmd" || (
    echo Failed to change directory to SteamCMD
    exit /b 1
)

steamcmd ^
+force_install_dir "%SERVER_LOCATION%" ^
+login %STEAM_USER% ^
+app_update %DAYZ_SERVER_ID% ^
+quit

if errorlevel 1 (
    echo SteamCMD failed with error %errorlevel%
    exit /b %errorlevel%
)

echo DayZ Server update completed successfully
