import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Kunci aplikasi hanya bisa portrait (tidak bisa landscape).
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const GapleScoreApp());
}

class GapleScoreApp extends StatelessWidget {
  const GapleScoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Dengarkan themeController — begitu mode gelap/terang diganti,
    // seluruh aplikasi otomatis rebuild dengan tema baru.
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) {
        return MaterialApp(
          title: 'Skor Gaple',
          debugShowCheckedModeBanner: false,
          themeMode: themeController.mode,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          home: const HomeScreen(),
        );
      },
    );
  }
}
