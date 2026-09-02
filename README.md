# 🁢 Skor Gaple

Aplikasi Flutter **offline** untuk menghitung skor pertandingan gaple (domino) antara 2 tim — tanpa perlu koneksi internet, tanpa backend.

<p align="left">
  <img src="assets/icon/icon.png" width="120" alt="Icon Skor Gaple" />
</p>

## ✨ Fitur

- **Hitung skor otomatis** — cukup input poin masuk tiap giliran, aplikasi yang menjumlahkan.
- **Riwayat poin** — setiap poin yang masuk tersimpan sebagai daftar, bisa **diedit** atau **dihapus** kalau salah input (lengkap dengan tombol urungkan).
- **Aturan menang otomatis** — ronde berakhir saat salah satu tim mencapai 101 poin:
  - Lawan masih ada poin → tim pemenang **+1** skor pertandingan.
  - Lawan masih kosong (0 poin) → tim pemenang langsung **+2** skor pertandingan.
- **Mode gelap & terang** — bisa diganti kapan saja, pilihan tersimpan otomatis.
- **Lanjutkan pertandingan** — progress tersimpan otomatis, jadi kalau aplikasi ditutup bisa dilanjut kapan saja, atau mulai baru dari awal.
- **Halaman Panduan** — penjelasan aturan main langsung di dalam aplikasi.
- **Halaman Apa yang Baru** — rangkuman perubahan/update aplikasi.
- **Terkunci mode portrait** — tampilan tetap konsisten, tidak bisa landscape.
- 100% **offline**, tidak ada iklan, tidak ada backend/server.

## 🎮 Aturan Singkat Gaple

1. Kedua tim saling menambah poin masuk tiap giliran.
2. Ronde berakhir begitu salah satu tim mencapai **101 poin**.
3. Skor pertandingan bertambah:
   - **+1** jika tim yang kalah sempat kemasukan poin.
   - **+2** jika tim yang kalah masih kosong (gaple) saat ronde berakhir.
4. Ronde baru dimulai lagi dari 0, skor pertandingan terus terakumulasi sampai kalian selesai bermain.


## 👤 Dibuat oleh

**Arneva**

---

Kontribusi, saran, dan laporan bug sangat diterima lewat [Issues](../../issues) 🙌
