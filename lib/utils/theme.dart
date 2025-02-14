import 'package:flutter/material.dart';

ThemeData appTheme(BuildContext context, bool isDarkMode) {
  return ThemeData(
    useMaterial3: true,
    brightness: isDarkMode ? Brightness.dark : Brightness.light,
    primaryColor: isDarkMode ? Colors.blueAccent : Colors.indigo,
    scaffoldBackgroundColor: isDarkMode ? Colors.black : Colors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: isDarkMode ? Colors.blueAccent : Colors.indigo,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        color: isDarkMode ? Colors.white70 : Colors.black87,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: isDarkMode ? Colors.black87 : Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
      iconTheme: IconThemeData(
        color: isDarkMode ? Colors.white : Colors.black,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: isDarkMode ? Colors.blueAccent : Colors.indigo,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    ),
    cardTheme: CardTheme(
      color: isDarkMode ? Colors.grey[900] : Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: isDarkMode ? Colors.black87 : Colors.white,
      selectedItemColor: isDarkMode ? Colors.blueAccent : Colors.indigo,
      unselectedItemColor: isDarkMode ? Colors.white70 : Colors.black54,
    ),
  );
}
