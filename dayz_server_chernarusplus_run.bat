@echo off
setlocal

:: =====================
:: SERVER CONFIG
:: =====================
set "SERVER_LOCATION=C:\DayZServer"
set "SERVER_NAME=DayZ Chernarus Plus Private Server"
set "SERVER_PORT=2302"
set "SERVER_CONFIG=serverDZchernarusplus.cfg"
set "SERVER_CPU=2"

:: 4 hours = 14400 seconds
set "RESTART_INTERVAL=14400"

:: =====================
:: MOD IDS
:: =====================
:: https://steamcommunity.com/workshop/filedetails/?id=1559212036 - CF
:: https://steamcommunity.com/workshop/filedetails/?id=1828439124 - VPPAdminTools
set "MOD_CF_ID=1559212036"
set "MOD_VPP_ID=1828439124"

:: =====================
:: MOD FOLDER NAMES
:: =====================
set "MOD_CF_NAME=@CF"
set "MOD_VPP_NAME=@VPPAdminTools"

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
call "%~dp0dayz_workshop_mod_install.bat" %SERVER_LOCATION% %MOD_CF_ID% %MOD_CF_NAME%
if errorlevel 1 exit /b 1
call "%~dp0dayz_workshop_mod_install.bat" %SERVER_LOCATION% %MOD_VPP_ID% %MOD_VPP_NAME%
if errorlevel 1 exit /b 1

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
-mod=%MOD_CF_NAME%;%MOD_VPP_NAME% ^
-cpuCount=%SERVER_CPU% ^
-dologs -adminlog -netlog -freezecheck

timeout /t %RESTART_INTERVAL% >nul

echo [%date% %time%] Restarting server
taskkill /IM DayZServer_x64.exe /F >nul 2>&1
timeout /t 10 >nul

goto START
