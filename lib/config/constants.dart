class GameConstants {
  // Lives System
  static const int maxLives = 5;
  static const int lifeRegenMinutes = 15; // 1 life per 15 minutes
  static const int maxAdLivesPerDay = 3;

  // Currency
  static const int coinsPerLevel = 10;
  static const int coinsForPerfectLevel = 25;
  static const int dailyLoginBonus = 50;
  static const int coinsPerAd = 25;

  // Power-Up Costs
  static const int hintCost = 50;
  static const int extraTimeCost = 75;
  static const int slowMotionCost = 100;
  static const int skipLevelCost = 200;

  // Scoring
  static const int baseScoreMultiplier = 100;
  static const int timeBonus = 50; // Points per second
  static const int perfectLevelBonus = 500;

  // Combo Multipliers
  static const int combo3Multiplier = 2; // 1.5x (stored as int for precision)
  static const int combo5Multiplier = 2;
  static const int combo10Multiplier = 3;

  // Ad Frequency
  static const int interstitialAdFrequency = 3; // Every 3 game overs

  // App Information
  static const String appName = 'Sequence Rush';
  static const String appVersion = '1.0.0';

  // URLs
  static const String privacyPolicyUrl = 'https://example.com/privacy';
  static const String termsOfServiceUrl = 'https://example.com/terms';
  static const String supportEmail = 'support@sequencerush.com';

  // Test Mode (set to false for production)
  static const bool testAds = true; // Use test ad IDs
  static const bool testIAP = true; // Use test product IDs
}
