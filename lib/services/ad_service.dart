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

  DateTime? _lastInterstitialTime;
  int _levelsSinceLastInterstitial = 0;

  // Ad Unit IDs - Replace with your actual ad unit IDs
  String get _bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111'; // Test ID
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716'; // Test ID
    }
    return '';
  }

  String get _interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712'; // Test ID
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910'; // Test ID
    }
    return '';
  }

  String get _rewardedAdUnitId {
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

  /// Set whether ads have been removed via purchase
  void setAdsRemoved(bool removed) {
    _adsRemoved = removed;

    if (_adsRemoved) {
      // Dispose all loaded ads
      _interstitialAd?.dispose();
      _interstitialAd = null;
      _bannerAd?.dispose();
      _bannerAd = null;
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
  bool get isRewardedAdReady => _rewardedAd != null;

  /// Check if an interstitial ad is ready to show
  bool get isInterstitialAdReady => _interstitialAd != null;

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
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          print('AdService: Interstitial ad loaded');

          _interstitialAd!.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              _loadInterstitialAd(); // Pre-load next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('AdService: Interstitial ad failed to show: $error');
              ad.dispose();
              _interstitialAd = null;
              _loadInterstitialAd(); // Pre-load next ad
            },
          );
        },
        onAdFailedToLoad: (error) {
          print('AdService: Interstitial ad failed to load: $error');
          _interstitialAd = null;
        },
      ),
    );
  }

  /// Show an interstitial ad
  Future<bool> showInterstitialAd() async {
    if (_adsRemoved || !_initialized || _interstitialAd == null) {
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
      return true;
    } catch (e) {
      print('AdService: Error showing interstitial ad: $e');
      return false;
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
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          print('AdService: Rewarded ad loaded');

          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedAd = null;
              _loadRewardedAd(); // Pre-load next ad
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('AdService: Rewarded ad failed to show: $error');
              ad.dispose();
              _rewardedAd = null;
              _loadRewardedAd(); // Pre-load next ad
            },
          );
        },
        onAdFailedToLoad: (error) {
          print('AdService: Rewarded ad failed to load: $error');
          _rewardedAd = null;
        },
      ),
    );
  }

  /// Show a rewarded ad
  Future<bool> showRewardedAd({
    required Function() onRewarded,
    Function()? onAdDismissed,
  }) async {
    if (!_initialized || _rewardedAd == null) {
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

      return rewarded;
    } catch (e) {
      print('AdService: Error showing rewarded ad: $e');
      return false;
    }
  }

  /// Dispose all ads
  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _bannerAd?.dispose();
    _bannerAd = null;
  }
}
