import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';

class SettingsProvider with ChangeNotifier {
  final StorageService _storage;
  bool _isDarkMode = false;
  bool _musicEnabled = true;
  bool _sfxEnabled = true;
  bool _hapticsEnabled = true;

  SettingsProvider(this._storage) {
    _loadSettings();
  }

  // Getters
  bool get isDarkMode => _isDarkMode;
  bool get musicEnabled => _musicEnabled;
  bool get sfxEnabled => _sfxEnabled;
  bool get hapticsEnabled => _hapticsEnabled;

  Future<void> _loadSettings() async {
    _musicEnabled = await _storage.getSetting('music');
    _sfxEnabled = await _storage.getSetting('sfx');
    _hapticsEnabled = await _storage.getSetting('haptics');
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  Future<void> setMusicEnabled(bool enabled) async {
    _musicEnabled = enabled;
    await _storage.setSetting('music', enabled);
    notifyListeners();
  }

  Future<void> setSfxEnabled(bool enabled) async {
    _sfxEnabled = enabled;
    await _storage.setSetting('sfx', enabled);
    notifyListeners();
  }

  Future<void> setHapticsEnabled(bool enabled) async {
    _hapticsEnabled = enabled;
    await _storage.setSetting('haptics', enabled);
    notifyListeners();
  }
}
