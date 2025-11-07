import 'package:flutter/material.dart';

class GameTheme {
  final int id;
  final String name;
  final int coinCost;
  final int? gemCost;
  final List<Color> buttonColors;
  final Color bgPrimary;
  final Color bgSecondary;
  final Color textPrimary;
  final Color textSecondary;
  final Color accent;

  const GameTheme({
    required this.id,
    required this.name,
    required this.coinCost,
    this.gemCost,
    required this.buttonColors,
    required this.bgPrimary,
    required this.bgSecondary,
    required this.textPrimary,
    required this.textSecondary,
    required this.accent,
  });

  static List<GameTheme> getAllThemes() {
    return [
      // 1. Classic (Default/Free)
      const GameTheme(
        id: 0,
        name: 'Classic',
        coinCost: 0,
        buttonColors: [
          Color(0xFFFF3B30), // Red
          Color(0xFF007AFF), // Blue
          Color(0xFF34C759), // Green
          Color(0xFFFFCC00), // Yellow
          Color(0xFFFF9500), // Orange
          Color(0xFFAF52DE), // Purple
          Color(0xFFFF2D55), // Pink
          Color(0xFF5AC8FA), // Cyan
        ],
        bgPrimary: Color(0xFFFFFFFF),
        bgSecondary: Color(0xFFF2F2F7),
        textPrimary: Color(0xFF000000),
        textSecondary: Color(0xFF3C3C43),
        accent: Color(0xFF007AFF),
      ),

      // 2. Dark Mode (50 coins)
      const GameTheme(
        id: 1,
        name: 'Dark Mode',
        coinCost: 50,
        buttonColors: [
          Color(0xFFFF453A), // Bright Red
          Color(0xFF0A84FF), // Bright Blue
          Color(0xFF32D74B), // Bright Green
          Color(0xFFFFD60A), // Bright Yellow
          Color(0xFFFF9F0A), // Bright Orange
          Color(0xFFBF5AF2), // Bright Purple
          Color(0xFFFF375F), // Bright Pink
          Color(0xFF64D2FF), // Bright Cyan
        ],
        bgPrimary: Color(0xFF1C1C1E),
        bgSecondary: Color(0xFF2C2C2E),
        textPrimary: Color(0xFFFFFFFF),
        textSecondary: Color(0xFFEBEBF5),
        accent: Color(0xFF0A84FF),
      ),

      // 3. Pastel Dreams (100 coins)
      const GameTheme(
        id: 2,
        name: 'Pastel Dreams',
        coinCost: 100,
        buttonColors: [
          Color(0xFFFFB3BA), // Pastel Red
          Color(0xFFBAE1FF), // Pastel Blue
          Color(0xFFBAFFBA), // Pastel Green
          Color(0xFFFFFFBA), // Pastel Yellow
          Color(0xFFFFDFBA), // Pastel Orange
          Color(0xFFE0BBE4), // Pastel Purple
          Color(0xFFFFD1DC), // Pastel Pink
          Color(0xFFB4F8C8), // Pastel Mint
        ],
        bgPrimary: Color(0xFFFFF5F7),
        bgSecondary: Color(0xFFFFE5E9),
        textPrimary: Color(0xFF5A5A5A),
        textSecondary: Color(0xFF8A8A8A),
        accent: Color(0xFFFFB3BA),
      ),

      // 4. Neon Nights (150 coins)
      const GameTheme(
        id: 3,
        name: 'Neon Nights',
        coinCost: 150,
        buttonColors: [
          Color(0xFFFF006E), // Neon Pink
          Color(0xFF00F5FF), // Neon Cyan
          Color(0xFF39FF14), // Neon Green
          Color(0xFFFFFF00), // Neon Yellow
          Color(0xFFFF6600), // Neon Orange
          Color(0xFFBF00FF), // Neon Purple
          Color(0xFFFF1493), // Neon Magenta
          Color(0xFF00FFFF), // Neon Aqua
        ],
        bgPrimary: Color(0xFF0A0A0A),
        bgSecondary: Color(0xFF1A1A1A),
        textPrimary: Color(0xFFFFFFFF),
        textSecondary: Color(0xFFCCCCCC),
        accent: Color(0xFFFF006E),
      ),

      // 5. Ocean Breeze (200 coins)
      const GameTheme(
        id: 4,
        name: 'Ocean Breeze',
        coinCost: 200,
        buttonColors: [
          Color(0xFF006994), // Deep Ocean Blue
          Color(0xFF0099CC), // Sky Blue
          Color(0xFF66D9EF), // Light Blue
          Color(0xFF9EEAF9), // Pale Blue
          Color(0xFF00C9A7), // Teal
          Color(0xFF4D8FAC), // Steel Blue
          Color(0xFF7FCDCD), // Turquoise
          Color(0xFFB8E6E6), // Mint Blue
        ],
        bgPrimary: Color(0xFFF0F8FF),
        bgSecondary: Color(0xFFE0F2F7),
        textPrimary: Color(0xFF1A4D5C),
        textSecondary: Color(0xFF4D7A8C),
        accent: Color(0xFF0099CC),
      ),

      // 6. Sunset Vibes (250 coins)
      const GameTheme(
        id: 5,
        name: 'Sunset Vibes',
        coinCost: 250,
        buttonColors: [
          Color(0xFFFF6B6B), // Coral Red
          Color(0xFFFF8E53), // Sunset Orange
          Color(0xFFFFA07A), // Light Salmon
          Color(0xFFFFD93D), // Golden Yellow
          Color(0xFFFFA500), // Warm Orange
          Color(0xFFFF69B4), // Hot Pink
          Color(0xFFFF7F50), // Coral
          Color(0xFFFFDAB9), // Peach
        ],
        bgPrimary: Color(0xFFFFF4E6),
        bgSecondary: Color(0xFFFFE4CC),
        textPrimary: Color(0xFF5C3D2E),
        textSecondary: Color(0xFF8C6D5C),
        accent: Color(0xFFFF8E53),
      ),

      // 7. Forest Fresh (300 coins)
      const GameTheme(
        id: 6,
        name: 'Forest Fresh',
        coinCost: 300,
        buttonColors: [
          Color(0xFF2D5016), // Dark Green
          Color(0xFF4A7C2C), // Forest Green
          Color(0xFF6FA82F), // Grass Green
          Color(0xFF8BC34A), // Light Green
          Color(0xFF9CCC65), // Lime Green
          Color(0xFFAED581), // Pale Green
          Color(0xFF7CB342), // Olive Green
          Color(0xFFC5E1A5), // Mint
        ],
        bgPrimary: Color(0xFFF1F8E9),
        bgSecondary: Color(0xFFDCEDC8),
        textPrimary: Color(0xFF2D5016),
        textSecondary: Color(0xFF5C7A3C),
        accent: Color(0xFF6FA82F),
      ),

      // 8. Galaxy (500 coins or 50 gems)
      const GameTheme(
        id: 7,
        name: 'Galaxy',
        coinCost: 500,
        gemCost: 50,
        buttonColors: [
          Color(0xFF9D00FF), // Cosmic Purple
          Color(0xFF6B00B3), // Deep Purple
          Color(0xFFB026FF), // Violet
          Color(0xFFD966FF), // Light Purple
          Color(0xFFFF00FF), // Magenta
          Color(0xFFFF66FF), // Pink Purple
          Color(0xFF8000FF), // Electric Purple
          Color(0xFFCC99FF), // Lavender
        ],
        bgPrimary: Color(0xFF0D0221),
        bgSecondary: Color(0xFF1A1033),
        textPrimary: Color(0xFFFFFFFF),
        textSecondary: Color(0xFFD4A5FF),
        accent: Color(0xFF9D00FF),
      ),
    ];
  }

  static GameTheme getThemeById(int id) {
    final themes = getAllThemes();
    return themes.firstWhere((theme) => theme.id == id, orElse: () => themes[0]);
  }
}
