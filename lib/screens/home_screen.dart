import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'game_screen.dart';
import 'guide_screen.dart';

/// Ganti nama di sini kalau ingin ditampilkan berbeda.
const String kCreatorName = 'Arneva';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _teamAController = TextEditingController(text: 'Tim A');
  final _teamBController = TextEditingController(text: 'Tim B');

  @override
  void dispose() {
    _teamAController.dispose();
    _teamBController.dispose();
    super.dispose();
  }

  void _startMatch() {
    final nameA = _teamAController.text.trim().isEmpty ? 'Tim A' : _teamAController.text.trim();
    final nameB = _teamBController.text.trim().isEmpty ? 'Tim B' : _teamBController.text.trim();

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => GameScreen(teamAName: nameA, teamBName: nameB)),
    );
  }

  void _openGuide() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const GuideScreen()));
  }

  InputDecoration _fieldDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryGreenDark,
              AppColors.primaryGreenLight,
              AppColors.cream,
            ],
            stops: [0, 0.35, 0.35],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton.icon(
                    onPressed: _openGuide,
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                    icon: const Icon(Icons.menu_book_outlined, size: 18),
                    label: const Text('Panduan'),
                  ),
                ),
                const Icon(Icons.casino, size: 56, color: Colors.white),
                const SizedBox(height: 12),
                const Text(
                  'Skor Gaple',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const Text(
                  'Penghitung skor domino, offline',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 32),
                Card(
                  elevation: 8,
                  shadowColor: Colors.black26,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Masukkan nama kedua tim',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 18),
                        TextField(
                          controller: _teamAController,
                          decoration: _fieldDecoration('Nama Tim A', Icons.groups),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: _teamBController,
                          decoration: _fieldDecoration('Nama Tim B', Icons.groups_2),
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          onPressed: _startMatch,
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            backgroundColor: AppColors.primaryGreen,
                          ),
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Mulai Pertandingan', style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Dibuat oleh $kCreatorName',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.primaryGreenDark.withOpacity(0.7), fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
