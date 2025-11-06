import '../config/constants.dart';

/// Player data model for persistence
/// Based on GDD Section 6.2 - Data Storage
class PlayerData {
  int currentLevel;
  int lives;
  int coins;
  int gems;
  DateTime lastLifeUpdate;
  List<int> highScores;
  List<int> unlockedThemes;
  int currentTheme;
  Set<int> completedAchievements;
  int consecutivePerfectLevels;
  int totalLevelsCompleted;
  int totalCoinsEarned;
  DateTime? lastDailyRewardClaim;
  int adsWatchedToday;
  DateTime? lastAdDate;

  PlayerData({
    this.currentLevel = 1,
    this.lives = GameConstants.maxLives,
    this.coins = 0,
    this.gems = 0,
    DateTime? lastLifeUpdate,
    List<int>? highScores,
    List<int>? unlockedThemes,
    this.currentTheme = 0,
    Set<int>? completedAchievements,
    this.consecutivePerfectLevels = 0,
    this.totalLevelsCompleted = 0,
    this.totalCoinsEarned = 0,
    this.lastDailyRewardClaim,
    this.adsWatchedToday = 0,
    this.lastAdDate,
  })  : lastLifeUpdate = lastLifeUpdate ?? DateTime.now(),
        highScores = highScores ?? [],
        unlockedThemes = unlockedThemes ?? [0], // Theme 0 is free
        completedAchievements = completedAchievements ?? {};

  /// Update lives based on time elapsed (1 life per 15 minutes)
  void updateLives() {
    if (lives >= GameConstants.maxLives) {
      lastLifeUpdate = DateTime.now();
      return;
    }

    final now = DateTime.now();
    final minutesElapsed = now.difference(lastLifeUpdate).inMinutes;
    final livesToAdd = minutesElapsed ~/ GameConstants.lifeRegenerationMinutes;

    if (livesToAdd > 0) {
      lives = (lives + livesToAdd).clamp(0, GameConstants.maxLives);
      lastLifeUpdate = now;
    }
  }

  /// Add coins and track total earned
  void addCoins(int amount) {
    coins += amount;
    totalCoinsEarned += amount;
  }

  /// Spend coins (returns false if not enough coins)
  bool spendCoins(int amount) {
    if (coins < amount) return false;
    coins -= amount;
    return true;
  }

  /// Add gems
  void addGems(int amount) {
    gems += amount;
  }

  /// Spend gems (returns false if not enough gems)
  bool spendGems(int amount) {
    if (gems < amount) return false;
    gems -= amount;
    return true;
  }

  /// Lose a life
  void loseLife() {
    lives = (lives - 1).clamp(0, GameConstants.maxLives);
  }

  /// Add a life (e.g., from rewarded ad)
  void addLife() {
    lives = (lives + 1).clamp(0, GameConstants.maxLives);
    lastLifeUpdate = DateTime.now();
  }

  /// Add a high score
  void addHighScore(int score) {
    highScores.add(score);
    highScores.sort((a, b) => b.compareTo(a)); // Sort descending
    if (highScores.length > 10) {
      highScores = highScores.take(10).toList();
    }
  }

  /// Get highest score
  int get bestScore => highScores.isEmpty ? 0 : highScores.first;

  /// Unlock a theme
  void unlockTheme(int themeId) {
    if (!unlockedThemes.contains(themeId)) {
      unlockedThemes.add(themeId);
    }
  }

  /// Check if theme is unlocked
  bool isThemeUnlocked(int themeId) {
    return unlockedThemes.contains(themeId);
  }

  /// Complete an achievement
  void completeAchievement(int achievementId) {
    completedAchievements.add(achievementId);
  }

  /// Check if achievement is completed
  bool isAchievementCompleted(int achievementId) {
    return completedAchievements.contains(achievementId);
  }

  /// Check if daily reward is available
  bool get canClaimDailyReward {
    if (lastDailyRewardClaim == null) return true;
    final now = DateTime.now();
    final lastClaim = lastDailyRewardClaim!;
    return now.difference(lastClaim).inHours >= 24;
  }

  /// Claim daily reward
  void claimDailyReward() {
    addCoins(GameConstants.coinsDailyBonus);
    lastDailyRewardClaim = DateTime.now();
  }

  /// Track ad watching (reset daily)
  void watchAd() {
    final now = DateTime.now();
    if (lastAdDate == null || !_isSameDay(now, lastAdDate!)) {
      // New day, reset counter
      adsWatchedToday = 0;
      lastAdDate = now;
    }
    adsWatchedToday++;
  }

  /// Check if can watch more rewarded ads today
  bool get canWatchRewardedAd {
    final now = DateTime.now();
    if (lastAdDate == null || !_isSameDay(now, lastAdDate!)) {
      return true; // New day
    }
    return adsWatchedToday < GameConstants.maxRewardedAdsPerDay;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'currentLevel': currentLevel,
      'lives': lives,
      'coins': coins,
      'gems': gems,
      'lastLifeUpdate': lastLifeUpdate.toIso8601String(),
      'highScores': highScores,
      'unlockedThemes': unlockedThemes,
      'currentTheme': currentTheme,
      'completedAchievements': completedAchievements.toList(),
      'consecutivePerfectLevels': consecutivePerfectLevels,
      'totalLevelsCompleted': totalLevelsCompleted,
      'totalCoinsEarned': totalCoinsEarned,
      'lastDailyRewardClaim': lastDailyRewardClaim?.toIso8601String(),
      'adsWatchedToday': adsWatchedToday,
      'lastAdDate': lastAdDate?.toIso8601String(),
    };
  }

  /// Create from JSON
  factory PlayerData.fromJson(Map<String, dynamic> json) {
    return PlayerData(
      currentLevel: json['currentLevel'] as int? ?? 1,
      lives: json['lives'] as int? ?? GameConstants.maxLives,
      coins: json['coins'] as int? ?? 0,
      gems: json['gems'] as int? ?? 0,
      lastLifeUpdate: json['lastLifeUpdate'] != null
          ? DateTime.parse(json['lastLifeUpdate'] as String)
          : DateTime.now(),
      highScores: (json['highScores'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      unlockedThemes: (json['unlockedThemes'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [0],
      currentTheme: json['currentTheme'] as int? ?? 0,
      completedAchievements: (json['completedAchievements'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toSet() ??
          {},
      consecutivePerfectLevels: json['consecutivePerfectLevels'] as int? ?? 0,
      totalLevelsCompleted: json['totalLevelsCompleted'] as int? ?? 0,
      totalCoinsEarned: json['totalCoinsEarned'] as int? ?? 0,
      lastDailyRewardClaim: json['lastDailyRewardClaim'] != null
          ? DateTime.parse(json['lastDailyRewardClaim'] as String)
          : null,
      adsWatchedToday: json['adsWatchedToday'] as int? ?? 0,
      lastAdDate: json['lastAdDate'] != null
          ? DateTime.parse(json['lastAdDate'] as String)
          : null,
    );
  }

  /// Create a copy with modified fields
  PlayerData copyWith({
    int? currentLevel,
    int? lives,
    int? coins,
    int? gems,
    DateTime? lastLifeUpdate,
    List<int>? highScores,
    List<int>? unlockedThemes,
    int? currentTheme,
    Set<int>? completedAchievements,
    int? consecutivePerfectLevels,
    int? totalLevelsCompleted,
    int? totalCoinsEarned,
    DateTime? lastDailyRewardClaim,
    int? adsWatchedToday,
    DateTime? lastAdDate,
  }) {
    return PlayerData(
      currentLevel: currentLevel ?? this.currentLevel,
      lives: lives ?? this.lives,
      coins: coins ?? this.coins,
      gems: gems ?? this.gems,
      lastLifeUpdate: lastLifeUpdate ?? this.lastLifeUpdate,
      highScores: highScores ?? this.highScores,
      unlockedThemes: unlockedThemes ?? this.unlockedThemes,
      currentTheme: currentTheme ?? this.currentTheme,
      completedAchievements: completedAchievements ?? this.completedAchievements,
      consecutivePerfectLevels: consecutivePerfectLevels ?? this.consecutivePerfectLevels,
      totalLevelsCompleted: totalLevelsCompleted ?? this.totalLevelsCompleted,
      totalCoinsEarned: totalCoinsEarned ?? this.totalCoinsEarned,
      lastDailyRewardClaim: lastDailyRewardClaim ?? this.lastDailyRewardClaim,
      adsWatchedToday: adsWatchedToday ?? this.adsWatchedToday,
      lastAdDate: lastAdDate ?? this.lastAdDate,
    );
  }
}
