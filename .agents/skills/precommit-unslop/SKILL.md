---
name: precommit-unslop
description: Review staged diff for slop before commit. Trigger pre-commit on lib/ and test/ changes.
---

# Pre-commit Unslop

Gate penilaian sebelum commit. Mesin tak bisa menilai, agen yang jalan.

## Trigger

Setiap commit yang menyentuh `lib/` atau `test/`. Baca staged diff utuh:

```bash
git diff --cached --stat
git diff --cached -- lib/ test/
```

## Daftar periksa, tolak jika kena satu

1. Kode mati: fungsi, import, parameter, test helper tak terpakai.
2. Duplikasi pola yang sudah ada di repo (query builder, validasi trim, fromMap).
3. Abstraksi sekali pakai: class/helper yang cuma dipanggil satu tempat tanpa alasan perluasan tiket.
4. Campur bahasa di satu file tanpa ikut konvensi file itu.
5. Generalitas spekulatif: opsi, flag, parameter di luar scope tiket.
6. Komentar yang menjelaskan ulang kode (lempar ke skill precommit-no-comments).
7. Test lemah: tautologi, echo source, `expect` tanpa klaim perilaku konsumen.

## Keluar

- Bersih: satu baris `unslop ok: <N> file, <M> baris staged`.
- Kotor: betulkan langsung di working tree, stage ulang, ulangi trigger. Jika betulan menyentuh kode, tutup dengan format + analyze + test hijau.
