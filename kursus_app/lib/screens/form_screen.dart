// lib/screens/form_screen.dart

import 'package:flutter/material.dart';
import '../models/kursus_model.dart';

class FormScreen extends StatefulWidget {
  final Kursus? kursusEdit; // null = tambah baru, ada isi = edit

  const FormScreen({super.key, this.kursusEdit});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _instrukturController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _durasiController = TextEditingController();

  String _kategoriDipilih = 'Mobile Dev';
  String _levelDipilih = 'Pemula';
  bool _adaPerubahan = false; // untuk PopScope

  final List<String> _daftarKategori = [
    'Mobile Dev',
    'Web Dev',
    'Data Science',
    'Design',
    'DevOps',
  ];

  final List<String> _daftarLevel = ['Pemula', 'Menengah', 'Lanjutan'];

  bool get _isEdit => widget.kursusEdit != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      // Isi field dengan data kursus yang akan diedit
      final k = widget.kursusEdit!;
      _judulController.text = k.judul;
      _instrukturController.text = k.instruktur;
      _deskripsiController.text = k.deskripsi;
      _durasiController.text = k.durasi.toString();
      _kategoriDipilih = k.kategori;
      _levelDipilih = k.level;
    }

    // Dengarkan perubahan form
    _judulController.addListener(_tandaiAdaPerubahan);
    _instrukturController.addListener(_tandaiAdaPerubahan);
    _deskripsiController.addListener(_tandaiAdaPerubahan);
    _durasiController.addListener(_tandaiAdaPerubahan);
  }

  void _tandaiAdaPerubahan() {
    if (!_adaPerubahan) {
      setState(() => _adaPerubahan = true);
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _instrukturController.dispose();
    _deskripsiController.dispose();
    _durasiController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final kursusBaruAtauEdit = Kursus(
        id: _isEdit
            ? widget.kursusEdit!.id
            : DateTime.now().millisecondsSinceEpoch,
        judul: _judulController.text.trim(),
        instruktur: _instrukturController.text.trim(),
        kategori: _kategoriDipilih,
        deskripsi: _deskripsiController.text.trim(),
        level: _levelDipilih,
        durasi: int.tryParse(_durasiController.text) ?? 60,
        rating: _isEdit ? widget.kursusEdit!.rating : 0.0,
        jumlahSiswa: _isEdit ? widget.kursusEdit!.jumlahSiswa : 0,
        emoji: _emojiDariKategori(_kategoriDipilih),
        isFavorit: _isEdit ? widget.kursusEdit!.isFavorit : false,
      );

      if (_isEdit) {
        // Update data di list asli
        final idx = daftarKursus.indexWhere((k) => k.id == kursusBaruAtauEdit.id);
        if (idx != -1) {
          daftarKursus[idx] = kursusBaruAtauEdit;
        }
      }

      Navigator.pop(context, kursusBaruAtauEdit);
    }
  }

  String _emojiDariKategori(String kategori) {
    switch (kategori) {
      case 'Mobile Dev':
        return '📱';
      case 'Web Dev':
        return '🌐';
      case 'Data Science':
        return '📊';
      case 'Design':
        return '🎨';
      case 'DevOps':
        return '⚙️';
      default:
        return '📚';
    }
  }

  Future<bool> _konfirmasiKeluar() async {
    if (!_adaPerubahan) return true;

    final hasil = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tinggalkan Halaman?'),
        content: const Text(
            'Kamu punya perubahan yang belum disimpan. Yakin mau keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Tetap di sini'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Keluar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    return hasil ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final bolehKeluar = await _konfirmasiKeluar();
        if (bolehKeluar && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEdit ? 'Edit Kursus' : 'Tambah Kursus Baru'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              final boleh = await _konfirmasiKeluar();
              if (boleh && context.mounted) Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info
                  if (!_isEdit)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: theme.colorScheme.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Isi semua field untuk menambahkan kursus baru',
                              style: TextStyle(
                                  color: theme.colorScheme.onPrimaryContainer),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Field 1: Judul
                  _buildLabel('Judul Kursus *'),
                  TextFormField(
                    controller: _judulController,
                    decoration: _inputDecor(
                        'Contoh: Belajar Flutter untuk Pemula', Icons.title),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Judul tidak boleh kosong';
                      }
                      if (val.trim().length < 5) {
                        return 'Judul minimal 5 karakter';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 16),

                  // Field 2: Instruktur
                  _buildLabel('Nama Instruktur *'),
                  TextFormField(
                    controller: _instrukturController,
                    decoration: _inputDecor('Nama lengkap instruktur', Icons.person),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Nama instruktur tidak boleh kosong';
                      }
                      if (val.trim().length < 3) {
                        return 'Nama minimal 3 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Field 3: Deskripsi
                  _buildLabel('Deskripsi Kursus *'),
                  TextFormField(
                    controller: _deskripsiController,
                    decoration: _inputDecor(
                        'Jelaskan isi kursus ini...', Icons.description),
                    maxLines: 4,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Deskripsi tidak boleh kosong';
                      }
                      if (val.trim().length < 20) {
                        return 'Deskripsi minimal 20 karakter';
                      }
                      return null;
                    },
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 16),

                  // Field 4: Durasi
                  _buildLabel('Durasi (dalam menit) *'),
                  TextFormField(
                    controller: _durasiController,
                    decoration: _inputDecor('Contoh: 120', Icons.timer),
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Durasi tidak boleh kosong';
                      }
                      final angka = int.tryParse(val);
                      if (angka == null || angka <= 0) {
                        return 'Masukkan angka yang valid (lebih dari 0)';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Dropdown kategori
                  _buildLabel('Kategori'),
                  DropdownButtonFormField<String>(
                    value: _kategoriDipilih,
                    decoration: _inputDecor('', Icons.category),
                    items: _daftarKategori
                        .map((k) =>
                            DropdownMenuItem(value: k, child: Text(k)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _kategoriDipilih = val;
                          _adaPerubahan = true;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Pilihan level
                  _buildLabel('Level Kesulitan'),
                  Row(
                    children: _daftarLevel.map((level) {
                      final dipilih = _levelDipilih == level;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Center(child: Text(level)),
                            selected: dipilih,
                            onSelected: (_) {
                              setState(() {
                                _levelDipilih = level;
                                _adaPerubahan = true;
                              });
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),

                  // Tombol submit
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _submitForm,
                      icon: Icon(_isEdit ? Icons.save : Icons.add),
                      label: Text(_isEdit ? 'Simpan Perubahan' : 'Tambah Kursus'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
    );
  }

  InputDecoration _inputDecor(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }
}
