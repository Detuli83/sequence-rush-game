import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/game_provider.dart';
import '../services/audio_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final audioService = context.read<AudioService>();
    final gameProvider = context.read<GameProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Audio',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SwitchListTile(
            title: const Text('Music'),
            subtitle: Text(settings.musicEnabled ? 'On' : 'Off'),
            value: settings.musicEnabled,
            onChanged: (value) {
              settings.toggleMusic();
              if (value) {
                audioService.playMusic('game_music');
              } else {
                audioService.stopMusic();
              }
            },
            secondary: const Icon(Icons.music_note),
          ),
          SwitchListTile(
            title: const Text('Sound Effects'),
            subtitle: Text(settings.sfxEnabled ? 'On' : 'Off'),
            value: settings.sfxEnabled,
            onChanged: (value) {
              settings.toggleSfx();
              if (value) {
                audioService.playSfx('click');
              }
            },
            secondary: const Icon(Icons.volume_up),
          ),
          SwitchListTile(
            title: const Text('Haptic Feedback'),
            subtitle: Text(settings.hapticsEnabled ? 'On' : 'Off'),
            value: settings.hapticsEnabled,
            onChanged: (value) {
              settings.toggleHaptics();
              if (value) {
                audioService.playHapticLight();
              }
            },
            secondary: const Icon(Icons.vibration),
          ),
          const Divider(height: 32),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Appearance',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: Text(settings.isDarkMode ? 'On' : 'Off'),
            value: settings.isDarkMode,
            onChanged: (value) => settings.toggleDarkMode(),
            secondary: const Icon(Icons.dark_mode),
          ),
          const Divider(height: 32),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Game Data',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Player Stats'),
            subtitle: Text(
              'Level ${gameProvider.currentLevelNumber} • ${gameProvider.coins} coins • ${gameProvider.gems} gems',
            ),
          ),
          ListTile(
            leading: const Icon(Icons.emoji_events),
            title: const Text('Achievements'),
            subtitle: Text(
              '${gameProvider.playerData.completedAchievements.length} unlocked',
            ),
          ),
          ListTile(
            leading: const Icon(Icons.restore),
            title: const Text('Restore Purchases'),
            subtitle: const Text('Restore previous IAP purchases'),
            onTap: () {
              _showRestorePurchasesDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: const Text('Reset Progress', style: TextStyle(color: Colors.red)),
            subtitle: const Text('Delete all game data (cannot be undone)'),
            onTap: () {
              _showResetProgressDialog(context, gameProvider);
            },
          ),
          const Divider(height: 32),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'About',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('Version'),
            subtitle: Text('1.0.0 (Phase 2 - MVP Complete)'),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Privacy Policy'),
            onTap: () {
              _showInfoDialog(
                context,
                'Privacy Policy',
                'This app stores data locally on your device. No personal information is collected or shared with third parties.',
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Terms of Service'),
            onTap: () {
              _showInfoDialog(
                context,
                'Terms of Service',
                'By using this app, you agree to our terms of service. The app is provided "as is" without warranty.',
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Credits'),
            onTap: () {
              _showInfoDialog(
                context,
                'Credits',
                'Developed with Flutter & Flame\n\nGame Design: Sequence Rush Team\nDevelopment: AI-Assisted Implementation\n\nThank you for playing!',
              );
            },
          ),
        ],
      ),
    );
  }

  void _showRestorePurchasesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restore Purchases'),
        content: const Text('Checking for previous purchases...'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No purchases found to restore')),
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showResetProgressDialog(BuildContext context, GameProvider gameProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Progress?'),
        content: const Text(
          'This will delete all your game data including:\n\n'
          '• Level progress\n'
          '• Coins and gems\n'
          '• Unlocked themes\n'
          '• Achievements\n'
          '• High scores\n\n'
          'This action cannot be undone!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () async {
              await gameProvider.resetProgress();
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pop(context); // Go back to main menu
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Progress reset successfully')),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('RESET'),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
