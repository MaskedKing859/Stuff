@echo off

net session >nul 2>&1
if %errorlevel% NEQ 0 (
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

winget install -e --id JernejSimoncic.Wget >nul 2>&1

set "archive=https://github.com/openziti/zrok/releases/download/v2.0.4/zrok_2.0.4_windows_amd64.tar.gz"
set "z2folder=C:\Program Files\zrok2"
set "downloads=%userprofile%\downloads"

if not exist "%z2folder%" mkdir "%z2folder%"

cd /d "%downloads%"

if exist zrok.7z del /q zrok.7z

wget -q -O "%z2folder%\zrok.7z" %archive%
