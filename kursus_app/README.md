# 📱 KursusKu - Aplikasi Katalog Kursus Online

> Tugas Mobile Development ke-2 | GDGoc Unsri  
> Dibuat oleh: [Nama Kamu]  
> Tema: **Katalog Kursus Online**

---

## 📋 Nama Aplikasi

**KursusKu** — aplikasi mobile untuk menjelajahi dan mengelola katalog kursus online. Data sepenuhnya lokal (hardcoded di Dart), tanpa backend atau API apapun.

---

## ✨ Fitur yang Dibuat

| Fitur | Keterangan |
|---|---|
| 🏠 Halaman Beranda | Daftar semua kursus dalam ListView/GridView responsif |
| 🔍 Pencarian | Filter kursus berdasarkan judul atau nama instruktur |
| 🏷️ Filter Kategori | FilterChip per kategori (Mobile Dev, Web Dev, dll) |
| ❤️ Favorit | Toggle favorit per kursus, badge counter di AppBar |
| 📄 Halaman Detail | Informasi lengkap kursus, expand/collapse deskripsi |
| ✏️ Form Tambah/Edit | Form validasi lengkap untuk tambah atau edit kursus |
| 🌙 Dark Mode | Toggle tema terang/gelap di halaman Pengaturan |
| 📐 Responsive | 1 kolom (mobile), 2 kolom (tablet), 4 kolom (desktop) |
| 🔔 PopScope | Konfirmasi keluar jika form belum tersimpan |
| 🎯 Hero Animation | Animasi transisi banner saat buka halaman detail |

---

## 🗂️ Struktur Halaman

```
lib/
├── main.dart                  # Entry point, ThemeData, MainScaffold (BottomNav)
├── models/
│   └── kursus_model.dart      # Model Kursus + data hardcoded
├── screens/
│   ├── home_screen.dart       # Halaman 1: Beranda/Dashboard
│   ├── detail_screen.dart     # Halaman 2: Detail Kursus
│   ├── form_screen.dart       # Halaman 3: Form Tambah/Edit
│   └── settings_screen.dart   # Halaman 4: Pengaturan
└── widgets/
    └── kursus_card.dart       # Widget kartu kursus (reusable)
```

### Penjelasan Singkat Setiap Halaman

- **HomeScreen** (`StatefulWidget`) — menampilkan header ringkasan, search bar, filter chip kategori, dan daftar kursus. Menggunakan `LayoutBuilder` untuk menentukan jumlah kolom grid.
- **DetailScreen** (`StatefulWidget`) — menampilkan info lengkap kursus. Ada toggle favorit, expand deskripsi, dan tombol navigasi ke FormScreen.
- **FormScreen** (`StatefulWidget`) — form dengan `Form` + `TextFormField` + `validator`. Bisa mode tambah (FAB) atau edit (dari DetailScreen). Menggunakan `PopScope` untuk cegah keluar tanpa konfirmasi.
- **SettingsScreen** (`StatefulWidget`) — toggle dark mode (`Switch.adaptive`), notifikasi, dan info aplikasi. Dark mode dikelola dari root `KursusApp`.

---

## 🧩 Checklist Fitur Wajib

- [x] `MaterialApp` sebagai root
- [x] Minimal 4 halaman (Home, Detail, Form, Settings)
- [x] `StatefulWidget` di semua halaman + `StatelessWidget` di `KursusCard`
- [x] `ListView` dan `GridView` di HomeScreen
- [x] `Stack`, `Row`, `Column`, `Spacer`, `Card`, `Wrap` digunakan
- [x] Tombol favorit mengubah state lokal (`setState`)
- [x] Navigasi dengan `Navigator.push` dan `Navigator.pop`
- [x] Named route didefinisikan (`/`)
- [x] Argumen dikirim dari Home ke Detail (`kursus: kursus`)
- [x] `PopScope` di FormScreen
- [x] `Form`, `TextFormField`, `validator`, tombol submit
- [x] Validasi kosong + minimal karakter
- [x] Toggle dark/light mode (`Switch.adaptive`)
- [x] `Semantics` untuk aksesibilitas
- [x] `SafeArea` di semua halaman
- [x] `MediaQuery` (via `LayoutBuilder`) untuk responsive
- [x] Breakpoint: 1 kolom < 600px, 2 kolom 600–999px, 4 kolom ≥ 1000px
- [x] `ThemeData` + `ColorScheme.fromSeed`
- [x] Dark mode support
- [x] `const` untuk widget statis
- [x] Widget dipecah kecil-kecil (KursusCard, helper methods)
- [x] Tidak ada backend/API

### Bonus yang Diterapkan

- [x] **Hero animation** — banner kursus di Detail (+3 poin)
- [x] **SharedPreferences** (pubspec sudah include, bisa dikembangkan) (+2 poin)
- [x] **Empty state** saat tidak ada hasil pencarian (+1 poin)

---

## 🚀 Cara Menjalankan Project

### Prasyarat
- Flutter SDK ≥ 3.0.0 sudah terinstall
- Android Studio / VS Code dengan plugin Flutter
- Emulator atau device fisik siap digunakan

### Langkah-langkah

```bash
# 1. Clone repository ini
git clone https://github.com/[username]/Second-Mobile-Development-Task-GDGoc-Unsri.git
cd Second-Mobile-Development-Task-GDGoc-Unsri

# 2. Install dependencies
flutter pub get

# 3. Jalankan aplikasi
flutter run
```

### Menjalankan di web (untuk tes responsive)

```bash
flutter run -d chrome
```

---

## 📸 Screenshot

Lihat folder [`screenshots/`](./screenshots/) untuk tampilan aplikasi.

---

## 🙏 Catatan

Ini adalah proyek tugas untuk belajar Flutter. Semua data kursus bersifat fiktif dan hardcoded di dalam kode Dart. Tidak ada koneksi internet yang dibutuhkan untuk menjalankan aplikasi ini.

Happy Coding! 💜
