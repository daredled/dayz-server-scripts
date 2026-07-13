@echo off
setlocal

:: =====================
:: SERVER CONFIG
:: =====================
set "SERVER_LOCATION=C:\DayZServer"
set "SERVER_NAME=DayZ Hashima Private Server"
set "SERVER_PORT=2302"
set "SERVER_CONFIG=serverDZhashima.cfg"
set "SERVER_CPU=2"

:: 4 hours = 14400 seconds
set "RESTART_INTERVAL=14400"

:: =====================
:: MOD IDS
:: =====================
:: https://steamcommunity.com/workshop/filedetails/?id=3001202420 - Hashima Islands Assets
:: https://steamcommunity.com/workshop/filedetails/?id=2781560371 - Hashima Islands
:: https://steamcommunity.com/workshop/filedetails/?id=2482312670 - SpawnerBubaku

set "MOD_HASHIMA_ISLANDS_ASSETS_ID=3001202420"
set "MOD_HASHIMA_ISLANDS_ID=2781560371"
set "MOD_SPAWNERBUBAKU_ID=2482312670"


:: =====================
:: MOD FOLDER NAMES
:: =====================
set "MOD_HASHIMA_ISLANDS_ASSETS_NAME=@HashimaIslandsAssets"
set "MOD_HASHIMA_ISLANDS_NAME=@HashimaIslands"
set "MOD_SPAWNERBUBAKU_NAME=@SpawnerBubaku"

title %SERVER_NAME% batch

:: =====================
:: UPDATE SERVER
:: =====================
echo Updating DayZ server...
call "%~dp0dayz_server_install.bat"
if errorlevel 1 exit /b 1

:: =====================
:: DOWNLOAD + INSTALL MODS
:: =====================
call "%~dp0dayz_workshop_mod_install.bat" %SERVER_LOCATION% %MOD_HASHIMA_ISLANDS_ASSETS_ID% %MOD_HASHIMA_ISLANDS_ASSETS_NAME%
if errorlevel 1 exit /b 1
call "%~dp0dayz_workshop_mod_install.bat" %SERVER_LOCATION% %MOD_HASHIMA_ISLANDS_ID% %MOD_HASHIMA_ISLANDS_NAME%
if errorlevel 1 exit /b 1
call "%~dp0dayz_workshop_mod_install.bat" %SERVER_LOCATION% %MOD_SPAWNERBUBAKU_ID% %MOD_SPAWNERBUBAKU_NAME%
if errorlevel 1 exit /b 1

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

:: =====================
:: CONFIG
:: =====================
copy /Y "%~dp0%SERVER_CONFIG%" "%SERVER_LOCATION%\%SERVER_CONFIG%"

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
-mod=%MOD_HASHIMA_ISLANDS_ASSETS_NAME%;%MOD_HASHIMA_ISLANDS_NAME% ^
-serverMod=%MOD_SPAWNERBUBAKU_NAME% ^
-mission=mpmissions\main.hashima ^
-cpuCount=%SERVER_CPU% ^
-dologs -adminlog -netlog -freezecheck

:: Run for 4 hours
timeout /t %RESTART_INTERVAL% >nul

echo [%date% %time%] Restarting server

taskkill /IM DayZServer_x64.exe /F >nul 2>&1
timeout /t 10 >nul

goto START
