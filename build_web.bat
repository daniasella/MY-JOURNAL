@echo off
setlocal
chcp 65001 > nul
title My Journal - Build Web

echo =======================================================
echo          MY JOURNAL - BUILD FLUTTER WEB
echo =======================================================
echo.

set /p api_url="Masukkan URL API Backend Vercel kamu (tekan Enter untuk default https://my-journal-api.vercel.app): "
if not defined api_url set api_url=https://my-journal-api.vercel.app

echo.
echo [1/2] Meng-compile Flutter Web dengan API: %api_url%...
call flutter build web --release --dart-define=API_BASE_URL=%api_url%
if errorlevel 1 (
  echo [ERROR] Gagal meng-compile Flutter Web!
  pause
  exit /b 1
)

echo.
echo [2/2] Menambahkan konfigurasi Vercel SPA...
if exist "web\vercel.json" (
  copy /y "web\vercel.json" "build\web\vercel.json" >nul
)

echo.
echo =======================================================
echo [BERHASIL] File web siap di folder: build\web
echo Anda dapat mendeploy isi folder build\web ke Vercel!
echo =======================================================
pause
