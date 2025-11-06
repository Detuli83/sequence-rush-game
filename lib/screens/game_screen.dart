import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../providers/game_provider.dart';
import '../services/audio_service.dart';
import '../widgets/color_button.dart';
import '../config/colors.dart';

enum GamePhase { memorize, execute, complete, failed }

class GameScreen extends StatefulWidget {
  final int levelNumber;

  const GameScreen({super.key, required this.levelNumber});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  GamePhase _phase = GamePhase.memorize;
  int _sequenceIndex = 0;
  double _remainingTime = 15.0;
  Timer? _timer;
  int? _highlightedButton;
  bool _isShowingSequence = false;

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startGame() async {
    final gameProvider = context.read<GameProvider>();
    await gameProvider.startLevel(widget.levelNumber);

    // Show sequence
    _phase = GamePhase.memorize;
    _isShowingSequence = true;
    await _showSequence();
  }

  Future<void> _showSequence() async {
    final gameProvider = context.read<GameProvider>();
    final sequence = gameProvider.currentSequence;
    if (sequence == null) return;

    for (int i = 0; i < sequence.length; i++) {
      setState(() {
        _sequenceIndex = i;
        _highlightedButton = sequence[i];
      });

      // Play sound
      context.read<AudioService>().playButtonSound(sequence[i]);

      await Future.delayed(const Duration(milliseconds: 600));

      setState(() {
        _highlightedButton = null;
      });

      await Future.delayed(const Duration(milliseconds: 200));
    }

    // Start execution phase
    setState(() {
      _isShowingSequence = false;
      _phase = GamePhase.execute;
      _remainingTime = gameProvider.currentLevel?.timeLimit ?? 15.0;
    });

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _remainingTime -= 0.1;
        if (_remainingTime <= 0) {
          _timer?.cancel();
          _handleFailure();
        }
      });
    });
  }

  void _handleButtonPress(int colorIndex) {
    if (_phase != GamePhase.execute) return;

    final gameProvider = context.read<GameProvider>();
    final audioService = context.read<AudioService>();

    // Check if correct
    final currentIndex = gameProvider.currentSequence!.length -
        (gameProvider.currentSequence!.length -
            (gameProvider.currentSequence!.length -
                gameProvider.currentSequence!.indexOf(
                  gameProvider.currentSequence![0],
                )));

    final userInput = List<int>.from([]);
    gameProvider.addInput(colorIndex);

    // Play sound
    audioService.playButtonSound(colorIndex);

    // Check if sequence is complete
    if (gameProvider.isSequenceComplete()) {
      if (gameProvider.isSequenceCorrect()) {
        _handleSuccess();
      } else {
        _handleFailure();
      }
    }
  }

  void _handleSuccess() async {
    _timer?.cancel();
    setState(() {
      _phase = GamePhase.complete;
    });

    final gameProvider = context.read<GameProvider>();
    final audioService = context.read<AudioService>();

    audioService.playSfx('level_complete');
    final score = await gameProvider.completeLevel(_remainingTime);

    if (!mounted) return;

    // Show success dialog
    await _showResultDialog(
      title: 'Level Complete!',
      message: 'Score: $score\nTime Remaining: ${_remainingTime.toStringAsFixed(1)}s',
      isSuccess: true,
    );
  }

  void _handleFailure() async {
    _timer?.cancel();
    setState(() {
      _phase = GamePhase.failed;
    });

    final gameProvider = context.read<GameProvider>();
    final audioService = context.read<AudioService>();

    audioService.playSfx('error');
    await gameProvider.failLevel();

    if (!mounted) return;

    // Show failure dialog
    await _showResultDialog(
      title: 'Level Failed',
      message: 'Lives remaining: ${gameProvider.lives}',
      isSuccess: false,
    );
  }

  Future<void> _showResultDialog({
    required String title,
    required String message,
    required bool isSuccess,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<GameProvider>(
          builder: (context, gameProvider, _) {
            final level = gameProvider.currentLevel;
            if (level == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final colors = AppColors.getButtonColors(level.colorCount);

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Level ${level.number}',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      Text(
                        _phase == GamePhase.execute
                            ? '${_remainingTime.toStringAsFixed(1)}s'
                            : _phase == GamePhase.memorize
                                ? 'Watch!'
                                : '',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      Text(
                        '♥' * gameProvider.lives,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Game info
                  if (_isShowingSequence)
                    Text(
                      'Memorize the sequence...',
                      style: Theme.of(context).textTheme.bodyLarge,
                    )
                  else if (_phase == GamePhase.execute)
                    Text(
                      'Tap the sequence!',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),

                  const Spacer(),

                  // Color buttons grid
                  _buildButtonGrid(colors),

                  const Spacer(),

                  // Instructions
                  if (_phase == GamePhase.execute)
                    Text(
                      'Sequence length: ${level.sequenceLength}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildButtonGrid(List<Color> colors) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: colors.length,
      itemBuilder: (context, index) {
        return ColorButton(
          color: colors[index],
          onPressed: () => _handleButtonPress(index),
          isHighlighted: _highlightedButton == index,
          size: 120,
        );
      },
    );
  }
}
