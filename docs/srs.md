# SRS Remindly App v1

Sumber: soal tugas kuliah. Dokumen ini mengunci scope agar 3 kontributor tidak melebar.

## 1 Tujuan

Aplikasi Flutter untuk mencatat tugas kuliah dan batas waktunya. Mahasiswa melihat tugas belum selesai, tugas hampir habis, dan tugas lewat batas.

## 2 Stack dan batasan

1. Flutter dan Dart, jalan di emulator Android atau HP.
2. Minimal 5 halaman, halaman utama memakai NavigationBar atau BottomNavigationBar.
3. Data di sqflite dengan 2 tabel: mata_kuliah (nama, dosen, hari kuliah) dan tugas (mata kuliah, judul, deskripsi, batas waktu, prioritas, status selesai). Tabel tugas mengacu ke mata_kuliah via foreign key.
4. Struktur folder dipisah, minimal models, database, dan pages.
5. Semua form memakai Form dan TextFormField dengan validator.
6. UI memakai Material 3 Expressive via paket komunitas `material_3_expressive` 1.2.x, Flutter `>=3.47.0`, SDK `^3.13.0`. Pin di `.fvmrc`.

## 3 Fitur wajib

### 3.1 Mata Kuliah

1. Tambah, lihat, ubah, hapus mata kuliah.
2. Nama wajib diisi dan tidak boleh sama dengan yang sudah ada.

### 3.2 Tugas

1. Tambah, lihat, ubah, hapus tugas.
2. Saat tambah: pilih mata kuliah, isi judul, pilih batas waktu dengan showDatePicker, pilih prioritas Rendah Sedang Tinggi.
3. Judul wajib diisi. Batas waktu tidak boleh tanggal lewat.
4. Tugas bisa ditandai selesai dengan Checkbox.

### 3.3 Daftar Tugas

1. Urut dari batas waktu paling dekat.
2. Filter: Semua, Belum Selesai, Selesai, Terlambat.
3. H-1 ditandai oranye. Lewat dan belum selesai ditandai merah.

### 3.4 Detail Mata Kuliah

1. Semua tugas dari satu mata kuliah.
2. Hitungan selesai dan belum selesai, contoh 3 dari 5 tugas selesai.

### 3.5 Beranda

1. Jumlah tugas belum selesai.
2. 3 tugas dengan batas waktu paling dekat.
3. Jumlah tugas terlambat.

### 3.6 Aturan hapus dan daftar kosong

1. Sebelum hapus, muncul dialog konfirmasi.
2. Mata kuliah yang masih punya tugas tidak boleh dihapus, tampilkan alasan.
3. Daftar kosong tampilkan pesan jelas, contoh Belum ada tugas. Tekan tombol + untuk menambah.

## 4 Kriteria selesai

1. App jalan tanpa error, `flutter analyze` nol error.
2. Repo ini mengetatkan jadi nol warning juga, format wajib pass.
3. Data tetap ada setelah app ditutup penuh lalu dibuka lagi.
4. Semua fitur wajib bisa didemokan.
5. Setiap anggota bisa menjelaskan kodenya saat presentasi.

## 5 Opsional nilai tambah

1. Pencarian tugas berdasar judul.
2. Notifikasi lokal H-1 via `flutter_local_notifications`.
3. Mode gelap.

## 6 Non scope v1

1. Backend atau sync cloud.
2. Login atau multi user.
3. E2E di CI. E2E stay lokal sesuai `docs/e2e-local.md`.
