import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/home_screen.dart';
import 'theme/app_colors.dart';

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
    return MaterialApp(
      title: 'Skor Gaple',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: AppColors.primaryGreen,
        scaffoldBackgroundColor: AppColors.cream,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
