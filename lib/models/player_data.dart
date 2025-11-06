import 'package:sequence_rush_game/config/constants.dart';

/// Represents the player's game data and progress
class PlayerData {
  int coins;
  int gems;
  int lives;
  int currentLevel;
  int highestLevel;
  int totalScore;
  DateTime? lastLifeRegenTime;
  DateTime lastLifeUpdate;
  int adForLifeCount;
  DateTime? lastAdForLifeDate;
  Map<String, bool> purchasedPowerUps;
  Map<String, int> powerUpCounts;
  List<int> highScores;
  List<int> unlockedThemes;
  int currentTheme;
  Set<int> completedAchievements;
  bool soundEnabled;
  bool musicEnabled;
  bool hapticsEnabled;
  Map<String, bool> settings;

  PlayerData({
    this.coins = 0,
    this.gems = 0,
    this.lives = GameConstants.maxLives,
    this.currentLevel = 1,
    this.highestLevel = 1,
    this.totalScore = 0,
    this.lastLifeRegenTime,
    DateTime? lastLifeUpdate,
    this.adForLifeCount = 0,
    this.lastAdForLifeDate,
    Map<String, bool>? purchasedPowerUps,
    Map<String, int>? powerUpCounts,
    List<int>? highScores,
    List<int>? unlockedThemes,
    this.currentTheme = 0,
    Set<int>? completedAchievements,
    this.soundEnabled = true,
    this.musicEnabled = true,
    this.hapticsEnabled = true,
    Map<String, bool>? settings,
  })  : purchasedPowerUps = purchasedPowerUps ?? {},
        powerUpCounts = powerUpCounts ?? {},
        lastLifeUpdate = lastLifeUpdate ?? DateTime.now(),
        highScores = highScores ?? [],
        unlockedThemes = unlockedThemes ?? [0],
        completedAchievements = completedAchievements ?? {},
        settings = settings ?? {
          'music': true,
          'sfx': true,
          'haptics': true,
        };

  /// Add coins to the player's balance
  void addCoins(int amount) {
    if (amount > 0) {
      coins += amount;
    }
  }

  /// Add gems to the player's balance
  void addGems(int amount) {
    if (amount > 0) {
      gems += amount;
    }
  }

  /// Spend coins
  bool spendCoins(int amount) {
    if (coins >= amount) {
      coins -= amount;
      return true;
    }
    return false;
  }

  /// Spend gems
  bool spendGems(int amount) {
    if (gems >= amount) {
      gems -= amount;
      return true;
    }
    return false;
  }

  /// Add lives to the player
  void addLives(int amount) {
    lives = (lives + amount).clamp(0, GameConstants.maxLives);
  }

  /// Add a single life
  void addLife() {
    lives++;
    if (lives > GameConstants.maxLives) lives = GameConstants.maxLives;
  }

  /// Remove a life
  bool removeLife() {
    if (lives > 0) {
      lives--;
      return true;
    }
    return false;
  }

  /// Lose a life (alias for removeLife)
  void loseLife() {
    if (lives > 0) lives--;
  }

  /// Update lives based on time elapsed
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

  /// Check if lives need to be regenerated
  void regenerateLives() {
    if (lives >= GameConstants.maxLives) {
      lastLifeRegenTime = null;
      return;
    }

    final now = DateTime.now();
    lastLifeRegenTime ??= now;

    final secondsSinceLastRegen =
        now.difference(lastLifeRegenTime!).inSeconds;
    final livesToAdd = secondsSinceLastRegen ~/ GameConstants.livesRegenTime;

    if (livesToAdd > 0) {
      addLives(livesToAdd);
      lastLifeRegenTime = now;
    }
  }

  /// Check if player can watch an ad for a life today
  bool canWatchAdForLife() {
    final now = DateTime.now();

    // Reset counter if it's a new day
    if (lastAdForLifeDate == null ||
        !_isSameDay(lastAdForLifeDate!, now)) {
      adForLifeCount = 0;
      lastAdForLifeDate = now;
    }

    return adForLifeCount < GameConstants.adForLifeLimit;
  }

  /// Increment the ad for life counter
  void incrementAdForLifeCount() {
    final now = DateTime.now();

    // Reset counter if it's a new day
    if (lastAdForLifeDate == null ||
        !_isSameDay(lastAdForLifeDate!, now)) {
      adForLifeCount = 0;
      lastAdForLifeDate = now;
    }

    adForLifeCount++;
    lastAdForLifeDate = now;
  }

  /// Check if two dates are on the same day
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Update highest level if current level is higher
  void updateHighestLevel() {
    if (currentLevel > highestLevel) {
      highestLevel = currentLevel;
    }
  }

  /// Add score to total
  void addScore(int score) {
    if (score > 0) {
      totalScore += score;
    }
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'coins': coins,
      'gems': gems,
      'lives': lives,
      'currentLevel': currentLevel,
      'highestLevel': highestLevel,
      'totalScore': totalScore,
      'lastLifeRegenTime': lastLifeRegenTime?.toIso8601String(),
      'lastLifeUpdate': lastLifeUpdate.toIso8601String(),
      'adForLifeCount': adForLifeCount,
      'lastAdForLifeDate': lastAdForLifeDate?.toIso8601String(),
      'purchasedPowerUps': purchasedPowerUps,
      'powerUpCounts': powerUpCounts,
      'highScores': highScores,
      'unlockedThemes': unlockedThemes,
      'currentTheme': currentTheme,
      'completedAchievements': completedAchievements.toList(),
      'soundEnabled': soundEnabled,
      'musicEnabled': musicEnabled,
      'hapticsEnabled': hapticsEnabled,
      'settings': settings,
    };
  }

  /// Create from JSON
  factory PlayerData.fromJson(Map<String, dynamic> json) {
    return PlayerData(
      coins: json['coins'] as int? ?? 0,
      gems: json['gems'] as int? ?? 0,
      lives: json['lives'] as int? ?? GameConstants.maxLives,
      currentLevel: json['currentLevel'] as int? ?? 1,
      highestLevel: json['highestLevel'] as int? ?? 1,
      totalScore: json['totalScore'] as int? ?? 0,
      lastLifeRegenTime: json['lastLifeRegenTime'] != null
          ? DateTime.parse(json['lastLifeRegenTime'] as String)
          : null,
      lastLifeUpdate: json['lastLifeUpdate'] != null
          ? DateTime.parse(json['lastLifeUpdate'] as String)
          : DateTime.now(),
      adForLifeCount: json['adForLifeCount'] as int? ?? 0,
      lastAdForLifeDate: json['lastAdForLifeDate'] != null
          ? DateTime.parse(json['lastAdForLifeDate'] as String)
          : null,
      purchasedPowerUps:
          Map<String, bool>.from(json['purchasedPowerUps'] as Map? ?? {}),
      powerUpCounts:
          Map<String, int>.from(json['powerUpCounts'] as Map? ?? {}),
      highScores: List<int>.from(json['highScores'] ?? []),
      unlockedThemes: List<int>.from(json['unlockedThemes'] ?? [0]),
      currentTheme: json['currentTheme'] ?? 0,
      completedAchievements:
          Set<int>.from(json['completedAchievements'] ?? []),
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      musicEnabled: json['musicEnabled'] as bool? ?? true,
      hapticsEnabled: json['hapticsEnabled'] as bool? ?? true,
      settings: Map<String, bool>.from(json['settings'] ?? {
        'music': true,
        'sfx': true,
        'haptics': true,
      }),
    );
  }

  /// Create a copy with modified values
  PlayerData copyWith({
    int? coins,
    int? gems,
    int? lives,
    int? currentLevel,
    int? highestLevel,
    int? totalScore,
    DateTime? lastLifeRegenTime,
    DateTime? lastLifeUpdate,
    int? adForLifeCount,
    DateTime? lastAdForLifeDate,
    Map<String, bool>? purchasedPowerUps,
    Map<String, int>? powerUpCounts,
    List<int>? highScores,
    List<int>? unlockedThemes,
    int? currentTheme,
    Set<int>? completedAchievements,
    bool? soundEnabled,
    bool? musicEnabled,
    bool? hapticsEnabled,
    Map<String, bool>? settings,
  }) {
    return PlayerData(
      coins: coins ?? this.coins,
      gems: gems ?? this.gems,
      lives: lives ?? this.lives,
      currentLevel: currentLevel ?? this.currentLevel,
      highestLevel: highestLevel ?? this.highestLevel,
      totalScore: totalScore ?? this.totalScore,
      lastLifeRegenTime: lastLifeRegenTime ?? this.lastLifeRegenTime,
      lastLifeUpdate: lastLifeUpdate ?? this.lastLifeUpdate,
      adForLifeCount: adForLifeCount ?? this.adForLifeCount,
      lastAdForLifeDate: lastAdForLifeDate ?? this.lastAdForLifeDate,
      purchasedPowerUps: purchasedPowerUps ?? this.purchasedPowerUps,
      powerUpCounts: powerUpCounts ?? this.powerUpCounts,
      highScores: highScores ?? this.highScores,
      unlockedThemes: unlockedThemes ?? this.unlockedThemes,
      currentTheme: currentTheme ?? this.currentTheme,
      completedAchievements: completedAchievements ?? this.completedAchievements,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      settings: settings ?? this.settings,
    );
  }
}
