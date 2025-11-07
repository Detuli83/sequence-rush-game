import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flame/flame.dart';

import 'app.dart';
import 'services/storage_service.dart';
import 'services/audio_service.dart';
import 'services/ad_service.dart';
import 'providers/game_provider.dart';
import 'providers/settings_provider.dart';

/// Entry point for Sequence Rush game
/// Initializes all services and launches the app
void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait orientation (GDD Section 6.4)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialize Flame for full-screen game experience
  await Flame.device.fullScreen();
  await Flame.device.setPortrait();

  // Initialize services
  print('Initializing Sequence Rush...');

  final storageService = StorageService();
  await storageService.init();
  print('✓ Storage service initialized');

  final audioService = AudioService();
  await audioService.init();
  print('✓ Audio service initialized');

  final adService = AdService();
  await adService.init();
  print('✓ Ad service initialized');

  print('Launching Sequence Rush!');

  // Launch app with providers
  runApp(
    MultiProvider(
      providers: [
        // Services (available to all providers)
        Provider.value(value: storageService),
        Provider.value(value: audioService),
        Provider.value(value: adService),

        // State providers
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(storageService),
        ),
        ChangeNotifierProvider(
          create: (_) => GameProvider(storageService),
        ),
      ],
      child: const SequenceRushApp(),
    ),
  );
}
