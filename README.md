# POS App - Aplikasi Point of Sales Sederhana
Laporan Kemajuan Iterasi Mingguan (Revisi berdasarkan klarifikasi)
Aplikasi POS Sederhana MVP
Nama: Muhammad Dimas Arya Nugroho
NIM: 221240001316
Minggu ke: 2 (dari 6)

Periode: [Tanggal Mulai Minggu 2] - [Tanggal Selesai Minggu 2]

Rangkuman Aktivitas dan Output Minggu 2: Implementasi Inti dan Dokumentasi Awal
Tujuan Utama Minggu Ini (berdasarkan progres aktual):
Mengimplementasikan sebagian besar fitur inti MVP yang telah direncanakan (Autentikasi, Tambah & Lihat Produk, Transaksi Penjualan, Laporan Ringkas).
Membuat dokumentasi awal proyek (README.md) yang menjelaskan fitur, teknologi, dan cara penggunaan.
Memastikan fungsionalitas dasar aplikasi yang sudah ada berjalan sesuai harapan.
Task Minggu Ini dan Status Penyelesaian (Berdasarkan Progres Aktual & Klarifikasi):
No	Kode Task	Deskripsi Task	Status
1	T-IMP-AUTH	Implementasi fitur Registrasi, Login, Logout dengan hashing password.	✅ Done
2	T-IMP-PROD-ADDVIEW	Implementasi fitur Tambah Produk & Lihat Daftar Produk.	✅ Done
3	T-IMP-PROD-STOCK	Implementasi update stok otomatis setelah transaksi.	✅ Done
4	T-IMP-TRX	Implementasi fitur Transaksi (Keranjang, Kalkulasi, Validasi Stok, Simpan).	✅ Done
5	T-IMP-REP-DASH	Implementasi Dashboard ringkasan penjualan harian.	✅ Done
6	T-IMP-REP-HISTLIST	Implementasi tampilan daftar Riwayat Transaksi (tanpa detail).	✅ Done
7	T-DOC-READ	Membuat README.md komprehensif untuk proyek.	✅ Done
8	T-STR-PROJ	Menetapkan dan mengimplementasikan struktur proyek (models, services, screens).	✅ Done
9	T-TECH-SEL	Memilih dan mengimplementasikan teknologi (Flutter, Shared Prefs, Crypto).	✅ Done
Fitur yang Belum Selesai (atau Di Luar Scope Awal MVP):			
10	T-IMP-PROD-EDIT	Implementasi fitur Edit Produk yang sudah ada.	❌ Not Started
11	T-IMP-REP-HISTDETAIL	Implementasi Lihat Detail untuk setiap Riwayat Transaksi.	❌ Not Started

Aplikasi Point of Sales (POS) sederhana yang dibangun dengan Flutter dan dapat dijalankan di web browser (Chrome) maupun mobile.

## Fitur Utama

### 🔐 Autentikasi
- **Registrasi Pengguna**: Membuat akun baru dengan username dan password
- **Login/Logout**: Sistem autentikasi dengan password hashing
- **Keamanan**: Password disimpan dalam bentuk hash SHA-256

### 📦 Manajemen Produk
- **Tambah Produk**: Menambahkan produk baru dengan nama, harga, dan stok awal
- **Daftar Produk**: Melihat semua produk yang tersedia
- **Stok Otomatis**: Stok berkurang otomatis setelah transaksi

### 🛒 Transaksi Penjualan
- **Keranjang Belanja**: Menambahkan produk ke keranjang dengan kuantitas
- **Kalkulasi Otomatis**: Total harga dihitung otomatis
- **Validasi Stok**: Mencegah transaksi jika stok tidak mencukupi
- **Proses Transaksi**: Menyimpan transaksi dan update stok

### 📊 Laporan dan Riwayat
- **Dashboard**: Tampilan ringkasan penjualan harian
- **Riwayat Transaksi**: Melihat semua transaksi yang telah dilakukan
- **Laporan Harian**: Total penjualan untuk hari ini

## Teknologi yang Digunakan

- **Flutter**: Framework UI cross-platform
- **Shared Preferences**: Penyimpanan data lokal
- **Crypto**: Library untuk hashing password
- **Intl**: Formatting tanggal dan angka

## Cara Menjalankan Aplikasi

### Prerequisites
- Flutter SDK (versi 3.8.1 atau lebih baru)
- Chrome browser (untuk web)
- Android Studio / VS Code (opsional)

### Langkah-langkah

1. **Clone atau download proyek**
   ```bash
   git clone <repository-url>
   cd pos_app
   ```

2. **Install dependensi**
   ```bash
   flutter pub get
   ```

3. **Jalankan di web (Chrome)**
   ```bash
   flutter run -d chrome
   ```

4. **Jalankan di mobile (Android/iOS)**
   ```bash
   flutter run
   ```

## Struktur Proyek

```
lib/
├── main.dart                 # Entry point aplikasi
├── models/                   # Model data
│   ├── user.dart            # Model User
│   ├── product.dart         # Model Product
│   └── transaction.dart     # Model Transaction
├── services/                # Business logic
│   ├── auth_service.dart    # Autentikasi
│   ├── product_service.dart # Manajemen produk
│   └── transaction_service.dart # Manajemen transaksi
└── screens/                 # UI screens
    ├── login_screen.dart    # Halaman login/register
    ├── dashboard_screen.dart # Dashboard utama
    ├── products_screen.dart # Manajemen produk
    ├── sales_screen.dart    # Transaksi baru
    └── transaction_history_screen.dart # Riwayat transaksi
```

## Cara Penggunaan

### 1. Registrasi dan Login
- Buka aplikasi di browser
- Klik "Belum punya akun? Registrasi"
- Isi username dan password (minimal 6 karakter)
- Klik "Registrasi"
- Setelah berhasil, login dengan akun yang baru dibuat

### 2. Menambahkan Produk
- Dari dashboard, klik menu "Produk"
- Klik tombol "+" untuk menambah produk baru
- Isi nama produk, harga jual, dan stok awal
- Klik "Simpan"

### 3. Melakukan Transaksi
- Dari dashboard, klik menu "Transaksi Baru"
- Pilih produk yang ingin dibeli dengan mengklik produk
- Atur kuantitas di keranjang
- Klik "Proses Transaksi" untuk menyelesaikan

### 4. Melihat Laporan
- Dashboard menampilkan total penjualan hari ini
- Menu "Riwayat Transaksi" untuk melihat semua transaksi
- Menu "Laporan" untuk detail laporan

## Penyimpanan Data

Aplikasi menggunakan penyimpanan lokal (Shared Preferences) yang berarti:
- Data tersimpan di perangkat pengguna
- Tidak memerlukan koneksi internet
- Data tidak tersinkronisasi antar perangkat
- Data akan hilang jika aplikasi dihapus

## Keamanan

- Password di-hash menggunakan SHA-256
- Data disimpan secara lokal di perangkat
- Tidak ada data yang dikirim ke server eksternal

## Batasan (MVP)

Sesuai dengan SRS, aplikasi ini adalah MVP dengan batasan:
- Tidak ada cetak struk/nota
- Tidak ada backup & restore data
- Tidak ada edit/hapus produk atau transaksi
- Tidak ada laporan lanjutan (bulanan, grafik)
- Tidak ada sinkronisasi data antar perangkat

## Kontribusi

Aplikasi ini dikembangkan sebagai proyek MVP sesuai dengan Software Requirements Specification (SRS) yang diberikan.

## Lisensi

Proyek ini dibuat untuk tujuan pembelajaran dan demonstrasi aplikasi POS sederhana.
