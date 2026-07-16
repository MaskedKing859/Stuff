@echo off
net session >nul 2>&1
if %errorlevel% NEQ 0 (
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

:: Variables
set "Loader=C:\XboxGames\Grounded 2\Content\Augusta\Binaries\WinGDK\"
set "Saved=C:\Users\Seans\AppData\Local\Augusta\Saved\Paks"
set "LoaderMods=C:\XboxGames\Grounded 2\Content\Augusta\Binaries\WinGDK\ue4ss\Mods"
set "Paks=C:\XboxGames\Grounded 2\Content\Augusta\Content\Paks"
set "Link=https://drive.usercontent.google.com/download?id=1f0yHbe1ymS3EdqrM_kfD7x50CModeTPz&export=download&confirm=t"
set "downloads=%userprofile%\downloads"
set "Bak=C:\Program Files\Script_Bak\Path_Variable_Backup"
set "wkdir=%~dp0"
set "ScTemp=%wkdir%Temp"

set "RoboSnake=False"

:: Post Cleanup/Setup
if exist "%ScTemp%" rmdir /s /q "%ScTemp%"
if not exist "%ScTemp%" mkdir "%ScTemp%"
if not exist "%ScTemp%\extract" mkdir "%ScTemp%\extract"
if not exist "%Paks%" mkdir "%Paks%"
if not exist "%Saved%" mkdir "%Saved%"

:: 7z and wget Setup/Variable SysPath Backup 
if not exist "%Bak%" mkdir "%Bak%"
cd "%Bak%"
if not exist BACKUP.txt echo %Path% >BACKUP.txt
cd %wkdir%

winget install --id 7zip.7zip --silent --accept-source-agreements --accept-package-agreements >nul 2>&1
winget install --id JernejSimoncic.Wget --silent --accept-source-agreements --accept-package-agreements >nul 2>&1

powershell -NoProfile -Command "$p='C:\Program Files\7-Zip\'; $curr=[Environment]::GetEnvironmentVariable('Path','Machine'); if (($curr -split ';' | ForEach-Object { $_.TrimEnd('\') }) -notcontains $p.TrimEnd('\')) { [Environment]::SetEnvironmentVariable('Path', $curr.TrimEnd(';') + ';' + $p, 'Machine') }"

:: Download/Extract
wget --no-check-certificate -O "%ScTemp%\Paks.rar" "%Link%"
7z x "%ScTemp%\Paks.rar" -o"%ScTemp%\extract" -y

:: PreCopy Cleanup
if exist "%Loader%\ue4ss\" rmdir /s /q "%Loader%\ue4ss\"
if exist "%Loader%\dwmapi.dll" del "%Loader%\dwmapi.dll"
if exist "%Saved%\OmniBits\" rmdir /s /q "%Saved%\OmniBits\"
for /d %%i in ("%Paks%\*") do rmdir /s /q "%%i"

:: Copy Files
echo Setting up ue4ss..
xcopy "%ScTemp%\extract\Paks\Loader\*" "%Loader%" /I /E /Y
echo Moving ue4ss Mods..
xcopy "%ScTemp%\extract\Paks\LoaderMods\**" "%LoaderMods%" /I /E /Y
echo Moving Pak Files..
xcopy "%ScTemp%\extract\Paks\Paks\**" "%Paks%" /I /E /Y

if not exist "%Saved%\OmniBits" (
    echo Installing OmniBits..
    xcopy "%ScTemp%\extract\Paks\Saved\OmniBits" "%Saved%\OmniBits" /I /E /Y 
) else echo OmniBits Found Skipping

:: Cleanup
rmdir /s /q "%ScTemp%"

if exist "%Paks%\RoboSnake" (
    if "%RoboSnake%"=="False" rmdir /s /q "%Paks%\RoboSnake"
    if "%RoboSnake%"=="false" rmdir /s /q "%Paks%\RoboSnake"
)
exit