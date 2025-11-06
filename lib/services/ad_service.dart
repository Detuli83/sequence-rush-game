import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sequence_rush_game/config/constants.dart';

/// Service for managing Google Mobile Ads
class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  bool _initialized = false;
  bool _adsRemoved = false;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  BannerAd? _bannerAd;

  bool _interstitialReady = false;
  bool _rewardedReady = false;
  int _gameOverCount = 0;

  DateTime? _lastInterstitialTime;
  int _levelsSinceLastInterstitial = 0;

  // Ad Unit IDs - Replace with your actual ad unit IDs
  static String get _bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111'; // Test ID
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716'; // Test ID
    }
    return '';
  }

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

  /// Initialize the Mobile Ads SDK
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      await MobileAds.instance.initialize();
      _initialized = true;
      print('AdService: Mobile Ads SDK initialized');

      // Pre-load ads if ads are not removed
      if (!_adsRemoved) {
        _loadInterstitialAd();
        _loadRewardedAd();
      }
    } catch (e) {
      print('AdService: Error initializing Mobile Ads SDK: $e');
    }
  }

  /// Initialize the Mobile Ads SDK (alias for compatibility)
  Future<void> init() async {
    await initialize();
  }

  /// Set whether ads have been removed via purchase
  void setAdsRemoved(bool removed) {
    _adsRemoved = removed;

    if (_adsRemoved) {
      // Dispose all loaded ads
      _interstitialAd?.dispose();
      _interstitialAd = null;
      _bannerAd?.dispose();
      _bannerAd = null;
      _interstitialReady = false;
      print('AdService: Ads removed');
    } else {
      // Pre-load ads
      _loadInterstitialAd();
      _loadRewardedAd();
    }
  }

  /// Check if ads are removed
  bool get adsRemoved => _adsRemoved;

  /// Check if a rewarded ad is ready to show
  bool get isRewardedAdReady => _rewardedReady && _rewardedAd != null;

  /// Check if an interstitial ad is ready to show
  bool get isInterstitialAdReady => _interstitialReady && _interstitialAd != null;

  // Banner Ads

  /// Create a banner ad
  BannerAd? createBannerAd() {
    if (_adsRemoved || !_initialized) return null;

    _bannerAd = BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          print('AdService: Banner ad loaded');
        },
        onAdFailedToLoad: (ad, error) {
          print('AdService: Banner ad failed to load: $error');
          ad.dispose();
          _bannerAd = null;
        },
      ),
    );

    _bannerAd!.load();
    return _bannerAd;
  }

  /// Dispose banner ad
  void disposeBannerAd() {
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  // Interstitial Ads

  /// Load an interstitial ad
  void _loadInterstitialAd() {
    if (_adsRemoved || !_initialized) return;

    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialReady = true;
          print('AdService: Interstitial ad loaded');

          _interstitialAd!.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              _interstitialReady = false;
              _loadInterstitialAd(); // Pre-load next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('AdService: Interstitial ad failed to show: $error');
              ad.dispose();
              _interstitialAd = null;
              _interstitialReady = false;
              _loadInterstitialAd(); // Pre-load next ad
            },
          );
        },
        onAdFailedToLoad: (error) {
          print('AdService: Interstitial ad failed to load: $error');
          _interstitialAd = null;
          _interstitialReady = false;
        },
      ),
    );
  }

  /// Show an interstitial ad
  Future<bool> showInterstitialAd() async {
    if (_adsRemoved || !_initialized || _interstitialAd == null || !_interstitialReady) {
      return false;
    }

    // Check if enough time has passed
    if (_lastInterstitialTime != null) {
      final secondsSinceLastAd =
          DateTime.now().difference(_lastInterstitialTime!).inSeconds;
      if (secondsSinceLastAd < GameConstants.minSecondsBetweenInterstitials) {
        return false;
      }
    }

    try {
      await _interstitialAd!.show();
      _lastInterstitialTime = DateTime.now();
      _levelsSinceLastInterstitial = 0;
      _interstitialReady = false;
      return true;
    } catch (e) {
      print('AdService: Error showing interstitial ad: $e');
      return false;
    }
  }

  /// Show interstitial ad based on game over count
  Future<void> showInterstitialAdOnGameOver() async {
    _gameOverCount++;

    // Show ad every N game overs
    if (_gameOverCount % GameConstants.gameOversBetweenInterstitial != 0) return;

    if (_interstitialReady && _interstitialAd != null) {
      await _interstitialAd!.show();
      _interstitialReady = false;
      _loadInterstitialAd(); // Reload for next time
    }
  }

  /// Check if an interstitial ad should be shown
  bool shouldShowInterstitialAd() {
    if (_adsRemoved) return false;

    _levelsSinceLastInterstitial++;

    if (_levelsSinceLastInterstitial >= GameConstants.levelsPerInterstitial) {
      return true;
    }

    return false;
  }

  // Rewarded Ads

  /// Load a rewarded ad
  void _loadRewardedAd() {
    if (!_initialized) return; // Note: Rewarded ads are shown even if ads are removed

    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _rewardedReady = true;
          print('AdService: Rewarded ad loaded');

          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedAd = null;
              _rewardedReady = false;
              _loadRewardedAd(); // Pre-load next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('AdService: Rewarded ad failed to show: $error');
              ad.dispose();
              _rewardedAd = null;
              _rewardedReady = false;
              _loadRewardedAd(); // Pre-load next ad
            },
          );
        },
        onAdFailedToLoad: (error) {
          print('AdService: Rewarded ad failed to load: $error');
          _rewardedAd = null;
          _rewardedReady = false;
        },
      ),
    );
  }

  /// Show a rewarded ad with callback
  Future<bool> showRewardedAd({
    required Function() onRewarded,
    Function()? onAdDismissed,
  }) async {
    if (!_initialized || _rewardedAd == null || !_rewardedReady) {
      return false;
    }

    bool rewarded = false;

    try {
      await _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          rewarded = true;
          onRewarded();
          print('AdService: User earned reward: ${reward.amount} ${reward.type}');
        },
      );

      if (onAdDismissed != null) {
        onAdDismissed();
      }

      _rewardedReady = false;
      return rewarded;
    } catch (e) {
      print('AdService: Error showing rewarded ad: $e');
      return false;
    }
  }

  /// Show a rewarded ad with simple callback (alternate signature for compatibility)
  Future<bool> showRewardedAdAlt(Function onRewardEarned) async {
    if (!_initialized || _rewardedAd == null || !_rewardedReady) {
      return false;
    }

    bool rewarded = false;

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedReady = false;
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

  /// Dispose all ads
  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _bannerAd?.dispose();
    _bannerAd = null;
    _interstitialReady = false;
    _rewardedReady = false;
  }
}
