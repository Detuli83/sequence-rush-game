import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/constants.dart';

/// Service for managing ads (Interstitial and Rewarded)
/// Based on GDD Section 7.1 - Ad Integration
class AdService {
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  bool _interstitialReady = false;
  bool _rewardedReady = false;
  int _gameOverCount = 0;
  bool _isInitialized = false;

  /// Get interstitial ad unit ID based on platform
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return AdUnitIds.androidInterstitial;
    } else if (Platform.isIOS) {
      return AdUnitIds.iosInterstitial;
    }
    return '';
  }

  /// Get rewarded ad unit ID based on platform
  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return AdUnitIds.androidRewarded;
    } else if (Platform.isIOS) {
      return AdUnitIds.iosRewarded;
    }
    return '';
  }

  /// Initialize AdMob SDK and load initial ads
  Future<void> init() async {
    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;

      // Load initial ads
      _loadInterstitialAd();
      _loadRewardedAd();

      print('AdService initialized successfully');
    } catch (e) {
      print('AdService initialization error: $e');
      _isInitialized = false;
    }
  }

  bool get isInitialized => _isInitialized;

  // ===== Interstitial Ads =====

  /// Load an interstitial ad
  void _loadInterstitialAd() {
    if (!_isInitialized) return;

    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialReady = true;
          print('Interstitial ad loaded');

          // Set callbacks
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialReady = false;
              _loadInterstitialAd(); // Load next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('Interstitial ad failed to show: $error');
              ad.dispose();
              _interstitialReady = false;
              _loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          print('Interstitial ad failed to load: $error');
          _interstitialReady = false;
          // Retry after delay
          Future.delayed(const Duration(seconds: 30), _loadInterstitialAd);
        },
      ),
    );
  }

  /// Show interstitial ad (with frequency control)
  /// Shows ad every 3 game overs as per GDD Section 7.1
  Future<void> showInterstitialAd({bool force = false}) async {
    if (!_isInitialized) return;

    _gameOverCount++;

    // Show ad every 3 game overs (unless forced)
    if (!force && _gameOverCount % GameConstants.adFrequencyGameOvers != 0) {
      return;
    }

    if (_interstitialReady && _interstitialAd != null) {
      await _interstitialAd!.show();
      _interstitialReady = false;
    } else {
      print('Interstitial ad not ready');
    }
  }

  /// Check if interstitial ad is ready
  bool get isInterstitialReady => _interstitialReady;

  // ===== Rewarded Ads =====

  /// Load a rewarded ad
  void _loadRewardedAd() {
    if (!_isInitialized) return;

    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _rewardedReady = true;
          print('Rewarded ad loaded');

          // Set callbacks
          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedReady = false;
              _loadRewardedAd(); // Load next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('Rewarded ad failed to show: $error');
              ad.dispose();
              _rewardedReady = false;
              _loadRewardedAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          print('Rewarded ad failed to load: $error');
          _rewardedReady = false;
          // Retry after delay
          Future.delayed(const Duration(seconds: 30), _loadRewardedAd);
        },
      ),
    );
  }

  /// Show rewarded ad with callback for reward
  /// Returns true if user watched ad and earned reward
  Future<bool> showRewardedAd(Function() onRewardEarned) async {
    if (!_isInitialized) {
      print('AdService not initialized');
      return false;
    }

    if (!_rewardedReady || _rewardedAd == null) {
      print('Rewarded ad not ready');
      return false;
    }

    bool rewarded = false;

    try {
      await _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          print('User earned reward: ${reward.amount} ${reward.type}');
          rewarded = true;
          onRewardEarned();
        },
      );
    } catch (e) {
      print('Error showing rewarded ad: $e');
      return false;
    }

    _rewardedReady = false;
    return rewarded;
  }

  /// Check if rewarded ad is ready
  bool get isRewardedReady => _rewardedReady;

  // ===== Rewarded Ad Helpers (GDD Section 7.1) =====

  /// Show rewarded ad for extra life
  Future<bool> showAdForLife(Function() onLifeEarned) async {
    return await showRewardedAd(onLifeEarned);
  }

  /// Show rewarded ad for coins
  Future<bool> showAdForCoins(Function() onCoinsEarned) async {
    return await showRewardedAd(onCoinsEarned);
  }

  /// Show rewarded ad for power-up
  Future<bool> showAdForPowerUp(Function() onPowerUpEarned) async {
    return await showRewardedAd(onPowerUpEarned);
  }

  /// Show rewarded ad for continue (after game over)
  Future<bool> showAdForContinue(Function() onContinueEarned) async {
    return await showRewardedAd(onContinueEarned);
  }

  // ===== Utility Methods =====

  /// Reset game over counter (for testing)
  void resetGameOverCount() {
    _gameOverCount = 0;
  }

  /// Get game over count
  int get gameOverCount => _gameOverCount;

  /// Dispose all ads
  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _interstitialReady = false;
    _rewardedReady = false;
  }

  // ===== Banner Ads (Optional - GDD Section 7.1) =====
  // Note: Banner ads can be added later if needed
  // They are optional and only shown on main menu

  /// Get banner ad unit ID based on platform
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return AdUnitIds.androidBanner;
    } else if (Platform.isIOS) {
      return AdUnitIds.iosBanner;
    }
    return '';
  }

  /// Create banner ad widget (can be used in screens)
  static BannerAd createBannerAd({
    required Function(Ad ad) onAdLoaded,
    required Function(Ad ad, LoadAdError error) onAdFailedToLoad,
  }) {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
      ),
    );
  }
}
