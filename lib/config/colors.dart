import 'package:flutter/material.dart';

class AppColors {
  // Button colors (for game sequence)
  static const Color red = Color(0xFFFF3B30);
  static const Color blue = Color(0xFF007AFF);
  static const Color green = Color(0xFF34C759);
  static const Color yellow = Color(0xFFFFCC00);
  static const Color orange = Color(0xFFFF9500);
  static const Color purple = Color(0xFFAF52DE);
  static const Color pink = Color(0xFFFF2D55);
  static const Color cyan = Color(0xFF5AC8FA);

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

  // Common colors
  static const Color accent = blue;
  static const Color success = green;
  static const Color warning = orange;
  static const Color error = red;
  static const Color coin = yellow;
  static const Color gem = purple;

  // Get button colors list
  static List<Color> getButtonColors(int count) {
    const colors = [red, blue, green, yellow, orange, purple, pink, cyan];
    return colors.take(count).toList();
  }

  // Get color by index
  static Color getColorByIndex(int index) {
    const colors = [red, blue, green, yellow, orange, purple, pink, cyan];
    return colors[index % colors.length];
  }
}
