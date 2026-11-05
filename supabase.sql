-- ============================================================
-- ANTRIAN FAB — Skema Supabase (Postgres)
-- Cara pakai: Supabase Dashboard → SQL Editor → New query →
-- tempel seluruh file ini → Run.
-- ============================================================

-- Tabel utama antrian
create table if not exists public.queue (
  id uuid primary key default gen_random_uuid(),
  queue_number text not null,
  name text not null,
  nim text not null,
  prodi text not null,
  phone text not null,
  keterangan text default '',
  status text not null default 'Menunggu'
    check (status in ('Menunggu', 'Dilayani', 'Selesai', 'Lewat')),
  duration_minutes int not null default 10,
  created_at timestamptz not null default now()
);

create index if not exists queue_created_at_idx on public.queue (created_at desc);
create index if not exists queue_status_idx on public.queue (status);

-- Tabel pengaturan (satu baris, id = 'main')
-- Menyimpan Jam Mulai Pelayanan & Menit Default per Orang
-- agar berubah di semua perangkat saat admin mengubahnya.
create table if not exists public.settings (
  id text primary key,
  start_time text not null default '08:00',
  default_minutes int not null default 10,
  updated_at timestamptz not null default now()
);

insert into public.settings (id, start_time, default_minutes)
values ('main', '08:00', 10)
on conflict (id) do nothing;

-- ============================================================
-- Row Level Security (RLS)
-- Sistem ini sederhana: halaman publik perlu baca/tulis antrian
-- tanpa login. Karena itu policy di bawah mengizinkan anon.
-- ⚠️ Ini BUKAN untuk data sensitif. Jangan simpan data rahasia
-- di tabel ini. Untuk keamanan serius, ganti policy ini dengan
-- Supabase Auth (hanya admin yang bisa ubah/hapus).
-- ============================================================
alter table public.queue enable row level security;
alter table public.settings enable row level security;

drop policy if exists "queue_public_all" on public.queue;
create policy "queue_public_all" on public.queue
  for all using (true) with check (true);

drop policy if exists "settings_public_all" on public.settings;
create policy "settings_public_all" on public.settings
  for all using (true) with check (true);

-- ============================================================
-- Realtime: supaya halaman utama langsung berubah saat admin
-- mengubah durasi / memanggil antrian, tanpa perlu refresh.
-- Supabase Dashboard → Database → Replication: pastikan tabel
-- public.queue dan public.settings tercantum, ATAU jalankan:
-- ============================================================
alter publication supabase_realtime add table public.queue;
alter publication supabase_realtime add table public.settings;
