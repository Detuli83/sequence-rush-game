class ScoreCalculator {
  static int calculateScore({
    required int baseScore,
    required double remainingTime,
    required int comboMultiplier,
    required bool isPerfect,
  }) {
    // Base score from level
    int score = baseScore;

    // Time bonus (50 points per second remaining)
    int timeBonus = (remainingTime * 50).round();
    score += timeBonus;

    // Apply combo multiplier
    score = (score * comboMultiplier).round();

    // Perfect level bonus
    if (isPerfect) {
      score += 500;
    }

    return score;
  }

  static int calculateComboMultiplier(int streak) {
    if (streak >= 10) return 3;
    if (streak >= 5) return 2;
    if (streak >= 3) return 1;
    return 1;
  }
}
