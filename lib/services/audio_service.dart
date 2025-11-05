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
    // Preload sound effects would happen here when assets are available
    // await FlameAudio.audioCache.loadAll([...]);
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
    // await FlameAudio.bgm.play('music/$track.ogg', volume: 0.3);
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
    // await FlameAudio.play('sfx/${_sfxFiles[name]}', volume: 0.5);
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
}
