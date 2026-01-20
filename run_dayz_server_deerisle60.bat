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
set "DAYZ_ID=221100"
set "WORKSHOP_CONTENT=%SERVER_LOCATION%\steamapps\workshop\content\%DAYZ_ID%"
set "STEAMCMD_DIR=C:\steamcmd"

:: 4 hours = 14400 seconds
set "RESTART_INTERVAL=14400"

:: =====================
:: MOD IDS
:: =====================

:: https://steamcommunity.com/workshop/filedetails/?id=1559212036
:: https://steamcommunity.com/workshop/filedetails/?id=1828439124
:: https://steamcommunity.com/workshop/filedetails/?id=1750506510
set "MOD_CF_ID=1559212036"
set "MOD_VPP_ID=1828439124"
set "MOD_DEERISLE_ID=1750506510"


:: =====================
:: MOD FOLDER NAMES
:: =====================
set "MOD_CF_NAME=@CF"
set "MOD_VPP_NAME=@VPPAdminTools"
set "MOD_DEERISLE_NAME=@DeerIsleOfficialExperimentalDevBuild"

title %SERVER_NAME% batch

:: =====================
:: UPDATE SERVER
:: =====================
echo Updating DayZ server...
call "%~dp0update_dayz_server.bat"
if errorlevel 1 exit /b 1

:: =====================
:: DOWNLOAD MODS
:: =====================
echo Downloading mods via SteamCMD...

cd /d "%STEAMCMD_DIR%" || exit /b 1

steamcmd ^
+force_install_dir "%SERVER_LOCATION%" ^
+login %STEAM_USER% ^
+workshop_download_item %DAYZ_ID% %MOD_CF_ID% ^
+workshop_download_item %DAYZ_ID% %MOD_VPP_ID% ^
+workshop_download_item %DAYZ_ID% %MOD_DEERISLE_ID% ^
+quit

if errorlevel 1 (
    echo ERROR: Failed to download mods
    exit /b 1
)

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

robocopy "%DEERISLE_EXTRACT_DIR%\%DEERISLE_FOLDER_NAME%\empty.deerisle" ^
"%SERVER_LOCATION%\mpmissions\experimental.deerisle" /E /R:3 /W:5

:: =====================
:: MODS COPY
:: =====================
if not exist "%SERVER_LOCATION%\keys" mkdir "%SERVER_LOCATION%\keys"

:: CF
robocopy "%WORKSHOP_CONTENT%\%MOD_CF_ID%" "%SERVER_LOCATION%\%MOD_CF_NAME%" /E /R:3 /W:5
robocopy "%WORKSHOP_CONTENT%\%MOD_CF_ID%\keys" "%SERVER_LOCATION%\keys" /E /R:3 /W:5

:: VPP Admin Tools
robocopy "%WORKSHOP_CONTENT%\%MOD_VPP_ID%" "%SERVER_LOCATION%\%MOD_VPP_NAME%" /E /R:3 /W:5
robocopy "%WORKSHOP_CONTENT%\%MOD_VPP_ID%\keys" "%SERVER_LOCATION%\keys" /E /R:3 /W:5

:: Deer Isle
robocopy "%WORKSHOP_CONTENT%\%MOD_DEERISLE_ID%" "%SERVER_LOCATION%\%MOD_DEERISLE_NAME%" /E /R:3 /W:5
robocopy "%WORKSHOP_CONTENT%\%MOD_DEERISLE_ID%\keys" "%SERVER_LOCATION%\keys" /E /R:3 /W:5

:: =====================
:: CONFIG
:: =====================
copy /Y "%~dp0%SERVER_CONFIG%" "%SERVER_LOCATION%\%SERVER_CONFIG%"

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
-mod=%MOD_CF_NAME%;%MOD_VPP_NAME%;%MOD_DEERISLE_NAME% ^
-cpuCount=%SERVER_CPU% ^
-dologs -adminlog -netlog -freezecheck

timeout /t %RESTART_INTERVAL% >nul

echo [%date% %time%] Restarting server
taskkill /IM DayZServer_x64.exe /F >nul 2>&1
timeout /t 10 >nul

goto START
