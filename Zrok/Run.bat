@echo off
set "REPO_URL=https://raw.githubusercontent.com/MaskedKing859/Stuff/main/Zrok"
set "FILE1=Download_zrok.bat"
set "FILE2=Varibles.bat"
set "FILE3=Setup_zrok.bat"

if exist "%temp%\Download_zrok.bat" del "%temp%\Download_zrok.bat"
if exist "%temp%\Varibles.bat" del "%temp%\Varibles.bat"
if exist "%temp%\Setup_zrok.bat" del "%temp%\Setup_zrok.bat"

powershell -NoProfile -ExecutionPolicy Bypass -Command "irm '%REPO_URL%/%FILE1%' -OutFile '%temp%\Download_zrok.bat'"
call "%temp%\Download_zrok.bat"

powershell -NoProfile -ExecutionPolicy Bypass -Command "irm '%REPO_URL%/%FILE2%' -OutFile '%temp%\Varibles.bat'"
call "%temp%\Varibles.bat"

powershell -NoProfile -ExecutionPolicy Bypass -Command "irm '%REPO_URL%/%FILE3%' -OutFile '%temp%\Setup_zrok.bat'"
call "%temp%\Setup_zrok.bat"

pause