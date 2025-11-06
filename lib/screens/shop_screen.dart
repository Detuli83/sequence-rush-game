import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/theme_data.dart';
import '../providers/game_provider.dart';
import '../providers/settings_provider.dart';
import '../services/audio_service.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final audioService = context.read<AudioService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'THEMES'),
            Tab(text: 'CURRENCY'),
            Tab(text: 'POWER-UPS'),
          ],
        ),
        actions: [
          // Display current coins and gems
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber),
                const SizedBox(width: 4),
                Text('${gameProvider.coins}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(width: 16),
                const Icon(Icons.diamond, color: Colors.cyan),
                const SizedBox(width: 4),
                Text('${gameProvider.gems}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildThemesTab(gameProvider, audioService),
          _buildCurrencyTab(gameProvider, audioService),
          _buildPowerUpsTab(gameProvider, audioService),
        ],
      ),
    );
  }

  Widget _buildThemesTab(GameProvider gameProvider, AudioService audioService) {
    final themes = GameTheme.getAllThemes();
    final settings = context.read<SettingsProvider>();

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: themes.length,
      itemBuilder: (context, index) {
        final theme = themes[index];
        final isUnlocked = gameProvider.playerData.isThemeUnlocked(theme.id);
        final isActive = gameProvider.playerData.currentTheme == theme.id;

        return Card(
          elevation: isActive ? 8 : 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isActive ? BorderSide(color: theme.accent, width: 3) : BorderSide.none,
          ),
          child: InkWell(
            onTap: () => _handleThemeTap(theme, isUnlocked, gameProvider, audioService, settings),
            borderRadius: BorderRadius.circular(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Color preview
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: theme.buttonColors.take(4).map((color) {
                    return Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                Text(
                  theme.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                if (isActive)
                  const Text(
                    'ACTIVE',
                    style: TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold),
                  )
                else if (isUnlocked)
                  ElevatedButton(
                    onPressed: () => _activateTheme(theme, gameProvider, audioService, settings),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: const Text('ACTIVATE'),
                  )
                else
                  Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.monetization_on, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text('${theme.coinCost}'),
                        ],
                      ),
                      if (theme.gemCost != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('or '),
                            const Icon(Icons.diamond, size: 16, color: Colors.cyan),
                            const SizedBox(width: 4),
                            Text('${theme.gemCost}'),
                          ],
                        ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCurrencyTab(GameProvider gameProvider, AudioService audioService) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildCurrencyCard(
          title: '100 Coins',
          price: '\$0.99',
          icon: Icons.monetization_on,
          iconColor: Colors.amber,
          onTap: () => _purchaseCurrency('100_coins', gameProvider, audioService),
        ),
        _buildCurrencyCard(
          title: '500 Coins',
          price: '\$3.99',
          subtitle: 'Best Value!',
          icon: Icons.monetization_on,
          iconColor: Colors.amber,
          onTap: () => _purchaseCurrency('500_coins', gameProvider, audioService),
        ),
        _buildCurrencyCard(
          title: '1000 Coins',
          price: '\$6.99',
          icon: Icons.monetization_on,
          iconColor: Colors.amber,
          onTap: () => _purchaseCurrency('1000_coins', gameProvider, audioService),
        ),
        const Divider(height: 32),
        _buildCurrencyCard(
          title: '100 Gems',
          price: '\$0.99',
          icon: Icons.diamond,
          iconColor: Colors.cyan,
          onTap: () => _purchaseCurrency('100_gems', gameProvider, audioService),
        ),
        _buildCurrencyCard(
          title: '600 Gems',
          price: '\$4.99',
          subtitle: '20% Bonus!',
          icon: Icons.diamond,
          iconColor: Colors.cyan,
          onTap: () => _purchaseCurrency('600_gems', gameProvider, audioService),
        ),
        _buildCurrencyCard(
          title: '1500 Gems',
          price: '\$9.99',
          subtitle: '50% Bonus!',
          icon: Icons.diamond,
          iconColor: Colors.cyan,
          onTap: () => _purchaseCurrency('1500_gems', gameProvider, audioService),
        ),
      ],
    );
  }

  Widget _buildPowerUpsTab(GameProvider gameProvider, AudioService audioService) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Text(
            'Power-Up Packs',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        _buildPowerUpPackCard(
          title: 'Starter Pack',
          description: '5 Hints + 3 Extra Time',
          price: '\$2.99',
          onTap: () => _purchasePowerUpPack('starter', gameProvider, audioService),
        ),
        _buildPowerUpPackCard(
          title: 'Pro Pack',
          description: '15 Hints + 10 Extra Time + 5 Slow-Mo',
          price: '\$7.99',
          subtitle: 'Popular!',
          onTap: () => _purchasePowerUpPack('pro', gameProvider, audioService),
        ),
        _buildPowerUpPackCard(
          title: 'Ultimate Pack',
          description: 'Unlimited power-ups for 30 days',
          price: '\$14.99',
          subtitle: 'Best Value!',
          onTap: () => _purchasePowerUpPack('ultimate', gameProvider, audioService),
        ),
        const Divider(height: 32),
        const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Text(
            'Premium Features',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        _buildPowerUpPackCard(
          title: 'Remove All Ads',
          description: 'Enjoy ad-free gameplay forever',
          price: '\$4.99',
          onTap: () => _purchasePremium('remove_ads', gameProvider, audioService),
        ),
        _buildPowerUpPackCard(
          title: 'VIP Pass',
          description: 'No ads + 2x coins + exclusive themes',
          price: '\$9.99/month',
          subtitle: 'Recurring',
          onTap: () => _purchasePremium('vip_pass', gameProvider, audioService),
        ),
        _buildPowerUpPackCard(
          title: 'Unlock All Themes',
          description: 'Get all 8 themes instantly',
          price: '\$2.99',
          onTap: () => _purchasePremium('all_themes', gameProvider, audioService),
        ),
      ],
    );
  }

  Widget _buildCurrencyCard({
    required String title,
    required String price,
    String? subtitle,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, size: 40, color: iconColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(color: Colors.green)) : null,
        trailing: ElevatedButton(
          onPressed: onTap,
          child: Text(price),
        ),
      ),
    );
  }

  Widget _buildPowerUpPackCard({
    required String title,
    required String description,
    required String price,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.flash_on, size: 40, color: Colors.orange),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            if (subtitle != null)
              Text(subtitle, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: onTap,
          child: Text(price),
        ),
      ),
    );
  }

  void _handleThemeTap(
    GameTheme theme,
    bool isUnlocked,
    GameProvider gameProvider,
    AudioService audioService,
    SettingsProvider settings,
  ) {
    if (isUnlocked) {
      _activateTheme(theme, gameProvider, audioService, settings);
    } else {
      _purchaseTheme(theme, gameProvider, audioService, settings);
    }
  }

  void _activateTheme(
    GameTheme theme,
    GameProvider gameProvider,
    AudioService audioService,
    SettingsProvider settings,
  ) {
    gameProvider.setTheme(theme.id);
    audioService.playSfx('click');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${theme.name} theme activated!')),
    );
  }

  void _purchaseTheme(
    GameTheme theme,
    GameProvider gameProvider,
    AudioService audioService,
    SettingsProvider settings,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Purchase ${theme.name}?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Do you want to unlock the ${theme.name} theme?'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    if (gameProvider.playerData.spendCoins(theme.coinCost)) {
                      gameProvider.unlockTheme(theme.id);
                      audioService.playSfx('coin');
                      Navigator.pop(context);
                      _activateTheme(theme, gameProvider, audioService, settings);
                    } else {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Not enough coins!')),
                      );
                    }
                  },
                  icon: const Icon(Icons.monetization_on, color: Colors.amber),
                  label: Text('${theme.coinCost}'),
                ),
                if (theme.gemCost != null) ...[
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (gameProvider.playerData.spendGems(theme.gemCost!)) {
                        gameProvider.unlockTheme(theme.id);
                        audioService.playSfx('coin');
                        Navigator.pop(context);
                        _activateTheme(theme, gameProvider, audioService, settings);
                      } else {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Not enough gems!')),
                        );
                      }
                    },
                    icon: const Icon(Icons.diamond, color: Colors.cyan),
                    label: Text('${theme.gemCost}'),
                  ),
                ],
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
        ],
      ),
    );
  }

  void _purchaseCurrency(String productId, GameProvider gameProvider, AudioService audioService) {
    // TODO: Implement actual IAP purchase
    // For now, show a placeholder message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Purchase $productId (IAP integration needed)')),
    );
  }

  void _purchasePowerUpPack(String packId, GameProvider gameProvider, AudioService audioService) {
    // TODO: Implement actual IAP purchase
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Purchase $packId pack (IAP integration needed)')),
    );
  }

  void _purchasePremium(String premiumId, GameProvider gameProvider, AudioService audioService) {
    // TODO: Implement actual IAP purchase
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Purchase $premiumId (IAP integration needed)')),
    );
  }
}
