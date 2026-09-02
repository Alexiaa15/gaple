import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class _GuideItem {
  const _GuideItem({required this.icon, required this.title, required this.description});
  final IconData icon;
  final String title;
  final String description;
}

const _guideItems = [
  _GuideItem(
    icon: Icons.flag_circle,
    title: 'Target 101 Poin',
    description:
        'Setiap ronde, kedua tim mengumpulkan "poin masuk" masing-masing. '
        'Ronde berakhir begitu salah satu tim mencapai atau melewati 101 poin.',
  ),
  _GuideItem(
    icon: Icons.emoji_events,
    title: 'Skor +1 (Menang Biasa)',
    description:
        'Jika tim yang kalah sudah sempat kemasukan poin (poin > 0) saat ronde '
        'berakhir, tim pemenang mendapat tambahan 1 skor pertandingan.',
  ),
  _GuideItem(
    icon: Icons.workspace_premium,
    title: 'Skor +2 (Menang Kosong)',
    description:
        'Jika tim yang kalah masih 0 poin sama sekali (kosong/gaple) saat lawan '
        'mencapai 101, tim pemenang langsung mendapat 2 skor pertandingan sekaligus.',
  ),
  _GuideItem(
    icon: Icons.add_circle_outline,
    title: 'Menambah Poin Masuk',
    description:
        'Tekan tombol "Poin Masuk" di kartu tim, lalu masukkan jumlah poin yang '
        'didapat pada giliran tersebut. Poin otomatis terakumulasi di "Poin Sementara".',
  ),
  _GuideItem(
    icon: Icons.edit_outlined,
    title: 'Mengedit / Menghapus Poin',
    description:
        'Salah input? Setiap entri poin di riwayat punya ikon pensil untuk mengubah '
        'nilainya, dan ikon tempat sampah untuk menghapusnya. Poin yang terhapus bisa '
        'diurungkan lewat notifikasi yang muncul di bawah layar.',
  ),
  _GuideItem(
    icon: Icons.refresh,
    title: 'Reset Pertandingan',
    description:
        'Tekan ikon refresh di pojok kanan atas layar permainan untuk mengatur ulang '
        'skor pertandingan dan riwayat poin kembali ke 0.',
  ),
  _GuideItem(
    icon: Icons.screen_lock_portrait,
    title: 'Mode Portrait',
    description:
        'Aplikasi ini dikunci hanya bisa digunakan dalam posisi tegak (portrait) '
        'agar kedua kartu tim tetap nyaman dilihat berdampingan.',
  ),
];

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Panduan'),
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primaryGreenDark, AppColors.primaryGreenLight],
            ),
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _guideItems.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = _guideItems[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGreen.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.creamCard,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(item.icon, color: AppColors.primaryGreenDark, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreenDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
