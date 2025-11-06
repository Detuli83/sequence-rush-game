import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/player_data.dart';
import '../config/constants.dart';

/// Service for local data persistence using SharedPreferences
/// Based on GDD Section 6.2 - Data Storage
class StorageService {
  SharedPreferences? _prefs;

  /// Initialize the storage service
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Ensure preferences are initialized
  void _ensureInitialized() {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call init() first.');
    }
  }

  // ===== Player Data =====

  /// Load player data from storage
  Future<PlayerData> loadPlayerData() async {
    _ensureInitialized();
    final jsonString = _prefs!.getString(StorageKeys.playerData);

    if (jsonString == null || jsonString.isEmpty) {
      // Return new player data if no saved data exists
      return PlayerData();
    }

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return PlayerData.fromJson(json);
    } catch (e) {
      // If there's an error parsing, return new player data
      print('Error loading player data: $e');
      return PlayerData();
    }
  }

  /// Save player data to storage
  Future<bool> savePlayerData(PlayerData data) async {
    _ensureInitialized();
    try {
      final jsonString = jsonEncode(data.toJson());
      return await _prefs!.setString(StorageKeys.playerData, jsonString);
    } catch (e) {
      print('Error saving player data: $e');
      return false;
    }
  }

  // ===== High Scores =====

  /// Get all high scores
  Future<List<int>> getHighScores() async {
    final data = await loadPlayerData();
    return data.highScores;
  }

  /// Add a new high score
  Future<void> addHighScore(int score) async {
    final data = await loadPlayerData();
    data.addHighScore(score);
    await savePlayerData(data);
  }

  // ===== Settings =====

  /// Get music enabled setting
  Future<bool> getMusicEnabled() async {
    _ensureInitialized();
    return _prefs!.getBool(StorageKeys.musicEnabled) ?? true;
  }

  /// Set music enabled setting
  Future<bool> setMusicEnabled(bool enabled) async {
    _ensureInitialized();
    return await _prefs!.setBool(StorageKeys.musicEnabled, enabled);
  }

  /// Get SFX enabled setting
  Future<bool> getSfxEnabled() async {
    _ensureInitialized();
    return _prefs!.getBool(StorageKeys.sfxEnabled) ?? true;
  }

  /// Set SFX enabled setting
  Future<bool> setSfxEnabled(bool enabled) async {
    _ensureInitialized();
    return await _prefs!.setBool(StorageKeys.sfxEnabled, enabled);
  }

  /// Get haptics enabled setting
  Future<bool> getHapticsEnabled() async {
    _ensureInitialized();
    return _prefs!.getBool(StorageKeys.hapticsEnabled) ?? true;
  }

  /// Set haptics enabled setting
  Future<bool> setHapticsEnabled(bool enabled) async {
    _ensureInitialized();
    return await _prefs!.setBool(StorageKeys.hapticsEnabled, enabled);
  }

  /// Get dark mode setting
  Future<bool> getIsDarkMode() async {
    _ensureInitialized();
    return _prefs!.getBool(StorageKeys.isDarkMode) ?? false;
  }

  /// Set dark mode setting
  Future<bool> setIsDarkMode(bool enabled) async {
    _ensureInitialized();
    return await _prefs!.setBool(StorageKeys.isDarkMode, enabled);
  }

  // ===== Utility Methods =====

  /// Clear all stored data (for debugging/testing)
  Future<bool> clearAll() async {
    _ensureInitialized();
    return await _prefs!.clear();
  }

  /// Reset player progress (but keep settings)
  Future<bool> resetProgress() async {
    _ensureInitialized();
    final newData = PlayerData();
    return await savePlayerData(newData);
  }

  /// Check if player has saved data
  Future<bool> hasSavedData() async {
    _ensureInitialized();
    return _prefs!.containsKey(StorageKeys.playerData);
  }

  /// Get storage size estimate (in bytes)
  Future<int> getStorageSize() async {
    _ensureInitialized();
    int totalSize = 0;
    for (final key in _prefs!.getKeys()) {
      final value = _prefs!.get(key);
      if (value is String) {
        totalSize += value.length;
      } else {
        totalSize += value.toString().length;
      }
    }
    return totalSize;
  }

  /// Export player data as JSON string (for backup)
  Future<String> exportPlayerData() async {
    final data = await loadPlayerData();
    return jsonEncode(data.toJson());
  }

  /// Import player data from JSON string (for restore)
  Future<bool> importPlayerData(String jsonString) async {
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final data = PlayerData.fromJson(json);
      return await savePlayerData(data);
    } catch (e) {
      print('Error importing player data: $e');
      return false;
    }
  }
}
