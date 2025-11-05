enum IAPProductType {
  consumable,
  nonConsumable,
  subscription,
}

enum IAPCategory {
  coins,
  gems,
  lives,
  powerUpPack,
  premium,
}

class IAPProduct {
  final String id;
  final String name;
  final String description;
  final String price;
  final IAPProductType type;
  final IAPCategory category;
  final int? coinAmount;
  final int? gemAmount;
  final int? liveAmount;

  const IAPProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.type,
    required this.category,
    this.coinAmount,
    this.gemAmount,
    this.liveAmount,
  });

  // Consumables - Coins
  static const IAPProduct coins100 = IAPProduct(
    id: 'coins_100',
    name: '100 Coins',
    description: 'Get 100 coins',
    price: '\$0.99',
    type: IAPProductType.consumable,
    category: IAPCategory.coins,
    coinAmount: 100,
  );

  static const IAPProduct coins500 = IAPProduct(
    id: 'coins_500',
    name: '500 Coins',
    description: 'Get 500 coins',
    price: '\$3.99',
    type: IAPProductType.consumable,
    category: IAPCategory.coins,
    coinAmount: 500,
  );

  static const IAPProduct coins1000 = IAPProduct(
    id: 'coins_1000',
    name: '1,000 Coins',
    description: 'Get 1,000 coins',
    price: '\$6.99',
    type: IAPProductType.consumable,
    category: IAPCategory.coins,
    coinAmount: 1000,
  );

  // Consumables - Gems
  static const IAPProduct gems100 = IAPProduct(
    id: 'gems_100',
    name: '100 Gems',
    description: 'Get 100 gems',
    price: '\$0.99',
    type: IAPProductType.consumable,
    category: IAPCategory.gems,
    gemAmount: 100,
  );

  static const IAPProduct gems600 = IAPProduct(
    id: 'gems_600',
    name: '600 Gems',
    description: 'Get 600 gems (20% bonus)',
    price: '\$4.99',
    type: IAPProductType.consumable,
    category: IAPCategory.gems,
    gemAmount: 600,
  );

  static const IAPProduct gems1500 = IAPProduct(
    id: 'gems_1500',
    name: '1,500 Gems',
    description: 'Get 1,500 gems (50% bonus)',
    price: '\$9.99',
    type: IAPProductType.consumable,
    category: IAPCategory.gems,
    gemAmount: 1500,
  );

  // Consumables - Lives
  static const IAPProduct lives5 = IAPProduct(
    id: 'lives_5',
    name: '5 Lives',
    description: 'Get 5 lives instantly',
    price: '\$0.99',
    type: IAPProductType.consumable,
    category: IAPCategory.lives,
    liveAmount: 5,
  );

  // Power-Up Packs
  static const IAPProduct starterPack = IAPProduct(
    id: 'starter_pack',
    name: 'Starter Pack',
    description: '5 hints, 3 extra time power-ups',
    price: '\$2.99',
    type: IAPProductType.consumable,
    category: IAPCategory.powerUpPack,
  );

  static const IAPProduct proPack = IAPProduct(
    id: 'pro_pack',
    name: 'Pro Pack',
    description: '15 hints, 10 extra time, 5 slow-mo',
    price: '\$7.99',
    type: IAPProductType.consumable,
    category: IAPCategory.powerUpPack,
  );

  // Premium Features
  static const IAPProduct removeAds = IAPProduct(
    id: 'remove_ads',
    name: 'Remove All Ads',
    description: 'Permanently remove all ads',
    price: '\$4.99',
    type: IAPProductType.nonConsumable,
    category: IAPCategory.premium,
  );

  static const IAPProduct vipPass = IAPProduct(
    id: 'vip_pass',
    name: 'VIP Pass',
    description: 'No ads + 2x coins + exclusive themes',
    price: '\$9.99/month',
    type: IAPProductType.subscription,
    category: IAPCategory.premium,
  );

  static const IAPProduct unlockThemes = IAPProduct(
    id: 'unlock_all_themes',
    name: 'Unlock All Themes',
    description: 'Unlock all 8 themes permanently',
    price: '\$2.99',
    type: IAPProductType.nonConsumable,
    category: IAPCategory.premium,
  );

  // All available products
  static const List<IAPProduct> allProducts = [
    // Coins
    coins100,
    coins500,
    coins1000,
    // Gems
    gems100,
    gems600,
    gems1500,
    // Lives
    lives5,
    // Power-Up Packs
    starterPack,
    proPack,
    // Premium
    removeAds,
    vipPass,
    unlockThemes,
  ];

  static IAPProduct? getById(String id) {
    try {
      return allProducts.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}
