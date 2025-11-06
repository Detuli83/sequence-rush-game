enum PowerUpType {
  hint,
  extraTime,
  slowMotion,
  skipLevel,
}

class PowerUp {
  final PowerUpType type;
  final String name;
  final String description;
  final int coinCost;
  final int? gemCost;
  final bool canUseAd;

  const PowerUp({
    required this.type,
    required this.name,
    required this.description,
    required this.coinCost,
    this.gemCost,
    this.canUseAd = false,
  });

  static const List<PowerUp> allPowerUps = [
    PowerUp(
      type: PowerUpType.hint,
      name: 'Show Hint',
      description: 'Replays the sequence one more time',
      coinCost: 50,
      canUseAd: true,
    ),
    PowerUp(
      type: PowerUpType.extraTime,
      name: 'Extra Time',
      description: 'Adds 5 seconds to execution timer',
      coinCost: 75,
      canUseAd: true,
    ),
    PowerUp(
      type: PowerUpType.slowMotion,
      name: 'Slow Motion',
      description: 'Slows down sequence display by 50%',
      coinCost: 100,
      canUseAd: true,
    ),
    PowerUp(
      type: PowerUpType.skipLevel,
      name: 'Skip Level',
      description: 'Skip current level entirely',
      coinCost: 200,
      gemCost: 10,
      canUseAd: false,
    ),
  ];

  static PowerUp? getByType(PowerUpType type) {
    return allPowerUps.firstWhere(
      (powerUp) => powerUp.type == type,
    );
  }
}
