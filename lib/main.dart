import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flame/flame.dart';

import 'services/storage_service.dart';
import 'services/audio_service.dart';
import 'services/ad_service.dart';
import 'services/iap_service.dart';
import 'providers/game_provider.dart';
import 'config/theme.dart';
import 'screens/shop_screen.dart';
import 'widgets/custom_button.dart';
import 'widgets/lives_indicator.dart';
import 'widgets/currency_display.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialize Flame (for game engine)
  await Flame.device.fullScreen();
  await Flame.device.setPortrait();

  // Initialize services
  final storageService = StorageService();
  await storageService.init();

  final audioService = AudioService();
  await audioService.init();

  final adService = AdService();
  await adService.init();

  final iapService = IAPService(storageService);
  await iapService.init();

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: storageService),
        Provider.value(value: audioService),
        Provider.value(value: adService),
        Provider.value(value: iapService),
        ChangeNotifierProvider(
          create: (_) => GameProvider(
            storageService,
            adService,
            iapService,
            audioService,
          ),
        ),
      ],
      child: const SequenceRushApp(),
    ),
  );
}

class SequenceRushApp extends StatelessWidget {
  const SequenceRushApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sequence Rush',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const MainMenuScreen(),
    );
  }
}

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<GameProvider>(
          builder: (context, gameProvider, _) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo/Title
                  Text(
                    'SEQUENCE RUSH',
                    style: Theme.of(context).textTheme.displayLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Memory + Reflex Challenge',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 60),

                  // Currency Display
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CurrencyDisplay(
                        amount: gameProvider.coins,
                        type: CurrencyType.coins,
                      ),
                      const SizedBox(width: 16),
                      CurrencyDisplay(
                        amount: gameProvider.gems,
                        type: CurrencyType.gems,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Lives Indicator
                  LivesIndicator(lives: gameProvider.lives),
                  const SizedBox(height: 40),

                  // Play button
                  CustomButton(
                    text: 'PLAY NOW',
                    icon: Icons.play_arrow,
                    onPressed: gameProvider.hasLives
                        ? () {
                            // Navigate to game screen
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Game screen not implemented yet'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Shop button
                  CustomButton(
                    text: 'SHOP',
                    icon: Icons.shopping_bag,
                    isOutlined: true,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ShopScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),

                  // Stats
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildStatRow(
                            'Current Level',
                            '${gameProvider.currentLevelNumber}',
                          ),
                          const Divider(),
                          _buildStatRow(
                            'Perfect Streak',
                            '${gameProvider.consecutivePerfectLevels}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Watch Ad for Life (if applicable)
                  if (!gameProvider.hasLives &&
                      gameProvider.canWatchAdForLife) ...[
                    CustomButton(
                      text: 'Watch Ad for Life',
                      icon: Icons.play_circle_outline,
                      onPressed: () async {
                        await gameProvider.watchAdForLife();
                      },
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
