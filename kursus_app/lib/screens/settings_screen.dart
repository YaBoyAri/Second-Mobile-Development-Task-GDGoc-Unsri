// lib/screens/settings_screen.dart

import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onToggleDarkMode;

  const SettingsScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _notifikasiAktif;
  late bool _ikutiSistem;

  @override
  void initState() {
    super.initState();
    _notifikasiAktif = true;
    _ikutiSistem = false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profil info
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: colorScheme.primary,
                      child: const Text('🧑‍💻',
                          style: TextStyle(fontSize: 28)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pengguna KursusKu',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                          Text(
                            'pengguna@email.com',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onPrimaryContainer
                                  .withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Judul seksi tampilan
              _buildSectionHeader('Tampilan', context),

              // Toggle dark mode
              Semantics(
                label: 'Toggle mode gelap',
                child: SwitchListTile.adaptive(
                  title: const Text('Mode Gelap'),
                  subtitle: const Text('Aktifkan tampilan gelap'),
                  secondary: Icon(
                    widget.isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: colorScheme.primary,
                  ),
                  value: widget.isDarkMode,
                  onChanged: _ikutiSistem
                      ? null // disabled kalau ikuti sistem
                      : widget.onToggleDarkMode,
                ),
              ),

              // Toggle ikuti sistem
              SwitchListTile.adaptive(
                title: const Text('Ikuti Sistem'),
                subtitle: const Text('Tema mengikuti pengaturan perangkat'),
                secondary: Icon(Icons.phone_android,
                    color: colorScheme.primary),
                value: _ikutiSistem,
                onChanged: (val) => setState(() => _ikutiSistem = val),
              ),

              const Divider(indent: 16, endIndent: 16),

              // Judul seksi notifikasi
              _buildSectionHeader('Notifikasi', context),

              SwitchListTile.adaptive(
                title: const Text('Notifikasi Kursus'),
                subtitle: const Text('Terima info kursus terbaru'),
                secondary:
                    Icon(Icons.notifications, color: colorScheme.primary),
                value: _notifikasiAktif,
                onChanged: (val) => setState(() => _notifikasiAktif = val),
              ),

              const Divider(indent: 16, endIndent: 16),

              _buildSectionHeader('Tentang Aplikasi', context),

              // Info aplikasi
              ListTile(
                leading: Icon(Icons.info, color: colorScheme.primary),
                title: const Text('Versi Aplikasi'),
                trailing: const Text('1.0.0',
                    style: TextStyle(color: Colors.grey)),
              ),
              ListTile(
                leading: Icon(Icons.code, color: colorScheme.primary),
                title: const Text('Dibuat dengan Flutter'),
                trailing: const Text('❤️'),
              ),
              ListTile(
                leading: Icon(Icons.school, color: colorScheme.primary),
                title: const Text('GDGoc Unsri'),
                subtitle: const Text('Second Mobile Development Task'),
              ),

              const SizedBox(height: 16),

              // Tentang warna tema
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Palet Warna Tema',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  children: [
                    _buildColorBox(colorScheme.primary, 'Primary'),
                    _buildColorBox(colorScheme.secondary, 'Secondary'),
                    _buildColorBox(colorScheme.tertiary, 'Tertiary'),
                    _buildColorBox(colorScheme.surface, 'Surface'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildColorBox(Color color, String label) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey)),
      ],
    );
  }
}
