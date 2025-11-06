import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../providers/settings_provider.dart';
import '../config/colors.dart';

/// Main menu screen
/// Entry point of the game showing player stats and navigation
class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer2<GameProvider, SettingsProvider>(
          builder: (context, gameProvider, settings, _) {
            // Show loading indicator while data loads
            if (!gameProvider.isLoaded) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Header with settings
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildHeaderStat(
                        context,
                        Icons.favorite,
                        '${gameProvider.lives}',
                        AppColors.error,
                      ),
                      _buildHeaderStat(
                        context,
                        Icons.monetization_on,
                        '${gameProvider.coins}',
                        AppColors.yellow,
                      ),
                      _buildHeaderStat(
                        context,
                        Icons.diamond,
                        '${gameProvider.gems}',
                        AppColors.cyan,
                      ),
                      IconButton(
                        icon: Icon(
                          settings.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        ),
                        onPressed: () => settings.toggleDarkMode(),
                      ),
                    ],
                  ),

                  // Logo/Title
                  Column(
                    children: [
                      Text(
                        'SEQUENCE',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                      ),
                      Text(
                        'RUSH',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accent,
                              letterSpacing: 2,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Memory + Reflex Game',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
                      ),
                    ],
                  ),

                  // Main actions
                  Column(
                    children: [
                      // Play button
                      ElevatedButton(
                        onPressed: gameProvider.hasLives
                            ? () {
                                // TODO: Navigate to game screen
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Game screen coming soon!'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 56),
                        ),
                        child: Text(
                          gameProvider.hasLives
                              ? 'PLAY NOW'
                              : 'NO LIVES - WAIT OR WATCH AD',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Level info
                      Text(
                        'LEVEL ${gameProvider.currentLevel}',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.bold,
                            ),
                      ),

                      const SizedBox(height: 8),

                      // Stats row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStat(
                            context,
                            'BEST SCORE',
                            '${gameProvider.bestScore}',
                          ),
                          _buildStat(
                            context,
                            'PERFECT STREAK',
                            '${gameProvider.consecutivePerfectLevels}',
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Bottom navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavButton(
                        context,
                        Icons.emoji_events,
                        'Achievements',
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Coming soon!')),
                          );
                        },
                      ),
                      _buildNavButton(
                        context,
                        Icons.shopping_bag,
                        'Shop',
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Coming soon!')),
                          );
                        },
                      ),
                      _buildNavButton(
                        context,
                        Icons.settings,
                        'Settings',
                        () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Coming soon!')),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderStat(
    BuildContext context,
    IconData icon,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildStat(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.accent,
              ),
        ),
      ],
    );
  }

  Widget _buildNavButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, size: 32, color: AppColors.accent),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
