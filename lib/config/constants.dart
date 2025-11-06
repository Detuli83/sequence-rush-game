class GameConstants {
  // Lives system
  static const int maxLives = 5;
  static const int lifeRegenerationMinutes = 15;

  // Currency costs
  static const int hintCost = 50;
  static const int extraTimeCost = 75;
  static const int slowMotionCost = 100;
  static const int skipLevelCost = 200;

  // Rewards
  static const int baseCoinsPerLevel = 10;
  static const int perfectLevelCoinBonus = 25;
  static const int dailyLoginBonus = 50;
  static const int adRewardCoins = 25;

  // Scoring
  static const int pointsPerSequenceStep = 100;
  static const int pointsPerSecondRemaining = 50;
  static const int perfectLevelBonus = 500;

  // Combo system
  static const int combo3Multiplier = 150; // 1.5x as int percentage
  static const int combo5Multiplier = 200; // 2x
  static const int combo10Multiplier = 300; // 3x

  // Ad configuration
  static const int gameOversBetweenInterstitial = 3;
  static const int maxRewardedAdsPerDay = 3;

  // Time limits (in seconds)
  static const double defaultMemorizeTime = 3.0;
  static const double defaultExecuteTime = 15.0;
}
