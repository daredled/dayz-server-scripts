@echo off
setlocal

:: =====================
:: SERVER CONFIG
:: =====================
set "SERVER_LOCATION=C:\DayZServer"
set "SERVER_NAME=DayZ Namalsk Private Server"
set "SERVER_PORT=2302"
set "SERVER_CONFIG=serverDZnamalsk.cfg"
set "SERVER_CPU=2"
set "STEAM_WORKSHOP=C:\Program Files (x86)\Steam\steamapps\common\DayZ\!Workshop"

:: 4 hours = 14400 seconds
set "RESTART_INTERVAL=14400"

:: =====================
:: NAMALSK MISSION SELECT
:: =====================
:: Options: regular.namalsk | hardcore.namalsk
set "NAMALSK_MISSION=regular.namalsk"

title %SERVER_NAME% batch

:: =====================
:: ENSURE REQUIRED FOLDERS
:: =====================
if not exist "%SERVER_LOCATION%\keys" mkdir "%SERVER_LOCATION%\keys"
if not exist "%SERVER_LOCATION%\mpmissions" mkdir "%SERVER_LOCATION%\mpmissions"

:: =====================
:: MODS
:: =====================

:: CF
robocopy "%STEAM_WORKSHOP%\@CF" "%SERVER_LOCATION%\@CF" /E /R:3 /W:5
robocopy "%STEAM_WORKSHOP%\@CF\keys" "%SERVER_LOCATION%\keys" /E /R:3 /W:5

:: Namalsk Island
robocopy "%STEAM_WORKSHOP%\@Namalsk Island" "%SERVER_LOCATION%\@NamalskIsland" /E /R:3 /W:5
robocopy "%STEAM_WORKSHOP%\@Namalsk Island\keys" "%SERVER_LOCATION%\keys" /E /R:3 /W:5

:: Namalsk Survival
robocopy "%STEAM_WORKSHOP%\@Namalsk Survival" "%SERVER_LOCATION%\@NamalskSurvival" /E /R:3 /W:5
robocopy "%STEAM_WORKSHOP%\@Namalsk Survival\keys" "%SERVER_LOCATION%\keys" /E /R:3 /W:5

:: (Optional) VPP Admin Tools
robocopy "%STEAM_WORKSHOP%\@VPPAdminTools" "%SERVER_LOCATION%\@VPPAdminTools" /E /R:3 /W:5
robocopy "%STEAM_WORKSHOP%\@VPPAdminTools\keys" "%SERVER_LOCATION%\keys" /E /R:3 /W:5

:: =====================
:: COPY NAMALSK MISSIONS
:: =====================

:: Regular
robocopy "%STEAM_WORKSHOP%\@Namalsk Survival\Extras\Regular\regular.namalsk" "%SERVER_LOCATION%\mpmissions\regular.namalsk" /E /R:3 /W:5

:: Hardcore
robocopy "%STEAM_WORKSHOP%\@Namalsk Survival\Extras\Hardcore\hardcore.namalsk" "%SERVER_LOCATION%\mpmissions\hardcore.namalsk" /E /R:3 /W:5

:: =====================
:: CONFIG
:: =====================
robocopy . "%SERVER_LOCATION%" "%SERVER_CONFIG%" /R:3 /W:5

:: =====================
:: SERVER LOOP
:: =====================
:START
cd /d "%SERVER_LOCATION%" || exit /b 1

echo [%date% %time%] Starting %SERVER_NAME% (%NAMALSK_MISSION%)

start "DayZ Server" /min "DayZServer_x64.exe" ^
-config=%SERVER_CONFIG% ^
-port=%SERVER_PORT% ^
-mission=mpmissions\%NAMALSK_MISSION% ^
-profiles=profiles ^
-mod=@CF;@NamalskIsland;@NamalskSurvival;@VPPAdminTools ^
-cpuCount=%SERVER_CPU% ^
-dologs -adminlog -netlog -freezecheck

:: Run for 4 hours
timeout /t %RESTART_INTERVAL% >nul

echo [%date% %time%] Restarting server

taskkill /IM DayZServer_x64.exe /F >nul 2>&1
timeout /t 10 >nul

goto START
