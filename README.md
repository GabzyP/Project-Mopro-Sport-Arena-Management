# 🏟️ Sport Arena Management - Kelompok 6

**Proyek Pemrograman Mobile (Kom A 24)**
Aplikasi *mobile* berbasis Flutter untuk mempermudah proses reservasi dan manajemen lapangan olahraga secara digital.

---

## 👥 Anggota Kelompok

| No | Nama Mahasiswa | NIM |
| :--- | :--- | :--- |
| 1. | [Gabriel Glenn Peter Pardede] | [241712041] |
| 2. | [Melati Simanungkalit] | [241712008] |
| 3. | [Ferlita Kristiani Hulu] | [241712025] |
| 4. | [Aditya Fahreza] | [241712013] |
| 5. | [Habil Rizky Tazir] | [241712030] |

---

## 📱 Deskripsi Aplikasi

**Sport Arena Management** adalah aplikasi yang menghubungkan penyedia lapangan olahraga (Admin) dengan pengguna (Customer). Aplikasi ini mengatasi masalah booking manual dengan menyediakan sistem reservasi *real-time*, pengecekan jadwal, dan manajemen pembayaran yang terintegrasi.

Aplikasi ini memiliki dua *role* pengguna:
1.  **Customer:** Mencari venue, melihat jadwal, booking lapangan, dan melihat riwayat transaksi.
2.  **Admin:** Mengelola data venue, memantau statistik pendapatan, dan mengubah status pesanan.

---

## ✨ Daftar Fitur Utama

### 👤 Customer (Pengguna)
* **Autentikasi:** Login & Register (Email/Phone).
* **Pencarian Venue:** Filter berdasarkan lokasi dan jenis olahraga (Futsal, Badminton, Basket, dll).
* **Booking System:** Cek ketersediaan lapangan (jam & tanggal) secara *real-time*.
* **Location Picker:** Memilih lokasi venue menggunakan Peta (`flutter_map`).
* **Riwayat Booking:** Melihat status pesanan (Menunggu, Lunas, Selesai, Batal).
* **Profile Management:** Update foto profil dan data diri.

### 🛡️ Admin (Pengelola)
* **Dashboard Statistik:** Grafik pendapatan dan total booking (`fl_chart`).
* **Manajemen Venue & Lapangan:** Tambah/Edit/Hapus data lapangan.
* **Manajemen Pesanan:** Konfirmasi pembayaran user.

---

## 🛠️ Technical Stack Application

Aplikasi ini dibangun menggunakan teknologi berikut:

### **Frontend (Mobile)**
* **Framework:** Flutter
* **Language:** Dart (SDK ^3.9.2)
* **Architecture:** MVC (Model-View-Controller) Pattern

### **Key Dependencies (Packages)**
* `http`: ^1.2.0 (Koneksi ke REST API)
* `shared_preferences`: ^2.2.2 (Penyimpanan sesi login lokal)
* `flutter_map` & `latlong2`: (Fitur Peta OpenStreetMap)
* `geolocator`: (Deteksi lokasi pengguna)
* `image_picker`: (Upload foto profil/bukti bayar)
* `fl_chart`: (Visualisasi grafik statistik admin)
* `intl`: (Format tanggal dan mata uang Rupiah)
* `qr_flutter`: (Generate QR Code booking)

### **Backend (API & Database)**
* **Language:** PHP Native
* **Database:** MySQL (MariaDB)
* **Server:** Apache (XAMPP/Localhost)

---

## 🚀 How to Run (Cara Menjalankan)

Ikuti langkah-langkah berikut untuk menjalankan proyek ini di komputer Anda:

### 1. Persiapan Backend
1.  Pastikan **XAMPP** sudah terinstall dan aktifkan **Apache** & **MySQL**.
2.  Buka **phpMyAdmin** (`http://localhost/phpmyadmin`).
3.  Buat database baru dengan nama **`arena_sport`**.
4.  Import file database **`arena_sport.sql`** yang ada di dalam folder root repository ini.
5.  Salin folder **`arena_sport`** (berisi file PHP) ke dalam folder `htdocs` XAMPP (biasanya di `C:\xampp\htdocs\`).

### 2. Konfigurasi Koneksi API
Agar aplikasi di HP/Emulator bisa terhubung ke Laptop:
1.  Buka Command Prompt (CMD) di laptop, ketik `ipconfig`.
2.  Catat **IPv4 Address** (Contoh: `192.168.1.10`).
3.  Buka file proyek Flutter: `lib/services/api_service.dart`.
4.  Ubah variabel `baseUrl` sesuai IP laptop Anda:
    ```dart
    static const String baseUrl = 'http://xxx.xx.xx.x/arena_sport';
    ```

### 3. Menjalankan Aplikasi
1.  Buka terminal di folder proyek Flutter lalu clone repository ini.
  ```bash
  https://github.com/GabzyP/Project-Mopro-Sport-Arena-Management
  ```
2.  Install dependencies:
    ```bash
    flutter pub get
    ```
3.  Jalankan aplikasi (pastikan Emulator atau HP fisik sudah tersambung):
    ```bash
    flutter run
    ```

---
