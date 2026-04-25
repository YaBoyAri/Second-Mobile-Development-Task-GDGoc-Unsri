// lib/widgets/kursus_card.dart

import 'package:flutter/material.dart';
import '../models/kursus_model.dart';

class KursusCard extends StatelessWidget {
  final Kursus kursus;
  final VoidCallback onTap;
  final VoidCallback onFavoritToggle;

  const KursusCard({
    super.key,
    required this.kursus,
    required this.onTap,
    required this.onFavoritToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Emoji + Favorit button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        kursus.emoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  Semantics(
                    label: kursus.isFavorit
                        ? 'Hapus dari favorit'
                        : 'Tambah ke favorit',
                    child: IconButton(
                      icon: Icon(
                        kursus.isFavorit
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: kursus.isFavorit ? Colors.red : Colors.grey,
                      ),
                      onPressed: onFavoritToggle,
                      tooltip:
                          kursus.isFavorit ? 'Hapus favorit' : 'Tambah favorit',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Judul kursus
              Text(
                kursus.judul,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // Instruktur
              Text(
                kursus.instruktur,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),

              // Badge kategori dan level
              Wrap(
                spacing: 4,
                children: [
                  _buildBadge(kursus.kategori, colorScheme.primaryContainer,
                      colorScheme.onPrimaryContainer),
                  _buildBadge(kursus.level, colorScheme.secondaryContainer,
                      colorScheme.onSecondaryContainer),
                ],
              ),
              const SizedBox(height: 8),

              // Rating dan jumlah siswa
              Row(
                children: [
                  const Icon(Icons.star, size: 14, color: Colors.amber),
                  const SizedBox(width: 2),
                  Text(
                    kursus.rating.toString(),
                    style: theme.textTheme.bodySmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  const Icon(Icons.people, size: 14),
                  const SizedBox(width: 2),
                  Text(
                    '${kursus.jumlahSiswa}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
