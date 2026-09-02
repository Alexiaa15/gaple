import 'package:flutter/material.dart';

import '../models/team.dart';
import '../services/match_storage.dart';
import '../theme/app_colors.dart';
import '../theme/theme_controller.dart';
import 'game_screen.dart';
import 'guide_screen.dart';
import 'whats_new_screen.dart';

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

  Map<String, dynamic>? _savedMatch;
  bool _loadingSavedMatch = true;

  @override
  void initState() {
    super.initState();
    _loadSavedMatch();
  }

  Future<void> _loadSavedMatch() async {
    final saved = await MatchStorage.load();
    if (!mounted) return;
    setState(() {
      _savedMatch = saved;
      _loadingSavedMatch = false;
    });
  }

  @override
  void dispose() {
    _teamAController.dispose();
    _teamBController.dispose();
    super.dispose();
  }

  Future<void> _startNewMatch() async {
    final nameA = _teamAController.text.trim().isEmpty ? 'Tim A' : _teamAController.text.trim();
    final nameB = _teamBController.text.trim().isEmpty ? 'Tim B' : _teamBController.text.trim();

    final teamA = Team(name: nameA);
    final teamB = Team(name: nameB);

    // Pertandingan baru menggantikan pertandingan tersimpan sebelumnya.
    await MatchStorage.save(teamA: teamA, teamB: teamB);
    if (!mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => GameScreen(teamA: teamA, teamB: teamB)),
    ).then((_) => _loadSavedMatch());
  }

  void _continueMatch() {
    final saved = _savedMatch;
    if (saved == null) return;

    final teamA = Team.fromJson(saved['teamA'] as Map<String, dynamic>);
    final teamB = Team.fromJson(saved['teamB'] as Map<String, dynamic>);

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => GameScreen(teamA: teamA, teamB: teamB)),
    ).then((_) => _loadSavedMatch());
  }

  void _openGuide() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const GuideScreen()));
  }

  void _openWhatsNew() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const WhatsNewScreen()));
  }

  InputDecoration _fieldDecoration(BuildContext context, String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Theme.of(context).cardColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildContinueCard(BuildContext context) {
    final saved = _savedMatch!;
    final teamA = Team.fromJson(saved['teamA'] as Map<String, dynamic>);
    final teamB = Team.fromJson(saved['teamB'] as Map<String, dynamic>);

    return Card(
      elevation: 8,
      shadowColor: Colors.black26,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.history, color: AppColors.primaryGreen),
                const SizedBox(width: 8),
                const Text(
                  'Pertandingan Tersimpan',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '${teamA.name} (${teamA.matchScore})  vs  ${teamB.name} (${teamB.matchScore})',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _continueMatch,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                backgroundColor: AppColors.primaryGreen,
              ),
              icon: const Icon(Icons.play_circle_outline),
              label: const Text('Lanjutkan Pertandingan'),
            ),
          ],
        ),
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
              Colors.transparent,
            ],
            stops: [0, 0.42, 0.42],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimatedBuilder(
                        animation: themeController,
                        builder: (context, _) => IconButton(
                          onPressed: themeController.toggle,
                          style: IconButton.styleFrom(foregroundColor: Colors.white),
                          icon: Icon(
                            themeController.isDark ? Icons.light_mode : Icons.dark_mode,
                          ),
                          tooltip: themeController.isDark ? 'Mode Terang' : 'Mode Gelap',
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: _openWhatsNew,
                            style: IconButton.styleFrom(foregroundColor: Colors.white),
                            icon: const Icon(Icons.campaign_outlined),
                            tooltip: 'Apa yang Baru',
                          ),
                          IconButton(
                            onPressed: _openGuide,
                            style: IconButton.styleFrom(foregroundColor: Colors.white),
                            icon: const Icon(Icons.menu_book_outlined),
                            tooltip: 'Panduan',
                          ),
                        ],
                      ),
                    ],
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
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 32),
                  if (!_loadingSavedMatch && _savedMatch != null) ...[
                    _buildContinueCard(context),
                    const SizedBox(height: 16),
                    Text(
                      'atau mulai pertandingan baru',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : AppColors.primaryGreenDark.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Card(
                    elevation: 8,
                    shadowColor: Colors.black26,
                    color: Theme.of(context).cardColor,
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
                            decoration: _fieldDecoration(context, 'Nama Tim A', Icons.groups),
                          ),
                          const SizedBox(height: 14),
                          TextField(
                            controller: _teamBController,
                            decoration: _fieldDecoration(context, 'Nama Tim B', Icons.groups_2),
                          ),
                          const SizedBox(height: 24),
                          FilledButton.icon(
                            onPressed: _startNewMatch,
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
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : AppColors.primaryGreenDark.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
