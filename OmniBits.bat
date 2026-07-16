@echo off
net session >nul 2>&1
if %errorlevel% NEQ 0 (
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

set "Paks=C:\XboxGames\Grounded 2\Content\Augusta\Content\Paks"
set "Saved=C:\Users\Seans\AppData\Local\Augusta\Saved"
set "Omnibits=https://drive.usercontent.google.com/download?id=1ojeDIVrOBTOoYZpil0ORpRl3ZCgWfD96&export=download&confirm=t"
set "downloads=%userprofile%\downloads"
set "Bak=C:\Program Files\Script_Bak\Sys_Variable_Backup"
set "wkdir=%~dp0"
set "ScTemp=%wkdir%Temp"

if exist "%ScTemp%" rmdir /s /q "%ScTemp%"
if not exist "%ScTemp%" mkdir "%ScTemp%"
if not exist "%ScTemp%\extract" mkdir "%ScTemp%\extract"
if not exist "%Paks%" mkdir "%Paks%"
if not exist "%Saved%" mkdir "%Saved%"

winget install --id 7zip.7zip --silent --accept-source-agreements --accept-package-agreements >nul 2>&1
winget install --id JernejSimoncic.Wget --silent --accept-source-agreements --accept-package-agreements >nul 2>&1

if not exist "%Bak%" mkdir "%Bak%"
cd "%Bak%"
if not exist BACKUP.txt echo %Path% >BACKUP.txt
cd %wkdir%

powershell -NoProfile -Command "$p='C:\Program Files\7-Zip\'; $curr=[Environment]::GetEnvironmentVariable('Path','Machine'); if (($curr -split ';' | ForEach-Object { $_.TrimEnd('\') }) -notcontains $p.TrimEnd('\')) { [Environment]::SetEnvironmentVariable('Path', $curr.TrimEnd(';') + ';' + $p, 'Machine') }"

wget --no-check-certificate -O "%ScTemp%\OmniBits.rar" "%Omnibits%"
7z x "%ScTemp%\OmniBits.rar" -o"%ScTemp%\extract" -y
move "%ScTemp%\extract\OmniBits" "%Saved%\Paks"
if exist "%ScTemp%" rmdir /s /q "%ScTemp%"
exit