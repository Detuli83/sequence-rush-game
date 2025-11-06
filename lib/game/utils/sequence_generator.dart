import 'dart:math';

/// Generates random color sequences for gameplay
/// Implements balanced randomization to avoid repetitive patterns
class SequenceGenerator {
  final Random _random = Random();

  /// Generate a random sequence of color indices
  /// [length] - number of steps in sequence
  /// [colorCount] - number of available colors (4, 6, or 8)
  List<int> generateSequence(int length, int colorCount) {
    return List.generate(length, (_) => _random.nextInt(colorCount));
  }

  /// Generate a balanced sequence that avoids too many repetitions
  /// This prevents frustrating patterns like [0,0,0,0] or excessive repeats
  /// Following GDD best practices for fair gameplay
  List<int> generateBalancedSequence(int length, int colorCount) {
    if (length <= 0 || colorCount <= 0) {
      return [];
    }

    final sequence = <int>[];
    int? lastColor;
    int repeatCount = 0;
    const maxRepeats = 2; // Max 2 consecutive same colors

    for (int i = 0; i < length; i++) {
      int nextColor;

      if (repeatCount >= maxRepeats) {
        // Force a different color after too many repeats
        do {
          nextColor = _random.nextInt(colorCount);
        } while (nextColor == lastColor && colorCount > 1);
        repeatCount = 1;
      } else {
        nextColor = _random.nextInt(colorCount);
        if (nextColor == lastColor) {
          repeatCount++;
        } else {
          repeatCount = 1;
        }
      }

      sequence.add(nextColor);
      lastColor = nextColor;
    }

    return sequence;
  }

  /// Generate a progressive difficulty sequence
  /// Early indices are easier (more spaced), later indices are harder
  List<int> generateProgressiveSequence(int length, int colorCount) {
    final sequence = <int>[];

    // First 30% uses wider spacing
    final easyCount = (length * 0.3).ceil();
    for (int i = 0; i < easyCount; i++) {
      final possibleColors = List.generate(colorCount, (index) => index);
      if (sequence.isNotEmpty) {
        possibleColors.remove(sequence.last);
      }
      sequence.add(possibleColors[_random.nextInt(possibleColors.length)]);
    }

    // Remaining 70% uses balanced generation
    final remaining = length - easyCount;
    if (remaining > 0) {
      final tail = generateBalancedSequence(remaining, colorCount);
      sequence.addAll(tail);
    }

    return sequence;
  }

  /// Generate a pattern-based sequence (for tutorial/training levels)
  /// Creates recognizable patterns to help players learn
  List<int> generatePatternSequence(PatternType pattern, int colorCount) {
    switch (pattern) {
      case PatternType.ascending:
        return List.generate(
          colorCount.clamp(3, 8),
          (i) => i % colorCount,
        );

      case PatternType.descending:
        return List.generate(
          colorCount.clamp(3, 8),
          (i) => (colorCount - 1 - i) % colorCount,
        );

      case PatternType.alternating:
        return List.generate(
          6,
          (i) => i % 2,
        );

      case PatternType.mirror:
        final half = [0, 1, 2];
        return [...half, ...half.reversed];

      case PatternType.repeat:
        final base = [0, 1];
        return [...base, ...base, ...base];
    }
  }

  /// Analyze sequence difficulty
  /// Returns a score from 0.0 (easy) to 1.0 (hard)
  double analyzeSequenceDifficulty(List<int> sequence) {
    if (sequence.isEmpty) return 0.0;

    double difficulty = 0.0;

    // Factor 1: Sequence length (longer = harder)
    final lengthScore = (sequence.length / 10).clamp(0.0, 1.0);
    difficulty += lengthScore * 0.3;

    // Factor 2: Number of unique colors
    final uniqueColors = sequence.toSet().length;
    final uniqueScore = uniqueColors / 8;
    difficulty += uniqueScore * 0.3;

    // Factor 3: Alternation frequency (more changes = harder)
    int changes = 0;
    for (int i = 1; i < sequence.length; i++) {
      if (sequence[i] != sequence[i - 1]) changes++;
    }
    final changeScore = (changes / sequence.length);
    difficulty += changeScore * 0.4;

    return difficulty.clamp(0.0, 1.0);
  }

  /// Validate sequence is playable
  /// Checks for issues like all same color, impossible patterns
  bool isSequenceValid(List<int> sequence, int colorCount) {
    if (sequence.isEmpty) return false;
    if (sequence.any((color) => color < 0 || color >= colorCount)) return false;

    // Check if not all the same (boring)
    if (sequence.toSet().length == 1 && sequence.length > 3) return false;

    return true;
  }

  /// Generate a sequence and ensure it's valid
  List<int> generateValidSequence(int length, int colorCount, {int maxAttempts = 10}) {
    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      final sequence = generateBalancedSequence(length, colorCount);
      if (isSequenceValid(sequence, colorCount)) {
        return sequence;
      }
    }

    // Fallback to simple generation if validation keeps failing
    return generateSequence(length, colorCount);
  }
}

/// Pattern types for tutorial/training levels
enum PatternType {
  ascending,
  descending,
  alternating,
  mirror,
  repeat,
}
