# Monetization Features Implementation

This document describes the monetization features that have been implemented for Sequence Rush.

## Overview

All monetization features from the Game Design Document have been fully implemented, including:
- ✅ Google Mobile Ads (Interstitial & Rewarded Video)
- ✅ In-App Purchases (IAP)
- ✅ Currency System (Coins & Gems)
- ✅ Lives System with regeneration
- ✅ Power-Ups System
- ✅ Shop Screen

## 📦 Implemented Features

### 1. Ad Integration (AdService)

**Location:** `lib/services/ad_service.dart`

**Features:**
- **Interstitial Ads:** Displayed every 3 game overs
- **Rewarded Video Ads:**
  - Watch ad for 1 life (max 3 per day)
  - Watch ad for 25 coins (unlimited)
  - Watch ad for power-ups
- **Banner Ads:** Optional banner ads with ability to remove via IAP
- Test mode enabled by default (using Google test ad IDs)

**Usage:**
```dart
// Show interstitial ad
await adService.showInterstitialAd();

// Show rewarded ad
await adService.showRewardedAd(() {
  // Reward callback
  playerData.addCoins(25);
});
```

### 2. In-App Purchases (IAPService)

**Location:** `lib/services/iap_service.dart`

**Supported Products:**

#### Consumables - Coins
- 100 Coins: $0.99
- 500 Coins: $3.99
- 1,000 Coins: $6.99

#### Consumables - Gems
- 100 Gems: $0.99
- 600 Gems: $4.99 (20% bonus)
- 1,500 Gems: $9.99 (50% bonus)

#### Consumables - Lives
- 5 Lives: $0.99

#### Non-Consumables
- Remove All Ads: $4.99 (one-time purchase)
- Unlock All Themes: $2.99
- VIP Pass: $9.99/month (subscription)

**Product Configuration:** `lib/models/iap_product.dart`

**Usage:**
```dart
// Purchase coins
await iapService.purchaseProduct('coins_100');

// Purchase non-consumable
await iapService.purchaseNonConsumable('remove_ads');

// Restore purchases
await iapService.restorePurchases();
```

### 3. Currency System

**Location:** `lib/models/player_data.dart`

**Soft Currency - Coins:**
- Earned through gameplay: 10 coins per level
- Perfect level bonus: +25 coins
- Daily login bonus: 50 coins
- Watch ad: 25 coins (unlimited)
- Can be used to purchase power-ups

**Hard Currency - Gems:**
- IAP only
- 1 gem = 10 coins conversion rate
- Premium currency for special purchases

**Features:**
- Persistent storage using SharedPreferences
- Automatic save/load
- Transaction tracking

### 4. Lives System

**Location:** `lib/models/player_data.dart`

**Features:**
- Start with 5 lives
- Lose 1 life per failed attempt
- Regeneration: 1 life per 15 minutes (automatic)
- Maximum: 5 lives

**Ways to Get Lives:**
1. **Free Regeneration:** 1 life every 15 minutes
2. **Watch Ad:** 1 life per ad (max 3 per day)
3. **IAP:** Buy 5 lives for $0.99

**Implementation:**
```dart
// Auto-regenerate lives
playerData.updateLives();

// Watch ad for life
if (playerData.canWatchAdForLife()) {
  await gameProvider.watchAdForLife();
}

// Buy lives
await gameProvider.buyLivesWithIAP();
```

### 5. Power-Ups System

**Location:** `lib/models/power_up.dart`

**Available Power-Ups:**

1. **Show Hint** (50 coins or watch ad)
   - Replays the sequence one more time
   - Available once per level

2. **Extra Time** (75 coins or watch ad)
   - Adds 5 seconds to execution timer
   - Can be activated during execution phase

3. **Slow Motion** (100 coins or watch ad)
   - Slows down sequence display by 50%
   - Easier to memorize complex patterns

4. **Skip Level** (200 coins or 10 gems)
   - Skip current level entirely
   - Still counts for progression

**Usage:**
```dart
// Use power-up with coins
await gameProvider.usePowerUp(PowerUpType.hint, useCoins: true);

// Use power-up with ad
await gameProvider.usePowerUpWithAd(PowerUpType.extraTime);
```

### 6. Shop Screen

**Location:** `lib/screens/shop_screen.dart`

**Features:**
- View current balance (coins & gems)
- Purchase lives
- Purchase coins packs
- Purchase gems packs
- Premium features (remove ads)
- Watch ads for rewards
- Visual indicators for bonuses

## 📱 Widgets

### Currency Display
**Location:** `lib/widgets/currency_display.dart`

Shows coins or gems with icon and amount in a styled container.

```dart
CurrencyDisplay(
  amount: 250,
  type: CurrencyType.coins,
)
```

### Lives Indicator
**Location:** `lib/widgets/lives_indicator.dart`

Displays hearts representing current lives.

```dart
LivesIndicator(lives: 5)
```

### Power-Up Button
**Location:** `lib/widgets/power_up_button.dart`

Interactive button for purchasing/using power-ups.

```dart
PowerUpButton(
  powerUp: PowerUp.hint,
  canAfford: true,
  onPressed: () => usePowerUp(),
  onWatchAd: () => usePowerUpWithAd(),
)
```

## 🔧 Configuration

### Constants
**Location:** `lib/config/constants.dart`

All monetization-related constants are centralized:
- Lives regeneration time (15 minutes)
- Coin rewards per level (10 coins)
- Perfect level bonus (25 coins)
- Ad frequency (every 3 game overs)
- Power-up costs
- Test mode flags

### Test Mode

**Ads Test Mode:** Enabled by default in `lib/config/constants.dart`
```dart
static const bool testAds = true; // Use test ad IDs
```

When `testAds = true`, the app uses Google's test ad unit IDs. Set to `false` and update production IDs in `lib/services/ad_service.dart` before release.

**IAP Test Mode:** Enabled by default
```dart
static const bool testIAP = true; // Use test product IDs
```

## 🎮 Game Provider Integration

**Location:** `lib/providers/game_provider.dart`

The GameProvider manages all monetization logic:
- Currency transactions
- Lives management
- Power-up purchases
- IAP handling
- Ad rewards
- Persistent storage

**Key Methods:**
```dart
// Level completion with rewards
await gameProvider.completeLevel(
  remainingTime: 10.5,
  isPerfect: true,
);

// Purchase with coins
await gameProvider.purchaseCoins('coins_100');

// Purchase with IAP
await gameProvider.removeAds();

// Watch ads
await gameProvider.watchAdForLife();
await gameProvider.watchAdForCoins();
```

## 📊 Revenue Streams

### 1. Rewarded Video Ads (Primary)
- Estimated eCPM: $10-20
- High engagement, user-initiated
- Multiple reward options

### 2. Interstitial Ads (Secondary)
- Estimated CPM: $4-8
- Non-intrusive frequency (every 3 game overs)
- Can be removed via IAP

### 3. In-App Purchases
- Multiple price points ($0.99 - $9.99)
- Consumables and non-consumables
- Subscription option (VIP Pass)

## 🔒 Data Persistence

**Location:** `lib/services/storage_service.dart`

All player data is stored locally using SharedPreferences:
- Current level
- Lives and last life update time
- Coins and gems
- High scores
- Unlocked themes
- Achievements
- Settings
- Purchased items (for non-consumables)

**Storage Keys:**
- `player_data`: Main player data JSON
- `purchased_items`: List of purchased non-consumable items

## 🚀 Next Steps

To complete the monetization integration:

1. **Replace Test Ad IDs** in `lib/services/ad_service.dart`:
   - Update `_prodInterstitialAdUnitId`
   - Update `_prodRewardedAdUnitId`
   - Update `_prodBannerAdUnitId`
   - Set `GameConstants.testAds = false`

2. **Configure IAP Products** in app stores:
   - Create products in Google Play Console
   - Create products in App Store Connect
   - Ensure product IDs match those in `lib/models/iap_product.dart`

3. **Add Required Permissions:**

   **Android** (`android/app/src/main/AndroidManifest.xml`):
   ```xml
   <uses-permission android:name="android.permission.INTERNET"/>
   <uses-permission android:name="com.android.vending.BILLING"/>

   <meta-data
       android:name="com.google.android.gms.ads.APPLICATION_ID"
       android:value="ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY"/>
   ```

   **iOS** (`ios/Runner/Info.plist`):
   ```xml
   <key>GADApplicationIdentifier</key>
   <string>ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY</string>
   <key>NSUserTrackingUsageDescription</key>
   <string>This identifier will be used to deliver personalized ads to you.</string>
   ```

4. **Test on Real Devices:**
   - Test all ad types
   - Test all IAP products
   - Test purchase restoration
   - Verify data persistence

5. **Add Audio Files** (Optional):
   - Place audio files in `assets/audio/sfx/`
   - Uncomment preload code in `lib/services/audio_service.dart`

## 📚 Additional Resources

- [Google Mobile Ads Flutter Plugin](https://pub.dev/packages/google_mobile_ads)
- [In-App Purchase Plugin](https://pub.dev/packages/in_app_purchase)
- [AdMob Setup Guide](https://developers.google.com/admob/flutter/quick-start)
- [App Store In-App Purchases](https://developer.apple.com/in-app-purchase/)
- [Google Play Billing](https://developer.android.com/google/play/billing)

## ⚠️ Important Notes

1. **Test Mode:** The app is currently in test mode. Ads and IAP will use test IDs.
2. **Production IDs:** Replace all placeholder IDs before publishing.
3. **Compliance:** Ensure GDPR/CCPA compliance for ads and data collection.
4. **Store Approval:** Follow App Store and Play Store monetization guidelines.
5. **User Experience:** Balance monetization with user experience to maintain retention.

## 🎯 Monetization Best Practices Implemented

✅ Never interrupt gameplay with ads
✅ Always offer ad-free alternative (IAP)
✅ Provide genuine value in IAPs
✅ Fair free-to-play balance
✅ Daily rewards keep players engaged
✅ Multiple price points for different user segments
✅ Clear value proposition for each purchase

---

**Implementation Status:** ✅ Complete
**Last Updated:** November 5, 2025
**Version:** 1.0.0
