/// Currency types in the game
enum CurrencyType {
  coins,
  gems,
}

/// In-App Purchase products
enum IAPProduct {
  removeAds('remove_ads', 'Remove Ads', 299),
  starterPack('starter_pack', 'Starter Pack', 99),
  megaPack('mega_pack', 'Mega Pack', 999),
  coins100('coins_100', '100 Coins', 99),
  coins500('coins_500', '500 Coins', 299),
  coins1000('coins_1000', '1000 Coins', 499),
  gems50('gems_50', '50 Gems', 199),
  gems100('gems_100', '100 Gems', 299),
  gems500('gems_500', '500 Gems', 999);

  final String id;
  final String name;
  final int priceInCents;

  const IAPProduct(this.id, this.name, this.priceInCents);

  /// Get price in dollars
  double get priceInDollars => priceInCents / 100.0;

  /// Get formatted price
  String get formattedPrice => '\$${priceInDollars.toStringAsFixed(2)}';

  /// Check if this is a consumable product
  bool get isConsumable {
    return id.startsWith('coins_') || id.startsWith('gems_');
  }

  /// Check if this is a non-consumable product
  bool get isNonConsumable => !isConsumable;
}

/// Power-up types
enum PowerUpType {
  slowTime('slow_time', 'Slow Time', 50, 'Slows down the timer'),
  skipLevel('skip_level', 'Skip Level', 100, 'Skip current level'),
  extraLife('extra_life', 'Extra Life', 30, 'Get an extra life'),
  doubleReward('double_reward', 'Double Reward', 75, 'Double your reward');

  final String id;
  final String name;
  final int cost;
  final String description;

  const PowerUpType(this.id, this.name, this.cost, this.description);
}

/// Game difficulty levels
enum DifficultyLevel {
  easy('Easy', 1.2),
  normal('Normal', 1.0),
  hard('Hard', 0.8),
  expert('Expert', 0.6);

  final String name;
  final double timeMultiplier;

  const DifficultyLevel(this.name, this.timeMultiplier);
}

/// Game state
enum GameState {
  menu,
  memorize,
  execute,
  paused,
  levelComplete,
  gameOver,
}

/// Button state for game buttons
enum ButtonState {
  idle,
  highlighted,
  pressed,
  correct,
  incorrect,
}

/// Achievement types
enum AchievementType {
  levelMilestone('Level Milestone'),
  perfectLevels('Perfect Levels'),
  coinsCollected('Coins Collected'),
  gemsCollected('Gems Collected'),
  powerUpsUsed('Power-ups Used'),
  dailyLogin('Daily Login');

  final String displayName;

  const AchievementType(this.displayName);
}
