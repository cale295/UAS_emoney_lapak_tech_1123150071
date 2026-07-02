<div align="center">
  <!-- Banner Placeholder -->
  <!-- <img src="https://via.placeholder.com/800x200.png?text=TechPay+Banner" alt="TechPay Banner"> -->

  <h1>💸 TechPay</h1>
  <p><strong>Aplikasi E-Money berbasis Flutter Terintegrasi dengan Lapak_Tech</strong></p>
  
  <p>
    <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" alt="Flutter"></a>
    <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white" alt="Dart"></a>
    <a href="https://supabase.com"><img src="https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white" alt="Supabase"></a>
  </p>
</div>

---

## 📖 Tentang Project

**TechPay** adalah aplikasi dompet digital (E-Money) yang dikembangkan sebagai bagian dari Tugas Akhir. TechPay dirancang secara khusus agar tidak berdiri sendiri, melainkan terintegrasi dengan aplikasi E-commerce **Lapak_Tech** sebagai metode pembayaran utama menggunakan mekanisme **Deep Link**.

Aplikasi ini menyediakan fitur e-money standar dengan keamanan berlapis melalui PIN dan *Two-Factor Authentication* (2FA) sebelum mengembalikan callback status pembayaran ke aplikasi E-commerce.

---

## 🎯 Tujuan Project

Project ini dibuat sebagai **implementasi integrasi dua aplikasi Flutter** yang berkomunikasi dua arah menggunakan Deep Link. Fokus utama dari sistem ini adalah menyediakan alur pembayaran yang mulus (*seamless*) antar aplikasi dengan menerapkan **keamanan berlapis** menggunakan autentikasi PIN dan 2FA (OTP).

---

## 🛠️ Tech Stack

Teknologi utama yang digunakan dalam pengembangan aplikasi TechPay:

| Kategori | Teknologi | Deskripsi |
| :--- | :--- | :--- |
| **Framework** | [Flutter](https://flutter.dev/) | Cross-platform mobile UI framework |
| **Bahasa** | [Dart](https://dart.dev/) | Bahasa pemrograman utama |
| **Backend & BaaS** | [Supabase](https://supabase.com/) | Autentikasi dan interaksi database |
| **Database** | PostgreSQL | Relational database (melalui Supabase) |
| **Routing** | Go Router | Navigasi deklaratif berbasis URL |
| **Storage** | Flutter Secure Storage | Penyimpanan lokal terenkripsi untuk Token/PIN |
| **Integration** | App Links / Deep Link | Komunikasi antar aplikasi Lapak_Tech & TechPay |
| **API** | REST API & JWT | Komunikasi client-server yang aman |
| **State Management**| *[Placeholder - e.g. Riverpod/Provider/Bloc]* | Manajemen state aplikasi |

*(Catatan: Beberapa tech stack dapat disesuaikan kembali sesuai implementasi final)*

---

## ✨ Fitur

- [x] Login
- [x] Register (Admin)
- [x] Dashboard
- [x] Saldo E-Money
- [x] Transfer Antar Pengguna
- [x] Pembayaran Merchant
- [x] Deep Link Payment Integration
- [x] PIN Authentication
- [x] Two-Factor Authentication (OTP/2FA)
- [x] Transaction History
- [x] User Profile
- [x] Logout

---

## 🏗️ Arsitektur Sistem

Berikut adalah diagram alur integrasi antara Lapak_Tech dan TechPay saat proses pembayaran terjadi:

```mermaid
sequenceDiagram
    participant LT as Lapak_Tech (E-Commerce)
    participant TP as TechPay (E-Money)
    participant SB as Supabase (Backend)
    
    LT->>TP: Checkout & Panggil Deep Link (techpay://payment?amount=...)
    activate TP
    TP-->>TP: Tampilkan Detail Pembayaran
    TP->>TP: Validasi PIN Authentication
    TP->>TP: Validasi Two-Factor Authentication (2FA)
    TP->>SB: Proses Transaksi & Potong Saldo
    SB-->>TP: Transaksi Sukses
    TP->>LT: Callback Deep Link (lapaktech://payment-success?trx_id=...)
    deactivate TP
    activate LT
    LT-->>LT: Update Status Pesanan Selesai
    deactivate LT
```

---

## 💳 Flow Pembayaran

1. **Checkout di Lapak_Tech**: Pengguna menyelesaikan belanjaan di aplikasi Lapak_Tech dan memilih "TechPay" sebagai metode pembayaran.
2. **Redirect via Deep Link**: Lapak_Tech memanggil URI scheme dari TechPay yang berisi data transaksi (nominal, ID merchant, dll).
3. **Konfirmasi di TechPay**: Aplikasi TechPay terbuka dan menampilkan rincian pembayaran.
4. **Input PIN**: Pengguna memasukkan PIN TechPay untuk otorisasi awal.
5. **Verifikasi 2FA**: Pengguna memasukkan kode 2FA (OTP) untuk keamanan tambahan.
6. **Proses Transaksi**: TechPay memvalidasi saldo dan memproses transaksi ke database Supabase.
7. **Callback Success**: Setelah sukses, TechPay otomatis mengembalikan pengguna ke Lapak_Tech menggunakan callback URI dengan menyertakan status sukses dan ID transaksi.
8. **Pesanan Selesai**: Lapak_Tech memperbarui status pesanan menjadi Lunas.

---

## 📁 Struktur Folder

Project ini menggunakan struktur folder terorganisir yang memisahkan logic, UI, dan service.

```text
lib/
├── core/            # Konfigurasi dasar, theme, konstanta, dan error handling
├── models/          # Data class dan model serialisasi (JSON)
├── services/        # Logic API, Supabase, dan integrasi pihak ketiga (DeepLink)
├── screens/         # Tampilan halaman utama aplikasi (UI)
├── widgets/         # Komponen UI yang reusable (tombol, textfield, dll)
├── providers/       # State management logic
├── routes/          # Konfigurasi Go Router untuk navigasi dan deep link
├── utils/           # Fungsi helper dan utilitas pendukung
└── main.dart        # Entry point aplikasi Flutter
```

---

## 🚀 Instalasi & Menjalankan Project

Ikuti langkah-langkah berikut untuk menjalankan project di perangkat lokal:

1. **Clone repository ini**
   ```bash
   git clone https://github.com/username-anda/techpay.git
   cd techpay
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Siapkan Environment Variables**
   Buat file `.env` di root directory (sejajar dengan `pubspec.yaml`) dan isi dengan konfigurasi Anda.

4. **Jalankan Aplikasi**
   ```bash
   flutter run
   ```

---

## 🔗 Deep Link Integration

TechPay dirancang untuk menerima request dari luar (Lapak_Tech) menggunakan sistem Deep Link / App Links.

* **Cara Kerja**: Aplikasi mendaftarkan custom URI scheme pada OS (Android/iOS). Saat URI tersebut dipanggil, OS akan otomatis membuka TechPay.
* **URI Scheme (Menerima Request)**: `techpay://payment`
* **Callback URL (Mengirim Response)**: `lapaktech://payment-result`

### Data Request (Dari Lapak_Tech ke TechPay)
```json
{
  "amount": "150000",
  "order_id": "ORD-12345",
  "merchant_name": "Lapak_Tech Store"
}
```
*Contoh URL: `techpay://payment?amount=150000&order_id=ORD-12345&merchant_name=Lapak_Tech+Store`*

### Data Response (Callback ke Lapak_Tech)
```json
{
  "status": "success",
  "transaction_id": "TRX-98765"
}
```
*Contoh Callback: `lapaktech://payment-result?status=success&transaction_id=TRX-98765`*

---

## 🔐 Two-Factor Authentication (2FA)

Untuk menjamin keamanan transaksi E-Money, flow otorisasi dibagi menjadi dua lapis:

```mermaid
graph TD
    A[Mulai Pembayaran] --> B[Input PIN E-Money]
    B --> C{PIN Valid?}
    C -->|Ya| D[Request & Input OTP / 2FA]
    C -->|Tidak| B
    D --> E{2FA Valid?}
    E -->|Ya| F[Payment Validation ke Database]
    E -->|Tidak| D
    F --> G([Transaction Success])
```

---

## 📸 Screenshots

| Login | Dashboard | Payment Confirmation |
| :---: | :---: | :---: |
| ![Login](<img width="390" height="874" alt="Screenshot 2026-07-02 213902" src="https://github.com/user-attachments/assets/e8d1c03a-1749-473c-a5fe-ae218cca161c" />
) | ![Dashboard]() | ![Payment Confirmation]() |

| PIN Input | 2FA Verification | Transaction Success |
| :---: | :---: | :---: |
| ![PIN Input]() | ![2FA Verification]() | ![Transaction Success]() |

| Transaction History | Profile | Settings |
| :---: | :---: | :---: |
| ![Transaction History]() | ![Profile]() | ![Settings]() |


---

## 🗺️ Roadmap

Fitur yang direncanakan untuk pengembangan ke depan:

- [ ] QRIS Payment Scanner
- [ ] NFC Payment (Tap to Pay)
- [ ] Push Notification Integrations
- [ ] Face ID / Biometrics Login
- [ ] Fingerprint Authentication
- [ ] Multi Merchant Integrations
- [ ] Dark Mode Support

---

## 👨‍💻 Author

**[Nama Anda]**
- Email: [Email Anda]
- GitHub: [@username-anda](https://github.com/username-anda)
- LinkedIn: [Profil LinkedIn Anda]

---
*Dibuat untuk keperluan Tugas Akhir - Universitas / Institusi*
