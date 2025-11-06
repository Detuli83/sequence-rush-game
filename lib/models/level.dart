import '../config/constants.dart';

/// Represents a game level with its configuration
/// Based on GDD Section 2.2 - Progression System
class Level {
  final int number;
  final int sequenceLength;
  final int colorCount;
  final double memorizeTime;
  final double executeTime;
  final int baseScore;
  final String worldName;

  Level({
    required this.number,
    required this.sequenceLength,
    required this.colorCount,
    required this.memorizeTime,
    required this.executeTime,
    required this.baseScore,
    required this.worldName,
  });

  /// Generate level configuration based on level number
  /// Follows the progression system from GDD Section 2.2
  factory Level.fromNumber(int number) {
    // World 1: Basic Colors (Levels 1-20, 4 colors)
    if (number <= GameConstants.world1MaxLevel) {
      final sequenceLength = _calculateSequenceLength(number, 3, 6);
      return Level(
        number: number,
        sequenceLength: sequenceLength,
        colorCount: 4,
        memorizeTime: 5.0,
        executeTime: 15.0 - (number * 0.15).clamp(0, 3), // 15s -> 12s
        baseScore: sequenceLength * GameConstants.pointsPerSequenceStep,
        worldName: 'Basic Colors',
      );
    }
    // World 2: Extended Palette (Levels 21-40, 6 colors)
    else if (number <= GameConstants.world2MaxLevel) {
      final worldLevel = number - GameConstants.world1MaxLevel;
      final sequenceLength = _calculateSequenceLength(worldLevel, 4, 7);
      return Level(
        number: number,
        sequenceLength: sequenceLength,
        colorCount: 6,
        memorizeTime: 5.0,
        executeTime: 14.0 - (worldLevel * 0.15).clamp(0, 3), // 14s -> 11s
        baseScore: sequenceLength * GameConstants.pointsPerSequenceStep,
        worldName: 'Extended Palette',
      );
    }
    // World 3: Master Challenge (Levels 41-60, 8 colors)
    else if (number <= GameConstants.world3MaxLevel) {
      final worldLevel = number - GameConstants.world2MaxLevel;
      final sequenceLength = _calculateSequenceLength(worldLevel, 6, 9);
      return Level(
        number: number,
        sequenceLength: sequenceLength,
        colorCount: 8,
        memorizeTime: 4.0, // Slightly faster for challenge
        executeTime: 12.0 - (worldLevel * 0.15).clamp(0, 3), // 12s -> 9s
        baseScore: sequenceLength * GameConstants.pointsPerSequenceStep,
        worldName: 'Master Challenge',
      );
    }
    // World 4+: Expert Mode (Levels 61+, 8 colors with increased difficulty)
    else {
      final worldLevel = number - GameConstants.world3MaxLevel;
      final sequenceLength = _calculateSequenceLength(worldLevel, 7, 12);
      return Level(
        number: number,
        sequenceLength: sequenceLength,
        colorCount: 8,
        memorizeTime: 4.0,
        executeTime: (10.0 - (worldLevel * 0.1)).clamp(7.0, 10.0),
        baseScore: sequenceLength * GameConstants.pointsPerSequenceStep,
        worldName: 'Expert Mode',
      );
    }
  }

  /// Calculate sequence length based on world level
  /// Gradually increases difficulty within each world
  static int _calculateSequenceLength(int worldLevel, int min, int max) {
    // Each 5 levels increases sequence length by 1
    final length = min + (worldLevel ~/ 5);
    return length.clamp(min, max);
  }

  /// Get world number (1-4)
  int get worldNumber {
    if (number <= GameConstants.world1MaxLevel) return 1;
    if (number <= GameConstants.world2MaxLevel) return 2;
    if (number <= GameConstants.world3MaxLevel) return 3;
    return 4;
  }

  /// Check if this is a world boss level (every 20 levels)
  bool get isBossLevel => number % 20 == 0;

  /// Get difficulty rating (1-5 stars)
  int get difficultyStars {
    if (number <= 10) return 1;
    if (number <= 25) return 2;
    if (number <= 45) return 3;
    if (number <= 60) return 4;
    return 5;
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'sequenceLength': sequenceLength,
      'colorCount': colorCount,
      'memorizeTime': memorizeTime,
      'executeTime': executeTime,
      'baseScore': baseScore,
      'worldName': worldName,
    };
  }

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      number: json['number'] as int,
      sequenceLength: json['sequenceLength'] as int,
      colorCount: json['colorCount'] as int,
      memorizeTime: (json['memorizeTime'] as num).toDouble(),
      executeTime: (json['executeTime'] as num).toDouble(),
      baseScore: json['baseScore'] as int,
      worldName: json['worldName'] as String,
    );
  }

  @override
  String toString() {
    return 'Level $number ($worldName): $sequenceLength steps, $colorCount colors';
  }
}
