# MoC03
Repository untuk Tugas mata kuliah Mobile Computing menggunakan flutter.

# 🎮 Steam Game Explorer - Flutter Navigation App

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)

Sebuah aplikasi *browser* game Steam yang dibangun menggunakan kerangka kerja Flutter. Aplikasi ini berfokus pada demonstrasi **Routing & Navigation** yang solid, manajemen *stack* memori halaman, serta praktik terbaik dalam melempar (*passing*) objek data di antara halaman.

---

## 📸 Screenshots

> **PENTING:** Ganti `URL_..._DI_SINI` dengan link asli atau letak path gambar *screenshot* Anda (misal: `assets/screenshots/page1.png`).

| 1️⃣ Steam List Page | 2️⃣ Game Detail Page | 3️⃣ Avatar Detail Page |
| :---: | :---: | :---: |
| <img src="<img width="720" height="1600" alt="image" src="https://github.com/user-attachments/assets/7fd5599a-4a22-438b-acdb-d51202cceb94" />
" width="250"> | <img src="<img width="720" height="1600" alt="image" src="https://github.com/user-attachments/assets/9bc4c673-9108-4502-8c65-b3229d119b39" />
" width="250"> | <img src="<img width="720" height="1600" alt="image" src="https://github.com/user-attachments/assets/ead4dfd1-439a-4b8b-8712-069cc698e306" />
" width="250"> |
| *List dan Grid View dengan fitur Live Search* | *Halaman detail lengkap game (Developer, Tanggal, dll)* | *Fitur Zoom Gambar + Tombol Skip Navigation* |

---

## 🎯 Pencapaian Ketentuan Tugas

Aplikasi ini dikembangkan dan dirancang khusus untuk memenuhi-dan melampaui-semua persyaratan tugas navigasi yang diinstruksikan oleh dosen:

1. **List Page (Halaman 1):** 
   - ✔️ Menampilkan lebih dari 4 item dinamis menggunakan `ListView.builder` (dan dilengkapi juga dengan `GridView`).
   - ✔️ Menampilkan kombinasi avatar gambar dan judul/nama di setiap *card*.
   - ✔️ Tapping bernavigasi menggunakan `Navigator.push()` sekaligus membawa data objek pilihan ke Halaman 2.

2. **Detail Page (Halaman 2):** 
   - ✔️ Menerima data utuh dari Halaman 1 melalui *Class Constructor*.
   - ✔️ Menampilkan gambar, nama, dan deskripsi (dengan UI ala Steam).
   - ✔️ Tapping pada area gambar akan melakukan `Navigator.push()` dan mengirimkan link/data gambar tersebut ke Halaman 3.

3. **Avatar Detail Page (Halaman 3):** 
   - ✔️ Menampilkan versi besar dari gambar (menggunakan `InteractiveViewer` agar bisa di-*zoom/pan* secara interaktif).
   - ✔️ Dilengkapi tombol **"Kembali ke Daftar"**.
   - ✔️ Tombol ini memotong jalur (*skip*) Halaman 2 sepenuhnya, langsung menuju Halaman 1 (List Page) menggunakan eksekusi: 
     `Navigator.popUntil(context, (route) => route.isFirst);`

---

## 📡 Sumber Data (GitHub Gist API)

Alih-alih menggunakan data *hardcode* (*dummy list* lokal) atau *Steam Web API* resmi yang terlalu kompleks, aplikasi ini menerapkan teknik ekstraksi data dengan memanggil **GitHub Gist JSON**.

**Alasan Menggunakan Gist:**
- **Fleksibel:** Pengubahan struktur data semudah mengedit file teks biasa di browser.
- **Lightweight:** Sangat cepat untuk dieksekusi HTTP Request-nya tanpa *overhead* server.
- **Implementasi Nyata:** Mengasah pemahaman integrasi `http`, JSON Parsing, dan arsitektur Model Data di Dart.

---

## 🛠️ Cara Instalasi & Menjalankan

1. Pastikan Anda telah menginstal [Flutter SDK](https://docs.flutter.dev/get-started/install) terbaru di perangkat Anda.
2. *Clone* repository ini ke folder lokal Anda:
   ```bash
   git clone https://github.com/username-anda/repo-ini.git
   ```
3. Masuk ke folder *project* dan unduh semua paket *dependencies*:
   ```bash
   cd nama_folder
   flutter pub get
   ```
4. Jalankan aplikasi (pastikan terdapat emulator berjalan atau *device* yang tersambung):
   ```bash
   flutter run
   ```

---
*Dibuat untuk menyelesaikan tugas pembelajaran dasar-dasar navigasi Flutter.*
