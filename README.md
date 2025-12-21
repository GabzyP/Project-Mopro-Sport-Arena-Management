# 🏟️ Sport Arena Management - Kelompok 6

**Proyek Pemrograman Mobile Kom A 24**

---

## 👥 Anggota Kelompok (Nama - NIM)

| No | Nama Mahasiswa | NIM | Github |
| :--- | :--- | :--- | :--- |
| 1. | **Gabriel Glenn Peter Pardede** | **241712041** | **GabzyP** |
| 2. | **Melati Simanungkalit** | **241712008** | **MelatiSimanungkalit** |
| 3. | **Ferlita Kristiani Hulu** | **241712025** | **ferlitakristianihulu25-source** |
| 4. | **Aditya Fahreza** | **241712013** | **Adittssfahreza12** |
| 5. | **Habil Rizky Tazir** | **241712030** | **HabilRizky** |

---

## 📱 Deskripsi Singkat Aplikasi

**Sport Arena Management** adalah aplikasi *mobile* berbasis Flutter yang dirancang untuk mendigitalisasi proses reservasi lapangan olahraga. Aplikasi ini menghubungkan penyedia lapangan (Admin) dengan pelanggan (Customer) dalam satu ekosistem yang terintegrasi, menyelesaikan masalah booking manual yang rentan kesalahan dan tidak efisien.

Dengan fitur **Real-time Availability**, **Smart Locking System**, dan **Auto-Refund**, aplikasi ini menjamin pengalaman booking yang adil, cepat, dan transparan bagi semua pengguna.

---

## ✨ Daftar Fitur

### 👤 Customer (Pengguna)
1.  **Smart Booking System**:
    *   Melihat jadwal lapangan secara *real-time*.
    *   **Locking Mechanism**: Slot waktu yang dipilih akan "dikunci" selama 10 menit untuk mencegah *double booking*.
    *   **Auto-Refund**: Jika pesanan tidak dikonfirmasi Admin hingga lewat jadwal main, saldo otomatis dikembalikan (Refund).
2.  **Sistem Level & XP**:
    *   Setiap transaksi memberikan XP.
    *   Naik level (Bronze -> Silver -> Gold) memberikan diskon khusus (hingga 10%).
3.  **Metode Pembayaran (Simulasi)**:
    *   E-Wallet (GoPay, OVO, Dana) dan Transfer Bank/VA.
    *   Saldo berkurang otomatis (Immediate Deduction) saat pembayaran.
4.  **Pencarian & Lokasi**:
    *   Filter venue berdasarkan jenis olahraga (Futsal, Badminton, Basket).
    *   Integrasi Peta (`flutter_map`) untuk melihat lokasi venue.
5.  **Notifikasi Sistem**: Pemberitahuan status booking, promo, dan refund.
6.  **Manajemen Profil**: Update foto, password, dan melihat riwayat transaksi.

### 🛡️ Admin (Pengelola)
1.  **Dashboard Statistik Real-time**:
    *   Memantau total pendapatan harian/bulanan.
    *   Grafik tren pemesanan (`fl_chart`).
    *   Angka pendapatan langsung terupdate saat booking dikonfirmasi.
2.  **Manajemen Venue**: Tambah, edit, dan hapus venue beserta fasilitasnya.
3.  **Verifikasi Pesanan**: Menerima atau menolak pesanan masuk.
4.  **Manajemen Iklan/Promo**: Membuat banner promo yang muncul di halaman utama user.
5.  **Manajemen User**: Memantau daftar pengguna dan status banned.

---

## 🛠️ Technical Stack Application

### **Frontend (Mobile)**
*   **Framework**: Flutter **3.38.1** (Channel Stable)
*   **Dart SDK**: Versi **3.10.0**
*   **Architecture**: MVC (Model-View-Controller)
*   **State Management**: `setState` (Native)

**Key Plugins:**
*   `http`: ^1.2.0 (Koneksi ke REST API)
*   `shared_preferences`: ^2.2.2 (Penyimpanan sesi lokal)
*   `image_picker`: ^1.0.4 (Upload foto)
*   `flutter_map`: ^6.0.0 (Peta OpenStreetMap)
*   `fl_chart`: ^0.66.0 (Grafik Statistik)
*   `intl`: ^0.19.0 (Format IDR & Tanggal)

### **Backend**
*   **Bahasa**: PHP Native (Versi 8.x via XAMPP)
*   **Database**: MySQL / MariaDB (via XAMPP)
*   **Server**: Apache Web Server
*   **Tools**: phpMyAdmin for Database Managementsi ini di lingkungan lokal (Dev Environment).

### 0. Setup Repository

```dart
    git clone https://github.com/GabzyP/Project-Mopro-Sport-Arena-Management.git
    ```

### 1. Setup Backend (Database & Server)
1.  Pastikan **XAMPP** terinstall. Jalankan service **Apache** dan **MySQL**.
2.  Buka **phpMyAdmin** (`http://localhost/phpmyadmin`).
3.  Buat database baru bernama **`arena_sport`**.
4.  **Import** file `arena_sport.sql` yang tersedia di root project ke database tersebut.
5.  Pindahkan folder `arena_sport` yang berisi skrip PHP ke folder `htdocs` XAMPP:
    *   Windows: `C:\xampp\htdocs\arena_sport`
    *   Pastikan struktur file: `htdocs/arena_sport/config/koneksi.php` valid.

### 2. Konfigurasi Koneksi (PENTING!)
Agar HP/Emulator bisa mengakses server laptop, kita perlu mengarahkan ke IP Address yang benar (bukan `localhost`).
1.  Buka CMD/Terminal, ketik `ipconfig` (Windows) atau `ifconfig` (Mac/Linux).
2.  Salin **IPv4 Address** Contoh: `192.168.1.15`.
3.  Buka file Dart: `lib/services/api_service.dart`.
4.  Update variabel `baseUrl` di baris atas:
    ```dart
    static const String baseUrl = 'http://192.168.1.15/arena_sport'; 
    // Ganti 192.168.1.15 dengan IP Laptop Anda
    ```

### 3. Menjalankan Aplikasi Flutter
1.  Buka terminal di root folder project Flutter.
2.  Install dependencies:
    ```bash
    flutter pub get
    ```
3.  Pastikan device emulator/fisik terdeteksi:
    ```bash
    flutter devices
    ```
4.  Jalankan aplikasi:
    ```bash
    flutter run
    ```
