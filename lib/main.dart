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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Initialize Flame
  await Flame.device.fullScreen();
  await Flame.device.setPortrait();

  // Initialize services
  final storageService = StorageService();
  await storageService.init();

  final audioService = AudioService();
  await audioService.init();

  final adService = AdService();
  await adService.init();

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: storageService),
        Provider.value(value: audioService),
        Provider.value(value: adService),
        ChangeNotifierProvider(
          create: (_) => GameProvider(storageService),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(storageService),
        ),
      ],
      child: const SequenceRushApp(),
    ),
  );
}
