@echo off
setlocal

:: =====================
:: SERVER CONFIG
:: =====================
set "SERVER_LOCATION=C:\DayZServer"
set "SERVER_NAME=DayZ Deer Isle 6.0 Private Server"
set "SERVER_PORT=2302"
set "SERVER_CONFIG=serverDZdeerisle60.cfg"
set "SERVER_CPU=2"
set "STEAM_WORKSHOP=C:\Program Files (x86)\Steam\steamapps\common\DayZ\!Workshop"

:: 4 hours = 14400 seconds
set "RESTART_INTERVAL=14400"

title %SERVER_NAME% batch

:: =====================
:: DEER ISLE MISSION
:: =====================
set "DEERISLE_REPO_ZIP_URL=https://github.com/johnmclane666/Deerisle-6.0-Experimental/archive/refs/heads/main.zip"
set "DEERISLE_ZIP_FILE=%TEMP%\deerisle_mission_main.zip"
set "DEERISLE_EXTRACT_DIR=%TEMP%\deerisle_mission_extracted"
set "DEERISLE_FOLDER_NAME=Deerisle-6.0-Experimental-main"

curl -L "%DEERISLE_REPO_ZIP_URL%" -o "%DEERISLE_ZIP_FILE%"

if not exist "%DEERISLE_EXTRACT_DIR%" mkdir "%DEERISLE_EXTRACT_DIR%"

tar -xf "%DEERISLE_ZIP_FILE%" -C "%DEERISLE_EXTRACT_DIR%"

robocopy "%DEERISLE_EXTRACT_DIR%\%DEERISLE_FOLDER_NAME%\empty.deerisle" "%SERVER_LOCATION%\mpmissions\experimental.deerisle" /E /R:3 /W:5

:: =====================
:: MODS
:: =====================
if not exist "%SERVER_LOCATION%\keys" mkdir "%SERVER_LOCATION%\keys"

:: CF
robocopy "%STEAM_WORKSHOP%\@CF" "%SERVER_LOCATION%\@CF" /E /R:3 /W:5
robocopy "%STEAM_WORKSHOP%\@CF\keys" "%SERVER_LOCATION%\keys" /E /R:3 /W:5

:: VPP Admin Tools
robocopy "%STEAM_WORKSHOP%\@VPPAdminTools" "%SERVER_LOCATION%\@VPPAdminTools" /E /R:3 /W:5
robocopy "%STEAM_WORKSHOP%\@VPPAdminTools\keys" "%SERVER_LOCATION%\keys" /E /R:3 /W:5

:: Deer Isle
robocopy "%STEAM_WORKSHOP%\@DeerIsle Official (Experimental - Dev Build)" "%SERVER_LOCATION%\@DeerIsleOfficialExperimentalDevBuild" /E /R:3 /W:5
robocopy "%STEAM_WORKSHOP%\@DeerIsle Official (Experimental - Dev Build)\keys" "%SERVER_LOCATION%\keys" /E /R:3 /W:5

:: =====================
:: CONFIG
:: =====================
robocopy . "%SERVER_LOCATION%" "%SERVER_CONFIG%" /R:3 /W:5

:: =====================
:: SERVER LOOP
:: =====================
:START
cd /d "%SERVER_LOCATION%" || exit /b 1

echo [%date% %time%] %SERVER_NAME% started

start "DayZ Server" /min "DayZServer_x64.exe" ^
-config=%SERVER_CONFIG% ^
-port=%SERVER_PORT% ^
-profiles=profiles ^
-mod=@CF;@VPPAdminTools;@DeerIsleOfficialExperimentalDevBuild ^
-cpuCount=%SERVER_CPU% ^
-dologs -adminlog -netlog -freezecheck

:: Run for 4 hours
timeout /t %RESTART_INTERVAL% >nul

echo [%date% %time%] Restarting server

taskkill /IM DayZServer_x64.exe /F >nul 2>&1
timeout /t 10 >nul

goto START