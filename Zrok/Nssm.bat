@echo off

winget install -e --id NSSM.NSSM >nul 2>&1

cd "C:\Program Files\zrok2"
set USERPROFILE=c:\Windows\System32\config\systemprofile
nssm remove zrok confirm
nssm install zrok "C:\Program Files\zrok2\zrok2.exe"
nssm set zrok AppParameters "agent start"
nssm set zrok AppDirectory C:\Windows\System32\config\systemprofile
nssm set zrok AppStdout C:\Windows\System32\config\systemprofile\.zrok2\agent-Output.log
nssm set zrok AppStderr C:\Windows\System32\config\systemprofile\.zrok2\agent-Error.log
nssm set zrok Start SERVICE_AUTO_START
sc start zrok
pause