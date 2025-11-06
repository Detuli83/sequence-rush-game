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
  Map<String, bool> settings;

  PlayerData({
    this.currentLevel = 1,
    this.lives = 5,
    this.coins = 0,
    this.gems = 0,
    DateTime? lastLifeUpdate,
    List<int>? highScores,
    List<int>? unlockedThemes,
    this.currentTheme = 0,
    Set<int>? completedAchievements,
    Map<String, bool>? settings,
  })  : lastLifeUpdate = lastLifeUpdate ?? DateTime.now(),
        highScores = highScores ?? [],
        unlockedThemes = unlockedThemes ?? [0],
        completedAchievements = completedAchievements ?? {},
        settings = settings ?? {
          'music': true,
          'sfx': true,
          'haptics': true,
        };

  // Update lives based on time elapsed
  void updateLives() {
    if (lives >= 5) return;

    final now = DateTime.now();
    final minutesElapsed = now.difference(lastLifeUpdate).inMinutes;
    final livesToAdd = minutesElapsed ~/ 15; // 1 life per 15 minutes

    if (livesToAdd > 0) {
      lives = (lives + livesToAdd).clamp(0, 5);
      lastLifeUpdate = now;
    }
  }

  void addCoins(int amount) {
    coins += amount;
  }

  void spendCoins(int amount) {
    coins -= amount;
    if (coins < 0) coins = 0;
  }

  void addGems(int amount) {
    gems += amount;
  }

  void loseLife() {
    lives--;
    if (lives < 0) lives = 0;
  }

  void addLife() {
    lives++;
    if (lives > 5) lives = 5;
  }

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
      'settings': settings,
    };
  }

  factory PlayerData.fromJson(Map<String, dynamic> json) {
    return PlayerData(
      currentLevel: json['currentLevel'] ?? 1,
      lives: json['lives'] ?? 5,
      coins: json['coins'] ?? 0,
      gems: json['gems'] ?? 0,
      lastLifeUpdate: json['lastLifeUpdate'] != null
          ? DateTime.parse(json['lastLifeUpdate'])
          : DateTime.now(),
      highScores: List<int>.from(json['highScores'] ?? []),
      unlockedThemes: List<int>.from(json['unlockedThemes'] ?? [0]),
      currentTheme: json['currentTheme'] ?? 0,
      completedAchievements:
          Set<int>.from(json['completedAchievements'] ?? []),
      settings: Map<String, bool>.from(json['settings'] ?? {
        'music': true,
        'sfx': true,
        'haptics': true,
      }),
    );
  }
}
