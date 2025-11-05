import 'package:flutter/foundation.dart';
import '../models/player_data.dart';
import '../models/level.dart';
import '../models/power_up.dart';
import '../models/iap_product.dart';
import '../services/storage_service.dart';
import '../services/ad_service.dart';
import '../services/iap_service.dart';
import '../services/audio_service.dart';
import '../config/constants.dart';

class GameProvider with ChangeNotifier {
  final StorageService _storage;
  final AdService _adService;
  final IAPService _iapService;
  final AudioService _audioService;

  PlayerData _playerData = PlayerData();
  Level? _currentLevel;
  int _consecutivePerfectLevels = 0;

  GameProvider(
    this._storage,
    this._adService,
    this._iapService,
    this._audioService,
  ) {
    _loadPlayerData();
  }

  // Getters
  PlayerData get playerData => _playerData;
  Level? get currentLevel => _currentLevel;
  int get currentLevelNumber => _playerData.currentLevel;
  int get lives => _playerData.lives;
  int get coins => _playerData.coins;
  int get gems => _playerData.gems;
  int get consecutivePerfectLevels => _consecutivePerfectLevels;

  Future<void> _loadPlayerData() async {
    _playerData = await _storage.loadPlayerData();
    _playerData.updateLives(); // Update lives based on time
    await _savePlayerData();

    // Check if ads have been removed
    final adsRemoved = await _storage.isPurchased(IAPProduct.removeAds.id);
    _adService.setAdsRemoved(adsRemoved);

    notifyListeners();
  }

  Future<void> _savePlayerData() async {
    await _storage.savePlayerData(_playerData);
  }

  // ============ LEVEL MANAGEMENT ============

  Future<void> startLevel(int levelNumber) async {
    _currentLevel = Level.fromNumber(levelNumber);
    notifyListeners();
  }

  Future<int> completeLevel({
    required double remainingTime,
    required bool isPerfect,
  }) async {
    if (_currentLevel == null) return 0;

    // Calculate score
    final comboMultiplier = _calculateComboMultiplier();
    final score = _calculateScore(
      baseScore: _currentLevel!.baseScore,
      remainingTime: remainingTime,
      comboMultiplier: comboMultiplier,
      isPerfect: isPerfect,
    );

    // Update player data
    _playerData.currentLevel++;
    _playerData.addCoins(GameConstants.coinsPerLevel);

    if (isPerfect) {
      _consecutivePerfectLevels++;
      _playerData.addCoins(GameConstants.coinsForPerfectLevel);
      _audioService.playSfx('level_complete');
    } else {
      _consecutivePerfectLevels = 0;
    }

    await _storage.addHighScore(score);
    await _savePlayerData();

    notifyListeners();
    return score;
  }

  Future<void> failLevel() async {
    _playerData.loseLife();
    _consecutivePerfectLevels = 0;
    await _savePlayerData();

    _audioService.playSfx('life_lost');

    // Show interstitial ad if applicable
    if (_playerData.lives == 0) {
      await _adService.showInterstitialAd();
    }

    notifyListeners();
  }

  int _calculateComboMultiplier() {
    if (_consecutivePerfectLevels >= 10) return GameConstants.combo10Multiplier;
    if (_consecutivePerfectLevels >= 5) return GameConstants.combo5Multiplier;
    if (_consecutivePerfectLevels >= 3) return GameConstants.combo3Multiplier;
    return 1;
  }

  int _calculateScore({
    required int baseScore,
    required double remainingTime,
    required int comboMultiplier,
    required bool isPerfect,
  }) {
    int score = baseScore;

    // Time bonus
    int timeBonus = (remainingTime * GameConstants.timeBonus).round();
    score += timeBonus;

    // Apply combo multiplier
    score = (score * comboMultiplier);

    // Perfect level bonus
    if (isPerfect) {
      score += GameConstants.perfectLevelBonus;
    }

    return score;
  }

  // ============ POWER-UPS ============

  Future<bool> usePowerUp(PowerUpType type, {bool useCoins = true}) async {
    final powerUp = PowerUp.getByType(type);
    if (powerUp == null) return false;

    if (useCoins) {
      if (_playerData.coins < powerUp.coinCost) {
        return false;
      }
      _playerData.spendCoins(powerUp.coinCost);
      await _savePlayerData();
      _audioService.playSfx('powerup');
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<bool> usePowerUpWithAd(PowerUpType type) async {
    final powerUp = PowerUp.getByType(type);
    if (powerUp == null || !powerUp.canUseAd) return false;

    final success = await _adService.showRewardedAd(() {
      _audioService.playSfx('powerup');
    });

    return success;
  }

  // ============ LIVES MANAGEMENT ============

  Future<void> watchAdForLife() async {
    if (!_playerData.canWatchAdForLife()) {
      return;
    }

    final success = await _adService.showRewardedAd(() {
      _playerData.addLife();
      _playerData.incrementAdForLifeCount();
      _savePlayerData();
      _audioService.playSfx('coin');
      notifyListeners();
    });

    if (!success) {
      // Ad failed to show
    }
  }

  Future<void> buyLivesWithIAP() async {
    final success = await _iapService.purchaseProduct(IAPProduct.lives5.id);
    if (success) {
      _playerData.addLives(5);
      await _savePlayerData();
      _audioService.playSfx('purchase');
      notifyListeners();
    }
  }

  // ============ CURRENCY MANAGEMENT ============

  Future<void> watchAdForCoins() async {
    final success = await _adService.showRewardedAd(() {
      _playerData.addCoins(GameConstants.coinsPerAd);
      _savePlayerData();
      _audioService.playSfx('coin');
      notifyListeners();
    });

    if (!success) {
      // Ad failed to show
    }
  }

  Future<void> purchaseCoins(String productId) async {
    final product = IAPProduct.getById(productId);
    if (product == null || product.coinAmount == null) return;

    final success = await _iapService.purchaseProduct(productId);
    if (success) {
      _playerData.addCoins(product.coinAmount!);
      await _savePlayerData();
      _audioService.playSfx('purchase');
      notifyListeners();
    }
  }

  Future<void> purchaseGems(String productId) async {
    final product = IAPProduct.getById(productId);
    if (product == null || product.gemAmount == null) return;

    final success = await _iapService.purchaseProduct(productId);
    if (success) {
      _playerData.addGems(product.gemAmount!);
      await _savePlayerData();
      _audioService.playSfx('purchase');
      notifyListeners();
    }
  }

  // ============ PREMIUM FEATURES ============

  Future<void> removeAds() async {
    final success =
        await _iapService.purchaseNonConsumable(IAPProduct.removeAds.id);
    if (success) {
      _adService.setAdsRemoved(true);
      _audioService.playSfx('purchase');
      notifyListeners();
    }
  }

  Future<bool> hasRemovedAds() async {
    return await _storage.isPurchased(IAPProduct.removeAds.id);
  }

  // ============ DAILY REWARDS ============

  Future<void> claimDailyBonus() async {
    // Check if daily bonus was already claimed today
    // This would require additional tracking in PlayerData
    _playerData.addCoins(GameConstants.dailyLoginBonus);
    await _savePlayerData();
    _audioService.playSfx('coin');
    notifyListeners();
  }

  // ============ SETTINGS ============

  Future<void> updateMusicSetting(bool enabled) async {
    _playerData.settings['music'] = enabled;
    _audioService.setMusicEnabled(enabled);
    await _savePlayerData();
    notifyListeners();
  }

  Future<void> updateSfxSetting(bool enabled) async {
    _playerData.settings['sfx'] = enabled;
    _audioService.setSfxEnabled(enabled);
    await _savePlayerData();
    notifyListeners();
  }

  Future<void> updateHapticsSetting(bool enabled) async {
    _playerData.settings['haptics'] = enabled;
    await _savePlayerData();
    notifyListeners();
  }

  // ============ UTILITIES ============

  bool canAffordPowerUp(PowerUpType type) {
    final powerUp = PowerUp.getByType(type);
    if (powerUp == null) return false;
    return _playerData.coins >= powerUp.coinCost;
  }

  bool get canWatchAdForLife => _playerData.canWatchAdForLife();
  bool get hasLives => _playerData.lives > 0;
  bool get isRewardedAdReady => _adService.isRewardedAdReady;
}
