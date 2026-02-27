import 'package:flutter/material.dart';

class AppTheme {
  static const primary = Color(0xFF2D6CDF);

  static ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: primary),
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Roboto',
  );
}