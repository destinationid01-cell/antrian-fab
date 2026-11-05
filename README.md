# Antrian Layanan — Fakultas Adab dan Bahasa
## UIN Raden Mas Said Surakarta

Sistem antrian web sederhana: mahasiswa daftar dari HP, halaman utama menampilkan nomor antrian + estimasi jam pelayanan, admin memantau dan mengatur dari halaman login.

**Repo GitHub:** `destinationid01-cell` (nama repo bebas, misal `antrian-fab`)
**Tampilan:** mirip aplikasi Pusaka v3 Kemenag (topbar pill, hero banner besar, kartu putih rounded), warna utama **orange** (`#EA580C` / `#F97316`), font Poppins.
**Logo:** logo FAB kiriman user di `assets/logo-fab.png` (508×520 PNG transparan, tulisan FAB orange + UIN RADEN MAS SAID SURAKARTA) — dipakai di topbar dan hero. Logo UIN tetap ada di `assets/logo-uin.png` sebagai cadangan.

---

## Fitur

### Halaman utama (publik) — buka `#/` atau halaman awal
- Kartu **Sedang Dilayani** (nomor + nama) dan **Berikutnya** di bagian atas.
- Daftar antrian hari ini: Nomor Antrian, Nama, Prodi, Estimasi Pelayanan (jam), Durasi, Status.
- Form **Ikut Antrian**: Nama, NIM, Prodi (dropdown 4 prodi FAB), Nomor WA, Keterangan. Setelah berhasil muncul nomor antrian + estimasi, plus tulisan *"Silakan pantau estimasi waktu Anda di halaman depan."*
- Nomor antrian format `A-001, A-002, ...`, **reset tiap hari**.
- Responsif untuk HP.

### Halaman admin — buka `#/admin`
- Login dulu. Default: username `admin`, password `admin123`.
  > ⚠️ **WAJIB DIGANTI** sebelum dipakai ramai-ramai. Caranya di bawah.
- Lihat semua data: nama, NIM, prodi, WA, keterangan, status, durasi.
- Nomor WA bisa diklik → membuka `https://wa.me/62xxx` (nomor `08xx` otomatis diubah jadi `62xx`, spasi/dash dihapus).
- Aksi per baris: **Panggil** (jadi Sedang Dilayani), **Selesai**, **Lewat**, **Hapus**.
- Ubah **durasi estimasi per orang** (menit) langsung di tabel.
- Ubah pengaturan: **Jam Mulai Pelayanan** (default `08:00` WIB) dan **Menit Default per Orang** (default `10`).

### Logika estimasi
Estimasi tiap orang = **Jam Mulai + jumlah kumulatif durasi orang-orang di depannya** (yang statusnya Menunggu / Dilayani, urut nomor antrian).

Contoh: mulai 08:00, A-001 durasi 10 menit → A-002 estimasi 08:10. Kalau admin mengubah durasi A-001 jadi 13 menit, estimasi A-002 otomatis bergeser jadi **08:13**, dan semua orang di bawahnya ikut bergeser. Yang sudah Selesai / Lewat tidak dihitung lagi.

---

## Dua mode

| | Mode Demo (bawaan) | Mode Bersama (Supabase) |
|---|---|---|
| Data tersimpan di | `localStorage` perangkat yang membuka (key `antrian_fab_v1`) | Database Supabase (Postgres) |
| Bisa dilihat bersama? | ❌ Tiap perangkat datanya sendiri-sendiri | ✅ Semua perangkat lihat data yang sama, realtime |
| Perlu setup? | Tidak, langsung jalan | Perlu buat proyek Supabase (gratis) |

Kalau `config.js` masih kosong, aplikasi jalan dalam Mode Demo dan menampilkan banner kuning di atas: *"Mode Demo — data hanya di perangkat ini..."*. Di Mode Demo ada tombol **"Isi 3 contoh"** untuk mencoba tampilan, dan di admin ada **"Hapus semua (demo)"**.

Untuk 100 orang/hari, paket gratis Supabase (500 MB database, 200 koneksi realtime bersamaan) dan Vercel (100 GB transfer/bulan) masih sangat cukup.

---

## Cara coba lokal

```bash
cd antrian-fab
python3 -m http.server 8000
# buka http://localhost:8000
```

Atau cukup buka file `index.html` langsung di browser (Mode Demo tetap jalan; Supabase juga jalan dari `file://` selama CDN bisa diakses, tapi `http.server` lebih aman).

---

## Cara isi Supabase (Mode Bersama)

1. Buat akun + proyek baru di https://supabase.com (paket Free).
2. Di dashboard Supabase → **SQL Editor** → **New query** → tempel seluruh isi `supabase.sql` → **Run**. File ini membuat:
   - tabel `queue` (id, queue_number, name, nim, prodi, phone, keterangan, status, duration_minutes, created_at),
   - tabel `settings` (jam mulai + menit default bersama),
   - policy RLS yang mengizinkan akses publik (anon), dan
   - realtime untuk kedua tabel.
3. Di dashboard Supabase → **Project Settings → API**, salin **Project URL** dan **anon public key**.
4. Isi di `config.js`:
   ```js
   SUPABASE_URL: "https://xxxx.supabase.co",
   SUPABASE_ANON_KEY: "eyJhbGciOi...",
   ```
   Jangan isi `service_role key` di sini — itu kunci rahasia, jangan pernah ditaruh di kode web.
5. Commit + push ke GitHub, Vercel akan deploy ulang otomatis. Pastikan di Supabase → **Database → Replication**, tabel `queue` dan `settings` aktif supaya perubahan admin langsung muncul di halaman utama tanpa refresh.

---

## Cara deploy Vercel dari GitHub

1. Buat repo baru di GitHub (misal `antrian-fab`), push semua file ini.
2. Buka https://vercel.com → **Add New → Project** → **Import** repo tersebut.
3. Framework Preset: **Other**. Build Command: *(kosongkan)*. Output Directory: *(kosongkan / `.`)*. Ini situs statis tanpa build step, jadi Vercel langsung menyajikan `index.html`.
4. **Deploy**. Dapat link `https://antrian-fab.vercel.app` — bagikan link itu ke mahasiswa.
5. Setiap push baru ke GitHub, Vercel deploy ulang otomatis.

---

## Cara ganti password admin

Buka `config.js`, ubah dua baris ini, lalu push ulang:

```js
ADMIN_USERNAME: "admin",
ADMIN_PASSWORD: "ganti-dengan-password-baru",
```

> ⚠️ **Batasan keamanan — penting dibaca:** login admin di sistem sederhana ini dicek di browser (client-side). Siapa pun yang bisa membaca `config.js` bisa melihat passwordnya. Jadi ini cukup untuk pemakaian internal / uji coba, **bukan** untuk data sensitif. Jangan simpan data rahasia di antrian ini. Untuk keamanan serius, langkah berikutnya adalah memakai Supabase Auth + Row Level Security (hanya admin yang bisa ubah/hapus).

---

## Struktur file

```
antrian-fab/
├── index.html          # Satu halaman utama (SPA: #/ publik, #/admin admin)
├── config.js           # Supabase URL/key, login admin, jam mulai, menit default, daftar prodi
├── supabase.sql        # Skema database + RLS + realtime
├── vercel.json         # Konfigurasi statis Vercel
├── assets/
│   └── logo-uin.png    # Logo resmi UIN Raden Mas Said Surakarta
└── README.md           # File ini
```

## Yang belum diuji

- **Mode Bersama (Supabase) belum diuji live** — belum ada proyek Supabase, jadi sinkronisasi realtime antar-perangkat belum terbukti di lapangan. Mode Demo sudah diuji lokal.
- Login admin default `admin / admin123` **belum diganti** — ganti dulu sebelum dipakai ramai-ramai.
- Belum diuji di HP fisik user, baru diuji lewat server lokal + render desktop.
