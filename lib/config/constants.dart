/// Game constants from GDD
class GameConstants {
  // Lives system (Section 3.1)
  static const int maxLives = 5;
  static const int lifeRegenerationMinutes = 15;

  // Scoring system (Section 2.4)
  static const int pointsPerSequenceStep = 100;
  static const int pointsPerSecond = 50;
  static const int perfectLevelBonus = 500;

  // Combo multipliers (Section 2.4)
  static const int comboLevel1 = 3; // 1.5x multiplier
  static const int comboLevel2 = 5; // 2x multiplier
  static const int comboLevel3 = 10; // 3x multiplier

  // Currency rewards (Section 3.3)
  static const int coinsPerLevel = 10;
  static const int coinsPerPerfect = 25;
  static const int coinsDailyBonus = 50;
  static const int coinsPerAd = 25;

  // Power-up costs (Section 3.2)
  static const int hintCost = 50;
  static const int extraTimeCost = 75;
  static const int slowMotionCost = 100;
  static const int skipLevelCost = 200;

  // Power-up effects
  static const double extraTimeSeconds = 5.0;
  static const double slowMotionMultiplier = 0.5;

  // Ad configuration (Section 7.1)
  static const int adFrequencyGameOvers = 3; // Show ad every 3 game overs
  static const int maxRewardedAdsPerDay = 3;

  // World configuration (Section 2.2)
  static const int world1MaxLevel = 20;
  static const int world2MaxLevel = 40;
  static const int world3MaxLevel = 60;

  // Animation durations (Section 4.4)
  static const int buttonPressDurationMs = 100;
  static const int sequenceHighlightDurationMs = 300;
  static const int successAnimationDurationMs = 1500;
  static const int failureAnimationDurationMs = 800;

  // Game timing
  static const double defaultMemorizeTime = 5.0;
  static const double defaultExecuteTime = 15.0;

  // UI sizing
  static const double buttonSize = 80.0;
  static const double buttonSpacing = 16.0;
  static const double buttonBorderRadius = 12.0;

  // Performance targets (Section 6.3)
  static const int targetFps = 60;
  static const int maxLoadTimeSeconds = 2;
}

/// Ad unit IDs
class AdUnitIds {
  // Test IDs - Replace with real IDs for production
  static const String androidInterstitial = 'ca-app-pub-3940256099942544/1033173712';
  static const String iosInterstitial = 'ca-app-pub-3940256099942544/4411468910';
  static const String androidRewarded = 'ca-app-pub-3940256099942544/5224354917';
  static const String iosRewarded = 'ca-app-pub-3940256099942544/1712485313';
  static const String androidBanner = 'ca-app-pub-3940256099942544/6300978111';
  static const String iosBanner = 'ca-app-pub-3940256099942544/2934735716';
}

/// Storage keys for SharedPreferences
class StorageKeys {
  static const String playerData = 'player_data';
  static const String currentLevel = 'current_level';
  static const String lives = 'lives';
  static const String coins = 'coins';
  static const String gems = 'gems';
  static const String lastLifeUpdate = 'last_life_update';
  static const String highScores = 'high_scores';
  static const String unlockedThemes = 'unlocked_themes';
  static const String currentTheme = 'current_theme';
  static const String achievements = 'achievements';
  static const String musicEnabled = 'music_enabled';
  static const String sfxEnabled = 'sfx_enabled';
  static const String hapticsEnabled = 'haptics_enabled';
  static const String isDarkMode = 'is_dark_mode';
}
