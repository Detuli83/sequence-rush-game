import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/player_data.dart';

class StorageService {
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Player data
  Future<PlayerData> loadPlayerData() async {
    final jsonString = _prefs?.getString('player_data');
    if (jsonString == null) {
      return PlayerData();
    }
    try {
      return PlayerData.fromJson(jsonDecode(jsonString));
    } catch (e) {
      // If there's an error parsing, return new player data
      return PlayerData();
    }
  }

  Future<void> savePlayerData(PlayerData data) async {
    await _prefs?.setString('player_data', jsonEncode(data.toJson()));
  }

  // High scores
  Future<List<int>> getHighScores() async {
    final data = await loadPlayerData();
    return data.highScores;
  }

  Future<void> addHighScore(int score) async {
    final data = await loadPlayerData();
    data.highScores.add(score);
    data.highScores.sort((a, b) => b.compareTo(a)); // Sort descending
    if (data.highScores.length > 10) {
      data.highScores = data.highScores.take(10).toList();
    }
    await savePlayerData(data);
  }

  // Settings
  Future<bool> getSetting(String key, {bool defaultValue = true}) async {
    final data = await loadPlayerData();
    return data.settings[key] ?? defaultValue;
  }

  Future<void> setSetting(String key, bool value) async {
    final data = await loadPlayerData();
    data.settings[key] = value;
    await savePlayerData(data);
  }

  // Purchased items tracking
  Future<void> savePurchasedItem(String productId) async {
    final purchasedItems = _prefs?.getStringList('purchased_items') ?? [];
    if (!purchasedItems.contains(productId)) {
      purchasedItems.add(productId);
      await _prefs?.setStringList('purchased_items', purchasedItems);
    }
  }

  Future<bool> isPurchased(String productId) async {
    final purchasedItems = _prefs?.getStringList('purchased_items') ?? [];
    return purchasedItems.contains(productId);
  }

  Future<List<String>> getPurchasedItems() async {
    return _prefs?.getStringList('purchased_items') ?? [];
  }

  // Clear all data (for testing)
  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
