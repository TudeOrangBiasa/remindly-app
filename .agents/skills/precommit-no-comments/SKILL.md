---
name: precommit-no-comments
description: Scan staged Dart lines for comments before commit. Trigger pre-commit on lib/ and test/ changes.
---

# Pre-commit No Comments

Baris baru di `lib/` dan `test/` tanpa komentar full-line. Alasan: kode harus jelas sendiri, invarian masuk assert atau nama test.

## Trigger

```bash
git diff --cached --unified=0 -- \
  ':(glob)lib/**/*.dart' ':(glob)test/**/*.dart' |
  grep -E '^\+\s*(//|/\*)'
```

Hit apa pun berarti gagal, termasuk `///`. Header `+++` tak cocok pola, aman.

## Perbaikan

Hapus komentarnya, bukan pola scan-nya:

1. Nama, signature, atau struktur ulang sampai jelas tanpa penjelasan.
2. Invarian yang butuh dinyatakan pindah ke `assert` di model atau ke nama test (`hapus matkul bertugas ditolak dengan jumlah`).
3. Jangan pindah komentar ke file lain atau ubah jadi trailing comment.

## Keluar

- Bersih: satu baris `no-comments ok`.
- Kotor: betulkan, stage ulang, ulangi trigger. Hook `githooks/pre-commit` dan CI menjalankan pola yang sama sebagai pengaman mesin.
