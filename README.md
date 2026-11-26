![Remindly](assets/images/remindly_logo_horizontal.svg)

# Remindly

Aplikasi Flutter untuk mencatat mata kuliah, tugas kuliah, dan batas waktunya secara lokal di perangkat Android menggunakan `sqflite`. Mahasiswa dapat memantau tugas yang belum selesai, tugas dengan batas waktu H-1, dan tugas yang sudah terlambat tanpa backend atau koneksi internet.

Status pengembangan saat ini berada pada tahap pengerjaan fitur secara vertikal setelah fondasi proyek (`REM-01`) dan verifikasi tanggal (`REM-08`) selesai. Rincian tiket dan urutan pengerjaan tersedia di [docs/peta-jalan.md](docs/peta-jalan.md).

## Fitur utama

1. **Beranda.** Menampilkan jumlah tugas yang belum selesai, 3 tugas dengan batas waktu terdekat, dan jumlah tugas yang terlambat.
2. **Mata kuliah.** Mendukung tambah, lihat, ubah, dan hapus mata kuliah dengan atribut nama, dosen, dan hari kuliah. Nama mata kuliah bersifat unik, dan penghapusan ditolak dengan pesan alasan jika masih ada tugas yang mengacu ke mata kuliah tersebut.
3. **Tugas dan daftar tugas.** Mendukung tambah, lihat, ubah, dan hapus tugas dengan pilihan mata kuliah, judul wajib isi, batas waktu melalui `showDatePicker` (tidak boleh tanggal lewat), prioritas (`Rendah`, `Sedang`, `Tinggi`), dan checkbox status selesai. Daftar tugas diurutkan dari batas waktu terdekat, memiliki 4 mode filter (`Semua`, `Belum Selesai`, `Selesai`, `Terlambat`), serta menandai batas waktu H-1 dengan warna oranye dan tugas terlambat dengan warna merah.
4. **Detail mata kuliah.** Menampilkan seluruh tugas pada satu mata kuliah beserta ringkasan progres, misalnya `3 dari 5 tugas selesai`.

## Teknologi dan struktur proyek

Aplikasi ini memakai Flutter `3.47.0` (dikunci di [.fvmrc](.fvmrc)) dan Dart SDK `^3.13.0` dengan dependensi utama dari [pubspec.yaml](pubspec.yaml): `sqflite` untuk basis data lokal, `material_3_expressive` untuk komponen antarmuka, `intl` untuk pemformatan tanggal, serta `very_good_analysis` dan `glados` untuk analisis statis dan property test.

Struktur direktori utama proyek ini terbagi sebagai berikut.

1. `lib/models/`: model data `MataKuliah` dan `Tugas`.
2. `lib/database/`: konfigurasi dan akses `sqflite` (`app_database.dart`).
3. `lib/pages/`: 5 halaman aplikasi (beranda, daftar mata kuliah, detail mata kuliah, daftar tugas, dan form tugas).
4. `lib/widgets/`: komponen UI bersama seperti `StatusBadge` dan `EmptyState`.
5. `lib/theme/`: token desain, tema aplikasi, dan branding.
6. `test/contract/`: pengujian kontrak dan property test tanggal.
7. `maestro/flows/`: skenario E2E Maestro yang dijalankan secara lokal.
8. `docs/`: dokumen spesifikasi, kontrak, peta jalan, dan panduan verifikasi.

## Mulai cepat (setup lokal)

Pastikan prasyarat berikut tersedia di sistem operasi Anda: Flutter `3.47.0` melalui FVM, Android SDK beserta emulator atau perangkat fisik, Java 17+, dan Maestro CLI jika ingin menjalankan pengujian E2E.

1. Aktifkan versi Flutter proyek dan samakan `PATH` ke biner FVM:
   ```bash
   fvm use 3.47.0
   export PATH="$HOME/fvm/versions/3.47.0/bin:$PATH"
   ```
2. Pasang dependensi dan jalankan pemeriksaan awal:
   ```bash
   flutter pub get
   dart format --set-exit-if-changed .
   flutter analyze --fatal-infos --fatal-warnings
   flutter test
   ```
3. Jalankan emulator atau sambungkan perangkat Android, lalu jalankan aplikasi:
   ```bash
   flutter run
   ```

## Pengujian dan verifikasi

Proyek ini membagi verifikasi menjadi 3 lapisan agar kualitas kode tetap terjaga sebelum pull request digabung.

1. **Analisis statis dan format kode.** Jalankan `dart format --set-exit-if-changed .` dan `flutter analyze --fatal-infos --fatal-warnings`. Target repo adalah nol error dan nol warning.
2. **Contract test dan property test.** Jalankan `flutter test` untuk memverifikasi kontrak data dan properti tanggal di `test/contract/`. Detail properti yang dijaga tercatat di [docs/verification.md](docs/verification.md).
3. **E2E lokal dengan Maestro.** Pengujian antarmuka tidak dijalankan di CI karena CI tidak menyalakan emulator. Jalankan flow Maestro secara lokal pada emulator atau perangkat dengan perintah `maestro test maestro/flows/smoke.yaml`. Panduan lengkap dan daftar jebakan Maestro tersedia di [docs/e2e-local.md](docs/e2e-local.md).

## Alur kontribusi dan aturan merge

Branch `main` dikunci dan seluruh perubahan wajib masuk melalui pull request. Satu pull request hanya mengerjakan satu tiket (`REM-xx`) dengan nama branch berpola `rem-02a-deskripsi-singkat` untuk slice, `chore/deskripsi` atau `docs/deskripsi` untuk non-slice.

1. **Tiga gerbang CI wajib hijau.** Pull request diperiksa oleh workflow `Static Analysis` (kelengkapan berkas, format, `flutter analyze`, `flutter test`, dan larangan komentar baru di `lib/` dan `test/`), `Security` (pemindaian rahasia dan larangan commit biner seperti `.apk` atau `.log`), serta `PR Format` (format judul PR, bagian Checklist, dan kewajiban screenshot untuk perubahan UI).
2. **Aturan PR UI.** Pull request yang menyentuh UI atau memakai label UI wajib menyertakan gambar screenshot pada deskripsi PR sesuai [.github/pull_request_template.md](.github/pull_request_template.md).
3. **Panduan kontributor.** Aturan lengkap mengenai penamaan judul PR, pembagian tugas, dan pemeriksaan lokal sebelum push dijelaskan di [CONTRIBUTING.md](CONTRIBUTING.md).

## Peta dokumentasi

1. [docs/srs.md](docs/srs.md): batasan ruang lingkup aplikasi v1, fitur wajib, dan non-scope.
2. [docs/peta-jalan.md](docs/peta-jalan.md): status tiket `REM-01` sampai `REM-09` dan urutan bundel pengerjaan.
3. [docs/kontrak.md](docs/kontrak.md): daftar skenario wajib E2E dari fitur hingga persistensi data.
4. `docs/specs/`: kontrak teknis per modul (`01-database.md`, `02-navigation.md`, `03-design-system.md`, `04-matkul.md`, `05-tugas.md`, `06-beranda-detail.md`).
5. [docs/e2e-local.md](docs/e2e-local.md): panduan instalasi Maestro dan alur pengujian E2E lokal per slice.
6. [docs/verification.md](docs/verification.md): daftar properti yang dijaga dan perintah verifikasi ringan lokal.
