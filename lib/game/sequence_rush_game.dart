import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../models/game_state.dart';
import '../models/level.dart';
import 'components/grid_manager.dart';

/// Main Flame game class for Sequence Rush
/// Handles the game loop, rendering, and input
class SequenceRushGame extends FlameGame {
  // Game state
  GamePhase _phase = GamePhase.memorize;
  List<int> _sequence = [];
  List<int> _userInput = [];

  // Level configuration
  late Level level;
  late int colorCount;

  // Time tracking
  double _memorizeTimeRemaining = 5.0;
  double _executeTimeRemaining = 15.0;
  bool _isPlayingSequence = false;

  // Components
  late GridManager gridManager;

  // Callbacks to Flutter UI
  Function(int colorIndex, bool isCorrect)? onButtonPressed;
  Function(bool success, double remainingTime)? onGameComplete;
  Function(double timeRemaining)? onTimeUpdate;
  Function()? onMemorizeComplete;
  Function(int colorIndex)? onSequenceStep;

  @override
  Color backgroundColor() => AppColors.darkBgPrimary;

  /// Initialize the game with a level and sequence
  Future<void> initGame({
    required Level gameLevel,
    required List<int> sequence,
  }) async {
    level = gameLevel;
    colorCount = level.colorCount;
    _sequence = sequence;
    _phase = GamePhase.memorize;
    _userInput = [];
    _memorizeTimeRemaining = level.memorizeTime;
    _executeTimeRemaining = level.executeTime;

    // Create grid manager
    gridManager = GridManager(
      colorCount: colorCount,
      onButtonTapped: _handleButtonTap,
    );

    await add(gridManager);

    // Start playing the sequence after a brief delay
    Future.delayed(const Duration(milliseconds: 500), () {
      _playSequence();
    });
  }

  /// Play the sequence animation (memorize phase)
  Future<void> _playSequence() async {
    _isPlayingSequence = true;

    for (int i = 0; i < _sequence.length; i++) {
      final colorIndex = _sequence[i];

      // Notify UI about current step
      onSequenceStep?.call(colorIndex);

      // Highlight button
      gridManager.highlightButton(colorIndex, true);

      // Wait for highlight duration
      await Future.delayed(const Duration(milliseconds: 500));

      // Un-highlight button
      gridManager.highlightButton(colorIndex, false);

      // Wait before next button
      await Future.delayed(const Duration(milliseconds: 300));
    }

    _isPlayingSequence = false;
  }

  /// Handle button tap during execute phase
  void _handleButtonTap(int colorIndex) {
    if (_phase != GamePhase.execute) return;
    if (_userInput.length >= _sequence.length) return;

    // Add to user input
    _userInput.add(colorIndex);

    // Check if correct
    final currentIndex = _userInput.length - 1;
    final isCorrect = _userInput[currentIndex] == _sequence[currentIndex];

    // Notify UI
    onButtonPressed?.call(colorIndex, isCorrect);

    // Visual feedback
    gridManager.flashButton(colorIndex, isCorrect);

    if (!isCorrect) {
      // Wrong input - game over
      _phase = GamePhase.failed;
      onGameComplete?.call(false, _executeTimeRemaining);
    } else if (_userInput.length == _sequence.length) {
      // Sequence complete and correct
      _phase = GamePhase.completed;
      onGameComplete?.call(true, _executeTimeRemaining);
    }
  }

  /// Start the execute phase (called from UI after memorize phase)
  void startExecutePhase() {
    _phase = GamePhase.execute;
    _userInput.clear();
  }

  /// Pause the game
  void pauseGame() {
    if (_phase == GamePhase.execute) {
      _phase = GamePhase.paused;
      paused = true;
    }
  }

  /// Resume the game
  void resumeGame() {
    if (_phase == GamePhase.paused) {
      _phase = GamePhase.execute;
      paused = false;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Update memorize phase timer
    if (_phase == GamePhase.memorize && !_isPlayingSequence) {
      _memorizeTimeRemaining -= dt;
      onTimeUpdate?.call(_memorizeTimeRemaining);

      if (_memorizeTimeRemaining <= 0) {
        // Memorize phase complete, start execute phase
        _phase = GamePhase.execute;
        _memorizeTimeRemaining = 0;
        onMemorizeComplete?.call();
      }
    }

    // Update execute phase timer
    if (_phase == GamePhase.execute) {
      _executeTimeRemaining -= dt;
      onTimeUpdate?.call(_executeTimeRemaining);

      if (_executeTimeRemaining <= 0) {
        // Time's up - game over
        _phase = GamePhase.failed;
        _executeTimeRemaining = 0;
        onGameComplete?.call(false, 0);
      }
    }
  }

  // Getters
  GamePhase get phase => _phase;
  List<int> get sequence => _sequence;
  List<int> get userInput => _userInput;
  double get memorizeTimeRemaining => _memorizeTimeRemaining;
  double get executeTimeRemaining => _executeTimeRemaining;
  bool get isPlayingSequence => _isPlayingSequence;

  /// Reset game for replay
  void reset() {
    _phase = GamePhase.memorize;
    _userInput.clear();
    _memorizeTimeRemaining = level.memorizeTime;
    _executeTimeRemaining = level.executeTime;
    _isPlayingSequence = false;
  }
}
