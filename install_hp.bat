@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul
title My Journal - Installer HP Otomatis

echo =======================================================
echo          MY JOURNAL - INSTALLER HP OTOMATIS
echo =======================================================
echo.

set ADB="C:\Users\ASUS\AppData\Local\platform-tools\adb.exe"
if not exist %ADB% (
  set ADB=adb
)

%ADB% version >nul 2>&1
if errorlevel 1 (
  echo [ERROR] ADB tidak ditemukan di sistem!
  pause
  exit /b 1
)

echo [INFO] Memulai ADB server...
%ADB% start-server >nul 2>&1

:wait_device
echo.
echo [1/3] Mendeteksi HP yang terhubung via kabel USB...
set FOUND=0
set UNAUTH=0

for /f "skip=1 tokens=1,2" %%A in ('%ADB% devices') do (
  if "%%B"=="device" (
    set FOUND=1
    set DEVICE_ID=%%A
  )
  if "%%B"=="unauthorized" (
    set UNAUTH=1
  )
)

if "!UNAUTH!"=="1" (
  echo.
  echo [PERINGATAN] HP terdeteksi tapi belum diizinkan!
  echo Silakan lihat layar HP Anda, centang "Selalu izinkan dari komputer ini"
  echo lalu tekan tombol "IZINKAN" / "ALLOW".
  echo.
  timeout /t 3 >nul
  goto wait_device
)

if "!FOUND!"=="0" (
  echo [BELUM TERDETEKSI] HP belum terbaca.
  echo Pastikan:
  echo 1. Kabel USB tercolok dengan baik ke laptop dan HP.
  echo 2. Ubah mode USB di HP menjadi "Transfer File" (MTP).
  echo 3. Aktifkan "USB Debugging" di Pengaturan HP (Opsi Pengembang).
  echo.
  echo Sedang menunggu HP terhubung (otomatis mendeteksi)...
  timeout /t 3 >nul
  goto wait_device
)

echo.
echo [BERHASIL] HP terdeteksi: !DEVICE_ID!
for /f "tokens=*" %%M in ('%ADB% -s !DEVICE_ID! shell getprop ro.product.model') do set MODEL=%%M
if defined MODEL echo Model HP: !MODEL!

echo.
echo [2/3] Menginstal My Journal.apk ke HP Anda...
%ADB% -s !DEVICE_ID! install -r "My Journal.apk"

if errorlevel 1 (
  echo.
  echo [PERINGATAN] Instalasi gagal. Mencoba dengan izin bypass (-d)...
  %ADB% -s !DEVICE_ID! install -r -d "My Journal.apk"
)

if errorlevel 1 (
  echo.
  echo [ERROR] Gagal menginstal APK.
  echo Pastikan di HP Anda:
  echo - Opsi "Install via USB" aktif di Opsi Pengembang (khusus Xiaomi/Redmi/Oppo/Vivo).
  echo - Berikan izin jika muncul popup di layar HP.
  pause
  exit /b 1
)

echo.
echo [3/3] Membuka aplikasi My Journal di HP Anda...
%ADB% -s !DEVICE_ID! shell monkey -p com.myjournal.my_journal -c android.intent.category.LAUNCHER 1 >nul 2>&1

echo.
echo =======================================================
echo [SUKSES] Aplikasi My Journal berhasil terinstal dan dibuka di HP!
echo =======================================================
echo.
pause
