import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/services.dart';

class AudioService {
  bool _musicEnabled = true;
  bool _sfxEnabled = true;
  bool _initialized = false;

  final Map<String, String> _sfxFiles = {
    'red': 'button_red.mp3',
    'blue': 'button_blue.mp3',
    'green': 'button_green.mp3',
    'yellow': 'button_yellow.mp3',
    'orange': 'button_orange.mp3',
    'purple': 'button_purple.mp3',
    'pink': 'button_pink.mp3',
    'cyan': 'button_cyan.mp3',
    'success': 'success.mp3',
    'error': 'error.mp3',
    'click': 'click.mp3',
    'coin': 'coin.mp3',
    'level_complete': 'level_complete.mp3',
    'powerup': 'powerup.mp3',
    'life_lost': 'life_lost.mp3',
    'purchase': 'purchase.mp3',
  };

  Future<void> init() async {
    try {
      // Note: Audio files should be placed in assets/audio/sfx/
      // For now, we'll mark as initialized even if files don't exist
      // In production, uncomment the preload code below after adding audio files

      /*
      await FlameAudio.audioCache.loadAll([
        'audio/sfx/button_red.mp3',
        'audio/sfx/button_blue.mp3',
        'audio/sfx/button_green.mp3',
        'audio/sfx/button_yellow.mp3',
        'audio/sfx/button_orange.mp3',
        'audio/sfx/button_purple.mp3',
        'audio/sfx/button_pink.mp3',
        'audio/sfx/button_cyan.mp3',
        'audio/sfx/success.mp3',
        'audio/sfx/error.mp3',
        'audio/sfx/click.mp3',
        'audio/sfx/coin.mp3',
        'audio/sfx/level_complete.mp3',
        'audio/sfx/powerup.mp3',
        'audio/sfx/life_lost.mp3',
        'audio/sfx/purchase.mp3',
      ]);
      */

      _initialized = true;
    } catch (e) {
      print('Error initializing audio: $e');
      _initialized = false;
    }
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
    if (!_musicEnabled || !_initialized) return;
    try {
      await FlameAudio.bgm.play('audio/music/$track.mp3', volume: 0.3);
    } catch (e) {
      print('Error playing music: $e');
    }
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
    if (!_sfxEnabled || !_initialized || !_sfxFiles.containsKey(name)) return;
    try {
      await FlameAudio.play('audio/sfx/${_sfxFiles[name]}', volume: 0.5);
    } catch (e) {
      // Silently fail if audio file doesn't exist
      // print('Error playing SFX: $e');
    }
  }

  void playButtonSound(int colorIndex) {
    final colors = [
      'red',
      'blue',
      'green',
      'yellow',
      'orange',
      'purple',
      'pink',
      'cyan'
    ];
    if (colorIndex < colors.length) {
      playSfx(colors[colorIndex]);
    }
  }

  void playHaptic() {
    HapticFeedback.lightImpact();
  }

  void playMediumHaptic() {
    HapticFeedback.mediumImpact();
  }

  void playHeavyHaptic() {
    HapticFeedback.heavyImpact();
  }

  bool get isMusicEnabled => _musicEnabled;
  bool get isSfxEnabled => _sfxEnabled;
  bool get isInitialized => _initialized;
}
