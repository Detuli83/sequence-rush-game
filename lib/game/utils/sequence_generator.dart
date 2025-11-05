import 'dart:math';

class SequenceGenerator {
  final Random _random = Random();

  List<int> generateSequence(int length, int colorCount) {
    return List.generate(length, (_) => _random.nextInt(colorCount));
  }

  // Ensure sequences don't repeat the same color more than 3 times
  List<int> generateBalancedSequence(int length, int colorCount) {
    final sequence = <int>[];
    int? lastColor;
    int repeatCount = 0;

    for (int i = 0; i < length; i++) {
      int nextColor;

      if (repeatCount >= 3) {
        // Force a different color
        do {
          nextColor = _random.nextInt(colorCount);
        } while (nextColor == lastColor);
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
}
