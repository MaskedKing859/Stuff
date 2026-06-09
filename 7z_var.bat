@echo off

net session >nul 2>&1
if %errorlevel% NEQ 0 (
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

set "z2folder=C:\Program Files\zrok2"
set "downloads=%userprofile%\downloads"

::Backs up varibles
if not exist %downloads%\!backup mkdir %downloads%\!backup
cd %downloads%\!backup
if not exist BACKUP.txt echo %Path% >BACKUP.txt
cd %downloads%

::Set varibles
powershell -NoProfile -Command "[Environment]::SetEnvironmentVariable('Path', [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';C:\Program Files\7-Zip\', 'Machine')"
