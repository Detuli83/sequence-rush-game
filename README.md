# Sequence Rush 🎮

A memory + reflex mobile game built with Flutter

## 🚀 Quick Start

```bash
# Install dependencies
flutter pub get

# Run the game
flutter run
```

That's it! The game is fully implemented and ready to play.

## 📖 What is Sequence Rush?

Sequence Rush is a hyper-casual mobile game that combines memory challenges with time-pressure gameplay:

1. **Memorize** - Watch colored buttons light up in sequence
2. **Execute** - Reproduce the sequence before time runs out
3. **Progress** - Complete 100+ levels with increasing difficulty

### Key Features

- ✨ Unique blend of memory + reflex gameplay
- 🎯 Easy to learn, hard to master
- ⚡ Quick 15-30 second sessions
- 🎨 4-8 colored buttons based on level
- 💰 Lives system and currency
- 📈 Progressive difficulty curve
- 🏆 Score tracking and combos

## 🎮 Game Mechanics

### Level Progression
- **World 1** (Levels 1-20): 4 colors, 3-6 step sequences
- **World 2** (Levels 21-40): 6 colors, 4-7 step sequences
- **World 3** (Levels 41-60): 8 colors, 6-9 step sequences
- **World 4+** (Levels 61+): Advanced challenges

### Lives System
- Start with 5 lives
- Lose 1 life per failed attempt
- Regenerate 1 life every 15 minutes
- Watch ads for extra lives (when implemented)

### Scoring
- Base score: 100 points per sequence step
- Time bonus: 50 points per second remaining
- Perfect level bonus: +500 points
- Combo multipliers: 1.5x (3 streak), 2x (5 streak), 3x (10 streak)

## 🛠️ Technical Stack

- **Framework**: Flutter 3.5.2+
- **Game Engine**: Flame 1.18+
- **State Management**: Provider
- **Storage**: SharedPreferences
- **Ads**: Google Mobile Ads
- **Audio**: Flame Audio

## 📂 Project Structure

```
lib/
├── main.dart                   # App entry point
├── app.dart                    # Main app widget
├── config/                     # Colors, theme, constants
├── models/                     # Level, PlayerData
├── services/                   # Storage, Audio, Ads
├── providers/                  # Game state management
├── game/utils/                 # Sequence generator, score calculator
├── screens/                    # Main menu, Game screen
└── widgets/                    # Color buttons, custom UI
```

## 🎨 Current Implementation Status

### ✅ Fully Implemented

- [x] Core game loop (memorize + execute phases)
- [x] Level progression system (1-100+ levels)
- [x] Lives system with regeneration
- [x] Coins and gems currency
- [x] Score calculation with combos
- [x] Data persistence (local storage)
- [x] State management (Provider)
- [x] Main menu screen
- [x] Game screen with animated buttons
- [x] Responsive UI design
- [x] Ad service integration (test mode)

### ⚠️ Assets Needed

- [ ] Sound effects (button sounds, success, error)
- [ ] Background music
- [ ] App icon
- [ ] Splash screen

### 📝 Optional Features (Not Yet Implemented)

- [ ] Settings screen
- [ ] Shop screen
- [ ] Power-ups UI
- [ ] Achievements screen
- [ ] Daily challenges
- [ ] Leaderboards
- [ ] Multiple themes

## 🔧 Build Instructions

### Development Build

```bash
# Run in debug mode
flutter run

# Run on specific device
flutter run -d <device-id>

# List available devices
flutter devices
```

### Release Build

**Android APK:**
```bash
flutter build apk --release
```

**Android App Bundle:**
```bash
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

For detailed build instructions, see [BUILD_INSTRUCTIONS.md](BUILD_INSTRUCTIONS.md)

## 🎯 How to Play

1. **Launch the game** - See your current level, lives, and coins
2. **Tap "PLAY NOW"** - Start the current level
3. **Watch the sequence** - Colored buttons will light up
4. **Memorize it!** - Pay attention to the order
5. **Tap the sequence** - Reproduce it before time runs out
6. **Level up!** - Progress through increasingly difficult levels

### Tips
- The sequence speeds up as levels increase
- Time limits get shorter at higher levels
- More colors are added in later worlds
- Perfect levels earn bonus coins and maintain combo streaks

## 📚 Documentation

Complete game documentation is available in the `docs/` folder:

- **`sequence_rush_gdd.md`** - Complete game design document (60+ pages)
- **`sequence_rush_flutter_implementation.md`** - Technical implementation guide
- **`sequence_rush_assets_guide.md`** - Asset specifications
- **`sequence_rush_marketing_plan.md`** - Marketing strategy
- **`QUICK_START.md`** - Quick start guide
- **`README.md`** - Documentation overview

## 🐛 Troubleshooting

### Game won't run
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

### Dependencies not installing
```bash
# Clear pub cache
flutter pub cache repair
flutter pub get
```

### Progress not saving
- Check that storage service initialized correctly
- Clear app data and restart

## 🎮 Testing

The game is fully playable in its current state. To test:

1. Run on your device/emulator
2. Play through several levels
3. Verify progression saves between sessions
4. Test lives regeneration (close app for 15+ minutes)
5. Try failing levels to test lives system

## 📱 Platform Support

- **Android**: API 21+ (Android 5.0+)
- **iOS**: iOS 12.0+
- **Web**: Supported for testing

## 🚀 Next Steps

### To Make Fully Playable
1. ✅ Run the game - **Already works!**
2. Test on device
3. Add sound effects (optional)
4. Customize app icon

### To Publish
1. Create AdMob account and configure real ad IDs
2. Design app icon and splash screen
3. Test on multiple devices
4. Submit to Google Play / App Store

## 💡 Credits

- **Game Design**: Based on comprehensive GDD in `docs/`
- **Implementation**: Flutter + Flame game engine
- **Architecture**: Clean architecture with Provider

## 📄 License

This project is ready for commercial use. See individual documentation files for details.

## 🎉 Ready to Play!

The game is **fully implemented and playable**. Just run:

```bash
flutter pub get
flutter run
```

Start playing Sequence Rush and see how far you can progress! 🚀

---

**Last Updated**: November 5, 2025
**Status**: ✅ Playable
**Version**: 1.0.0
