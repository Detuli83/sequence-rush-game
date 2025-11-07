class Achievement {
  final int id;
  final String title;
  final String description;
  final String icon;
  final int coinReward;
  final int gemReward;
  final AchievementType type;
  final int targetValue;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.coinReward = 50,
    this.gemReward = 0,
    required this.type,
    required this.targetValue,
  });

  static List<Achievement> getAllAchievements() {
    return [
      // Beginner Achievements
      const Achievement(
        id: 1,
        title: 'First Steps',
        description: 'Complete Level 1',
        icon: '🎯',
        coinReward: 25,
        type: AchievementType.levelComplete,
        targetValue: 1,
      ),
      const Achievement(
        id: 2,
        title: 'Getting Started',
        description: 'Complete 5 levels',
        icon: '🌟',
        coinReward: 50,
        type: AchievementType.levelComplete,
        targetValue: 5,
      ),
      const Achievement(
        id: 3,
        title: 'Dedicated Player',
        description: 'Complete 10 levels',
        icon: '⭐',
        coinReward: 100,
        gemReward: 5,
        type: AchievementType.levelComplete,
        targetValue: 10,
      ),

      // World Completion
      const Achievement(
        id: 4,
        title: 'Color Master',
        description: 'Complete World 1 (Level 20)',
        icon: '🎨',
        coinReward: 150,
        gemReward: 10,
        type: AchievementType.worldComplete,
        targetValue: 1,
      ),
      const Achievement(
        id: 5,
        title: 'Palette Pro',
        description: 'Complete World 2 (Level 40)',
        icon: '🌈',
        coinReward: 250,
        gemReward: 15,
        type: AchievementType.worldComplete,
        targetValue: 2,
      ),
      const Achievement(
        id: 6,
        title: 'Master Challenger',
        description: 'Complete World 3 (Level 60)',
        icon: '👑',
        coinReward: 500,
        gemReward: 25,
        type: AchievementType.worldComplete,
        targetValue: 3,
      ),

      // Perfect Levels
      const Achievement(
        id: 7,
        title: 'Perfect Player',
        description: 'Complete 10 perfect levels',
        icon: '💎',
        coinReward: 100,
        gemReward: 10,
        type: AchievementType.perfectLevels,
        targetValue: 10,
      ),
      const Achievement(
        id: 8,
        title: 'Flawless',
        description: 'Complete 25 perfect levels',
        icon: '✨',
        coinReward: 200,
        gemReward: 20,
        type: AchievementType.perfectLevels,
        targetValue: 25,
      ),
      const Achievement(
        id: 9,
        title: 'Perfectionist',
        description: 'Complete 50 perfect levels',
        icon: '🏆',
        coinReward: 500,
        gemReward: 50,
        type: AchievementType.perfectLevels,
        targetValue: 50,
      ),

      // Speed Achievements
      const Achievement(
        id: 10,
        title: 'Speed Demon',
        description: 'Complete a level with 10+ seconds remaining',
        icon: '⚡',
        coinReward: 75,
        type: AchievementType.speedRun,
        targetValue: 10,
      ),
      const Achievement(
        id: 11,
        title: 'Lightning Fast',
        description: 'Complete a level with 12+ seconds remaining',
        icon: '⚡⚡',
        coinReward: 150,
        gemReward: 10,
        type: AchievementType.speedRun,
        targetValue: 12,
      ),

      // Combo Achievements
      const Achievement(
        id: 12,
        title: 'Combo Starter',
        description: 'Achieve 3x combo multiplier',
        icon: '🔥',
        coinReward: 50,
        type: AchievementType.comboMultiplier,
        targetValue: 3,
      ),
      const Achievement(
        id: 13,
        title: 'Combo King',
        description: 'Achieve 10x combo multiplier',
        icon: '🔥🔥',
        coinReward: 200,
        gemReward: 15,
        type: AchievementType.comboMultiplier,
        targetValue: 10,
      ),

      // Coin Collection
      const Achievement(
        id: 14,
        title: 'Coin Collector',
        description: 'Collect 500 coins',
        icon: '🪙',
        coinReward: 100,
        type: AchievementType.coinsCollected,
        targetValue: 500,
      ),
      const Achievement(
        id: 15,
        title: 'Wealthy',
        description: 'Collect 1000 coins',
        icon: '💰',
        coinReward: 250,
        gemReward: 10,
        type: AchievementType.coinsCollected,
        targetValue: 1000,
      ),
      const Achievement(
        id: 16,
        title: 'Coin Master',
        description: 'Collect 5000 coins',
        icon: '💎💰',
        coinReward: 500,
        gemReward: 50,
        type: AchievementType.coinsCollected,
        targetValue: 5000,
      ),

      // Theme Collection
      const Achievement(
        id: 17,
        title: 'Theme Collector',
        description: 'Unlock 4 themes',
        icon: '🎨',
        coinReward: 100,
        gemReward: 10,
        type: AchievementType.themesUnlocked,
        targetValue: 4,
      ),
      const Achievement(
        id: 18,
        title: 'Style Icon',
        description: 'Unlock all 8 themes',
        icon: '🌟🎨',
        coinReward: 500,
        gemReward: 50,
        type: AchievementType.themesUnlocked,
        targetValue: 8,
      ),

      // Power-Up Usage
      const Achievement(
        id: 19,
        title: 'Power Player',
        description: 'Use 10 power-ups',
        icon: '⚡',
        coinReward: 50,
        type: AchievementType.powerUpsUsed,
        targetValue: 10,
      ),
      const Achievement(
        id: 20,
        title: 'Power Master',
        description: 'Use 50 power-ups',
        icon: '⚡⚡',
        coinReward: 200,
        gemReward: 20,
        type: AchievementType.powerUpsUsed,
        targetValue: 50,
      ),

      // High Score
      const Achievement(
        id: 21,
        title: 'High Scorer',
        description: 'Score 1000+ points in a single level',
        icon: '📊',
        coinReward: 100,
        gemReward: 10,
        type: AchievementType.highScore,
        targetValue: 1000,
      ),
      const Achievement(
        id: 22,
        title: 'Score Legend',
        description: 'Score 2000+ points in a single level',
        icon: '📈',
        coinReward: 250,
        gemReward: 25,
        type: AchievementType.highScore,
        targetValue: 2000,
      ),

      // Daily Challenges
      const Achievement(
        id: 23,
        title: 'Daily Challenger',
        description: 'Complete 5 daily challenges',
        icon: '📅',
        coinReward: 100,
        gemReward: 10,
        type: AchievementType.dailyChallenges,
        targetValue: 5,
      ),
      const Achievement(
        id: 24,
        title: 'Challenge Master',
        description: 'Complete 20 daily challenges',
        icon: '📅🏆',
        coinReward: 300,
        gemReward: 30,
        type: AchievementType.dailyChallenges,
        targetValue: 20,
      ),

      // Play Time
      const Achievement(
        id: 25,
        title: 'Dedicated',
        description: 'Play for 7 consecutive days',
        icon: '📆',
        coinReward: 200,
        gemReward: 20,
        type: AchievementType.consecutiveDays,
        targetValue: 7,
      ),
    ];
  }

  static Achievement? getAchievementById(int id) {
    try {
      return getAllAchievements().firstWhere((achievement) => achievement.id == id);
    } catch (e) {
      return null;
    }
  }
}

enum AchievementType {
  levelComplete,
  worldComplete,
  perfectLevels,
  speedRun,
  comboMultiplier,
  coinsCollected,
  themesUnlocked,
  powerUpsUsed,
  highScore,
  dailyChallenges,
  consecutiveDays,
}
