# MoC03
Repository untuk Tugas mata kuliah Mobile Computing menggunakan Flutter.

# 🎮 Steam Game Explorer - Flutter Navigation & Local Storage

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)

Sebuah aplikasi *browser* game Steam yang dibangun menggunakan kerangka kerja Flutter. Aplikasi ini berfokus pada penerapan **Routing & Navigation** yang solid, manajemen *stack* memori halaman, serta praktik standar industri dalam penyimpanan data lokal persisten menggunakan **SharedPreferences**.

---

## 📸 Screenshots

| 1️⃣ Steam List Page | 2️⃣ Game Detail Page | 3️⃣ Avatar Detail Page |
| :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/7fd5599a-4a22-438b-acdb-d51202cceb94" width="250" alt="Steam List Page" /> | <img src="https://github.com/user-attachments/assets/9bc4c673-9108-4502-8c65-b3229d119b39" width="250" alt="Game Detail Page" /> | <img src="https://github.com/user-attachments/assets/ead4dfd1-439a-4b8b-8712-069cc698e306" width="250" alt="Avatar Detail Page" /> |
| *List dan Grid View dengan fitur Live Search* | *Halaman detail lengkap game (Developer, Tanggal, dll)* | *Fitur Zoom Gambar + Tombol Skip Navigation* |

*(Screenshots untuk Splash Screen, Onboarding, dan Login akan ditambahkan kemudian)*

---

## ✨ Fitur Utama & Pembaruan (Sesi 12-13)

Aplikasi ini telah diperbarui secara signifikan dari versi dasarnya untuk memenuhi standar industri dan mengakomodasi manajemen sesi pengguna:

1. **Penyimpanan Lokal (SharedPreferences)** 💾
   - Manajemen sesi persisten: Menyimpan status *login* sehingga pengguna tidak perlu *login* berulang kali saat aplikasi ditutup (memori tidak hilang).
   - *Onboarding Flag*: Menyimpan riwayat instalasi untuk memastikan layar perkenalan (*Onboarding*) hanya muncul satu kali saat aplikasi pertama kali dibuka.
   
2. **Onboarding & Splash Screen Interaktif** 🚀
   - *Splash Screen* mulus yang secara otomatis mendeteksi status pengguna (baru vs sudah login).
   - *Onboarding Screen* dinamis yang menggunakan `PageView` interaktif dengan 3 *slide* penjelasan aplikasi, dilengkapi indikator *progress* animasi.

3. **Autentikasi & Validasi Standar Industri** 🔒
   - Desain kolom input *Static Label* modern (UI/UX standar iOS/Web).
   - *Helper text* preventif yang memandu pengguna sebelum melakukan kesalahan.
   - Validasi ketat (*RegExp*) menolak penggunaan spasi dan menegakkan batas karakter minimal untuk Username dan Password.

4. **Arsitektur Kode Bersih (Clean Code)** 🧹
   - **Pemisahan Logika (Separation of Concerns)**: Logika *Shared Preferences* tidak dicampur di UI, melainkan diabstraksi ke dalam satu *class* terpusat (`PreferencesService`).
   - Ekstraksi fungsi validasi ke dalam folder `utils/validators.dart` untuk mencegah *spaghetti code* di layar antarmuka.
   - Integrasi sistem warna global berbasis *Dark Mode* Steam di `app_colors.dart`.
   - Menggunakan rute nama (`Navigator.pushNamed`) untuk memisahkan UI dan mekanisme navigasi.

---

## 🎯 Pencapaian Ketentuan Tugas Navigasi Awal

1. **List Page (Halaman 1):** 
   - ✔️ Menampilkan lebih dari 4 item dinamis menggunakan `ListView.builder` (dan dilengkapi juga dengan `GridView`).
   - ✔️ Tapping bernavigasi menggunakan `Navigator.push()` membawa objek utuh ke Halaman 2.
2. **Detail Page (Halaman 2):** 
   - ✔️ Menerima data dari Halaman 1 melalui *Class Constructor*.
   - ✔️ Tapping gambar memicu navigasi ke Halaman 3 mengirim URL.
3. **Avatar Detail Page (Halaman 3):** 
   - ✔️ Terdapat `InteractiveViewer` untuk *zoom* gambar.
   - ✔️ Tombol memotong jalur (*skip route*) langsung ke Halaman 1 menggunakan `Navigator.popUntil(context, (route) => route.isFirst);`.

---

## 📡 Sumber Data (GitHub Gist API)

Alih-alih menggunakan data *hardcode*, aplikasi ini menerapkan teknik ekstraksi data dinamis dengan memanggil JSON publik dari **GitHub Gist**. Ini membuktikan kemampuan dalam implementasi HTTP Request, JSON Parsing, dan integrasi Model Data Dart.

---

## 🛠️ Cara Instalasi & Menjalankan

1. Pastikan Anda telah menginstal [Flutter SDK](https://docs.flutter.dev/get-started/install) terbaru di perangkat Anda.
2. *Clone* repository ini ke folder lokal Anda:
   ```bash
   git clone https://github.com/username-anda/repo-ini.git
   ```
3. Masuk ke folder *project* dan unduh semua paket dependensi:
   ```bash
   cd moc03_flutter
   flutter pub get
   ```
4. Jalankan aplikasi di emulator atau *device* yang tersambung:
   ```bash
   flutter run
   ```

> **💡 Tips Debugging (Cheat):** Terdapat tombol kuning bergambar "*refresh*" melayang (Floating Action Button) di layar **Home Screen**. Tombol ini berfungsi untuk menghapus seluruh data *SharedPreferences*, sehingga Anda bisa melihat kembali alur perkenalan (Onboarding) dan Login secara utuh layaknya aplikasi yang baru diinstal ulang.

---
*Dikembangkan dengan ❤️ untuk eksplorasi Routing, Navigation, dan Local Storage pada Flutter.*
