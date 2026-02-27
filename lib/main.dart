import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/presentation/screens/welcome_screen.dart';

void main() {
  runApp(const BabiVoyageLiteApp());
}

class BabiVoyageLiteApp extends StatelessWidget {
  const BabiVoyageLiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BabiVoyage Lite',
      theme: AppTheme.light,
      home: const WelcomeScreen(),
    );
  }
}