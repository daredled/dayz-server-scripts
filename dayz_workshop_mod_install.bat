@echo off
setlocal

if "%~1"=="" goto usage
if "%~2"=="" goto usage
if "%~3"=="" goto usage

set "installDir=%~1"
set "modId=%~2"
set "folderName=%~3"
set "appId=221100"

call "%~dp0common\steam_workshop_mods_install.bat" %appId% %installDir% %modId% %folderName%
if errorlevel 1 exit /b 1

set "workshopContent=%installDir%\steamapps\workshop\content\%appId%\%modId%"
if not exist "%installDir%\keys" mkdir "%installDir%\keys"
robocopy "%workshopContent%\keys" "%installDir%\keys" /E /R:3 /W:5

rem robocopy exit codes 0-7 all indicate some degree of success; only 8+
rem is a real failure, so we don't gate on errorlevel here either.

exit /b 0

:usage
echo Usage: dayz_workshop_mod_install.bat ^<installDir^> ^<modId^> ^<folderName^>
echo   Downloads and installs one DayZ Workshop mod (app ID 221100) via the
echo   shared common\steam_workshop_mods_install.bat, then copies its keys
echo   subfolder into ^<installDir^>\keys. Call once per mod.
echo   Requires the STEAM_USER environment variable to be set.
exit /b 1
