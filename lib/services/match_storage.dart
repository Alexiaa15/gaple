import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/team.dart';

/// Menyimpan & memulihkan progress pertandingan yang sedang berjalan,
/// supaya kalau aplikasi ditutup, saat dibuka lagi bisa dilanjutkan.
class MatchStorage {
  MatchStorage._();

  static const _key = 'saved_match_v1';

  static Future<void> save({required Team teamA, required Team teamB}) async {
    final prefs = await SharedPreferences.getInstance();
    final data = {'teamA': teamA.toJson(), 'teamB': teamB.toJson()};
    await prefs.setString(_key, jsonEncode(data));
  }

  /// Mengembalikan null jika belum ada pertandingan tersimpan, atau data
  /// tersimpan rusak/tidak bisa dibaca.
  static Future<Map<String, dynamic>?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
