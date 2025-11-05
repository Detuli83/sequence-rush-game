import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';
import '../config/constants.dart';

class AdService {
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  BannerAd? _bannerAd;
  bool _interstitialReady = false;
  bool _rewardedReady = false;
  bool _bannerReady = false;
  int _gameOverCount = 0;
  bool _adsRemoved = false;

  // Test ad unit IDs (for development)
  static String get _testInterstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    }
    return '';
  }

  static String get _testRewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/1712485313';
    }
    return '';
  }

  static String get _testBannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    }
    return '';
  }

  // Production ad unit IDs (replace with your actual IDs)
  static String get _prodInterstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY'; // Replace
    } else if (Platform.isIOS) {
      return 'ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY'; // Replace
    }
    return '';
  }

  static String get _prodRewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY'; // Replace
    } else if (Platform.isIOS) {
      return 'ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY'; // Replace
    }
    return '';
  }

  static String get _prodBannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY'; // Replace
    } else if (Platform.isIOS) {
      return 'ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY'; // Replace
    }
    return '';
  }

  // Get appropriate ad unit IDs based on test mode
  static String get interstitialAdUnitId =>
      GameConstants.testAds ? _testInterstitialAdUnitId : _prodInterstitialAdUnitId;

  static String get rewardedAdUnitId =>
      GameConstants.testAds ? _testRewardedAdUnitId : _prodRewardedAdUnitId;

  static String get bannerAdUnitId =>
      GameConstants.testAds ? _testBannerAdUnitId : _prodBannerAdUnitId;

  Future<void> init() async {
    await MobileAds.instance.initialize();
    _loadInterstitialAd();
    _loadRewardedAd();
  }

  void setAdsRemoved(bool removed) {
    _adsRemoved = removed;
  }

  void _loadInterstitialAd() {
    if (_adsRemoved) return;

    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialReady = true;

          // Set up full screen content callback
          _interstitialAd?.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _loadInterstitialAd(); // Reload for next time
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _interstitialReady = false;
          // Retry loading after a delay
          Future.delayed(const Duration(seconds: 60), () {
            _loadInterstitialAd();
          });
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
          // Retry loading after a delay
          Future.delayed(const Duration(seconds: 60), () {
            _loadRewardedAd();
          });
        },
      ),
    );
  }

  BannerAd? createBannerAd() {
    if (_adsRemoved) return null;

    _bannerAd = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _bannerReady = true;
        },
        onAdFailedToLoad: (ad, error) {
          _bannerReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd?.load();
    return _bannerAd;
  }

  Future<void> showInterstitialAd() async {
    if (_adsRemoved) return;

    _gameOverCount++;

    // Show ad every 3 game overs
    if (_gameOverCount % GameConstants.interstitialAdFrequency != 0) return;

    if (_interstitialReady && _interstitialAd != null) {
      await _interstitialAd!.show();
      _interstitialReady = false;
    }
  }

  Future<bool> showRewardedAd(Function() onRewardEarned) async {
    if (!_rewardedReady || _rewardedAd == null) {
      return false;
    }

    bool rewarded = false;

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadRewardedAd(); // Reload for next time
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
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

  bool get isRewardedAdReady => _rewardedReady;
  bool get isInterstitialAdReady => _interstitialReady;
  bool get isBannerAdReady => _bannerReady;

  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _bannerAd?.dispose();
  }
}
