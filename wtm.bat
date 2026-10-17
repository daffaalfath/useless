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

REM =========================================================
REM CATEGORY 1: OPTIMIZER TOOLS
REM =========================================================
:optimize
cls
echo.
echo  --- Optimizer Tools ---
echo.
echo  1. Windows 11
echo  2. Windows 10
echo  3. Windows 7
echo  B. Back
echo.
set "os="
set /p "os=Choose: "
if "%os%"=="1" goto win11
if "%os%"=="2" goto win10
if "%os%"=="3" goto win7
if /i "%os%"=="B" goto menu
goto optimize

REM ---------------- Windows 11 ----------------
:win11
cls
echo.
echo  --- Optimizer Tools : Windows 11 ---
echo.
echo  1. Chris Titus Tool
echo  2. Mem Reduct (henrypp)
echo  3. OneClick Optimizer (QuakedK)
echo  B. Back
echo.
set "tool="
set /p "tool=Choose: "
if "%tool%"=="1" call :chris
if "%tool%"=="2" call :memreduct
if "%tool%"=="3" call :oneclick
if /i "%tool%"=="B" goto optimize
goto win11

REM ---------------- Windows 10 (All) ----------------
:win10
cls
echo.
echo  --- Optimizer Tools : Windows 10 (All) ---
echo.
echo  1. Chris Titus Tool
echo  2. Optimizer (hellzerg)
echo  3. Mem Reduct (henrypp)
echo  B. Back
echo.
set "tool="
set /p "tool=Choose: "
if "%tool%"=="1" call :chris
if "%tool%"=="2" call :hellzerg
if "%tool%"=="3" call :memreduct
if /i "%tool%"=="B" goto optimize
goto win10

REM ---------------- Windows 7 (empty) ----------------
:win7
cls
echo.
echo  --- Optimizer Tools : Windows 7 ---
echo.
echo  (No tools added yet)
echo.
echo  B. Back
echo.
set "tool="
set /p "tool=Choose: "
if /i "%tool%"=="B" goto optimize
goto win7

REM ---------------- Tool launchers (subroutines) ----------------
:chris
cls
echo Launching Chris Titus Tool as Administrator...
start "" powershell -NoProfile -Command "Start-Process powershell -Verb RunAs -ArgumentList '-NoProfile -ExecutionPolicy Bypass -NoExit -Command irm christitus.com/win | iex'"
timeout /t 2 >nul
exit /b

:hellzerg
set "NAME=Optimizer (hellzerg)"
set "URL=https://github.com/hellzerg/optimizer/releases/download/16.7/Optimizer-16.7.exe"
set "FILE=Optimizer-16.7.exe"
call :run_exe
exit /b

:memreduct
set "NAME=Mem Reduct (henrypp)"
set "URL=https://github.com/henrypp/memreduct/releases/download/v.3.5.2/memreduct-3.5.2-setup.exe"
set "FILE=memreduct-3.5.2-setup.exe"
call :run_exe
exit /b

:oneclick
set "NAME=OneClick Optimizer (QuakedK)"
set "URL=https://github.com/QuakedK/Oneclick/releases/download/DebloatTool/Oneclick-V8.4.bat"
set "FILE=Oneclick-V8.4.bat"
call :run_exe
exit /b

REM =========================================================
REM CATEGORY 2: ACTIVATE TOOLS
REM =========================================================
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
REM Change the command on the next line
set "ACT_CMD=[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; irm https://get.activated.win | iex; Start-Sleep -Seconds 2; Stop-Process -Id $PID -Force"
call :run_admin_ps
goto activate

REM ---------------------------------------------------------
REM Runs ACT_CMD in a new elevated PowerShell window.
REM The command is Base64-encoded so pipes/quotes are not mangled.
REM Uses variable: ACT_CMD
REM ---------------------------------------------------------
:run_admin_ps
start "" powershell -NoProfile -Command "$c=[Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($env:ACT_CMD)); Start-Process powershell -Verb RunAs -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-EncodedCommand',$c"
timeout /t 1 >nul
exit /b

REM ---------------------------------------------------------
REM Downloads a file (.exe or .bat) in a NEW PowerShell window,
REM runs it as administrator, and closes the window on success.
REM On error the window stays open until you press Enter.
REM Uses variables: NAME, URL, FILE
REM ---------------------------------------------------------
:run_exe
cls
echo Opening a new window to download %NAME%...
start "Downloading %NAME%" powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; $ProgressPreference='SilentlyContinue'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; try { Write-Host ('Downloading '+$env:NAME+'...'); $f=Join-Path $env:TEMP $env:FILE; Invoke-WebRequest -Uri $env:URL -OutFile $f -UseBasicParsing; Write-Host 'Download complete. Launching...' -ForegroundColor Green; Start-Process -FilePath $f -Verb RunAs } catch { Write-Host ('ERROR: '+$_.Exception.Message) -ForegroundColor Red; Read-Host 'Press Enter to close' }"
echo.
echo The download is running in the new window.
timeout /t 3 >nul
exit /b
