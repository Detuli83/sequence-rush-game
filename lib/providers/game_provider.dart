import 'package:flutter/foundation.dart';
import '../models/player_data.dart';
import '../models/level.dart';
import '../services/storage_service.dart';
import '../game/utils/sequence_generator.dart';
import '../game/utils/score_calculator.dart';

class GameProvider with ChangeNotifier {
  final StorageService _storage;
  final SequenceGenerator _sequenceGenerator = SequenceGenerator();

  PlayerData _playerData = PlayerData();
  Level? _currentLevel;
  List<int>? _currentSequence;
  List<int> _userInput = [];
  int _consecutivePerfectLevels = 0;
  bool _isPerfectLevel = true;

  GameProvider(this._storage) {
    _loadPlayerData();
  }

  // Getters
  PlayerData get playerData => _playerData;
  Level? get currentLevel => _currentLevel;
  List<int>? get currentSequence => _currentSequence;
  int get currentLevelNumber => _playerData.currentLevel;
  int get lives => _playerData.lives;
  int get coins => _playerData.coins;
  int get gems => _playerData.gems;

  Future<void> _loadPlayerData() async {
    _playerData = await _storage.loadPlayerData();
    _playerData.updateLives(); // Update lives based on time
    await _savePlayerData();
    notifyListeners();
  }

  Future<void> _savePlayerData() async {
    await _storage.savePlayerData(_playerData);
  }

  // Start a new level
  Future<void> startLevel(int levelNumber) async {
    _currentLevel = Level.fromNumber(levelNumber);
    _currentSequence = _sequenceGenerator.generateBalancedSequence(
      _currentLevel!.sequenceLength,
      _currentLevel!.colorCount,
    );
    _userInput = [];
    _isPerfectLevel = true;
    notifyListeners();
  }

  // User taps a button
  void addInput(int colorIndex) {
    if (_currentSequence == null) return;

    _userInput.add(colorIndex);

    // Check if input is correct
    final currentIndex = _userInput.length - 1;
    if (_userInput[currentIndex] != _currentSequence![currentIndex]) {
      _isPerfectLevel = false;
    }

    notifyListeners();
  }

  // Check if sequence is complete and correct
  bool isSequenceComplete() {
    if (_currentSequence == null) return false;
    return _userInput.length == _currentSequence!.length;
  }

  bool isSequenceCorrect() {
    if (_currentSequence == null) return false;
    if (_userInput.length != _currentSequence!.length) return false;

    for (int i = 0; i < _userInput.length; i++) {
      if (_userInput[i] != _currentSequence![i]) return false;
    }
    return true;
  }

  // Complete level
  Future<int> completeLevel(double remainingTime) async {
    if (_currentLevel == null) return 0;

    // Calculate score
    final comboMultiplier = ScoreCalculator.calculateComboMultiplier(
      _consecutivePerfectLevels,
    );
    final score = ScoreCalculator.calculateScore(
      baseScore: _currentLevel!.baseScore,
      remainingTime: remainingTime,
      comboMultiplier: comboMultiplier,
      isPerfect: _isPerfectLevel,
    );

    // Update player data
    _playerData.currentLevel++;
    _playerData.addCoins(10); // Base coin reward

    if (_isPerfectLevel) {
      _consecutivePerfectLevels++;
      _playerData.addCoins(25); // Perfect level bonus
    } else {
      _consecutivePerfectLevels = 0;
    }

    await _storage.addHighScore(score);
    await _savePlayerData();

    notifyListeners();
    return score;
  }

  // Fail level
  Future<void> failLevel() async {
    _playerData.loseLife();
    _consecutivePerfectLevels = 0;
    await _savePlayerData();
    notifyListeners();
  }

  // Power-ups
  Future<void> usePowerUp(String type) async {
    switch (type) {
      case 'hint':
        if (_playerData.coins >= 50) {
          _playerData.spendCoins(50);
          await _savePlayerData();
          notifyListeners();
        }
        break;
      case 'extra_time':
        if (_playerData.coins >= 75) {
          _playerData.spendCoins(75);
          await _savePlayerData();
          notifyListeners();
        }
        break;
      case 'slow_motion':
        if (_playerData.coins >= 100) {
          _playerData.spendCoins(100);
          await _savePlayerData();
          notifyListeners();
        }
        break;
    }
  }

  // Buy lives with ad
  void addLifeFromAd() {
    _playerData.addLife();
    _savePlayerData();
    notifyListeners();
  }

  // Add coins from ad
  void addCoinsFromAd(int amount) {
    _playerData.addCoins(amount);
    _savePlayerData();
    notifyListeners();
  }
}
