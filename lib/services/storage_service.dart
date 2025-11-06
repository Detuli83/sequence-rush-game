import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sequence_rush_game/config/constants.dart';
import 'package:sequence_rush_game/models/player_data.dart';

/// Service for managing local storage using SharedPreferences
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;

  /// Initialize the storage service
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Initialize the storage service (alias for compatibility)
  Future<void> init() async {
    await initialize();
  }

  /// Ensure preferences are initialized
  Future<SharedPreferences> get _preferences async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Player Data Management

  /// Save player data
  Future<void> savePlayerData(PlayerData playerData) async {
    final prefs = await _preferences;
    final jsonString = jsonEncode(playerData.toJson());
    await prefs.setString(GameConstants.keyPlayerData, jsonString);
  }

  /// Load player data
  Future<PlayerData> loadPlayerData() async {
    final prefs = await _preferences;
    final jsonString = prefs.getString(GameConstants.keyPlayerData);

    if (jsonString != null) {
      try {
        final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
        return PlayerData.fromJson(jsonMap);
      } catch (e) {
        print('Error loading player data: $e');
        return PlayerData();
      }
    }

    return PlayerData();
  }

  /// Delete player data (for reset/logout)
  Future<void> deletePlayerData() async {
    final prefs = await _preferences;
    await prefs.remove(GameConstants.keyPlayerData);
  }

  // Purchase Management

  /// Save a purchased item
  Future<void> savePurchasedItem(String productId) async {
    final prefs = await _preferences;
    final purchases = await getPurchasedItems();
    purchases.add(productId);
    await prefs.setStringList(GameConstants.keyPurchases, purchases.toList());
  }

  /// Check if an item is purchased
  Future<bool> isPurchased(String productId) async {
    final purchases = await getPurchasedItems();
    return purchases.contains(productId);
  }

  /// Get all purchased items
  Future<Set<String>> getPurchasedItems() async {
    final prefs = await _preferences;
    final purchasesList = prefs.getStringList(GameConstants.keyPurchases) ?? [];
    return purchasesList.toSet();
  }

  /// Remove a purchased item (for testing/refunds)
  Future<void> removePurchasedItem(String productId) async {
    final prefs = await _preferences;
    final purchases = await getPurchasedItems();
    purchases.remove(productId);
    await prefs.setStringList(GameConstants.keyPurchases, purchases.toList());
  }

  // High Scores

  /// Get high scores
  Future<List<int>> getHighScores() async {
    final data = await loadPlayerData();
    return data.highScores;
  }

  /// Add high score
  Future<void> addHighScore(int score) async {
    final data = await loadPlayerData();
    data.highScores.add(score);
    data.highScores.sort((a, b) => b.compareTo(a)); // Sort descending
    if (data.highScores.length > 10) {
      data.highScores = data.highScores.take(10).toList();
    }
    await savePlayerData(data);
  }

  // Settings Management

  /// Get a setting
  Future<bool> getSetting(String key, {bool defaultValue = true}) async {
    final data = await loadPlayerData();
    return data.settings[key] ?? defaultValue;
  }

  /// Set a setting
  Future<void> setSetting(String key, bool value) async {
    final data = await loadPlayerData();
    data.settings[key] = value;
    await savePlayerData(data);
  }

  /// Save a boolean setting
  Future<void> saveBoolSetting(String key, bool value) async {
    final prefs = await _preferences;
    await prefs.setBool(key, value);
  }

  /// Load a boolean setting
  Future<bool> loadBoolSetting(String key, {bool defaultValue = true}) async {
    final prefs = await _preferences;
    return prefs.getBool(key) ?? defaultValue;
  }

  /// Save an integer setting
  Future<void> saveIntSetting(String key, int value) async {
    final prefs = await _preferences;
    await prefs.setInt(key, value);
  }

  /// Load an integer setting
  Future<int> loadIntSetting(String key, {int defaultValue = 0}) async {
    final prefs = await _preferences;
    return prefs.getInt(key) ?? defaultValue;
  }

  /// Save a string setting
  Future<void> saveStringSetting(String key, String value) async {
    final prefs = await _preferences;
    await prefs.setString(key, value);
  }

  /// Load a string setting
  Future<String?> loadStringSetting(String key) async {
    final prefs = await _preferences;
    return prefs.getString(key);
  }

  // Ad Management

  /// Save the last ad date
  Future<void> saveLastAdDate(DateTime date) async {
    final prefs = await _preferences;
    await prefs.setString(GameConstants.keyLastAdDate, date.toIso8601String());
  }

  /// Get the last ad date
  Future<DateTime?> getLastAdDate() async {
    final prefs = await _preferences;
    final dateString = prefs.getString(GameConstants.keyLastAdDate);
    if (dateString != null) {
      try {
        return DateTime.parse(dateString);
      } catch (e) {
        print('Error parsing last ad date: $e');
        return null;
      }
    }
    return null;
  }

  /// Save ad for life count
  Future<void> saveAdForLifeCount(int count) async {
    final prefs = await _preferences;
    await prefs.setInt(GameConstants.keyAdForLifeCount, count);
  }

  /// Get ad for life count
  Future<int> getAdForLifeCount() async {
    final prefs = await _preferences;
    return prefs.getInt(GameConstants.keyAdForLifeCount) ?? 0;
  }

  // Achievement Management

  /// Save achievements
  Future<void> saveAchievements(Map<String, bool> achievements) async {
    final prefs = await _preferences;
    final jsonString = jsonEncode(achievements);
    await prefs.setString(GameConstants.keyAchievements, jsonString);
  }

  /// Load achievements
  Future<Map<String, bool>> loadAchievements() async {
    final prefs = await _preferences;
    final jsonString = prefs.getString(GameConstants.keyAchievements);

    if (jsonString != null) {
      try {
        final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
        return jsonMap.map((key, value) => MapEntry(key, value as bool));
      } catch (e) {
        print('Error loading achievements: $e');
        return {};
      }
    }

    return {};
  }

  // Utility Methods

  /// Clear all stored data (for testing or reset)
  Future<void> clearAll() async {
    final prefs = await _preferences;
    await prefs.clear();
  }

  /// Check if any data exists
  Future<bool> hasData() async {
    final prefs = await _preferences;
    return prefs.getKeys().isNotEmpty;
  }

  /// Get all keys
  Future<Set<String>> getAllKeys() async {
    final prefs = await _preferences;
    return prefs.getKeys();
  }
}
