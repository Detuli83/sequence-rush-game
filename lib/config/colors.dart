import 'package:flutter/material.dart';

/// App color constants
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Brand colors
  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFFFF6584);
  static const Color accent = Color(0xFF00D9FF);

  // Currency colors (required by currency_display.dart)
  static const Color coin = Color(0xFFFFD700); // Gold color for coins
  static const Color gem = Color(0xFF00BFFF);  // Diamond blue for gems

  // Background colors
  static const Color background = Color(0xFF1A1A2E);
  static const Color backgroundLight = Color(0xFF16213E);
  static const Color backgroundDark = Color(0xFF0F0F1E);

  // UI colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFFF5252);
  static const Color info = Color(0xFF2196F3);

  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB8B8B8);
  static const Color textDisabled = Color(0xFF757575);

  // Game button colors (8 colors for the memory game)
  static const Color red = Color(0xFFFF3B30);
  static const Color blue = Color(0xFF007AFF);
  static const Color green = Color(0xFF34C759);
  static const Color yellow = Color(0xFFFFCC00);
  static const Color orange = Color(0xFFFF9500);
  static const Color purple = Color(0xFFAF52DE);
  static const Color pink = Color(0xFFFF2D55);
  static const Color cyan = Color(0xFF5AC8FA);

  // Legacy button colors (for backward compatibility)
  static const Color buttonRed = red;
  static const Color buttonBlue = blue;
  static const Color buttonGreen = green;
  static const Color buttonYellow = yellow;
  static const Color buttonOrange = orange;
  static const Color buttonPurple = purple;
  static const Color buttonPink = pink;
  static const Color buttonTeal = cyan;

  // UI colors - Light theme
  static const Color lightBgPrimary = Color(0xFFFFFFFF);
  static const Color lightBgSecondary = Color(0xFFF2F2F7);
  static const Color lightTextPrimary = Color(0xFF000000);
  static const Color lightTextSecondary = Color(0xFF3C3C43);

  // UI colors - Dark theme
  static const Color darkBgPrimary = Color(0xFF1C1C1E);
  static const Color darkBgSecondary = Color(0xFF2C2C2E);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFEBEBF5);

  // Additional UI colors
  static const Color cardBackground = Color(0xFF2A2A3E);
  static const Color divider = Color(0xFF3A3A4E);
  static const Color overlay = Color(0x80000000);

  // Get button colors list
  static List<Color> getButtonColors(int count) {
    const colors = [red, blue, green, yellow, orange, purple, pink, cyan];
    return colors.take(count).toList();
  }
}
