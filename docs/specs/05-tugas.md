# Spec 05 Tugas CRUD plus Daftar

Acuan SRS 3.2 dan 3.3. Pemilik: `lib/pages/task_list_page.dart`,
`lib/pages/task_form_page.dart`, `lib/models/tugas.dart`,
flow `maestro/flows/tasks.yaml`.

## Form tambah dan ubah

1. `Form` plus `TextFormField` validator untuk judul. Judul trim non kosong.
2. Pilih mata kuliah dari dropdown. Pilih deadline via `showDatePicker`.
   Deadline hari lewat ditolak, hari ini boleh.
3. Prioritas pilihan Rendah, Sedang, Tinggi. Default Sedang.
4. Selesai via Checkbox di daftar, bukan di form.

## Daftar

1. Urut deadline menaik. Seri deadline urut id menaik.
2. Filter 4 mode: Semua, Belum Selesai, Selesai, Terlambat. Terlambat
   berarti deadline lewat dan belum selesai, ikut `isTerlambat`.
3. H-1 belum selesai pakai `StatusBadge.hampir` oranye. Lewat belum
   selesai pakai `StatusBadge.terlambat` merah. Selalu ada label teks.
4. Hapus selalu dialog konfirmasi.

## Bukti selesai

1. `flutter analyze` nol issue, `flutter test` hijau termasuk property test.
2. Flow Maestro tambah valid, tolak judul kosong, tolak deadline lewat,
   filter 4 mode, badge oranye dan merah tampil.
