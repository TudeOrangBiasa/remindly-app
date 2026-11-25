# Verifikasi Ringan Remindly

Keputusan: pakai rekomendasi ringan. Proof penuh tidak dipakai untuk skala tugas kuliah. Acuan skill lokal: `create-formal-verification` untuk target baru, `maintain-formal-verification` setelah merge yang menyentuh kode terverifikasi.

## Properti yang dijaga

1. Judul tugas non-kosong setelah trim.
2. Deadline tidak boleh tanggal lewat saat create dan update.
3. Delete mata kuliah diblokir jika masih ada tugas yang mengacu (foreign key guard) dengan pesan alasan.
4. List tugas selalu urut deadline menaik.
5. Filter 4 mode benar: Semua, Belum Selesai, Selesai, Terlambat (terlambat berarti deadline lewat dan status belum selesai).
6. Hitungan detail matkul konsisten contoh 3 dari 5 selesai.

## Perintah lokal (setelah ada kode)

1. `very_good_analysis` sebagai base lint, lalu `dart analyze --fatal-infos --fatal-warnings`.
2. `dart format --set-exit-if-changed .` wajib pass.
3. `flutter test` untuk 4 contract tests: sorting deadline, filter 4 mode, guard hapus matkul, validasi form judul dan deadline.
4. Opsional: satu file property test `glados` untuk fungsi murni (tambah lalu hapus sama dengan awal, toggle 2x identitas, serialisasi round-trip).

## Playbooks

Cek folder skill verifikasi lokal sebagai playbook: `create-formal-verification` untuk membuat verify skill per area rawan (race, retry, state machine tugas), `maintain-formal-verification` untuk sinkron ulang setelah refactor. Verify skill project-local ditaruh di `docs/verify-*` atau `.agents/skills/` repo ini setelah kode pertama ada, lengkap dengan coverage, bounds, sync commit, dan cara rerun satu perintah.
