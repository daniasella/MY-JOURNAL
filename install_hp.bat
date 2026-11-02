@echo off
setlocal
chcp 65001 > nul
title My Journal - Installer HP Otomatis
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install_hp.ps1"
if errorlevel 1 pause
