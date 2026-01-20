@echo off
setlocal

:: =====================
:: SERVER CONFIG
:: =====================
set "SERVER_LOCATION=C:\DayZServer"
set "SERVER_NAME=DayZ Private Server"
set "SERVER_PORT=2302"
set "SERVER_CONFIG=serverDZhashima.cfg"
set "SERVER_CPU=2"
set "STEAM_WORKSHOP=C:\Program Files (x86)\Steam\steamapps\common\DayZ\!Workshop"

:: 4 hours = 14400 seconds
set "RESTART_INTERVAL=14400"

title %SERVER_NAME% batch

:: =====================
:: HASHIMA MISSION
:: =====================
set "HASHIMA_REPO_ZIP_URL=https://github.com/hashimagg/mission/archive/refs/heads/main.zip"
set "HASHIMA_ZIP_FILE=%TEMP%\hashima_mission_main.zip"
set "HASHIMA_EXTRACT_DIR=%TEMP%\hashima_mission_extracted"
set "HASHIMA_FOLDER_NAME=mission-main"

curl -L "%HASHIMA_REPO_ZIP_URL%" -o "%HASHIMA_ZIP_FILE%"

if not exist "%HASHIMA_EXTRACT_DIR%" mkdir "%HASHIMA_EXTRACT_DIR%"
tar -xf "%HASHIMA_ZIP_FILE%" -C "%HASHIMA_EXTRACT_DIR%"

robocopy "%HASHIMA_EXTRACT_DIR%\%HASHIMA_FOLDER_NAME%\main.hashima" "%SERVER_LOCATION%\mpmissions\main.hashima" /E /R:3 /W:5
robocopy "%HASHIMA_EXTRACT_DIR%\%HASHIMA_FOLDER_NAME%\profiles\SpawnerBubaku" "%SERVER_LOCATION%\profiles\SpawnerBubaku" SpawnerBubakuV2.json /R:3 /W:5

set "AREAFILES_URL=https://github.com/hashimagg/mission/raw/refs/heads/main/main.hashima/areaflags.map"
set "AREAFILES_NAME=areaflags.map"
set "AREAFILES_TEMP_FILE=%TEMP%\%AREAFILES_NAME%"

curl -L "%AREAFILES_URL%" -o "%AREAFILES_TEMP_FILE%"

robocopy "%TEMP%" "%SERVER_LOCATION%\mpmissions\main.hashima" "%AREAFILES_NAME%" /R:3 /W:5

pause

:: =====================
:: MODS
:: =====================
if not exist "%SERVER_LOCATION%\keys" mkdir "%SERVER_LOCATION%\keys"

:: Hashima Islands Assets
robocopy "%STEAM_WORKSHOP%\@Hashima Islands Assets" "%SERVER_LOCATION%\@HashimaIslandsAssets" /E
robocopy "%STEAM_WORKSHOP%\@Hashima Islands Assets\keys" "%SERVER_LOCATION%\keys" /E

:: Hashima Islands
robocopy "%STEAM_WORKSHOP%\@Hashima Islands" "%SERVER_LOCATION%\@HashimaIslands" /E
robocopy "%STEAM_WORKSHOP%\@Hashima Islands\keys" "%SERVER_LOCATION%\keys" /E

:: SpawnerBubaku
robocopy "%STEAM_WORKSHOP%\@SpawnerBubaku" "%SERVER_LOCATION%\@SpawnerBubaku" /E
robocopy "%STEAM_WORKSHOP%\@SpawnerBubaku\keys" "%SERVER_LOCATION%\keys" /E

:: =====================
:: CONFIG
:: =====================
robocopy . "%SERVER_LOCATION%" "%SERVER_CONFIG%" /R:3 /W:5

:: =====================
:: SERVER LOOP
:: =====================
:START
cd /d "%SERVER_LOCATION%" || exit /b 1

echo [%date% %time%] %SERVER_NAME% started (restart #%RESTART_COUNT%)

start "DayZ Server" /min "DayZServer_x64.exe" ^
-config=%SERVER_CONFIG% ^
-port=%SERVER_PORT% ^
-profiles=profiles ^
-mod=@HashimaIslandsAssets;@HashimaIslands ^
-serverMod=@SpawnerBubaku ^
-mission=mpmissions\main.hashima ^
-cpuCount=%SERVER_CPU% ^
-dologs -adminlog -netlog -freezecheck

:: Run for 4 hours
timeout /t %RESTART_INTERVAL% >nul

echo [%date% %time%] Restarting server

taskkill /IM DayZServer_x64.exe /F >nul 2>&1
timeout /t 10 >nul

goto START
