/// Satu entri poin yang masuk ke suatu tim dalam ronde berjalan.
/// Disimpan sebagai histori supaya bisa diedit/dihapus jika salah input.
class PointEntry {
  PointEntry({required this.id, required this.points});

  final String id;
  int points;
}

/// Model untuk satu tim dalam permainan gaple.
///
/// Poin ronde berjalan TIDAK disimpan sebagai angka tunggal, melainkan
/// dihitung dari total [entries] — supaya begitu satu entri diedit/dihapus,
/// totalnya otomatis ikut berubah.
class Team {
  Team({required this.name, this.matchScore = 0});

  String name;
  int matchScore;
  final List<PointEntry> entries = [];

  /// Total poin sementara (akumulasi) di ronde yang sedang berjalan.
  int get roundPoints => entries.fold(0, (sum, e) => sum + e.points);

  void addEntry(PointEntry entry) => entries.add(entry);

  void removeEntryAt(int index) => entries.removeAt(index);

  void insertEntryAt(int index, PointEntry entry) =>
      entries.insert(index, entry);

  void updateEntry(String id, int newPoints) {
    final entry = entries.firstWhere((e) => e.id == id);
    entry.points = newPoints;
  }

  /// Reset histori poin ronde (dipanggil setelah salah satu tim mencapai target).
  void resetRound() => entries.clear();
}
