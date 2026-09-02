import 'package:flutter/material.dart';

/// Palet warna aplikasi — diambil dari warna-warna khas icon aplikasi
/// (latar hijau, meja kayu, kertas krem, dan scoreboard biru/merah).
class AppColors {
  AppColors._();

  // Hijau — warna utama, diambil dari latar belakang icon.
  static const Color primaryGreenDark = Color(0xFF0A4D1F);
  static const Color primaryGreen = Color(0xFF0F7A31);
  static const Color primaryGreenLight = Color(0xFF1B9142);

  // Krem — dari kertas notes di icon, dipakai sebagai latar panel/kartu.
  static const Color cream = Color(0xFFFBF7EF);
  static const Color creamCard = Color(0xFFF3E6D4);

  // Kayu — aksen coklat dari meja pada icon.
  static const Color wood = Color(0xFF753814);

  // Biru & merah — dari scoreboard digital pada icon, dipakai sebagai
  // warna pembeda Tim A dan Tim B.
  static const Color teamABlue = Color(0xFF00499F);
  static const Color teamABlueDark = Color(0xFF002B5E);
  static const Color teamABlueLight = Color(0xFFE3ECFB);

  static const Color teamBRed = Color(0xFFD92215);
  static const Color teamBRedDark = Color(0xFF7A0F0A);
  static const Color teamBRedLight = Color(0xFFFDE7E5);
}
