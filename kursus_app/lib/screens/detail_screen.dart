// lib/screens/detail_screen.dart

import 'package:flutter/material.dart';
import '../models/kursus_model.dart';
import 'form_screen.dart';

class DetailScreen extends StatefulWidget {
  final Kursus kursus;

  const DetailScreen({super.key, required this.kursus});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late bool _isFavorit;
  bool _deskripsiDiperluas = false;

  @override
  void initState() {
    super.initState();
    _isFavorit = widget.kursus.isFavorit;
  }

  void _toggleFavorit() {
    setState(() {
      _isFavorit = !_isFavorit;
      widget.kursus.isFavorit = _isFavorit;
    });
  }

  String _formatDurasi(int menit) {
    final jam = menit ~/ 60;
    final sisaMenit = menit % 60;
    if (sisaMenit == 0) return '${jam}j';
    return '${jam}j ${sisaMenit}m';
  }

  Color _warnaTingkat(String level) {
    switch (level) {
      case 'Pemula':
        return Colors.green;
      case 'Menengah':
        return Colors.orange;
      case 'Lanjutan':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final kursus = widget.kursus;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header dengan Hero animation (bonus)
              Stack(
                children: [
                  // Banner atas
                  Hero(
                    tag: 'kursus-banner-${kursus.id}',
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [colorScheme.primary, colorScheme.tertiary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(kursus.emoji,
                                style: const TextStyle(fontSize: 64)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Tombol kembali
                  Positioned(
                    top: 8,
                    left: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.black45,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                        tooltip: 'Kembali',
                      ),
                    ),
                  ),
                  // Tombol favorit
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Semantics(
                      label: _isFavorit
                          ? 'Hapus dari favorit'
                          : 'Tambah ke favorit',
                      child: CircleAvatar(
                        backgroundColor: Colors.black45,
                        child: IconButton(
                          icon: Icon(
                            _isFavorit ? Icons.favorite : Icons.favorite_border,
                            color: _isFavorit ? Colors.red : Colors.white,
                          ),
                          onPressed: _toggleFavorit,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Judul
                    Text(
                      kursus.judul,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Instruktur
                    Row(
                      children: [
                        const Icon(Icons.person, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          kursus.instruktur,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Badge kategori dan level
                    Wrap(
                      spacing: 8,
                      children: [
                        Chip(
                          label: Text(kursus.kategori),
                          backgroundColor: colorScheme.primaryContainer,
                          labelStyle: TextStyle(
                              color: colorScheme.onPrimaryContainer,
                              fontSize: 12),
                        ),
                        Chip(
                          label: Text(kursus.level),
                          backgroundColor:
                              _warnaTingkat(kursus.level).withOpacity(0.15),
                          labelStyle: TextStyle(
                              color: _warnaTingkat(kursus.level), fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Statistik kursus
                    Row(
                      children: [
                        _buildStatItem(
                            Icons.star, '${kursus.rating}', 'Rating',
                            Colors.amber),
                        _buildStatItem(
                            Icons.people, '${kursus.jumlahSiswa}', 'Siswa',
                            colorScheme.primary),
                        _buildStatItem(
                            Icons.timer,
                            _formatDurasi(kursus.durasi),
                            'Durasi',
                            colorScheme.tertiary),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Divider
                    const Divider(),
                    const SizedBox(height: 8),

                    // Deskripsi
                    Text(
                      'Tentang Kursus Ini',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _deskripsiDiperluas
                          ? kursus.deskripsi
                          : (kursus.deskripsi.length > 120
                              ? '${kursus.deskripsi.substring(0, 120)}...'
                              : kursus.deskripsi),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (kursus.deskripsi.length > 120)
                      TextButton(
                        onPressed: () => setState(
                            () => _deskripsiDiperluas = !_deskripsiDiperluas),
                        child: Text(_deskripsiDiperluas
                            ? 'Tampilkan lebih sedikit'
                            : 'Baca selengkapnya'),
                      ),

                    const SizedBox(height: 24),

                    // Tombol daftar kursus
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const FormScreen()),
                          );
                        },
                        icon: const Icon(Icons.school),
                        label: const Text('Daftar Sekarang'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Tombol edit kursus
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FormScreen(kursusEdit: kursus),
                            ),
                          ).then((result) {
                            if (result != null && result is Kursus) {
                              setState(() {});
                            }
                          });
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit Kursus Ini'),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
      IconData icon, String nilai, String label, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(nilai,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: color)),
            Text(label,
                style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
