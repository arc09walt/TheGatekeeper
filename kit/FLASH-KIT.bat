@echo off
REM ROUTER FLASH KIT 1.0 launcher - Songwright
REM Starts the kit as administrator (admin is only needed so the network
REM recon can read adapter details - the kit changes NO settings).
REM   FLASH-KIT.bat            prep + verify + guide
REM   FLASH-KIT.bat postcheck  check whether OpenWrt is live after a flash
setlocal
set "MODE="
if /i "%~1"=="postcheck" set "MODE=-PostCheck"
net session >nul 2>&1
if %errorlevel% neq 0 (
  if "%~1"=="" (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  ) else (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -ArgumentList '%~1' -Verb RunAs"
  )
  exit /b
)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0flash-kit.ps1" %MODE%
endlocal
