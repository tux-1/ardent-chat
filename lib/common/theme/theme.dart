import 'package:flutter/material.dart';

final ThemeData kLightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF6A00FF), // Purple for buttons and accents
    onPrimary: Colors.white, // White text/icons on primary color
    secondary: Color(0xFFF5F5F5), // Light grey for background areas
    onSecondary: Color(0xFF333333), // Dark text on secondary elements
    surface: Colors.white, // Surface colors like cards
    onSurface: Color(0xFF333333), // Text color on surfaces
  ),
  scaffoldBackgroundColor: const Color(0xFFF9F9F9), // Light background
);

final ThemeData kDarkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF6A00FF), // Purple for buttons and accents
    onPrimary: Colors.white, // White text/icons on primary color
    secondary: Color(0xFF333333), // Dark grey for background areas
    onSecondary: Color(0xFFF5F5F5), // Light text on dark elements
    surface: Color(0xFF222222), // Dark surface colors
    onSurface: Colors.white, // Light text on dark surfaces
  ),
  scaffoldBackgroundColor: const Color(0xFF121212), // Dark background
);
