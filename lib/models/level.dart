class Level {
  final int number;
  final int sequenceLength;
  final int colorCount;
  final double timeLimit;
  final int baseScore;

  Level({
    required this.number,
    required this.sequenceLength,
    required this.colorCount,
    required this.timeLimit,
    required this.baseScore,
  });

  // Generate level configuration based on level number
  factory Level.fromNumber(int number) {
    // World 1: Levels 1-20 (4 colors)
    if (number <= 20) {
      return Level(
        number: number,
        sequenceLength: 3 + (number ~/ 6), // 3-6 steps
        colorCount: 4,
        timeLimit: 15.0 - (number * 0.15), // 15s -> 12s
        baseScore: 100 * (3 + (number ~/ 6)),
      );
    }
    // World 2: Levels 21-40 (6 colors)
    else if (number <= 40) {
      final worldLevel = number - 20;
      return Level(
        number: number,
        sequenceLength: 4 + (worldLevel ~/ 5), // 4-7 steps
        colorCount: 6,
        timeLimit: 14.0 - (worldLevel * 0.15),
        baseScore: 100 * (4 + (worldLevel ~/ 5)),
      );
    }
    // World 3+: Advanced levels (8 colors)
    else {
      final worldLevel = number - 40;
      return Level(
        number: number,
        sequenceLength: 6 + (worldLevel ~/ 5), // 6-9+ steps
        colorCount: 8,
        timeLimit: 12.0 - (worldLevel * 0.1).clamp(0, 3),
        baseScore: 100 * (6 + (worldLevel ~/ 5)),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'sequenceLength': sequenceLength,
      'colorCount': colorCount,
      'timeLimit': timeLimit,
      'baseScore': baseScore,
    };
  }
}
