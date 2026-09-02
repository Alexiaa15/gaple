import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/game_controller.dart';
import '../models/team.dart';
import '../theme/app_colors.dart';

/// Palet warna tema untuk tiap tim, supaya kedua panel mudah dibedakan
/// sekilas mata (bukan sekadar teks polos di atas putih).
class _TeamTheme {
  const _TeamTheme({required this.primary, required this.dark, required this.light});
  final Color primary;
  final Color dark;
  final Color light;
}

const _teamAColors = _TeamTheme(
  primary: AppColors.teamABlue,
  dark: AppColors.teamABlueDark,
  light: AppColors.teamABlueLight,
);

const _teamBColors = _TeamTheme(
  primary: AppColors.teamBRed,
  dark: AppColors.teamBRedDark,
  light: AppColors.teamBRedLight,
);

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, required this.teamAName, required this.teamBName});

  final String teamAName;
  final String teamBName;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final Team _teamA = Team(name: widget.teamAName);
  late final Team _teamB = Team(name: widget.teamBName);
  late final GameController _controller = GameController(teamA: _teamA, teamB: _teamB);

  Future<int?> _showPointsInputDialog({required String title, int? initialValue}) {
    final textController = TextEditingController(
      text: initialValue == null ? '' : '$initialValue',
    );

    return showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title),
        content: TextField(
          controller: textController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Contoh: 15',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) {
            final value = int.tryParse(textController.text.trim());
            Navigator.of(context).pop(value);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              final value = int.tryParse(textController.text.trim());
              Navigator.of(context).pop(value);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  Future<void> _addPoints(Team team) async {
    final points = await _showPointsInputDialog(title: 'Poin masuk — ${team.name}');
    if (points == null || points <= 0) return;

    final result = _controller.addPoints(team, points);
    setState(() {});
    if (result.roundEnded) _showRoundEndedDialog(result.winner!, result.loserWasZero!);
  }

  Future<void> _editEntry(Team team, PointEntry entry) async {
    final newPoints = await _showPointsInputDialog(
      title: 'Ubah poin — ${team.name}',
      initialValue: entry.points,
    );
    if (newPoints == null || newPoints <= 0) return;

    final result = _controller.editEntry(team, entry.id, newPoints);
    setState(() {});
    if (result.roundEnded) _showRoundEndedDialog(result.winner!, result.loserWasZero!);
  }

  void _deleteEntry(Team team, PointEntry entry) {
    final index = _controller.deleteEntryById(team, entry.id);
    setState(() {});

    if (index == -1) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Poin ${entry.points} milik ${team.name} dihapus'),
        action: SnackBarAction(
          label: 'Urungkan',
          onPressed: () => setState(() => team.insertEntryAt(index, entry)),
        ),
      ),
    );
  }

  void _showRoundEndedDialog(Team winner, bool loserWasZero) {
    final bonusText = loserWasZero
        ? 'Lawan masih kosong (0 poin) → skor +2 🎉'
        : 'Lawan sudah kebobolan poin → skor +1';

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: const Icon(Icons.emoji_events, color: Colors.amber, size: 40),
        title: const Text('Ronde Selesai!'),
        content: Text(
          '${winner.name} mencapai $kTargetPoints poin!\n$bonusText\n\n'
          'Skor pertandingan sekarang:\n'
          '${_teamA.name}: ${_teamA.matchScore}   •   ${_teamB.name}: ${_teamB.matchScore}',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Lanjut Ronde Berikutnya'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmResetMatch() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Reset Pertandingan?'),
        content: const Text('Skor pertandingan dan histori poin ronde akan diatur ulang ke 0.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red.shade600),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true) setState(() => _controller.resetMatch());
  }

  Widget _buildTeamPanel(Team team, _TeamTheme theme) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: theme.primary.withOpacity(0.25),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header dengan gradient warna khas tim.
            Container(
              padding: const EdgeInsets.fromLTRB(16, 22, 16, 18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [theme.primary, theme.dark],
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.white.withOpacity(0.25),
                        child: Text(
                          team.name.isNotEmpty ? team.name[0].toUpperCase() : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          team.name,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.35)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.emoji_events, size: 22, color: Color(0xFFFFD54F)),
                        const SizedBox(width: 8),
                        Text(
                          '${team.matchScore}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            'SKOR',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Poin sementara (akumulasi ronde berjalan) — angka besar, tanpa "/101".
            Container(
              color: theme.light,
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Column(
                children: [
                  Text(
                    'POIN SEMENTARA',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.1,
                      color: theme.dark.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 2),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Text(
                      '${team.roundPoints}',
                      key: ValueKey(team.roundPoints),
                      style: TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.w800,
                        color: theme.dark,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Histori entri poin — bisa diedit/dihapus.
            Expanded(
              child: Container(
                color: Colors.white,
                child: team.entries.isEmpty
                    ? Center(
                        child: Text(
                          'Belum ada poin\nmasuk di ronde ini',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        itemCount: team.entries.length,
                        separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade200),
                        itemBuilder: (context, index) {
                          final entry = team.entries[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                            child: Row(
                              children: [
                                Container(
                                  width: 22,
                                  height: 22,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: theme.light,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(fontSize: 10, color: theme.dark, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '+${entry.points}',
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                  ),
                                ),
                                InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () => _editEntry(team, entry),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Icon(Icons.edit_outlined, size: 16, color: Colors.grey.shade500),
                                  ),
                                ),
                                InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () => _deleteEntry(team, entry),
                                  child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Icon(Icons.delete_outline, size: 16, color: Colors.red.shade300),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),

            // Tombol tambah poin.
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () => _addPoints(team),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Poin Masuk'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Skor Gaple'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primaryGreenDark, AppColors.primaryGreenLight],
            ),
          ),
        ),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _confirmResetMatch,
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Pertandingan',
          ),
        ],
      ),
      body: SafeArea(
        child: Row(
          children: [
            _buildTeamPanel(_teamA, _teamAColors),
            _buildTeamPanel(_teamB, _teamBColors),
          ],
        ),
      ),
    );
  }
}
