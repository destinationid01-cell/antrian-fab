// ============================================================
// KONFIGURASI — ANTRIAN FAB (UIN Raden Mas Said Surakarta)
// ============================================================
// CARA PAKAI:
// 1. MODE DEMO (bawaan): biarkan SUPABASE_URL dan SUPABASE_ANON_KEY
//    kosong. Data hanya tersimpan di perangkat ini (localStorage).
// 2. MODE BERSAMA: buat proyek di https://supabase.com, jalankan
//    supabase.sql di SQL Editor, lalu isi dua kolom di bawah ini.
//    JANGAN isi kunci service_role di sini — hanya anon key (publik).
// ============================================================
window.ANTRIAN_CONFIG = {
  // --- Supabase (kosong = Mode Demo) ---
  SUPABASE_URL: "https://qmogxgcphmexcvmt.supabase.co",
  SUPABASE_ANON_KEY: "sb_publishable_EbV2RE97w7_EI5KoO46Jkw_fV3wpZGn",

  // --- Login admin (HALAMAN ADMIN) ---
  // Default: admin / admin123
  // ⚠️ WAJIB DIGANTI sebelum dipakai ramai-ramai. Lihat README.md.
  // Catatan: pengecekan login ini dilakukan di browser (client-side).
  // Sistem sederhana ini BUKAN untuk data sensitif. Untuk keamanan
  // serius, gunakan Supabase Auth + Row Level Security.
  ADMIN_USERNAME: "admin",
  ADMIN_PASSWORD: "admin123",

  // --- Pengaturan awal pelayanan ---
  START_TIME: "08:00", // Jam Mulai Pelayanan (format HH:MM, WIB)
  DEFAULT_MINUTES: 10, // Menit Default per Orang

  // --- Daftar prodi (dropdown form) ---
  PRODI: [
    "Bahasa dan Sastra Arab",
    "Sastra Inggris",
    "Sejarah Peradaban Islam",
    "Ilmu Perpustakaan dan Informasi Islam"
  ]
};
