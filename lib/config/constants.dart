/// Game configuration constants
class GameConstants {
  GameConstants._(); // Private constructor to prevent instantiation

  // Currency rewards
  static const int coinsPerLevel = 10;
  static const int coinsForPerfectLevel = 25;
  static const int coinsPerAd = 20;

  // Time bonus multiplier (coins per second remaining)
  static const double timeBonus = 0.5;

  // Lives system
  static const int maxLives = 5;
  static const int livesRegenTime = 30 * 60; // 30 minutes in seconds
  static const int adForLifeLimit = 3; // Max ads for lives per day

  // Game timing
  static const int baseMemorizeTime = 3000; // milliseconds
  static const int baseExecuteTime = 5000; // milliseconds
  static const int minMemorizeTime = 1000; // milliseconds
  static const int minExecuteTime = 2000; // milliseconds

  // Sequence difficulty
  static const int startingSequenceLength = 3;
  static const int maxSequenceLength = 15;
  static const int numberOfColors = 8;

  // Power-ups costs
  static const int slowTimeCost = 50;
  static const int skipLevelCost = 100;
  static const int extraLifeCost = 30;
  static const int doubleRewardCost = 75;

  // IAP prices (in USD cents)
  static const int removeAdsCost = 299; // $2.99
  static const int starterPackCost = 99; // $0.99
  static const int megaPackCost = 999; // $9.99

  // Ad timing
  static const int minSecondsBetweenInterstitials = 180; // 3 minutes
  static const int levelsPerInterstitial = 3;

  // Daily rewards
  static const List<int> dailyRewardCoins = [10, 20, 30, 50, 100, 150, 200];

  // Progression
  static const double difficultyIncreaseRate = 0.95; // Time multiplier per level
  static const int levelsPerDifficultyIncrease = 5;

  // UI constants
  static const double buttonSize = 80.0;
  static const double buttonSpacing = 12.0;
  static const int animationDuration = 300; // milliseconds
  static const int feedbackDuration = 500; // milliseconds

  // Storage keys
  static const String keyPlayerData = 'player_data';
  static const String keySettings = 'settings';
  static const String keyPurchases = 'purchases';
  static const String keyAchievements = 'achievements';
  static const String keyLastAdDate = 'last_ad_date';
  static const String keyAdForLifeCount = 'ad_for_life_count';
}
