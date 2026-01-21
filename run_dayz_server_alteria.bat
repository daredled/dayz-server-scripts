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
set "DAYZ_ID=221100"
set "WORKSHOP_CONTENT=%SERVER_LOCATION%\steamapps\workshop\content\%DAYZ_ID%"
set "STEAMCMD_DIR=C:\steamcmd"

:: 4 hours = 14400 seconds
set "RESTART_INTERVAL=14400"

:: =====================
:: MOD IDS
:: =====================
:: https://steamcommunity.com/workshop/filedetails/?id=1559212036 - CF
:: https://steamcommunity.com/workshop/filedetails/?id=1828439124 - VPPAdminTools
:: https://steamcommunity.com/workshop/filedetails/?id=3154500253 - GSC Gameworld Assets (JMC Edition)
:: https://steamcommunity.com/workshop/filedetails/?id=3296994216 - Alteria
set "MOD_CF_ID=1559212036"
set "MOD_VPP_ID=1828439124"
set "MOD_GSC_ID=3154500253"
set "MOD_ALTERIA_ID=3296994216"

:: =====================
:: MOD FOLDER NAMES
:: =====================
set "MOD_CF_NAME=@CF"
set "MOD_VPP_NAME=@VPPAdminTools"
set "MOD_GSC_NAME=@GSCGameworldAssets"
set "MOD_ALTERIA_NAME=@Alteria"

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
+workshop_download_item %DAYZ_ID% %MOD_GSC_ID% ^
+workshop_download_item %DAYZ_ID% %MOD_ALTERIA_ID% ^
+quit

if errorlevel 1 (
    echo ERROR: Failed to download mods
    exit /b 1
)

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

robocopy ^
"%ALTERIA_EXTRACT_DIR%\%ALTERIA_FOLDER_NAME%\empty.alteria" ^
"%SERVER_LOCATION%\mpmissions\empty.alteria" /E /R:3 /W:5

:: =====================
:: MODS COPY
:: =====================
if not exist "%SERVER_LOCATION%\keys" mkdir "%SERVER_LOCATION%\keys"

:: CF
robocopy "%WORKSHOP_CONTENT%\%MOD_CF_ID%" "%SERVER_LOCATION%\%MOD_CF_NAME%" /E /R:3 /W:5
robocopy "%WORKSHOP_CONTENT%\%MOD_CF_ID%\keys" "%SERVER_LOCATION%\keys" /E /R:3 /W:5

:: VPP
robocopy "%WORKSHOP_CONTENT%\%MOD_VPP_ID%" "%SERVER_LOCATION%\%MOD_VPP_NAME%" /E /R:3 /W:5
robocopy "%WORKSHOP_CONTENT%\%MOD_VPP_ID%\keys" "%SERVER_LOCATION%\keys" /E /R:3 /W:5

:: GSC Gameworld Assets
robocopy "%WORKSHOP_CONTENT%\%MOD_GSC_ID%" "%SERVER_LOCATION%\%MOD_GSC_NAME%" /E /R:3 /W:5
robocopy "%WORKSHOP_CONTENT%\%MOD_GSC_ID%\keys" "%SERVER_LOCATION%\keys" /E /R:3 /W:5

:: Alteria
robocopy "%WORKSHOP_CONTENT%\%MOD_ALTERIA_ID%" "%SERVER_LOCATION%\%MOD_ALTERIA_NAME%" /E /R:3 /W:5
robocopy "%WORKSHOP_CONTENT%\%MOD_ALTERIA_ID%\keys" "%SERVER_LOCATION%\keys" /E /R:3 /W:5

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
-mod=%MOD_CF_NAME%;%MOD_VPP_NAME%;%MOD_GSC_NAME%;%MOD_ALTERIA_NAME% ^
-cpuCount=%SERVER_CPU% ^
-dologs -adminlog -netlog -freezecheck

timeout /t %RESTART_INTERVAL% >nul

echo [%date% %time%] Restarting server
taskkill /IM DayZServer_x64.exe /F >nul 2>&1
timeout /t 10 >nul

goto START
