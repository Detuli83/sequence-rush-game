import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/iap_product.dart';
import '../widgets/currency_display.dart';
import '../widgets/custom_button.dart';
import '../config/colors.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
      ),
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Balance
                _buildBalanceSection(gameProvider),
                const SizedBox(height: 24),

                // Lives Section
                _buildSectionTitle('Lives'),
                const SizedBox(height: 12),
                _buildLivesSection(context, gameProvider),
                const SizedBox(height: 24),

                // Coins Section
                _buildSectionTitle('Coins'),
                const SizedBox(height: 12),
                _buildCoinsSection(context, gameProvider),
                const SizedBox(height: 24),

                // Gems Section
                _buildSectionTitle('Gems'),
                const SizedBox(height: 12),
                _buildGemsSection(context, gameProvider),
                const SizedBox(height: 24),

                // Premium Section
                _buildSectionTitle('Premium'),
                const SizedBox(height: 12),
                _buildPremiumSection(context, gameProvider),
                const SizedBox(height: 24),

                // Watch Ad for Coins
                _buildAdSection(context, gameProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBalanceSection(GameProvider gameProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const Text(
                  'Your Balance',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    CurrencyDisplay(
                      amount: gameProvider.coins,
                      type: CurrencyType.coins,
                    ),
                    const SizedBox(width: 12),
                    CurrencyDisplay(
                      amount: gameProvider.gems,
                      type: CurrencyType.gems,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildLivesSection(BuildContext context, GameProvider gameProvider) {
    return Column(
      children: [
        _buildProductCard(
          context: context,
          product: IAPProduct.lives5,
          onPurchase: () => gameProvider.buyLivesWithIAP(),
        ),
        const SizedBox(height: 12),
        if (gameProvider.canWatchAdForLife)
          CustomButton(
            text: 'Watch Ad for 1 Life',
            icon: Icons.play_circle_outline,
            isOutlined: true,
            onPressed: () => gameProvider.watchAdForLife(),
          ),
      ],
    );
  }

  Widget _buildCoinsSection(BuildContext context, GameProvider gameProvider) {
    return Column(
      children: [
        _buildProductCard(
          context: context,
          product: IAPProduct.coins100,
          onPurchase: () => gameProvider.purchaseCoins(IAPProduct.coins100.id),
        ),
        const SizedBox(height: 12),
        _buildProductCard(
          context: context,
          product: IAPProduct.coins500,
          onPurchase: () => gameProvider.purchaseCoins(IAPProduct.coins500.id),
        ),
        const SizedBox(height: 12),
        _buildProductCard(
          context: context,
          product: IAPProduct.coins1000,
          onPurchase: () => gameProvider.purchaseCoins(IAPProduct.coins1000.id),
        ),
      ],
    );
  }

  Widget _buildGemsSection(BuildContext context, GameProvider gameProvider) {
    return Column(
      children: [
        _buildProductCard(
          context: context,
          product: IAPProduct.gems100,
          onPurchase: () => gameProvider.purchaseGems(IAPProduct.gems100.id),
        ),
        const SizedBox(height: 12),
        _buildProductCard(
          context: context,
          product: IAPProduct.gems600,
          onPurchase: () => gameProvider.purchaseGems(IAPProduct.gems600.id),
          badge: '20% BONUS',
        ),
        const SizedBox(height: 12),
        _buildProductCard(
          context: context,
          product: IAPProduct.gems1500,
          onPurchase: () => gameProvider.purchaseGems(IAPProduct.gems1500.id),
          badge: '50% BONUS',
        ),
      ],
    );
  }

  Widget _buildPremiumSection(BuildContext context, GameProvider gameProvider) {
    return Column(
      children: [
        _buildProductCard(
          context: context,
          product: IAPProduct.removeAds,
          onPurchase: () => gameProvider.removeAds(),
          icon: Icons.block,
        ),
      ],
    );
  }

  Widget _buildAdSection(BuildContext context, GameProvider gameProvider) {
    return Card(
      color: AppColors.coin.withOpacity(0.1),
      child: InkWell(
        onTap: () => gameProvider.watchAdForCoins(),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.play_circle_filled,
                size: 48,
                color: AppColors.accent,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Watch Ad for Coins',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Earn 25 coins instantly',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard({
    required BuildContext context,
    required IAPProduct product,
    required VoidCallback onPurchase,
    String? badge,
    IconData? icon,
  }) {
    return Card(
      child: InkWell(
        onTap: onPurchase,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon ?? _getIconForProduct(product),
                  size: 32,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (badge != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.warning,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              badge,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Text(
                product.price,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForProduct(IAPProduct product) {
    switch (product.category) {
      case IAPCategory.coins:
        return Icons.monetization_on;
      case IAPCategory.gems:
        return Icons.diamond;
      case IAPCategory.lives:
        return Icons.favorite;
      case IAPCategory.powerUpPack:
        return Icons.bolt;
      case IAPCategory.premium:
        return Icons.star;
    }
  }
}
