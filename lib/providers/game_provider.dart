import 'package:flutter/foundation.dart';
import '../models/player_data.dart';
import '../models/level.dart';
import '../models/game_state.dart';
import '../services/storage_service.dart';
import '../game/utils/sequence_generator.dart';
import '../game/utils/score_calculator.dart';
import '../config/constants.dart';

/// Main game state provider
/// Manages player data, level progression, and gameplay state
class GameProvider with ChangeNotifier {
  final StorageService _storage;
  final SequenceGenerator _sequenceGenerator = SequenceGenerator();

  PlayerData _playerData = PlayerData();
  GameState? _currentGameState;
  bool _isLoaded = false;

  GameProvider(this._storage) {
    _loadPlayerData();
  }

  // Getters
  PlayerData get playerData => _playerData;
  GameState? get currentGameState => _currentGameState;
  bool get isLoaded => _isLoaded;
  bool get isPlaying => _currentGameState != null;

  // Player stats
  int get currentLevel => _playerData.currentLevel;
  int get lives => _playerData.lives;
  int get coins => _playerData.coins;
  int get gems => _playerData.gems;
  int get consecutivePerfectLevels => _playerData.consecutivePerfectLevels;
  List<int> get highScores => _playerData.highScores;
  int get bestScore => _playerData.bestScore;

  // Lives system
  bool get hasLives => _playerData.lives > 0;
  bool get canClaimDailyReward => _playerData.canClaimDailyReward;

  /// Load player data from storage
  Future<void> _loadPlayerData() async {
    try {
      _playerData = await _storage.loadPlayerData();
      _playerData.updateLives(); // Update lives based on time elapsed
      await _savePlayerData();
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      print('Error loading player data: $e');
      _playerData = PlayerData();
      _isLoaded = true;
      notifyListeners();
    }
  }

  /// Save player data to storage
  Future<void> _savePlayerData() async {
    try {
      await _storage.savePlayerData(_playerData);
    } catch (e) {
      print('Error saving player data: $e');
    }
  }

  // ===== Level Management =====

  /// Start a new level
  Future<GameState?> startLevel(int levelNumber) async {
    // Check if player has lives
    if (!hasLives) {
      print('No lives remaining');
      return null;
    }

    // Create level configuration
    final level = Level.fromNumber(levelNumber);

    // Generate sequence
    final sequence = _sequenceGenerator.generateValidSequence(
      level.sequenceLength,
      level.colorCount,
    );

    // Create game state
    _currentGameState = GameState(
      level: level,
      sequence: sequence,
      phase: GamePhase.memorize,
    );

    notifyListeners();
    return _currentGameState;
  }

  /// Add user input during execute phase
  void addInput(int colorIndex) {
    if (_currentGameState == null) return;
    if (_currentGameState!.phase != GamePhase.execute) return;

    final newState = _currentGameState!.addInput(colorIndex);
    _currentGameState = newState;

    // Check if sequence is complete
    if (newState.isSequenceComplete) {
      if (newState.isCurrentInputCorrect) {
        _currentGameState = newState.markCompleted();
      } else {
        _currentGameState = newState.markFailed();
      }
    } else if (!newState.isLastInputCorrect) {
      // Wrong input - fail immediately
      _currentGameState = newState.markFailed();
    }

    notifyListeners();
  }

  /// Update game time (called every frame)
  void updateTime(double deltaTime) {
    if (_currentGameState == null) return;
    if (_currentGameState!.phase != GamePhase.execute) return;

    _currentGameState = _currentGameState!.updateTime(deltaTime);
    notifyListeners();
  }

  /// Start execute phase
  void startExecutePhase() {
    if (_currentGameState == null) return;
    _currentGameState = _currentGameState!.startExecutePhase();
    notifyListeners();
  }

  /// Complete current level
  Future<int> completeLevel() async {
    if (_currentGameState == null) return 0;

    final state = _currentGameState!;
    final level = state.level;

    // Calculate score
    final comboMultiplier = ScoreCalculator.calculateComboMultiplier(
      _playerData.consecutivePerfectLevels,
    );
    final score = ScoreCalculator.calculateScore(
      baseScore: level.baseScore,
      remainingTime: state.remainingTime,
      comboMultiplier: comboMultiplier,
      isPerfect: state.isPerfectLevel,
    );

    // Calculate coins
    final coinsEarned = ScoreCalculator.calculateCoinsEarned(
      isPerfect: state.isPerfectLevel,
    );

    // Update player data
    _playerData.currentLevel = level.number + 1;
    _playerData.totalLevelsCompleted++;
    _playerData.addCoins(coinsEarned);
    _playerData.addHighScore(score);

    if (state.isPerfectLevel) {
      _playerData.consecutivePerfectLevels++;
    } else {
      _playerData.consecutivePerfectLevels = 0;
    }

    await _savePlayerData();

    // Clear game state
    _currentGameState = null;
    notifyListeners();

    return score;
  }

  /// Fail current level
  Future<void> failLevel() async {
    // Lose a life
    _playerData.loseLife();
    _playerData.consecutivePerfectLevels = 0;

    await _savePlayerData();

    // Clear game state
    _currentGameState = null;
    notifyListeners();
  }

  /// Pause game
  void pauseGame() {
    if (_currentGameState == null) return;
    _currentGameState = _currentGameState!.pause();
    notifyListeners();
  }

  /// Resume game
  void resumeGame() {
    if (_currentGameState == null) return;
    _currentGameState = _currentGameState!.resume();
    notifyListeners();
  }

  /// Quit current game
  void quitGame() {
    _currentGameState = null;
    notifyListeners();
  }

  // ===== Lives Management =====

  /// Update lives (regeneration)
  Future<void> updateLives() async {
    _playerData.updateLives();
    await _savePlayerData();
    notifyListeners();
  }

  /// Add a life (from ad or purchase)
  Future<void> addLife() async {
    _playerData.addLife();
    await _savePlayerData();
    notifyListeners();
  }

  /// Buy lives with coins or gems
  Future<bool> buyLives(int count, {bool useGems = false}) async {
    final cost = useGems ? 1 * count : 20 * count; // Example pricing

    if (useGems) {
      if (!_playerData.spendGems(cost)) return false;
    } else {
      if (!_playerData.spendCoins(cost)) return false;
    }

    for (int i = 0; i < count; i++) {
      _playerData.addLife();
    }

    await _savePlayerData();
    notifyListeners();
    return true;
  }

  // ===== Currency Management =====

  /// Add coins
  Future<void> addCoins(int amount) async {
    _playerData.addCoins(amount);
    await _savePlayerData();
    notifyListeners();
  }

  /// Spend coins
  Future<bool> spendCoins(int amount) async {
    if (!_playerData.spendCoins(amount)) return false;
    await _savePlayerData();
    notifyListeners();
    return true;
  }

  /// Add gems
  Future<void> addGems(int amount) async {
    _playerData.addGems(amount);
    await _savePlayerData();
    notifyListeners();
  }

  /// Spend gems
  Future<bool> spendGems(int amount) async {
    if (!_playerData.spendGems(amount)) return false;
    await _savePlayerData();
    notifyListeners();
    return true;
  }

  // ===== Power-Ups =====

  /// Use hint power-up
  Future<bool> useHint() async {
    if (_currentGameState == null) return false;
    return await spendCoins(GameConstants.hintCost);
  }

  /// Use extra time power-up
  Future<bool> useExtraTime() async {
    if (_currentGameState == null) return false;
    if (await spendCoins(GameConstants.extraTimeCost)) {
      // Add extra time to current game
      final newTime = _currentGameState!.remainingTime + GameConstants.extraTimeSeconds;
      _currentGameState = _currentGameState!.copyWith(remainingTime: newTime);
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Use slow motion power-up (not implemented in game state yet)
  Future<bool> useSlowMotion() async {
    if (_currentGameState == null) return false;
    return await spendCoins(GameConstants.slowMotionCost);
  }

  /// Skip level
  Future<bool> skipLevel() async {
    if (_currentGameState == null) return false;
    if (await spendCoins(GameConstants.skipLevelCost)) {
      _playerData.currentLevel++;
      await _savePlayerData();
      _currentGameState = null;
      notifyListeners();
      return true;
    }
    return false;
  }

  // ===== Themes & Achievements =====

  /// Unlock theme
  Future<bool> unlockTheme(int themeId, int cost) async {
    if (_playerData.isThemeUnlocked(themeId)) return true;
    if (!await spendCoins(cost)) return false;

    _playerData.unlockTheme(themeId);
    await _savePlayerData();
    notifyListeners();
    return true;
  }

  /// Set current theme
  Future<void> setTheme(int themeId) async {
    if (!_playerData.isThemeUnlocked(themeId)) return;
    _playerData.currentTheme = themeId;
    await _savePlayerData();
    notifyListeners();
  }

  /// Complete achievement
  Future<void> completeAchievement(int achievementId) async {
    if (_playerData.isAchievementCompleted(achievementId)) return;
    _playerData.completeAchievement(achievementId);
    await _savePlayerData();
    notifyListeners();
  }

  // ===== Daily Rewards =====

  /// Claim daily reward
  Future<bool> claimDailyReward() async {
    if (!_playerData.canClaimDailyReward) return false;
    _playerData.claimDailyReward();
    await _savePlayerData();
    notifyListeners();
    return true;
  }

  // ===== Debug & Utility =====

  /// Reset progress (for testing)
  Future<void> resetProgress() async {
    _playerData = PlayerData();
    await _storage.resetProgress();
    _currentGameState = null;
    notifyListeners();
  }

  /// Reload data from storage
  Future<void> reload() async {
    await _loadPlayerData();
  }

  /// Get time until next life
  Duration? getTimeUntilNextLife() {
    if (_playerData.lives >= GameConstants.maxLives) return null;

    final now = DateTime.now();
    final elapsed = now.difference(_playerData.lastLifeUpdate);
    final minutesUntilNext = GameConstants.lifeRegenerationMinutes -
        (elapsed.inMinutes % GameConstants.lifeRegenerationMinutes);

    return Duration(minutes: minutesUntilNext);
  }
}
