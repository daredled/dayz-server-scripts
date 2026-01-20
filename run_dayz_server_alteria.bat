@echo off
setlocal

:: =====================
:: SERVER CONFIG
:: =====================
set "SERVER_LOCATION=C:\DayZServer"
set "SERVER_NAME=DayZ Alteria Private Server"
set "SERVER_PORT=2302"
set "SERVER_CONFIG=serverDZalteria.cfg"
set "SERVER_CPU=2"
set "STEAM_WORKSHOP=C:\Program Files (x86)\Steam\steamapps\common\DayZ\!Workshop"

:: 4 hours = 14400 seconds
set "RESTART_INTERVAL=14400"

title %SERVER_NAME% batch

:: =====================
:: ALTERIA MISSION
:: =====================
set "ALTERIA_REPO_ZIP_URL=https://github.com/johnmclane666/DayZ-Alteria-Stable/archive/refs/heads/main.zip"
set "ALTERIA_ZIP_FILE=%TEMP%\alteria_mission_main.zip"
set "ALTERIA_EXTRACT_DIR=%TEMP%\alteria_mission_extracted"
set "ALTERIA_FOLDER_NAME=DayZ-Alteria-Stable-main"

curl -L "%ALTERIA_REPO_ZIP_URL%" -o "%ALTERIA_ZIP_FILE%"

if not exist "%ALTERIA_EXTRACT_DIR%" mkdir "%ALTERIA_EXTRACT_DIR%"

tar -xf "%ALTERIA_ZIP_FILE%" -C "%ALTERIA_EXTRACT_DIR%"

robocopy "%ALTERIA_EXTRACT_DIR%\%ALTERIA_FOLDER_NAME%\empty.alteria" "%SERVER_LOCATION%\mpmissions\empty.alteria" /E /R:3 /W:5

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

:: GSC Gameworld Assets (JMC Edition)
robocopy "%STEAM_WORKSHOP%\@GSC Gameworld Assets (JMC Edition)" "%SERVER_LOCATION%\@GSCGameworldAssets" /E /R:3 /W:5
robocopy "%STEAM_WORKSHOP%\@GSC Gameworld Assets (JMC Edition)\keys" "%SERVER_LOCATION%\keys" /E /R:3 /W:5

:: Alteria
robocopy "%STEAM_WORKSHOP%\@Alteria" "%SERVER_LOCATION%\@Alteria" /E /R:3 /W:5
robocopy "%STEAM_WORKSHOP%\@Alteria\keys" "%SERVER_LOCATION%\keys" /E /R:3 /W:5

:: =====================
:: CONFIG
:: =====================
robocopy . "%SERVER_LOCATION%" "%SERVER_CONFIG%" /R:3 /W:5

:: =====================
:: SERVER LOOP
:: =====================
:START
cd /d "%SERVER_LOCATION%" || exit /b 1

echo [%date% %time%] Starting %SERVER_NAME%

start "DayZ Server" /min "DayZServer_x64.exe" ^
-config=%SERVER_CONFIG% ^
-port=%SERVER_PORT% ^
-profiles=profiles ^
-mod=@CF;@VPPAdminTools;@GSCGameworldAssets;@Alteria ^
-cpuCount=%SERVER_CPU% ^
-dologs -adminlog -netlog -freezecheck

:: Run for 4 hours
timeout /t %RESTART_INTERVAL% >nul

echo [%date% %time%] Restarting server

:: Kill server if still running
taskkill /IM DayZServer_x64.exe /F >nul 2>&1
timeout /t 10 >nul

goto START
