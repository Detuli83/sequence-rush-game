import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/achievement.dart';
import '../providers/game_provider.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final achievements = Achievement.getAllAchievements();

    // Separate completed and locked achievements
    final completedAchievements = achievements
        .where((a) => gameProvider.playerData.isAchievementCompleted(a.id))
        .toList();
    final lockedAchievements = achievements
        .where((a) => !gameProvider.playerData.isAchievementCompleted(a.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                '${completedAchievements.length}/${achievements.length}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (completedAchievements.isNotEmpty) ...[
            const Text(
              'Completed',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...completedAchievements.map((achievement) =>
                _buildAchievementCard(achievement, true, gameProvider)),
            const SizedBox(height: 24),
          ],
          if (lockedAchievements.isNotEmpty) ...[
            const Text(
              'Locked',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            ...lockedAchievements.map((achievement) =>
                _buildAchievementCard(achievement, false, gameProvider)),
          ],
        ],
      ),
    );
  }

  Widget _buildAchievementCard(
    Achievement achievement,
    bool isCompleted,
    GameProvider gameProvider,
  ) {
    final progress = _getAchievementProgress(achievement, gameProvider);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isCompleted ? null : Colors.grey.shade800.withOpacity(0.3),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted ? Colors.amber.shade700 : Colors.grey.shade700,
          ),
          child: Center(
            child: Text(
              achievement.icon,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        title: Text(
          achievement.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isCompleted ? null : Colors.grey,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              achievement.description,
              style: TextStyle(
                color: isCompleted ? Colors.grey.shade400 : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            if (!isCompleted && progress != null) ...[
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.shade700,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
              ),
              const SizedBox(height: 4),
              Text(
                '${(progress * 100).toInt()}% Complete',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
            const SizedBox(height: 4),
            Row(
              children: [
                if (achievement.coinReward > 0) ...[
                  const Icon(Icons.monetization_on, size: 16, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text('+${achievement.coinReward}'),
                ],
                if (achievement.gemReward > 0) ...[
                  const SizedBox(width: 12),
                  const Icon(Icons.diamond, size: 16, color: Colors.cyan),
                  const SizedBox(width: 4),
                  Text('+${achievement.gemReward}'),
                ],
              ],
            ),
          ],
        ),
        trailing: isCompleted
            ? const Icon(Icons.check_circle, color: Colors.green, size: 32)
            : const Icon(Icons.lock, color: Colors.grey, size: 32),
      ),
    );
  }

  double? _getAchievementProgress(Achievement achievement, GameProvider gameProvider) {
    final playerData = gameProvider.playerData;

    switch (achievement.type) {
      case AchievementType.levelComplete:
        return (playerData.totalLevelsCompleted / achievement.targetValue).clamp(0.0, 1.0);
      case AchievementType.worldComplete:
        final currentWorld = (playerData.currentLevel / 20).ceil();
        return (currentWorld / achievement.targetValue).clamp(0.0, 1.0);
      case AchievementType.perfectLevels:
        return (playerData.perfectLevelsCount / achievement.targetValue).clamp(0.0, 1.0);
      case AchievementType.speedRun:
        return null; // Can't show progress for one-time events
      case AchievementType.comboMultiplier:
        return (playerData.consecutivePerfectLevels / achievement.targetValue).clamp(0.0, 1.0);
      case AchievementType.coinsCollected:
        return (playerData.totalCoinsEarned / achievement.targetValue).clamp(0.0, 1.0);
      case AchievementType.themesUnlocked:
        return (playerData.unlockedThemes.length / achievement.targetValue).clamp(0.0, 1.0);
      case AchievementType.powerUpsUsed:
        return (playerData.powerUpsUsedCount / achievement.targetValue).clamp(0.0, 1.0);
      case AchievementType.highScore:
        if (playerData.bestScore >= achievement.targetValue) return 1.0;
        return (playerData.bestScore / achievement.targetValue).clamp(0.0, 1.0);
      case AchievementType.dailyChallenges:
        return (playerData.dailyChallengesCompleted / achievement.targetValue).clamp(0.0, 1.0);
      case AchievementType.consecutiveDays:
        return (playerData.consecutiveDaysPlayed / achievement.targetValue).clamp(0.0, 1.0);
    }
  }
}
