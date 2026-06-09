@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0"
set "Archive=%~dp0Dome-Keeper-SteamRIP.com.rar"
set "Output=%~dp0"
set "Onlinefix=%~dp0Dome Keeper"

if not exist "%Output%" mkdir "%Output%"

7z x "%Archive%" "-o%Output%" -y

if exist "%Output%\_CommonRedist" rmdir /s /q "%Output%\_CommonRedist"
if exist "%Output%\Read_Me_Instructions.txt" del /f /q "%Output%\Read_Me_Instructions.txt"
if exist "%Output%\STEAMRIP*.url" del /f /q "%Output%\STEAMRIP*.url"

wget -O "%~dp0onlinefix.zip" "https://vikingfile.com/d/geoXnXBJ0Y/DomeKeeper%20Online%20Fix%20RexaGames.com.zip"

7z x "%~dp0onlinefix.zip" -prexagames.com "-o%Onlinefix%" -y

del %~dp0onlinefix.zip

exit
