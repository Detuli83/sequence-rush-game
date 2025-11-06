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
  int adForLifeCount;
  DateTime? lastAdForLifeDate;
  Map<String, bool> purchasedPowerUps;
  Map<String, int> powerUpCounts;
  bool soundEnabled;
  bool musicEnabled;
  bool hapticsEnabled;

  PlayerData({
    this.coins = 0,
    this.gems = 0,
    this.lives = GameConstants.maxLives,
    this.currentLevel = 1,
    this.highestLevel = 1,
    this.totalScore = 0,
    this.lastLifeRegenTime,
    this.adForLifeCount = 0,
    this.lastAdForLifeDate,
    Map<String, bool>? purchasedPowerUps,
    Map<String, int>? powerUpCounts,
    this.soundEnabled = true,
    this.musicEnabled = true,
    this.hapticsEnabled = true,
  })  : purchasedPowerUps = purchasedPowerUps ?? {},
        powerUpCounts = powerUpCounts ?? {};

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

  /// Remove a life
  bool removeLife() {
    if (lives > 0) {
      lives--;
      return true;
    }
    return false;
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
      'adForLifeCount': adForLifeCount,
      'lastAdForLifeDate': lastAdForLifeDate?.toIso8601String(),
      'purchasedPowerUps': purchasedPowerUps,
      'powerUpCounts': powerUpCounts,
      'soundEnabled': soundEnabled,
      'musicEnabled': musicEnabled,
      'hapticsEnabled': hapticsEnabled,
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
      adForLifeCount: json['adForLifeCount'] as int? ?? 0,
      lastAdForLifeDate: json['lastAdForLifeDate'] != null
          ? DateTime.parse(json['lastAdForLifeDate'] as String)
          : null,
      purchasedPowerUps:
          Map<String, bool>.from(json['purchasedPowerUps'] as Map? ?? {}),
      powerUpCounts:
          Map<String, int>.from(json['powerUpCounts'] as Map? ?? {}),
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      musicEnabled: json['musicEnabled'] as bool? ?? true,
      hapticsEnabled: json['hapticsEnabled'] as bool? ?? true,
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
    int? adForLifeCount,
    DateTime? lastAdForLifeDate,
    Map<String, bool>? purchasedPowerUps,
    Map<String, int>? powerUpCounts,
    bool? soundEnabled,
    bool? musicEnabled,
    bool? hapticsEnabled,
  }) {
    return PlayerData(
      coins: coins ?? this.coins,
      gems: gems ?? this.gems,
      lives: lives ?? this.lives,
      currentLevel: currentLevel ?? this.currentLevel,
      highestLevel: highestLevel ?? this.highestLevel,
      totalScore: totalScore ?? this.totalScore,
      lastLifeRegenTime: lastLifeRegenTime ?? this.lastLifeRegenTime,
      adForLifeCount: adForLifeCount ?? this.adForLifeCount,
      lastAdForLifeDate: lastAdForLifeDate ?? this.lastAdForLifeDate,
      purchasedPowerUps: purchasedPowerUps ?? this.purchasedPowerUps,
      powerUpCounts: powerUpCounts ?? this.powerUpCounts,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
    );
  }
}
