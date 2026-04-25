// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../models/kursus_model.dart';
import '../widgets/kursus_card.dart';
import 'detail_screen.dart';
import 'form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _kategoriDipilih = 'Semua';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Filter kursus berdasarkan kategori dan search
  List<Kursus> get _kursusTerfilter {
    return daftarKursus.where((k) {
      final cocokKategori =
          _kategoriDipilih == 'Semua' || k.kategori == _kategoriDipilih;
      final cocokSearch = _searchQuery.isEmpty ||
          k.judul.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          k.instruktur.toLowerCase().contains(_searchQuery.toLowerCase());
      return cocokKategori && cocokSearch;
    }).toList();
  }

  int get _jumlahFavorit => daftarKursus.where((k) => k.isFavorit).length;

  void _toggleFavorit(int index) {
    // cari index di daftar asli
    final kursus = _kursusTerfilter[index];
    final indexAsli = daftarKursus.indexOf(kursus);
    setState(() {
      daftarKursus[indexAsli].isFavorit = !daftarKursus[indexAsli].isFavorit;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kategoriList = getKategori();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'KursusKu',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Ikon favorit dengan badge
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite),
                tooltip: 'Favorit',
                onPressed: () {
                  // Tampilkan snackbar jumlah favorit
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          '$_jumlahFavorit kursus ada di daftar favorit kamu!'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
              if (_jumlahFavorit > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$_jumlahFavorit',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      // Tombol tambah kursus baru
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FormScreen()),
          );
          if (result != null && result is Kursus) {
            setState(() {
              daftarKursus.add(result);
            });
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Kursus "${result.judul}" berhasil ditambahkan!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          }
        },
        tooltip: 'Tambah Kursus',
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header ringkasan
            _buildHeaderRingkasan(context),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari kursus atau instruktur...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                ),
                onChanged: (val) => setState(() => _searchQuery = val),
              ),
            ),

            // Filter kategori
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: kategoriList.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (ctx, i) {
                  final kat = kategoriList[i];
                  final dipilih = kat == _kategoriDipilih;
                  return FilterChip(
                    label: Text(kat),
                    selected: dipilih,
                    onSelected: (_) => setState(() => _kategoriDipilih = kat),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // Jumlah hasil
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${_kursusTerfilter.length} kursus ditemukan',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),

            const SizedBox(height: 8),

            // Daftar kursus - responsive dengan LayoutBuilder
            Expanded(
              child: _kursusTerfilter.isEmpty
                  ? _buildEmptyState()
                  : LayoutBuilder(
                      builder: (ctx, constraints) {
                        int kolom = 1;
                        if (constraints.maxWidth >= 1000) {
                          kolom = 4;
                        } else if (constraints.maxWidth >= 600) {
                          kolom = 2;
                        }

                        if (kolom == 1) {
                          // ListView untuk mobile (1 kolom)
                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _kursusTerfilter.length,
                            itemBuilder: (ctx, i) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: KursusCard(
                                kursus: _kursusTerfilter[i],
                                onTap: () => _bukaDetail(i),
                                onFavoritToggle: () => _toggleFavorit(i),
                              ),
                            ),
                          );
                        } else {
                          // GridView untuk tablet/desktop
                          return GridView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: kolom,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: _kursusTerfilter.length,
                            itemBuilder: (ctx, i) => KursusCard(
                              kursus: _kursusTerfilter[i],
                              onTap: () => _bukaDetail(i),
                              onFavoritToggle: () => _toggleFavorit(i),
                            ),
                          );
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _bukaDetail(int indexFiltered) {
    final kursus = _kursusTerfilter[indexFiltered];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailScreen(kursus: kursus),
      ),
    ).then((_) => setState(() {})); // refresh state setelah balik
  }

  Widget _buildHeaderRingkasan(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selamat datang! 👋',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Temukan kursus terbaik buat kamu',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: colorScheme.onPrimary.withOpacity(0.85)),
          ),
          const SizedBox(height: 12),
          // Row ringkasan statistik
          Row(
            children: [
              _buildStatBox(
                  '${daftarKursus.length}', 'Kursus', colorScheme.onPrimary),
              const SizedBox(width: 12),
              _buildStatBox(
                  '$_jumlahFavorit', 'Favorit', colorScheme.onPrimary),
              const SizedBox(width: 12),
              _buildStatBox(
                  '${getKategori().length - 1}', 'Kategori', colorScheme.onPrimary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String angka, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(angka,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: TextStyle(fontSize: 11, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('🔍', style: TextStyle(fontSize: 48)),
          SizedBox(height: 12),
          Text('Tidak ada kursus yang ditemukan',
              style: TextStyle(fontSize: 16)),
          SizedBox(height: 4),
          Text('Coba ubah filter atau kata kunci',
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
