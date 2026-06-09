@echo off

net session >nul 2>&1
if %errorlevel% NEQ 0 (
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

set "downloads=%userprofile%\downloads"

winget list --id 7zip.7zip >nul 2>nul || winget install -e --id 7zip.7zip

if not exist %downloads%\!backup mkdir %downloads%\!backup
cd %downloads%\!backup
if not exist BACKUP.txt echo %Path% >BACKUP.txt
cd %downloads%

powershell -NoProfile -Command "[Environment]::SetEnvironmentVariable('Path', [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';C:\Program Files\7-Zip\', 'Machine')"
