import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';

/// Provider for app settings management
/// Manages audio, haptics, and theme preferences
class SettingsProvider with ChangeNotifier {
  final StorageService _storage;

  bool _musicEnabled = true;
  bool _sfxEnabled = true;
  bool _hapticsEnabled = true;
  bool _isDarkMode = false;
  bool _isLoaded = false;

  SettingsProvider(this._storage) {
    _loadSettings();
  }

  // Getters
  bool get musicEnabled => _musicEnabled;
  bool get sfxEnabled => _sfxEnabled;
  bool get hapticsEnabled => _hapticsEnabled;
  bool get isDarkMode => _isDarkMode;
  bool get isLoaded => _isLoaded;

  /// Load settings from storage
  Future<void> _loadSettings() async {
    try {
      _musicEnabled = await _storage.getMusicEnabled();
      _sfxEnabled = await _storage.getSfxEnabled();
      _hapticsEnabled = await _storage.getHapticsEnabled();
      _isDarkMode = await _storage.getIsDarkMode();
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      print('Error loading settings: $e');
      _isLoaded = true;
      notifyListeners();
    }
  }

  /// Toggle music on/off
  Future<void> toggleMusic() async {
    _musicEnabled = !_musicEnabled;
    await _storage.setMusicEnabled(_musicEnabled);
    notifyListeners();
  }

  /// Set music enabled state
  Future<void> setMusicEnabled(bool enabled) async {
    if (_musicEnabled == enabled) return;
    _musicEnabled = enabled;
    await _storage.setMusicEnabled(_musicEnabled);
    notifyListeners();
  }

  /// Toggle sound effects on/off
  Future<void> toggleSfx() async {
    _sfxEnabled = !_sfxEnabled;
    await _storage.setSfxEnabled(_sfxEnabled);
    notifyListeners();
  }

  /// Set SFX enabled state
  Future<void> setSfxEnabled(bool enabled) async {
    if (_sfxEnabled == enabled) return;
    _sfxEnabled = enabled;
    await _storage.setSfxEnabled(_sfxEnabled);
    notifyListeners();
  }

  /// Toggle haptics on/off
  Future<void> toggleHaptics() async {
    _hapticsEnabled = !_hapticsEnabled;
    await _storage.setHapticsEnabled(_hapticsEnabled);
    notifyListeners();
  }

  /// Set haptics enabled state
  Future<void> setHapticsEnabled(bool enabled) async {
    if (_hapticsEnabled == enabled) return;
    _hapticsEnabled = enabled;
    await _storage.setHapticsEnabled(_hapticsEnabled);
    notifyListeners();
  }

  /// Toggle dark mode on/off
  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await _storage.setIsDarkMode(_isDarkMode);
    notifyListeners();
  }

  /// Set dark mode state
  Future<void> setDarkMode(bool enabled) async {
    if (_isDarkMode == enabled) return;
    _isDarkMode = enabled;
    await _storage.setIsDarkMode(_isDarkMode);
    notifyListeners();
  }

  /// Reset all settings to default
  Future<void> resetToDefaults() async {
    _musicEnabled = true;
    _sfxEnabled = true;
    _hapticsEnabled = true;
    _isDarkMode = false;

    await Future.wait([
      _storage.setMusicEnabled(_musicEnabled),
      _storage.setSfxEnabled(_sfxEnabled),
      _storage.setHapticsEnabled(_hapticsEnabled),
      _storage.setIsDarkMode(_isDarkMode),
    ]);

    notifyListeners();
  }

  /// Get all settings as a map
  Map<String, bool> getAllSettings() {
    return {
      'music': _musicEnabled,
      'sfx': _sfxEnabled,
      'haptics': _hapticsEnabled,
      'darkMode': _isDarkMode,
    };
  }
}
