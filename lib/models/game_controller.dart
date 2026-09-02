import 'team.dart';

const int kTargetPoints = 101;

/// Hasil dari satu kali penambahan/perubahan poin, berisi info apakah
/// ronde berakhir karena aksi tersebut.
class RoundResult {
  RoundResult({required this.roundEnded, this.winner, this.loserWasZero});

  final bool roundEnded;
  final Team? winner;
  final bool? loserWasZero;
}

/// Mengelola aturan permainan:
/// - Tim A dan Tim B saling menambah poin masuk tiap giliran (tersimpan
///   sebagai histori entri, bukan angka tunggal).
/// - Ronde berakhir saat total poin salah satu tim mencapai >= 101.
/// - Jika tim yang kalah masih punya poin (poin > 0) saat ronde berakhir,
///   tim pemenang mendapat skor pertandingan +1.
/// - Jika tim yang kalah masih 0 poin (kosong/gaple), tim pemenang
///   langsung mendapat skor pertandingan +2.
class GameController {
  GameController({required this.teamA, required this.teamB});

  final Team teamA;
  final Team teamB;

  int _nextId = 0;
  String _generateId() => '${_nextId++}_${DateTime.now().microsecondsSinceEpoch}';

  /// Tambahkan entri poin baru ke [team], lalu cek apakah ronde berakhir.
  RoundResult addPoints(Team team, int points) {
    team.addEntry(PointEntry(id: _generateId(), points: points));
    return _checkRoundEnd(team);
  }

  /// Ubah nilai entri poin yang sudah ada (perbaikan salah input).
  RoundResult editEntry(Team team, String entryId, int newPoints) {
    team.updateEntry(entryId, newPoints);
    return _checkRoundEnd(team);
  }

  /// Hapus entri poin yang salah. Mengembalikan index-nya supaya bisa
  /// di-undo (insert kembali) oleh UI jika perlu.
  int deleteEntryById(Team team, String entryId) {
    final index = team.entries.indexWhere((e) => e.id == entryId);
    if (index != -1) team.removeEntryAt(index);
    return index;
  }

  RoundResult _checkRoundEnd(Team team) {
    final Team other = identical(team, teamA) ? teamB : teamA;

    if (team.roundPoints >= kTargetPoints) {
      final bool loserWasZero = other.roundPoints == 0;
      team.matchScore += loserWasZero ? 2 : 1;

      teamA.resetRound();
      teamB.resetRound();

      return RoundResult(
        roundEnded: true,
        winner: team,
        loserWasZero: loserWasZero,
      );
    }

    return RoundResult(roundEnded: false);
  }

  void resetMatch() {
    teamA.matchScore = 0;
    teamB.matchScore = 0;
    teamA.resetRound();
    teamB.resetRound();
  }
}
