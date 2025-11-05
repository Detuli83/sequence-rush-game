# Sequence Rush - Flutter/Flame Implementation Guide

**Version:** 1.0  
**Date:** November 5, 2025  
**For:** Flutter Developers  
**Tech Stack:** Flutter 3.24+, Flame 1.18+  

---

## 1. PROJECT SETUP

### 1.1 Create Flutter Project

```bash
# Create new Flutter project
flutter create sequence_rush
cd sequence_rush

# Clean up default files
rm -rf test/
rm lib/main.dart
```

### 1.2 Dependencies (pubspec.yaml)

```yaml
name: sequence_rush
description: A memory + reflex mobile game
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.2.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # Game engine
  flame: ^1.18.0
  flame_audio: ^2.1.0
  
  # State management
  provider: ^6.1.0
  
  # Local storage
  shared_preferences: ^2.2.0
  
  # Ads
  google_mobile_ads: ^5.0.0
  
  # Analytics (optional)
  firebase_analytics: ^10.7.0
  firebase_crashlytics: ^3.4.0
  
  # UI utilities
  flutter_animate: ^4.5.0
  confetti: ^0.7.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
    - assets/audio/sfx/
    - assets/audio/music/
  
  fonts:
    - family: Poppins
      fonts:
        - asset: assets/fonts/Poppins-Regular.ttf
        - asset: assets/fonts/Poppins-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Poppins-Bold.ttf
          weight: 700
```

### 1.3 Project Structure

```
lib/
├── main.dart
├── app.dart
├── config/
│   ├── theme.dart
│   ├── constants.dart
│   └── colors.dart
├── models/
│   ├── level.dart
│   ├── game_state.dart
│   ├── power_up.dart
│   └── player_data.dart
├── services/
│   ├── storage_service.dart
│   ├── audio_service.dart
│   ├── ad_service.dart
│   └── analytics_service.dart
├── providers/
│   ├── game_provider.dart
│   └── settings_provider.dart
├── screens/
│   ├── main_menu_screen.dart
│   ├── game_screen.dart
│   ├── settings_screen.dart
│   ├── shop_screen.dart
│   └── achievements_screen.dart
├── widgets/
│   ├── color_button.dart
│   ├── timer_widget.dart
│   ├── lives_indicator.dart
│   ├── custom_button.dart
│   └── modal_dialog.dart
├── game/
│   ├── sequence_rush_game.dart
│   ├── components/
│   │   ├── color_button_component.dart
│   │   ├── timer_component.dart
│   │   ├── particles/
│   │   │   ├── confetti_particle.dart
│   │   │   └── glow_effect.dart
│   │   └── grid_manager.dart
│   └── utils/
│       ├── sequence_generator.dart
│       └── score_calculator.dart
└── utils/
    ├── constants.dart
    └── helpers.dart
```

---

## 2. CORE IMPLEMENTATION

### 2.1 Main Entry Point (main.dart)

```dart
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
```

### 2.2 App Widget (app.dart)

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'screens/main_menu_screen.dart';
import 'providers/settings_provider.dart';

class SequenceRushApp extends StatelessWidget {
  const SequenceRushApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        return MaterialApp(
          title: 'Sequence Rush',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const MainMenuScreen(),
        );
      },
    );
  }
}
```

### 2.3 Theme Configuration (config/theme.dart)

```dart
import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.accent,
      scaffoldBackgroundColor: AppColors.lightBgPrimary,
      fontFamily: 'Poppins',
      textTheme: _textTheme(AppColors.lightTextPrimary),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.accent,
      scaffoldBackgroundColor: AppColors.darkBgPrimary,
      fontFamily: 'Poppins',
      textTheme: _textTheme(AppColors.darkTextPrimary),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  static TextTheme _textTheme(Color color) {
    return TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color),
      displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
      displaySmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: color),
      bodyLarge: TextStyle(fontSize: 16, color: color),
      bodyMedium: TextStyle(fontSize: 14, color: color),
      bodySmall: TextStyle(fontSize: 12, color: color),
    );
  }
}
```

### 2.4 Color Constants (config/colors.dart)

```dart
import 'package:flutter/material.dart';

class AppColors {
  // Button colors
  static const Color red = Color(0xFFFF3B30);
  static const Color blue = Color(0xFF007AFF);
  static const Color green = Color(0xFF34C759);
  static const Color yellow = Color(0xFFFFCC00);
  static const Color orange = Color(0xFFFF9500);
  static const Color purple = Color(0xFFAF52DE);
  static const Color pink = Color(0xFFFF2D55);
  static const Color cyan = Color(0xFF5AC8FA);

  // UI colors - Light theme
  static const Color lightBgPrimary = Color(0xFFFFFFFF);
  static const Color lightBgSecondary = Color(0xFFF2F2F7);
  static const Color lightTextPrimary = Color(0xFF000000);
  static const Color lightTextSecondary = Color(0xFF3C3C43);

  // UI colors - Dark theme
  static const Color darkBgPrimary = Color(0xFF1C1C1E);
  static const Color darkBgSecondary = Color(0xFF2C2C2E);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFEBEBF5);

  // Common colors
  static const Color accent = blue;
  static const Color success = green;
  static const Color warning = orange;
  static const Color error = red;

  // Get button colors list
  static List<Color> getButtonColors(int count) {
    const colors = [red, blue, green, yellow, orange, purple, pink, cyan];
    return colors.take(count).toList();
  }
}
```

---

## 3. DATA MODELS

### 3.1 Level Model (models/level.dart)

```dart
class Level {
  final int number;
  final int sequenceLength;
  final int colorCount;
  final double timeLimit;
  final int baseScore;

  Level({
    required this.number,
    required this.sequenceLength,
    required this.colorCount,
    required this.timeLimit,
    required this.baseScore,
  });

  // Generate level configuration based on level number
  factory Level.fromNumber(int number) {
    // World 1: Levels 1-20 (4 colors)
    if (number <= 20) {
      return Level(
        number: number,
        sequenceLength: 3 + (number ~/ 6), // 3-6 steps
        colorCount: 4,
        timeLimit: 15.0 - (number * 0.15), // 15s -> 12s
        baseScore: 100 * (3 + (number ~/ 6)),
      );
    }
    // World 2: Levels 21-40 (6 colors)
    else if (number <= 40) {
      final worldLevel = number - 20;
      return Level(
        number: number,
        sequenceLength: 4 + (worldLevel ~/ 5), // 4-7 steps
        colorCount: 6,
        timeLimit: 14.0 - (worldLevel * 0.15),
        baseScore: 100 * (4 + (worldLevel ~/ 5)),
      );
    }
    // World 3+: Advanced levels
    else {
      final worldLevel = number - 40;
      return Level(
        number: number,
        sequenceLength: 6 + (worldLevel ~/ 5), // 6-9+ steps
        colorCount: 8,
        timeLimit: 12.0 - (worldLevel * 0.1).clamp(0, 3),
        baseScore: 100 * (6 + (worldLevel ~/ 5)),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'sequenceLength': sequenceLength,
      'colorCount': colorCount,
      'timeLimit': timeLimit,
      'baseScore': baseScore,
    };
  }
}
```

### 3.2 Player Data Model (models/player_data.dart)

```dart
class PlayerData {
  int currentLevel;
  int lives;
  int coins;
  int gems;
  DateTime lastLifeUpdate;
  List<int> highScores;
  List<int> unlockedThemes;
  int currentTheme;
  Set<int> completedAchievements;
  Map<String, bool> settings;

  PlayerData({
    this.currentLevel = 1,
    this.lives = 5,
    this.coins = 0,
    this.gems = 0,
    DateTime? lastLifeUpdate,
    List<int>? highScores,
    List<int>? unlockedThemes,
    this.currentTheme = 0,
    Set<int>? completedAchievements,
    Map<String, bool>? settings,
  })  : lastLifeUpdate = lastLifeUpdate ?? DateTime.now(),
        highScores = highScores ?? [],
        unlockedThemes = unlockedThemes ?? [0],
        completedAchievements = completedAchievements ?? {},
        settings = settings ?? {
          'music': true,
          'sfx': true,
          'haptics': true,
        };

  // Update lives based on time elapsed
  void updateLives() {
    if (lives >= 5) return;

    final now = DateTime.now();
    final minutesElapsed = now.difference(lastLifeUpdate).inMinutes;
    final livesToAdd = minutesElapsed ~/ 15; // 1 life per 15 minutes

    if (livesToAdd > 0) {
      lives = (lives + livesToAdd).clamp(0, 5);
      lastLifeUpdate = now;
    }
  }

  void addCoins(int amount) {
    coins += amount;
  }

  void spendCoins(int amount) {
    coins -= amount;
    if (coins < 0) coins = 0;
  }

  void addGems(int amount) {
    gems += amount;
  }

  void loseLife() {
    lives--;
    if (lives < 0) lives = 0;
  }

  void addLife() {
    lives++;
    if (lives > 5) lives = 5;
  }

  Map<String, dynamic> toJson() {
    return {
      'currentLevel': currentLevel,
      'lives': lives,
      'coins': coins,
      'gems': gems,
      'lastLifeUpdate': lastLifeUpdate.toIso8601String(),
      'highScores': highScores,
      'unlockedThemes': unlockedThemes,
      'currentTheme': currentTheme,
      'completedAchievements': completedAchievements.toList(),
      'settings': settings,
    };
  }

  factory PlayerData.fromJson(Map<String, dynamic> json) {
    return PlayerData(
      currentLevel: json['currentLevel'] ?? 1,
      lives: json['lives'] ?? 5,
      coins: json['coins'] ?? 0,
      gems: json['gems'] ?? 0,
      lastLifeUpdate: json['lastLifeUpdate'] != null
          ? DateTime.parse(json['lastLifeUpdate'])
          : DateTime.now(),
      highScores: List<int>.from(json['highScores'] ?? []),
      unlockedThemes: List<int>.from(json['unlockedThemes'] ?? [0]),
      currentTheme: json['currentTheme'] ?? 0,
      completedAchievements: Set<int>.from(json['completedAchievements'] ?? []),
      settings: Map<String, bool>.from(json['settings'] ?? {
        'music': true,
        'sfx': true,
        'haptics': true,
      }),
    );
  }
}
```

---

## 4. SERVICES

### 4.1 Storage Service (services/storage_service.dart)

```dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/player_data.dart';

class StorageService {
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Player data
  Future<PlayerData> loadPlayerData() async {
    final jsonString = _prefs?.getString('player_data');
    if (jsonString == null) {
      return PlayerData();
    }
    return PlayerData.fromJson(jsonDecode(jsonString));
  }

  Future<void> savePlayerData(PlayerData data) async {
    await _prefs?.setString('player_data', jsonEncode(data.toJson()));
  }

  // High scores
  Future<List<int>> getHighScores() async {
    final data = await loadPlayerData();
    return data.highScores;
  }

  Future<void> addHighScore(int score) async {
    final data = await loadPlayerData();
    data.highScores.add(score);
    data.highScores.sort((a, b) => b.compareTo(a)); // Sort descending
    if (data.highScores.length > 10) {
      data.highScores = data.highScores.take(10).toList();
    }
    await savePlayerData(data);
  }

  // Settings
  Future<bool> getSetting(String key, {bool defaultValue = true}) async {
    final data = await loadPlayerData();
    return data.settings[key] ?? defaultValue;
  }

  Future<void> setSetting(String key, bool value) async {
    final data = await loadPlayerData();
    data.settings[key] = value;
    await savePlayerData(data);
  }

  // Clear all data (for testing)
  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
```

### 4.2 Audio Service (services/audio_service.dart)

```dart
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/services.dart';

class AudioService {
  bool _musicEnabled = true;
  bool _sfxEnabled = true;
  
  final Map<String, String> _sfxFiles = {
    'red': 'button_red.ogg',
    'blue': 'button_blue.ogg',
    'green': 'button_green.ogg',
    'yellow': 'button_yellow.ogg',
    'orange': 'button_orange.ogg',
    'purple': 'button_purple.ogg',
    'pink': 'button_pink.ogg',
    'cyan': 'button_cyan.ogg',
    'success': 'success.ogg',
    'error': 'error.ogg',
    'click': 'click.ogg',
    'coin': 'coin.ogg',
    'level_complete': 'level_complete.ogg',
    'powerup': 'powerup.ogg',
  };

  Future<void> init() async {
    // Preload all sound effects
    await FlameAudio.audioCache.loadAll([
      'sfx/button_red.ogg',
      'sfx/button_blue.ogg',
      'sfx/button_green.ogg',
      'sfx/button_yellow.ogg',
      'sfx/button_orange.ogg',
      'sfx/button_purple.ogg',
      'sfx/button_pink.ogg',
      'sfx/button_cyan.ogg',
      'sfx/success.ogg',
      'sfx/error.ogg',
      'sfx/click.ogg',
      'sfx/coin.ogg',
      'sfx/level_complete.ogg',
      'sfx/powerup.ogg',
    ]);
  }

  void setMusicEnabled(bool enabled) {
    _musicEnabled = enabled;
    if (!enabled) {
      FlameAudio.bgm.stop();
    }
  }

  void setSfxEnabled(bool enabled) {
    _sfxEnabled = enabled;
  }

  Future<void> playMusic(String track) async {
    if (!_musicEnabled) return;
    await FlameAudio.bgm.play('music/$track.ogg', volume: 0.3);
  }

  void stopMusic() {
    FlameAudio.bgm.stop();
  }

  void pauseMusic() {
    FlameAudio.bgm.pause();
  }

  void resumeMusic() {
    if (_musicEnabled) {
      FlameAudio.bgm.resume();
    }
  }

  Future<void> playSfx(String name) async {
    if (!_sfxEnabled || !_sfxFiles.containsKey(name)) return;
    await FlameAudio.play('sfx/${_sfxFiles[name]}', volume: 0.5);
  }

  void playButtonSound(int colorIndex) {
    final colors = ['red', 'blue', 'green', 'yellow', 'orange', 'purple', 'pink', 'cyan'];
    if (colorIndex < colors.length) {
      playSfx(colors[colorIndex]);
    }
  }

  void playHaptic() {
    HapticFeedback.lightImpact();
  }
}
```

### 4.3 Ad Service (services/ad_service.dart)

```dart
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

class AdService {
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  bool _interstitialReady = false;
  bool _rewardedReady = false;
  int _gameOverCount = 0;

  // Test ad unit IDs
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712'; // Test ID
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910'; // Test ID
    }
    return '';
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917'; // Test ID
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/1712485313'; // Test ID
    }
    return '';
  }

  Future<void> init() async {
    await MobileAds.instance.initialize();
    _loadInterstitialAd();
    _loadRewardedAd();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialReady = true;
        },
        onAdFailedToLoad: (error) {
          _interstitialReady = false;
        },
      ),
    );
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _rewardedReady = true;
        },
        onAdFailedToLoad: (error) {
          _rewardedReady = false;
        },
      ),
    );
  }

  Future<void> showInterstitialAd() async {
    _gameOverCount++;
    
    // Show ad every 3 game overs
    if (_gameOverCount % 3 != 0) return;
    
    if (_interstitialReady && _interstitialAd != null) {
      await _interstitialAd!.show();
      _interstitialReady = false;
      _loadInterstitialAd(); // Reload for next time
    }
  }

  Future<bool> showRewardedAd(Function onRewardEarned) async {
    if (!_rewardedReady || _rewardedAd == null) {
      return false;
    }

    bool rewarded = false;
    
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadRewardedAd();
      },
    );

    await _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) {
        rewarded = true;
        onRewardEarned();
      },
    );

    _rewardedReady = false;
    return rewarded;
  }

  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }
}
```

---

## 5. GAME LOGIC

### 5.1 Sequence Generator (game/utils/sequence_generator.dart)

```dart
import 'dart:math';

class SequenceGenerator {
  final Random _random = Random();

  List<int> generateSequence(int length, int colorCount) {
    return List.generate(length, (_) => _random.nextInt(colorCount));
  }

  // Ensure sequences don't repeat the same color more than 3 times
  List<int> generateBalancedSequence(int length, int colorCount) {
    final sequence = <int>[];
    int? lastColor;
    int repeatCount = 0;

    for (int i = 0; i < length; i++) {
      int nextColor;
      
      if (repeatCount >= 3) {
        // Force a different color
        do {
          nextColor = _random.nextInt(colorCount);
        } while (nextColor == lastColor);
        repeatCount = 1;
      } else {
        nextColor = _random.nextInt(colorCount);
        if (nextColor == lastColor) {
          repeatCount++;
        } else {
          repeatCount = 1;
        }
      }
      
      sequence.add(nextColor);
      lastColor = nextColor;
    }

    return sequence;
  }
}
```

### 5.2 Score Calculator (game/utils/score_calculator.dart)

```dart
class ScoreCalculator {
  static int calculateScore({
    required int baseScore,
    required double remainingTime,
    required int comboMultiplier,
    required bool isPerfect,
  }) {
    // Base score from level
    int score = baseScore;

    // Time bonus (50 points per second remaining)
    int timeBonus = (remainingTime * 50).round();
    score += timeBonus;

    // Apply combo multiplier
    score = (score * comboMultiplier).round();

    // Perfect level bonus
    if (isPerfect) {
      score += 500;
    }

    return score;
  }

  static int calculateComboMultiplier(int streak) {
    if (streak >= 10) return 3;
    if (streak >= 5) return 2;
    if (streak >= 3) return 1.5.round();
    return 1;
  }
}
```

### 5.3 Game Provider (providers/game_provider.dart)

```dart
import 'package:flutter/foundation.dart';
import '../models/player_data.dart';
import '../models/level.dart';
import '../services/storage_service.dart';
import '../game/utils/sequence_generator.dart';
import '../game/utils/score_calculator.dart';

class GameProvider with ChangeNotifier {
  final StorageService _storage;
  final SequenceGenerator _sequenceGenerator = SequenceGenerator();
  
  PlayerData _playerData = PlayerData();
  Level? _currentLevel;
  List<int>? _currentSequence;
  List<int> _userInput = [];
  int _consecutivePerfectLevels = 0;
  bool _isPerfectLevel = true;

  GameProvider(this._storage) {
    _loadPlayerData();
  }

  // Getters
  PlayerData get playerData => _playerData;
  Level? get currentLevel => _currentLevel;
  List<int>? get currentSequence => _currentSequence;
  int get currentLevelNumber => _playerData.currentLevel;
  int get lives => _playerData.lives;
  int get coins => _playerData.coins;
  int get gems => _playerData.gems;

  Future<void> _loadPlayerData() async {
    _playerData = await _storage.loadPlayerData();
    _playerData.updateLives(); // Update lives based on time
    await _savePlayerData();
    notifyListeners();
  }

  Future<void> _savePlayerData() async {
    await _storage.savePlayerData(_playerData);
  }

  // Start a new level
  Future<void> startLevel(int levelNumber) async {
    _currentLevel = Level.fromNumber(levelNumber);
    _currentSequence = _sequenceGenerator.generateBalancedSequence(
      _currentLevel!.sequenceLength,
      _currentLevel!.colorCount,
    );
    _userInput = [];
    _isPerfectLevel = true;
    notifyListeners();
  }

  // User taps a button
  void addInput(int colorIndex) {
    if (_currentSequence == null) return;

    _userInput.add(colorIndex);
    
    // Check if input is correct
    final currentIndex = _userInput.length - 1;
    if (_userInput[currentIndex] != _currentSequence![currentIndex]) {
      _isPerfectLevel = false;
    }

    notifyListeners();
  }

  // Check if sequence is complete and correct
  bool isSequenceComplete() {
    if (_currentSequence == null) return false;
    return _userInput.length == _currentSequence!.length;
  }

  bool isSequenceCorrect() {
    if (_currentSequence == null) return false;
    if (_userInput.length != _currentSequence!.length) return false;
    
    for (int i = 0; i < _userInput.length; i++) {
      if (_userInput[i] != _currentSequence![i]) return false;
    }
    return true;
  }

  // Complete level
  Future<int> completeLevel(double remainingTime) async {
    if (_currentLevel == null) return 0;

    // Calculate score
    final comboMultiplier = ScoreCalculator.calculateComboMultiplier(
      _consecutivePerfectLevels,
    );
    final score = ScoreCalculator.calculateScore(
      baseScore: _currentLevel!.baseScore,
      remainingTime: remainingTime,
      comboMultiplier: comboMultiplier,
      isPerfect: _isPerfectLevel,
    );

    // Update player data
    _playerData.currentLevel++;
    _playerData.addCoins(10); // Base coin reward
    
    if (_isPerfectLevel) {
      _consecutivePerfectLevels++;
      _playerData.addCoins(25); // Perfect level bonus
    } else {
      _consecutivePerfectLevels = 0;
    }

    await _storage.addHighScore(score);
    await _savePlayerData();
    
    notifyListeners();
    return score;
  }

  // Fail level
  Future<void> failLevel() async {
    _playerData.loseLife();
    _consecutivePerfectLevels = 0;
    await _savePlayerData();
    notifyListeners();
  }

  // Power-ups
  Future<void> usePowerUp(String type) async {
    switch (type) {
      case 'hint':
        if (_playerData.coins >= 50) {
          _playerData.spendCoins(50);
          await _savePlayerData();
          notifyListeners();
        }
        break;
      case 'extra_time':
        if (_playerData.coins >= 75) {
          _playerData.spendCoins(75);
          await _savePlayerData();
          notifyListeners();
        }
        break;
      case 'slow_motion':
        if (_playerData.coins >= 100) {
          _playerData.spendCoins(100);
          await _savePlayerData();
          notifyListeners();
        }
        break;
    }
  }

  // Buy lives with ad
  void addLifeFromAd() {
    _playerData.addLife();
    _savePlayerData();
    notifyListeners();
  }

  // Add coins from ad
  void addCoinsFromAd(int amount) {
    _playerData.addCoins(amount);
    _savePlayerData();
    notifyListeners();
  }
}
```

---

## 6. FLAME GAME IMPLEMENTATION

### 6.1 Main Game Class (game/sequence_rush_game.dart)

```dart
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'components/color_button_component.dart';
import 'components/grid_manager.dart';
import 'utils/sequence_generator.dart';

enum GamePhase {
  memorize,
  execute,
  complete,
  failed,
}

class SequenceRushGame extends FlameGame {
  late GridManager gridManager;
  GamePhase phase = GamePhase.memorize;
  List<int> sequence = [];
  List<int> userInput = [];
  
  int sequenceLength = 4;
  int colorCount = 4;
  double timeLimit = 15.0;
  double remainingTime = 15.0;
  
  Function(bool success, double remainingTime)? onGameComplete;
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    gridManager = GridManager(
      colorCount: colorCount,
      onButtonPressed: handleButtonPress,
    );
    add(gridManager);
    
    startMemorizePhase();
  }

  void startMemorizePhase() {
    phase = GamePhase.memorize;
    sequence = SequenceGenerator().generateBalancedSequence(
      sequenceLength,
      colorCount,
    );
    userInput = [];
    
    // Show sequence
    gridManager.playSequence(sequence, onComplete: () {
      startExecutePhase();
    });
  }

  void startExecutePhase() {
    phase = GamePhase.execute;
    remainingTime = timeLimit;
  }

  void handleButtonPress(int colorIndex) {
    if (phase != GamePhase.execute) return;
    
    userInput.add(colorIndex);
    
    // Check if input is correct so far
    final currentIndex = userInput.length - 1;
    final isCorrect = userInput[currentIndex] == sequence[currentIndex];
    
    gridManager.highlightButton(colorIndex, isCorrect);
    
    if (!isCorrect) {
      // Wrong input - game over
      phase = GamePhase.failed;
      onGameComplete?.call(false, remainingTime);
      return;
    }
    
    // Check if sequence is complete
    if (userInput.length == sequence.length) {
      phase = GamePhase.complete;
      onGameComplete?.call(true, remainingTime);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    if (phase == GamePhase.execute) {
      remainingTime -= dt;
      if (remainingTime <= 0) {
        phase = GamePhase.failed;
        onGameComplete?.call(false, 0);
      }
    }
  }
}
```

---

## 7. SCREEN IMPLEMENTATIONS

### 7.1 Main Menu Screen (screens/main_menu_screen.dart)

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/custom_button.dart';
import 'game_screen.dart';

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
                  // Logo
                  Text(
                    'SEQUENCE RUSH',
                    style: Theme.of(context).textTheme.displayLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 60),
                  
                  // Play button
                  CustomButton(
                    text: 'PLAY NOW',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GameScreen(
                            levelNumber: gameProvider.currentLevelNumber,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  
                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat(
                        'Level',
                        '${gameProvider.currentLevelNumber}',
                      ),
                      _buildStat(
                        'Lives',
                        '♥' * gameProvider.lives,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat(
                        'Coins',
                        '${gameProvider.coins}',
                      ),
                      _buildStat(
                        'Gems',
                        '${gameProvider.gems}',
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

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
```

---

## 8. BUILD & DEPLOYMENT

### 8.1 Android Build Configuration

**android/app/build.gradle:**
```gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        applicationId "com.yourcompany.sequence_rush"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
    
    signingConfigs {
        release {
            // Add your signing config
        }
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
        }
    }
}
```

### 8.2 iOS Build Configuration

**ios/Runner/Info.plist:**
```xml
<key>NSUserTrackingUsageDescription</key>
<string>We use your data to provide personalized ads</string>
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-YOUR-ID~YOUR-APP-ID</string>
```

### 8.3 Build Commands

```bash
# Android APK
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release

# iOS
flutter build ios --release
```

---

## 9. TESTING CHECKLIST

- [ ] All levels generate correctly
- [ ] Sequence memorization works
- [ ] Input validation is accurate
- [ ] Timer counts down properly
- [ ] Score calculation is correct
- [ ] Lives system functions
- [ ] Coins/gems persistence
- [ ] Power-ups work as expected
- [ ] Ads display correctly
- [ ] Audio plays properly
- [ ] Haptic feedback works
- [ ] Theme switching functional
- [ ] Settings save/load
- [ ] Performance is smooth (60 FPS)
- [ ] Battery usage is reasonable
- [ ] No memory leaks
- [ ] Crash-free on target devices

---

## 10. OPTIMIZATION TIPS

1. **Use const constructors** wherever possible
2. **Preload assets** during splash screen
3. **Cache expensive computations**
4. **Dispose controllers** properly
5. **Use RepaintBoundary** for complex widgets
6. **Optimize image sizes** for different densities
7. **Profile with DevTools** regularly
8. **Test on low-end devices**

---

**This implementation guide provides a solid foundation for building Sequence Rush in Flutter/Flame. Adapt and extend as needed for your specific requirements.**

**Next Steps:**
1. Set up project with dependencies
2. Implement core game logic
3. Add UI screens
4. Integrate services (ads, audio)
5. Test thoroughly
6. Polish and optimize
7. Submit to stores

---

**Document Status:** Complete  
**For:** Development Team  
**Last Updated:** November 5, 2025
