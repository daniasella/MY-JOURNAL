# Panduan Deploy Flutter My Journal ke Web

Aplikasi Flutter **My Journal** dapat dideploy sebagai web app agar bisa diakses oleh siapa saja melalui browser (di laptop maupun smartphone).

---

## Opsi 1: Deploy ke Vercel (Rekomendasi Terbaik)

Karena backend Anda sudah di Vercel, mendeploy frontend ke Vercel juga akan memberikan URL yang bersih dan cepat (misal: `my-journal-app.vercel.app`).

### Langkah 1: Build Web di Komputer Anda
1. Jalankan script pembantu:
   **Klik dua kali file `build_web.bat`**
   *(Atau jalankan perintah berikut di PowerShell):*
   ```powershell
   flutter build web --release --dart-define=API_BASE_URL=https://<domain-backend-kamu>.vercel.app
   ```
2. Tunggu proses compile selesai (~1-2 menit). File hasil build akan berada di folder:
   `D:\MY JOURNAL TERBARU\MY-JOURNAL-main\build\web`

### Langkah 2: Deploy Folder `build\web` ke Vercel

Ada dua cara mudah untuk mengunggah `build\web` ke Vercel:

#### Cara A (Lewat Vercel CLI — Paling Cepat):
1. Buka PowerShell dan arahkan ke folder hasil build:
   ```powershell
   cd "D:\MY JOURNAL TERBARU\MY-JOURNAL-main\build\web"
   ```
2. Jalankan:
   ```powershell
   npx vercel --prod
   ```
3. Ikuti instruksi di layar (login, pilih nama project, tekan Enter). Web Anda langsung aktif dalam 10 detik!

#### Cara B (Lewat Drag & Drop di Vercel Dashboard):
1. Buka [https://vercel.com/new](https://vercel.com/new).
2. Jika ada opsi upload / deploy manual, atau instal Vercel Desktop / Vercel CLI untuk deploy folder `build/web`.

---

## Opsi 2: Deploy Gratis ke GitHub Pages (Otomatis)

Jika Anda ingin website terdeploy otomatis setiap kali push kode baru ke GitHub:

1. Di repository GitHub Anda: **Settings** > **Pages**.
2. Pada bagian **Build and deployment** > **Source**, pilih **Deploy from a branch**.
3. Pilih branch `gh-pages` (folder `/root`).
4. Website Anda akan otomatis aktif di:
   `https://daniasella.github.io/MY-JOURNAL/`

---

## Catatan Penting
File [web/vercel.json](file:///d:/MY%20JOURNAL%20TERBARU/MY-JOURNAL-main/web/vercel.json) sudah disiapkan agar semua rute GoRouter Flutter (seperti `/planner`, `/journal`, `/tracker`, `/insight`) tidak menghasilkan halaman 404 saat pengguna me-refresh browser.
