@echo off
setlocal EnableExtensions
title Windows Tools Menu 
color 0A

:menu
cls
echo.
echo  1. Optimizer Tools
echo  2. Activate Tools
echo  X. Exit
echo.
set "choose="
set /p "choose=Choose: "
if /i "%choose%"=="1" goto optimize
if /i "%choose%"=="2" goto activate
if /i "%choose%"=="X" exit /b
goto menu

:: =========================================================
:: CATEGORY 1: OPTIMIZER TOOLS
:: =========================================================
:optimize
cls
echo.
echo  --- Optimizer Tools ---
echo.
echo  1. Chris Titus Tool
echo  2. Optimizer (hellzerg)
echo  3. Mem Reduct (henrypp)
echo  B. Back
echo.
set "tool="
set /p "tool=Choose: "
if "%tool%"=="1" goto chris
if "%tool%"=="2" goto hellzerg
if "%tool%"=="3" goto memreduct
if /i "%tool%"=="B" goto menu
goto optimize

:chris
cls
echo Launching Chris Titus Tool as Administrator...
start "" powershell -NoProfile -Command "Start-Process powershell -Verb RunAs -ArgumentList '-NoProfile -ExecutionPolicy Bypass -NoExit -Command irm christitus.com/win | iex'"
timeout /t 2 >nul
goto optimize

:hellzerg
set "NAME=Optimizer (hellzerg)"
set "URL=https://github.com/hellzerg/optimizer/releases/download/16.7/Optimizer-16.7.exe"
set "FILE=Optimizer-16.7.exe"
call :run_exe
goto optimize

:memreduct
set "NAME=Mem Reduct (henrypp)"
set "URL=https://github.com/henrypp/memreduct/releases/download/v.3.5.2/memreduct-3.5.2-setup.exe"
set "FILE=memreduct-3.5.2-setup.exe"
call :run_exe
goto optimize

:: =========================================================
:: CATEGORY 2: ACTIVATE TOOLS
:: =========================================================
:activate
cls
echo.
echo  --- Activate Tools ---
echo.
echo  1. massgrave.dev
echo  B. Back
echo.
set "act="
set /p "act=Choose: "
if "%act%"=="1" goto massgrave
if /i "%act%"=="B" goto menu
goto activate

:massgrave
cls
echo Opening massgrave.dev in a new PowerShell window as Administrator...
:: >>> CHANGE THE COMMAND BELOW <<<
set "ACT_CMD=[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; irm https://get.activated.win | iex; Start-Sleep -Seconds 2; Stop-Process -Id $PID -Force"
call :run_admin_ps
goto activate

:: ---------------------------------------------------------
:: Runs ACT_CMD in a new elevated PowerShell window.
:: The command is Base64-encoded so pipes/quotes are not mangled.
:: Uses variable: ACT_CMD
:: ---------------------------------------------------------
:run_admin_ps
start "" powershell -NoProfile -Command "$c=[Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($env:ACT_CMD)); Start-Process powershell -Verb RunAs -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-EncodedCommand',$c"
timeout /t 1 >nul
exit /b

:: ---------------------------------------------------------
:: Downloads an EXE in a NEW PowerShell window, runs it as
:: administrator, and closes the window on success.
:: On error the window stays open until you press Enter.
:: Uses variables: NAME, URL, FILE
:: ---------------------------------------------------------
:run_exe
cls
echo Opening a new window to download %NAME%...
start "Downloading %NAME%" powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; $ProgressPreference='SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; try { Write-Host ('Downloading '+$env:NAME+'...'); $f=Join-Path $env:TEMP $env:FILE; Invoke-WebRequest -Uri $env:URL -OutFile $f -UseBasicParsing; Write-Host 'Download complete. Launching...' -ForegroundColor Green; Start-Process -FilePath $f -Verb RunAs } catch { Write-Host ('ERROR: '+$_.Exception.Message) -ForegroundColor Red; Read-Host 'Press Enter to close' }"
echo.
echo The download is running in the new window.
timeout /t 3 >nul
exit /b
