@echo off
setlocal enabledelayedexpansion

:: Require STEAM_USER env var
if "%STEAM_USER%"=="" (
    echo ERROR: STEAM_USER environment variable is not set
    exit /b 1
)

cd /d "C:\steamcmd" || (
    echo Failed to change directory to SteamCMD
    exit /b 1
)

set CMD=^
+force_install_dir "C:\DayZServer" ^
+login %STEAM_USER% ^
+app_update 223350 ^
+quit

steamcmd %CMD%

if errorlevel 1 (
    echo SteamCMD failed with error %errorlevel%
    exit /b %errorlevel%
)

echo DayZ Server update completed successfully
