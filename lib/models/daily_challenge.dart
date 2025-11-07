import 'dart:math';

class DailyChallenge {
  final String id;
  final String title;
  final String description;
  final ChallengeType type;
  final int targetValue;
  final int coinReward;
  final int gemReward;
  final DateTime date;
  bool isCompleted;
  int currentProgress;

  DailyChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.targetValue,
    this.coinReward = 50,
    this.gemReward = 5,
    required this.date,
    this.isCompleted = false,
    this.currentProgress = 0,
  });

  double get progressPercentage {
    if (targetValue == 0) return 0.0;
    return (currentProgress / targetValue).clamp(0.0, 1.0);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.toString(),
      'targetValue': targetValue,
      'coinReward': coinReward,
      'gemReward': gemReward,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted,
      'currentProgress': currentProgress,
    };
  }

  factory DailyChallenge.fromJson(Map<String, dynamic> json) {
    return DailyChallenge(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: ChallengeType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => ChallengeType.completeLevels,
      ),
      targetValue: json['targetValue'],
      coinReward: json['coinReward'] ?? 50,
      gemReward: json['gemReward'] ?? 5,
      date: DateTime.parse(json['date']),
      isCompleted: json['isCompleted'] ?? false,
      currentProgress: json['currentProgress'] ?? 0,
    );
  }

  static List<DailyChallenge> generateDailyChallenges(DateTime date) {
    final Random random = Random(date.year * 10000 + date.month * 100 + date.day);
    final challenges = <DailyChallenge>[];

    // Challenge 1: Complete levels
    final levelCount = 3 + random.nextInt(3); // 3-5 levels
    challenges.add(DailyChallenge(
      id: 'daily_${date.toIso8601String()}_1',
      title: 'Level Marathon',
      description: 'Complete $levelCount levels',
      type: ChallengeType.completeLevels,
      targetValue: levelCount,
      coinReward: 50,
      gemReward: 5,
      date: date,
    ));

    // Challenge 2: Speed or Perfect
    if (random.nextBool()) {
      // Speed challenge
      challenges.add(DailyChallenge(
        id: 'daily_${date.toIso8601String()}_2',
        title: 'Speed Challenge',
        description: 'Complete a level with 8+ seconds remaining',
        type: ChallengeType.speedRun,
        targetValue: 8,
        coinReward: 75,
        gemReward: 5,
        date: date,
      ));
    } else {
      // Perfect challenge
      final perfectCount = 2 + random.nextInt(2); // 2-3 levels
      challenges.add(DailyChallenge(
        id: 'daily_${date.toIso8601String()}_2',
        title: 'Perfect Streak',
        description: 'Complete $perfectCount perfect levels in a row',
        type: ChallengeType.perfectStreak,
        targetValue: perfectCount,
        coinReward: 75,
        gemReward: 5,
        date: date,
      ));
    }

    // Challenge 3: Score or No Power-ups
    if (random.nextBool()) {
      // Score challenge
      final scoreTarget = 800 + random.nextInt(400); // 800-1200
      challenges.add(DailyChallenge(
        id: 'daily_${date.toIso8601String()}_3',
        title: 'High Score',
        description: 'Score $scoreTarget+ points in a single level',
        type: ChallengeType.highScore,
        targetValue: scoreTarget,
        coinReward: 100,
        gemReward: 10,
        date: date,
      ));
    } else {
      // No power-ups challenge
      challenges.add(DailyChallenge(
        id: 'daily_${date.toIso8601String()}_3',
        title: 'Pure Skill',
        description: 'Complete 3 levels without using power-ups',
        type: ChallengeType.noPowerUps,
        targetValue: 3,
        coinReward: 100,
        gemReward: 10,
        date: date,
      ));
    }

    return challenges;
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

enum ChallengeType {
  completeLevels,
  perfectStreak,
  speedRun,
  highScore,
  noPowerUps,
  collectCoins,
}
