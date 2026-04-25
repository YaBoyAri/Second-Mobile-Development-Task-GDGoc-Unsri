// lib/models/kursus_model.dart

class Kursus {
  final int id;
  final String judul;
  final String instruktur;
  final String kategori;
  final String deskripsi;
  final String level;
  final int durasi; // dalam menit
  final double rating;
  final int jumlahSiswa;
  final String emoji;
  bool isFavorit;

  Kursus({
    required this.id,
    required this.judul,
    required this.instruktur,
    required this.kategori,
    required this.deskripsi,
    required this.level,
    required this.durasi,
    required this.rating,
    required this.jumlahSiswa,
    required this.emoji,
    this.isFavorit = false,
  });
}

// Data kursus hardcoded (lokal, tanpa API)
List<Kursus> daftarKursus = [
  Kursus(
    id: 1,
    judul: 'Belajar Flutter dari Nol',
    instruktur: 'Budi Santoso',
    kategori: 'Mobile Dev',
    deskripsi:
        'Pelajari Flutter dari dasar hingga bisa membuat aplikasi mobile yang keren. '
        'Kursus ini cocok untuk pemula yang belum pernah menyentuh Flutter sama sekali. '
        'Kita akan belajar widget, state management, navigasi, dan masih banyak lagi!',
    level: 'Pemula',
    durasi: 480,
    rating: 4.8,
    jumlahSiswa: 3200,
    emoji: '📱',
    isFavorit: false,
  ),
  Kursus(
    id: 2,
    judul: 'Python untuk Data Science',
    instruktur: 'Siti Rahayu',
    kategori: 'Data Science',
    deskripsi:
        'Kuasai Python dan library populer seperti Pandas, NumPy, dan Matplotlib. '
        'Belajar cara mengolah data, membuat visualisasi, dan membangun model machine learning sederhana.',
    level: 'Menengah',
    durasi: 600,
    rating: 4.7,
    jumlahSiswa: 5100,
    emoji: '🐍',
    isFavorit: true,
  ),
  Kursus(
    id: 3,
    judul: 'UI/UX Design Fundamentals',
    instruktur: 'Andi Wijaya',
    kategori: 'Design',
    deskripsi:
        'Pelajari prinsip-prinsip dasar desain UI/UX yang baik. '
        'Mulai dari riset pengguna, wireframing, prototyping, hingga cara menyampaikan desain ke developer.',
    level: 'Pemula',
    durasi: 360,
    rating: 4.9,
    jumlahSiswa: 2800,
    emoji: '🎨',
    isFavorit: false,
  ),
  Kursus(
    id: 4,
    judul: 'React JS Modern',
    instruktur: 'Dewi Kusuma',
    kategori: 'Web Dev',
    deskripsi:
        'Bangun aplikasi web modern dengan React JS. Pelajari hooks, context API, dan cara mengelola state '
        'di aplikasi React yang kompleks. Termasuk integrasi dengan REST API.',
    level: 'Menengah',
    durasi: 540,
    rating: 4.6,
    jumlahSiswa: 4400,
    emoji: '⚛️',
    isFavorit: false,
  ),
  Kursus(
    id: 5,
    judul: 'Belajar Kotlin Android',
    instruktur: 'Reza Pratama',
    kategori: 'Mobile Dev',
    deskripsi:
        'Mulai perjalanan Android development dengan Kotlin. Kursus ini mencakup activity, fragment, '
        'RecyclerView, Room Database, dan integrasi API menggunakan Retrofit.',
    level: 'Pemula',
    durasi: 720,
    rating: 4.5,
    jumlahSiswa: 1900,
    emoji: '🤖',
    isFavorit: false,
  ),
  Kursus(
    id: 6,
    judul: 'Machine Learning dengan TensorFlow',
    instruktur: 'Lina Hartono',
    kategori: 'Data Science',
    deskripsi:
        'Selami dunia Machine Learning menggunakan TensorFlow dan Keras. '
        'Dari regresi linear hingga deep learning, kamu akan bisa membuat model AI sendiri.',
    level: 'Lanjutan',
    durasi: 900,
    rating: 4.8,
    jumlahSiswa: 2100,
    emoji: '🧠',
    isFavorit: false,
  ),
  Kursus(
    id: 7,
    judul: 'DevOps dengan Docker & CI/CD',
    instruktur: 'Fajar Nugroho',
    kategori: 'DevOps',
    deskripsi:
        'Pelajari cara men-deploy aplikasi dengan Docker, membuat pipeline CI/CD, '
        'dan mengelola infrastruktur cloud. Sangat berguna bagi developer yang ingin naik level.',
    level: 'Lanjutan',
    durasi: 660,
    rating: 4.7,
    jumlahSiswa: 1500,
    emoji: '🐳',
    isFavorit: false,
  ),
  Kursus(
    id: 8,
    judul: 'Figma Prototyping Masterclass',
    instruktur: 'Maya Indah',
    kategori: 'Design',
    deskripsi:
        'Jadilah master Figma! Dari komponen dasar hingga auto layout, variabel, dan cara membuat '
        'prototype interaktif yang bisa langsung dipresentasikan ke klien.',
    level: 'Menengah',
    durasi: 300,
    rating: 4.9,
    jumlahSiswa: 3700,
    emoji: '🖼️',
    isFavorit: true,
  ),
];

// Daftar kategori unik
List<String> getKategori() {
  final set = <String>{'Semua'};
  for (final k in daftarKursus) {
    set.add(k.kategori);
  }
  return set.toList();
}
