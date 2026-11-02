$Host.UI.RawUI.WindowTitle = "My Journal - Installer HP Otomatis"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host "         MY JOURNAL - INSTALLER HP OTOMATIS            " -ForegroundColor Yellow
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host ""

$adb = "C:\Users\ASUS\AppData\Local\platform-tools\adb.exe"
if (!(Test-Path $adb)) {
    $found = Get-Command adb -ErrorAction SilentlyContinue
    if ($found) { $adb = $found.Source }
    else {
        Write-Host "[ERROR] ADB tidak ditemukan di $adb" -ForegroundColor Red
        pause
        exit 1
    }
}

$apkPath = Join-Path $PSScriptRoot "My Journal.apk"
if (!(Test-Path $apkPath)) {
    $apkPath = "D:\MY JOURNAL TERBARU\MY-JOURNAL-main\My Journal.apk"
}

Write-Host "[INFO] Memulai ADB Server..." -ForegroundColor Gray
& $adb start-server | Out-Null

Write-Host "[1/3] Mendeteksi HP yang terhubung via kabel USB..." -ForegroundColor Cyan

while ($true) {
    $output = & $adb devices
    $lines = $output | Where-Object { $_ -and $_ -notmatch "List of devices" -and $_ -notmatch "daemon" }
    
    $readyDevice = $null
    $unauthDevice = $null

    foreach ($line in $lines) {
        $parts = $line -split "\s+"
        if ($parts.Count -ge 2) {
            $id = $parts[0]
            $status = $parts[1]
            if ($status -eq "device") {
                $readyDevice = $id
                break
            } elseif ($status -eq "unauthorized") {
                $unauthDevice = $id
            }
        }
    }

    if ($readyDevice) {
        Write-Host ""
        Write-Host "[BERHASIL] HP Terdeteksi: $readyDevice" -ForegroundColor Green
        $model = (& $adb -s $readyDevice shell getprop ro.product.model).Trim()
        if ($model) {
            Write-Host "[INFO] Model HP: $model" -ForegroundColor Green
        }
        
        Write-Host ""
        Write-Host "[2/3] Menginstal My Journal.apk ke HP Anda..." -ForegroundColor Cyan
        Write-Host "File APK: $apkPath" -ForegroundColor Gray
        
        $installResult = & $adb -s $readyDevice install -r $apkPath
        $installText = $installResult -join " "
        
        if ($installText -match "Success") {
            Write-Host "[SUKSES] Instalasi berhasil!" -ForegroundColor Green
        } else {
            Write-Host "[PERINGATAN] Instalasi standar gagal, mencoba opsi bypass (-d)..." -ForegroundColor Yellow
            $retryResult = & $adb -s $readyDevice install -r -d $apkPath
            $retryText = $retryResult -join " "
            if ($retryText -notmatch "Success") {
                Write-Host "[ERROR] Gagal menginstal: $retryText" -ForegroundColor Red
                Write-Host "Catatan: Jika HP Anda Xiaomi/Redmi/Oppo/Realme/Vivo, pastikan 'Install via USB' diaktifkan di Opsi Pengembang." -ForegroundColor Yellow
                pause
                exit 1
            }
        }

        Write-Host ""
        Write-Host "[3/3] Membuka aplikasi My Journal di layar HP Anda..." -ForegroundColor Cyan
        & $adb -s $readyDevice shell monkey -p com.myjournal.my_journal -c android.intent.category.LAUNCHER 1 | Out-Null

        Write-Host ""
        Write-Host "=======================================================" -ForegroundColor Green
        Write-Host " [SELESAI] My Journal berhasil terinstal & aktif di HP!  " -ForegroundColor Yellow
        Write-Host "=======================================================" -ForegroundColor Green
        Write-Host ""
        pause
        break
    } elseif ($unauthDevice) {
        Write-Host "`r[PERINGATAN] HP terdeteksi ($unauthDevice) tapi belum diizinkan!" -ForegroundColor Yellow
        Write-Host "-> Silakan lihat layar HP Anda, centang 'Selalu izinkan dari komputer ini' lalu klik IZINKAN (ALLOW)." -ForegroundColor Yellow
        Start-Sleep -Seconds 2
    } else {
        Write-Host -NoNewline "`r[MENUNGGU] HP belum terbaca. Pastikan kabel terhubung & USB Debugging aktif..."
        Start-Sleep -Seconds 2
    }
}
