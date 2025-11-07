import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/services.dart';

/// Service for managing audio (SFX and Music)
/// Based on GDD Section 5 - Audio Design
class AudioService {
  bool _musicEnabled = true;
  bool _sfxEnabled = true;
  bool _hapticsEnabled = true;
  bool _isInitialized = false;

  /// Sound effect file mappings
  /// Note: Audio files need to be added to assets/audio/sfx/
  final Map<String, String> _sfxFiles = {
    // Button sounds - Each color has unique tone (Section 5.1)
    'red': 'button_red.mp3',
    'blue': 'button_blue.mp3',
    'green': 'button_green.mp3',
    'yellow': 'button_yellow.mp3',
    'orange': 'button_orange.mp3',
    'purple': 'button_purple.mp3',
    'pink': 'button_pink.mp3',
    'cyan': 'button_cyan.mp3',

    // Game feedback sounds
    'correct': 'correct.mp3',
    'wrong': 'wrong.mp3',
    'success': 'success.mp3',
    'level_complete': 'level_complete.mp3',
    'game_over': 'game_over.mp3',

    // UI sounds
    'click': 'click.mp3',
    'coin': 'coin.mp3',
    'powerup': 'powerup.mp3',
    'unlock': 'unlock.mp3',
  };

  /// Music file mappings
  /// Note: Music files need to be added to assets/audio/music/
  final Map<String, String> _musicFiles = {
    'menu': 'menu_music.mp3',
    'gameplay': 'gameplay_music.mp3',
    'victory': 'victory_music.mp3',
  };

  /// Initialize audio service
  /// Preloads essential sound effects for better performance
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      // Preload critical sound effects
      // Note: Only load if files exist, gracefully handle missing files
      await _preloadSounds();
      _isInitialized = true;
      print('AudioService initialized successfully');
    } catch (e) {
      print('AudioService initialization warning: $e');
      print('Some audio files may be missing. Game will continue without audio.');
      _isInitialized = true; // Continue without audio if files missing
    }
  }

  /// Preload sound effects
  Future<void> _preloadSounds() async {
    final soundsToPreload = [
      'sfx/${_sfxFiles['click']}',
      'sfx/${_sfxFiles['correct']}',
      'sfx/${_sfxFiles['wrong']}',
      'sfx/${_sfxFiles['level_complete']}',
    ];

    // Try to load sounds, but don't fail if they don't exist
    for (final sound in soundsToPreload) {
      try {
        await FlameAudio.audioCache.load(sound);
      } catch (e) {
        print('Could not preload $sound: $e');
      }
    }
  }

  // ===== Settings =====

  /// Enable/disable music
  void setMusicEnabled(bool enabled) {
    _musicEnabled = enabled;
    if (!enabled) {
      FlameAudio.bgm.stop();
    }
  }

  /// Enable/disable sound effects
  void setSfxEnabled(bool enabled) {
    _sfxEnabled = enabled;
  }

  /// Enable/disable haptic feedback
  void setHapticsEnabled(bool enabled) {
    _hapticsEnabled = enabled;
  }

  bool get isMusicEnabled => _musicEnabled;
  bool get isSfxEnabled => _sfxEnabled;
  bool get isHapticsEnabled => _hapticsEnabled;

  // ===== Music Playback =====

  /// Play background music
  Future<void> playMusic(String trackName, {double volume = 0.3}) async {
    if (!_musicEnabled || !_isInitialized) return;

    final filename = _musicFiles[trackName];
    if (filename == null) {
      print('Music track not found: $trackName');
      return;
    }

    try {
      await FlameAudio.bgm.play('music/$filename', volume: volume);
    } catch (e) {
      print('Could not play music $trackName: $e');
    }
  }

  /// Stop background music
  void stopMusic() {
    FlameAudio.bgm.stop();
  }

  /// Pause background music
  void pauseMusic() {
    FlameAudio.bgm.pause();
  }

  /// Resume background music
  void resumeMusic() {
    if (_musicEnabled) {
      FlameAudio.bgm.resume();
    }
  }

  // ===== Sound Effects =====

  /// Play a sound effect by name
  Future<void> playSfx(String name, {double volume = 0.5}) async {
    if (!_sfxEnabled || !_isInitialized) return;

    final filename = _sfxFiles[name];
    if (filename == null) {
      print('Sound effect not found: $name');
      return;
    }

    try {
      await FlameAudio.play('sfx/$filename', volume: volume);
    } catch (e) {
      print('Could not play sound $name: $e');
    }
  }

  /// Play button sound by color index
  /// Each button has a unique musical note
  Future<void> playButtonSound(int colorIndex) async {
    final colorNames = ['red', 'blue', 'green', 'yellow', 'orange', 'purple', 'pink', 'cyan'];
    if (colorIndex >= 0 && colorIndex < colorNames.length) {
      await playSfx(colorNames[colorIndex]);
    }
  }

  /// Play button sound by color name
  Future<void> playButtonSoundByName(String colorName) async {
    await playSfx(colorName.toLowerCase());
  }

  // ===== Game Feedback Sounds =====

  /// Play correct input sound
  Future<void> playCorrectSound() async {
    await playSfx('correct', volume: 0.4);
  }

  /// Play wrong input sound
  Future<void> playWrongSound() async {
    await playSfx('wrong', volume: 0.6);
  }

  /// Play success sound
  Future<void> playSuccessSound() async {
    await playSfx('success', volume: 0.7);
  }

  /// Play level complete sound
  Future<void> playLevelCompleteSound() async {
    await playSfx('level_complete', volume: 0.7);
  }

  /// Play game over sound
  Future<void> playGameOverSound() async {
    await playSfx('game_over', volume: 0.6);
  }

  /// Play click sound (UI interactions)
  Future<void> playClickSound() async {
    await playSfx('click', volume: 0.3);
  }

  /// Play coin collection sound
  Future<void> playCoinSound() async {
    await playSfx('coin', volume: 0.5);
  }

  /// Play power-up activation sound
  Future<void> playPowerUpSound() async {
    await playSfx('powerup', volume: 0.6);
  }

  /// Play unlock sound (achievements, themes)
  Future<void> playUnlockSound() async {
    await playSfx('unlock', volume: 0.7);
  }

  // ===== Haptic Feedback =====

  /// Light haptic feedback (for button taps)
  void playHapticLight() {
    if (_hapticsEnabled) {
      HapticFeedback.lightImpact();
    }
  }

  /// Medium haptic feedback (for correct input)
  void playHapticMedium() {
    if (_hapticsEnabled) {
      HapticFeedback.mediumImpact();
    }
  }

  /// Heavy haptic feedback (for wrong input, game over)
  void playHapticHeavy() {
    if (_hapticsEnabled) {
      HapticFeedback.heavyImpact();
    }
  }

  /// Selection haptic feedback (for UI selections)
  void playHapticSelection() {
    if (_hapticsEnabled) {
      HapticFeedback.selectionClick();
    }
  }

  // ===== Combined Audio + Haptic =====

  /// Play button press (sound + haptic)
  Future<void> playButtonPress(int colorIndex) async {
    playHapticLight();
    await playButtonSound(colorIndex);
  }

  /// Play correct feedback (sound + haptic)
  Future<void> playCorrectFeedback() async {
    playHapticMedium();
    await playCorrectSound();
  }

  /// Play wrong feedback (sound + haptic)
  Future<void> playWrongFeedback() async {
    playHapticHeavy();
    await playWrongSound();
  }

  // ===== Cleanup =====

  /// Dispose audio resources
  void dispose() {
    stopMusic();
    FlameAudio.audioCache.clearAll();
  }
}
