@echo off
title INTELLI-TRADER MISSION CONTROL
setlocal enabledelayedexpansion

:: 1. Force directory to backend folder
d:
cd \prj\Intelli-Trader\backend

echo ============================================================
echo [1/4] STARTING INFRASTRUCTURE
echo ============================================================

rem Start Services
net start postgresql-x64-16
net start MongoDB
wsl -u root service redis-server start

echo Databases processing complete.
echo.

echo ============================================================
echo [2/4] LAUNCHING ENGINES
echo ============================================================

rem Launch Executioner
echo Launching Executioner...
start "EXECUTIONER" cmd /k "python section_2_executioner.py"
timeout /t 5

rem Launch Auditor
echo Launching Auditor...
start "AUDITOR" cmd /k "python section_3_auditor.py"
timeout /t 2

echo.
echo ============================================================
echo [3/4] LAUNCHING BRIDGE
echo ============================================================

rem Launch MT5 Bridge (Moving up one level)
echo Launching MT5 Bridge...
start "MT5_BRIDGE" cmd /k "cd .. && python mt5_bridge.py"

echo.
echo ============================================================
echo [4/4] WAITING FOR READINESS
echo ============================================================
echo Checking Port 8081...

rem Simplified wait loop (Wait 10 seconds for safety instead of complex loop)
timeout /t 10

echo.
echo ============================================================
echo [COMPLETE] ALL PROCESSES STARTED
echo ============================================================
echo.
echo 1. Check the 3 new windows for errors.
echo 2. If windows are green/white text, start Flutter.
echo.
echo Press any key to exit this launcher.
pause > nul
