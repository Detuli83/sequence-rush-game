import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flame/game.dart';
import '../game/sequence_rush_game.dart';
import '../providers/game_provider.dart';
import '../services/audio_service.dart';
import '../models/game_state.dart';
import '../config/colors.dart';
import '../game/utils/score_calculator.dart';

/// Main game screen that displays the Flame game and UI overlay
class GameScreen extends StatefulWidget {
  final int levelNumber;

  const GameScreen({
    super.key,
    required this.levelNumber,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late SequenceRushGame _game;
  GamePhase _currentPhase = GamePhase.memorize;
  double _timeRemaining = 0;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    final gameProvider = context.read<GameProvider>();
    final audioService = context.read<AudioService>();

    // Start level in provider
    final gameState = await gameProvider.startLevel(widget.levelNumber);

    if (gameState == null) {
      // No lives - go back
      if (mounted) {
        Navigator.of(context).pop();
      }
      return;
    }

    // Create Flame game
    _game = SequenceRushGame();

    // Set up callbacks
    _game.onTimeUpdate = (time) {
      if (mounted) {
        setState(() {
          _timeRemaining = time;
        });
      }
    };

    _game.onMemorizeComplete = () {
      if (mounted) {
        setState(() {
          _currentPhase = GamePhase.execute;
        });
        _game.startExecutePhase();
      }
    };

    _game.onButtonPressed = (colorIndex, isCorrect) {
      if (isCorrect) {
        audioService.playCorrectFeedback();
      } else {
        audioService.playWrongFeedback();
      }
    };

    _game.onSequenceStep = (colorIndex) {
      audioService.playButtonSound(colorIndex);
    };

    _game.onGameComplete = (success, remainingTime) {
      _handleGameComplete(success, remainingTime);
    };

    // Initialize Flame game
    await _game.initGame(
      gameLevel: gameState.level,
      sequence: gameState.sequence,
    );

    setState(() {
      _isInitialized = true;
      _currentPhase = GamePhase.memorize;
      _timeRemaining = gameState.level.memorizeTime;
    });
  }

  void _handleGameComplete(bool success, double remainingTime) async {
    final gameProvider = context.read<GameProvider>();
    final audioService = context.read<AudioService>();

    if (success) {
      // Level complete
      audioService.playLevelCompleteSound();
      final score = await gameProvider.completeLevel();

      if (mounted) {
        _showLevelCompleteDialog(score, remainingTime);
      }
    } else {
      // Game over
      audioService.playGameOverSound();
      await gameProvider.failLevel();

      if (mounted) {
        _showGameOverDialog();
      }
    }
  }

  void _showLevelCompleteDialog(int score, double remainingTime) {
    final gameProvider = context.read<GameProvider>();
    final level = _game.level;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Level Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Level ${level.number}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            _buildScoreStat('Score', score.toString()),
            _buildScoreStat(
              'Time Bonus',
              '+${(remainingTime * 50).round()}',
            ),
            _buildScoreStat('Coins', '+${ScoreCalculator.calculateCoinsEarned(
              isPerfect: gameProvider.currentGameState?.isPerfectLevel ?? false,
            )}'),
            if (gameProvider.consecutivePerfectLevels > 0)
              _buildScoreStat(
                'Perfect Streak',
                '${gameProvider.consecutivePerfectLevels}x',
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Return to menu
            },
            child: const Text('MENU'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              // Restart with next level
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => GameScreen(levelNumber: level.number + 1),
                ),
              );
            },
            child: const Text('NEXT LEVEL'),
          ),
        ],
      ),
    );
  }

  void _showGameOverDialog() {
    final gameProvider = context.read<GameProvider>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('💔 Game Over'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Lives remaining: ${gameProvider.lives}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            if (!gameProvider.hasLives)
              const Text('No lives left! Wait for regeneration or watch an ad.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Return to menu
            },
            child: const Text('MENU'),
          ),
          if (gameProvider.hasLives)
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                // Retry same level
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => GameScreen(levelNumber: widget.levelNumber),
                  ),
                );
              },
              child: const Text('RETRY'),
            ),
        ],
      ),
    );
  }

  Widget _buildScoreStat(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Flame game
            GameWidget(game: _game),

            // Top UI overlay
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildTopBar(),
            ),

            // Phase indicator
            if (_currentPhase == GamePhase.memorize)
              Positioned(
                top: 80,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      _game.isPlayingSequence
                          ? 'WATCH SEQUENCE'
                          : 'MEMORIZE!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, _) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),

              // Level info
              Text(
                'Level ${_game.level.number}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              // Timer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _timeRemaining < 5
                      ? AppColors.error.withOpacity(0.2)
                      : AppColors.accent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.timer,
                      size: 20,
                      color: _timeRemaining < 5 ? AppColors.error : AppColors.accent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _timeRemaining.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _timeRemaining < 5 ? AppColors.error : AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ),

              // Lives indicator
              Row(
                children: List.generate(
                  gameProvider.lives.clamp(0, 5),
                  (index) => const Icon(
                    Icons.favorite,
                    color: AppColors.error,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _game.pauseGame();
    super.dispose();
  }
}
