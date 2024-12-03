@echo off

if not DEFINED IS_MINIMIZED set IS_MINIMIZED=1 && start "" /min "%~dpnx0" %* && exit

::create some variables to tell the batch file where to find the powershell script.

set "caminhopastaatual=%~dp0getpcinfohardware.ps1"

:: Verify if the file does exists

if exist "%caminhopastaatual%" (
    echo powershell file found. Starting powershell in loop.
    :loop
    powershell.exe -WindowStyle hidden -NoProfile -executionpolicy bypass -File "%~dp0getpcinfohardware.ps1"
    timeout /t 300 /nobreak
    goto :loop
) else (
    goto :Filenotfound
)

:Filenotfound

echo getpcinfohardware.ps1 script not found, verify its path and try once again.
exit

:: exit or pause

exit
