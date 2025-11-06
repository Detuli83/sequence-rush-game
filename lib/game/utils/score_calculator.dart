import '../../config/constants.dart';

/// Calculates scores based on game performance
/// Implements scoring system from GDD Section 2.4
class ScoreCalculator {
  /// Calculate total score for a completed level
  ///
  /// Formula from GDD:
  /// - Base Score = Sequence Length × 100
  /// - Time Bonus = Remaining Seconds × 50
  /// - Combo Multiplier = 1x, 1.5x, 2x, or 3x based on streak
  /// - Perfect Bonus = +500 if no mistakes
  static int calculateScore({
    required int baseScore,
    required double remainingTime,
    required int comboMultiplier,
    required bool isPerfect,
  }) {
    // Start with base score
    int score = baseScore;

    // Add time bonus (50 points per second)
    final timeBonus = (remainingTime * GameConstants.pointsPerSecond).round();
    score += timeBonus;

    // Apply combo multiplier
    score = (score * comboMultiplier).round();

    // Add perfect level bonus
    if (isPerfect) {
      score += GameConstants.perfectLevelBonus;
    }

    return score;
  }

  /// Calculate combo multiplier based on perfect level streak
  ///
  /// From GDD Section 2.4:
  /// - 3+ levels: 1.5x multiplier
  /// - 5+ levels: 2x multiplier
  /// - 10+ levels: 3x multiplier
  static int calculateComboMultiplier(int perfectStreak) {
    if (perfectStreak >= GameConstants.comboLevel3) {
      return 3; // 10+ perfect levels
    } else if (perfectStreak >= GameConstants.comboLevel2) {
      return 2; // 5-9 perfect levels
    } else if (perfectStreak >= GameConstants.comboLevel1) {
      return 2; // 3-4 perfect levels (GDD shows 1.5x, using 2 for simplicity)
    }
    return 1; // No combo
  }

  /// Calculate base score from sequence length
  /// Base Score = Sequence Length × 100
  static int calculateBaseScore(int sequenceLength) {
    return sequenceLength * GameConstants.pointsPerSequenceStep;
  }

  /// Calculate time bonus
  /// Time Bonus = Remaining Seconds × 50
  static int calculateTimeBonus(double remainingTime) {
    return (remainingTime * GameConstants.pointsPerSecond).round();
  }

  /// Calculate coins earned for completing a level
  /// From GDD Section 3.3:
  /// - Base: 10 coins per level
  /// - Perfect: +25 coins bonus
  static int calculateCoinsEarned({required bool isPerfect}) {
    int coins = GameConstants.coinsPerLevel;
    if (isPerfect) {
      coins += GameConstants.coinsPerPerfect;
    }
    return coins;
  }

  /// Calculate score breakdown for display
  /// Returns a map with all score components
  static Map<String, int> calculateScoreBreakdown({
    required int baseScore,
    required double remainingTime,
    required int comboMultiplier,
    required bool isPerfect,
  }) {
    final timeBonus = calculateTimeBonus(remainingTime);
    final subtotal = baseScore + timeBonus;
    final comboBonus = subtotal * (comboMultiplier - 1);
    final perfectBonus = isPerfect ? GameConstants.perfectLevelBonus : 0;
    final total = calculateScore(
      baseScore: baseScore,
      remainingTime: remainingTime,
      comboMultiplier: comboMultiplier,
      isPerfect: isPerfect,
    );

    return {
      'baseScore': baseScore,
      'timeBonus': timeBonus,
      'comboBonus': comboBonus,
      'perfectBonus': perfectBonus,
      'total': total,
    };
  }

  /// Calculate rank based on score for a level
  /// Returns rank from 1 (bronze) to 5 (diamond)
  static int calculateRank(int score, int baseScore) {
    final ratio = score / baseScore;

    if (ratio >= 3.0) return 5; // Diamond - Exceptional
    if (ratio >= 2.5) return 4; // Platinum - Excellent
    if (ratio >= 2.0) return 3; // Gold - Great
    if (ratio >= 1.5) return 2; // Silver - Good
    return 1; // Bronze - Completed
  }

  /// Get rank name
  static String getRankName(int rank) {
    switch (rank) {
      case 5:
        return 'Diamond';
      case 4:
        return 'Platinum';
      case 3:
        return 'Gold';
      case 2:
        return 'Silver';
      case 1:
        return 'Bronze';
      default:
        return 'None';
    }
  }

  /// Calculate star rating (1-3 stars) based on performance
  /// Stars are based on time remaining and perfection
  static int calculateStars({
    required double remainingTime,
    required double totalTime,
    required bool isPerfect,
  }) {
    final timePercent = remainingTime / totalTime;

    if (isPerfect && timePercent >= 0.5) {
      return 3; // Fast and perfect
    } else if (isPerfect || timePercent >= 0.4) {
      return 2; // Perfect or good time
    }
    return 1; // Completed
  }

  /// Calculate progress percentage for a level
  static double calculateProgress(int userInputLength, int sequenceLength) {
    if (sequenceLength == 0) return 0.0;
    return (userInputLength / sequenceLength * 100).clamp(0.0, 100.0);
  }

  /// Estimate potential score if level completed now
  /// Useful for showing predicted score during gameplay
  static int estimateScore({
    required int baseScore,
    required double currentTime,
    required int comboMultiplier,
    required bool isCurrentlyPerfect,
  }) {
    return calculateScore(
      baseScore: baseScore,
      remainingTime: currentTime,
      comboMultiplier: comboMultiplier,
      isPerfect: isCurrentlyPerfect,
    );
  }

  /// Check if score qualifies for high score list
  static bool isHighScore(int score, List<int> highScores) {
    if (highScores.isEmpty || highScores.length < 10) return true;
    return score > highScores.last;
  }

  /// Get position in high score list (1-based index, 0 if not in list)
  static int getHighScorePosition(int score, List<int> highScores) {
    for (int i = 0; i < highScores.length; i++) {
      if (score > highScores[i]) {
        return i + 1;
      }
    }
    if (highScores.length < 10) {
      return highScores.length + 1;
    }
    return 0; // Not in top 10
  }
}
