import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class _UpdateGroup {
  const _UpdateGroup({required this.title, required this.icon, required this.items});
  final String title;
  final IconData icon;
  final List<String> items;
}

// Urutan dari yang terbaru ke yang paling lama.
const _updates = [
  _UpdateGroup(
    title: 'Mode Gelap & Lanjutkan Pertandingan',
    icon: Icons.dark_mode,
    items: [
      'Tambah mode gelap dan terang, tinggal tap ikon matahari/bulan.',
      'Progress pertandingan otomatis tersimpan — kalau aplikasi ditutup, saat dibuka lagi bisa lanjut dari home screen, atau mulai baru kalau mau.',
    ],
  ),
  _UpdateGroup(
    title: 'Tampilan Baru & Panduan',
    icon: Icons.palette,
    items: [
      'Icon aplikasi kustom, plus warna aplikasi kini mengikuti warna khas icon (hijau, biru, merah).',
      'Halaman Panduan baru untuk menjelaskan aturan skor & cara pakai fitur.',
      'Nama pembuat aplikasi ditampilkan di home screen.',
    ],
  ),
  _UpdateGroup(
    title: 'Perbaikan Tampilan Skor',
    icon: Icons.visibility,
    items: [
      'Skor pertandingan dibuat lebih besar dan kontras supaya gampang dibaca sekilas.',
      'Aplikasi dikunci hanya bisa portrait (tidak bisa landscape).',
    ],
  ),
  _UpdateGroup(
    title: 'Histori Poin & Desain Ulang',
    icon: Icons.history,
    items: [
      'Setiap poin masuk kini tersimpan sebagai riwayat, bisa diedit atau dihapus kalau salah input.',
      'Poin sementara ronde berjalan ditampilkan tanpa target "/101" agar lebih ringkas.',
      'Desain kartu tim dirombak total — lebih berwarna dan tidak polos.',
    ],
  ),
  _UpdateGroup(
    title: 'Rilis Awal',
    icon: Icons.rocket_launch,
    items: [
      'Aplikasi Skor Gaple offline untuk 2 tim.',
      'Ronde berakhir di 101 poin, dengan bonus skor +1 (biasa) atau +2 (lawan kosong).',
    ],
  ),
];

class WhatsNewScreen extends StatelessWidget {
  const WhatsNewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Apa yang Baru'),
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
        itemCount: _updates.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final group = _updates[index];
          final isLatest = index == 0;

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(18),
              border: isLatest ? Border.all(color: AppColors.primaryGreen, width: 1.4) : null,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGreen.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.primaryGreenDark.withOpacity(0.35)
                            : AppColors.creamCard,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        group.icon,
                        size: 18,
                        color: isDark ? AppColors.primaryGreenLight : AppColors.primaryGreenDark,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        group.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.primaryGreenLight : AppColors.primaryGreenDark,
                        ),
                      ),
                    ),
                    if (isLatest)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'TERBARU',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                ...group.items.map(
                  (text) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Icon(Icons.circle, size: 5, color: Colors.grey.shade500),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            text,
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.4,
                              color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
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
