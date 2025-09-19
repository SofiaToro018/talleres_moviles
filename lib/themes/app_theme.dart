import 'package:flutter/material.dart';

class AppTheme {
  // Color lila personalizado
  static const Color lila = Color(0xFFB39DDB); // Puedes ajustar el tono

  // Color para las tarjetas
  static const Color cardColor = lila;

  // Fuente personalizada (ejemplo: 'Montserrat')
  static const String fontFamily = 'Montserrat';

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: lila,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      fontFamily: fontFamily,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: lila,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: fontFamily,
        ),
      ),
      drawerTheme: const DrawerThemeData(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      cardColor: cardColor,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black87, fontFamily: fontFamily),
        bodyMedium: TextStyle(color: Colors.black87, fontFamily: fontFamily),
      ),
    );
  }
}
