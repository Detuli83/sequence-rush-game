import 'level.dart';

/// Game phase during gameplay
enum GamePhase {
  /// Showing the sequence to memorize
  memorize,

  /// Player is executing the sequence
  execute,

  /// Level completed successfully
  completed,

  /// Level failed
  failed,

  /// Paused
  paused,
}

/// Current game session state
class GameState {
  final Level level;
  final List<int> sequence;
  final List<int> userInput;
  final GamePhase phase;
  final double remainingTime;
  final bool isPerfectLevel;
  final int mistakeCount;

  GameState({
    required this.level,
    required this.sequence,
    List<int>? userInput,
    this.phase = GamePhase.memorize,
    double? remainingTime,
    this.isPerfectLevel = true,
    this.mistakeCount = 0,
  })  : userInput = userInput ?? [],
        remainingTime = remainingTime ?? level.executeTime;

  /// Check if sequence is complete
  bool get isSequenceComplete => userInput.length == sequence.length;

  /// Check if current input is correct
  bool get isCurrentInputCorrect {
    if (userInput.isEmpty) return true;
    for (int i = 0; i < userInput.length; i++) {
      if (userInput[i] != sequence[i]) return false;
    }
    return true;
  }

  /// Check if last input was correct
  bool get isLastInputCorrect {
    if (userInput.isEmpty) return true;
    final lastIndex = userInput.length - 1;
    return userInput[lastIndex] == sequence[lastIndex];
  }

  /// Get progress percentage (0.0 to 1.0)
  double get progress {
    if (sequence.isEmpty) return 0.0;
    return userInput.length / sequence.length;
  }

  /// Get time progress percentage (0.0 to 1.0)
  double get timeProgress {
    if (level.executeTime == 0) return 0.0;
    return (remainingTime / level.executeTime).clamp(0.0, 1.0);
  }

  /// Create a copy with modified fields
  GameState copyWith({
    Level? level,
    List<int>? sequence,
    List<int>? userInput,
    GamePhase? phase,
    double? remainingTime,
    bool? isPerfectLevel,
    int? mistakeCount,
  }) {
    return GameState(
      level: level ?? this.level,
      sequence: sequence ?? this.sequence,
      userInput: userInput ?? this.userInput,
      phase: phase ?? this.phase,
      remainingTime: remainingTime ?? this.remainingTime,
      isPerfectLevel: isPerfectLevel ?? this.isPerfectLevel,
      mistakeCount: mistakeCount ?? this.mistakeCount,
    );
  }

  /// Add user input
  GameState addInput(int colorIndex) {
    final newInput = List<int>.from(userInput)..add(colorIndex);
    final isCorrect = newInput.last == sequence[newInput.length - 1];

    return copyWith(
      userInput: newInput,
      isPerfectLevel: isPerfectLevel && isCorrect,
      mistakeCount: isCorrect ? mistakeCount : mistakeCount + 1,
    );
  }

  /// Update remaining time
  GameState updateTime(double delta) {
    final newTime = (remainingTime - delta).clamp(0.0, level.executeTime);
    GamePhase newPhase = phase;

    // Check if time ran out
    if (newTime <= 0 && phase == GamePhase.execute) {
      newPhase = GamePhase.failed;
    }

    return copyWith(
      remainingTime: newTime,
      phase: newPhase,
    );
  }

  /// Start execute phase
  GameState startExecutePhase() {
    return copyWith(
      phase: GamePhase.execute,
      remainingTime: level.executeTime,
    );
  }

  /// Mark as completed
  GameState markCompleted() {
    return copyWith(phase: GamePhase.completed);
  }

  /// Mark as failed
  GameState markFailed() {
    return copyWith(phase: GamePhase.failed);
  }

  /// Pause game
  GameState pause() {
    return copyWith(phase: GamePhase.paused);
  }

  /// Resume game
  GameState resume() {
    return copyWith(phase: GamePhase.execute);
  }

  @override
  String toString() {
    return 'GameState(level: ${level.number}, phase: $phase, '
        'progress: ${userInput.length}/${sequence.length}, '
        'time: ${remainingTime.toStringAsFixed(1)}s, '
        'perfect: $isPerfectLevel)';
  }
}
