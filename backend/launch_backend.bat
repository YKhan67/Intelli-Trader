@echo off
title INTELLI-TRADER MISSION CONTROL
setlocal enabledelayedexpansion

:: 1. Force directory to backend folder
d:
cd \prj\Intelli-Trader\backend

echo ============================================================
echo [1/4] STARTING INFRASTRUCTURE
echo ============================================================

rem Start PostgreSQL
echo Checking PostgreSQL...
net start postgresql-x64-18 >nul 2>&1
if !errorlevel! equ 0 (
    echo   ✅ PostgreSQL started successfully.
) else (
    net session >nul 2>&1
    if !errorlevel! neq 0 (
        echo   ❌ ERROR: Admin privileges required to start services.
    ) else (
        echo   ℹ️  PostgreSQL already running or name mismatch.
    )
)

rem Start MongoDB
echo Checking MongoDB...
net start MongoDB >nul 2>&1
if !errorlevel! equ 0 (
    echo   ✅ MongoDB started successfully.
) else (
    echo   ℹ️  MongoDB already running.
)

rem Start Redis (WSL)
echo Checking Redis (WSL)...
wsl -u root service redis-server start >nul 2>&1
echo   ✅ Redis startup command sent to WSL.

echo.
echo ============================================================
echo [2/4] LAUNCHING ENGINES
echo ============================================================

rem Launch Executioner (API & Live Cycle)
echo Launching Executioner (API + Decision Engine)...
start "EXECUTIONER" cmd /k "python section_2_executioner.py"
timeout /t 5

rem Launch Auditor (Monitoring)
echo Launching Auditor (Continuous Learning)...
start "AUDITOR" cmd /k "python section_3_auditor.py"
timeout /t 2

rem Launch Strategist (Shadow Grid)
echo Launching Strategist (Immune System)...
start "STRATEGIST" cmd /k "python section_4_strategist.py"
timeout /t 2

echo.
echo ============================================================
echo [3/4] LAUNCHING BRIDGE
echo ============================================================

rem Launch MT5 Bridge
echo Launching MT5 Bridge...
start "MT5_BRIDGE" cmd /k "cd .. && python mt5_bridge.py"

echo.
echo ============================================================
echo [4/4] SYSTEM STATUS
echo ============================================================
echo Infrastructure initialized.
echo 56-Core Grid is now online.
echo.
echo 1. Verify all 4 new windows are running without errors.
echo 2. Once 'ALL SYSTEMS OPERATIONAL' appears in Executioner, start Flutter.
echo.
echo Press any key to exit this launcher (processes will remain running).
pause > nul
