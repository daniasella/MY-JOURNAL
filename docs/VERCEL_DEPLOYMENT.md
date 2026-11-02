# Panduan Deploy Backend My Journal ke Vercel

Backend My Journal dibuat menggunakan **Hono** (Node.js) dan terhubung ke **PostgreSQL Neon Database**. Struktur backend sudah siap dideploy ke Vercel Serverless Functions.

---

## Langkah 1: Push Kode Terbaru ke GitHub
Semua konfigurasi Vercel (`api/index.ts`, `vercel.json`, dan penyesuaian SSL Neon) sudah disiapkan dan di-push ke repositori:
👉 [https://github.com/daniasella/MY-JOURNAL](https://github.com/daniasella/MY-JOURNAL)

---

## Langkah 2: Buat Project di Vercel

1. Buka [https://vercel.com](https://vercel.com) dan login (gunakan akun GitHub Anda).
2. Di dashboard Vercel, klik tombol **"Add New..."** lalu pilih **"Project"**.
3. Cari repositori **`daniasella/MY-JOURNAL`** lalu klik **"Import"**.

---

## Langkah 3: Konfigurasi Project Settings (PENTING)

Pada halaman **Configure Project**:

1. **Framework Preset**: Biarkan **Other** (atau kosong).
2. **Root Directory**:
   - Klik tombol **Edit** di samping Root Directory.
   - Pilih folder **`backend`** lalu klik **Continue**.
3. **Environment Variables**:
   Buka accordion **Environment Variables** dan tambahkan variabel berikut:

   | KEY | VALUE | KETERANGAN |
   |---|---|---|
   | `DATABASE_URL` | `postgresql://...` | Connection string dari Neon Console |
   | `NODE_ENV` | `production` | Mode produksi |
   | `SESSION_TTL_DAYS` | `30` | Masa berlaku login user (hari) |
   | `CORS_ORIGINS` | `*` | Mengizinkan koneksi dari aplikasi Flutter |

   > **Catatan DATABASE_URL**: Gunakan connection string Neon Anda (contoh dari `backend/.env.example` atau Neon Console > Dashboard > Connection Details). Pastikan sudah menyertakan `sslmode=require`.

4. Klik tombol **Deploy**.

---

## Langkah 4: Uji Coba Endpoint Setelah Selesai

Setelah deploy selesai (biasanya hanya 1 menit), Vercel akan memberikan domain, misalnya:
`https://my-journal-api.vercel.app`

Anda dapat menguji di browser:
- `https://my-journal-api.vercel.app/` -> Mengembalikan `{ "status": "online", ... }`
- `https://my-journal-api.vercel.app/api/health` -> Mengembalikan `{ "status": "ok", "database": "connected" }`

---

## Langkah 5: Hubungkan ke Aplikasi Flutter

Setelah URL Vercel aktif, jalankan aplikasi Flutter Anda menggunakan URL Vercel tersebut:

### Di Web / Desktop / Emulator:
```powershell
flutter run -d chrome --dart-define=API_BASE_URL=https://<domain-kamu>.vercel.app
```

### Atau Build APK Android dengan URL Vercel:
```powershell
flutter build apk --dart-define=API_BASE_URL=https://<domain-kamu>.vercel.app
```
