@echo off

net session >nul 2>&1
if %errorlevel% NEQ 0 (
    powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

set "z2folder=C:\Program Files\zrok2"
set "downloads=%userprofile%\downloads"

:: Extracts Archives
cd %z2folder%
7z e -aoa "zrok.7z" > NUL:
7z e -aoa "zrok" > NUL:

::removes extra Files
del zrok.7z
del zrok
del CHANGELOG.md
del LICENSE
del README.md

::Creates z2
xcopy zrok2.exe z2.exe /-I /Q /y
