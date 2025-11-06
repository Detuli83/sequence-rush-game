import 'package:flame/components.dart';
import '../../config/colors.dart';
import '../../config/constants.dart';
import 'color_button_component.dart';
import '../sequence_rush_game.dart';

/// Manages the grid of color buttons
/// Handles layout, creation, and coordination of button components
class GridManager extends Component with HasGameRef<SequenceRushGame> {
  final int colorCount;
  final Function(int colorIndex) onButtonTapped;

  final List<ColorButtonComponent> _buttons = [];
  bool _isInitialized = false;

  GridManager({
    required this.colorCount,
    required this.onButtonTapped,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _createButtons();
    _isInitialized = true;
  }

  /// Create and layout the color buttons
  void _createButtons() {
    final gameSize = gameRef.size;
    final colors = AppColors.getButtonColors(colorCount);

    // Calculate grid layout based on color count
    final gridLayout = _getGridLayout(colorCount);
    final rows = gridLayout['rows']!;
    final cols = gridLayout['cols']!;

    // Calculate button size and spacing
    final availableWidth = gameSize.x - 48; // 24px padding on each side
    final availableHeight = gameSize.y * 0.6; // Use 60% of screen height

    final buttonWidth = (availableWidth - (cols - 1) * GameConstants.buttonSpacing) / cols;
    final buttonHeight = (availableHeight - (rows - 1) * GameConstants.buttonSpacing) / rows;
    final buttonSize = buttonWidth < buttonHeight ? buttonWidth : buttonHeight;

    // Calculate grid position (centered)
    final gridWidth = (buttonSize * cols) + (GameConstants.buttonSpacing * (cols - 1));
    final gridHeight = (buttonSize * rows) + (GameConstants.buttonSpacing * (rows - 1));
    final startX = (gameSize.x - gridWidth) / 2 + (buttonSize / 2);
    final startY = (gameSize.y - gridHeight) / 2 + (buttonSize / 2);

    // Create buttons
    for (int i = 0; i < colorCount; i++) {
      final row = i ~/ cols;
      final col = i % cols;

      final x = startX + (col * (buttonSize + GameConstants.buttonSpacing));
      final y = startY + (row * (buttonSize + GameConstants.buttonSpacing));

      final button = ColorButtonComponent(
        colorIndex: i,
        color: colors[i],
        onTap: onButtonTapped,
        position: Vector2(x, y),
        size: Vector2(buttonSize, buttonSize),
      );

      _buttons.add(button);
      add(button);
    }
  }

  /// Get grid layout (rows x cols) based on color count
  Map<String, int> _getGridLayout(int count) {
    switch (count) {
      case 4:
        return {'rows': 2, 'cols': 2}; // 2x2 grid
      case 6:
        return {'rows': 2, 'cols': 3}; // 2x3 grid
      case 8:
        return {'rows': 2, 'cols': 4}; // 2x4 grid
      default:
        return {'rows': 2, 'cols': 2};
    }
  }

  /// Highlight a specific button (used during sequence playback)
  void highlightButton(int colorIndex, bool highlight) {
    if (colorIndex >= 0 && colorIndex < _buttons.length) {
      if (highlight) {
        _buttons[colorIndex].highlight();
      } else {
        _buttons[colorIndex].unhighlight();
      }
    }
  }

  /// Flash a button with feedback (correct/wrong)
  void flashButton(int colorIndex, bool isCorrect) {
    if (colorIndex >= 0 && colorIndex < _buttons.length) {
      _buttons[colorIndex].flash(isCorrect);
    }
  }

  /// Disable all buttons (during memorize phase)
  void disableButtons() {
    for (final button in _buttons) {
      button.priority = -1; // Lower priority prevents tap detection
    }
  }

  /// Enable all buttons (during execute phase)
  void enableButtons() {
    for (final button in _buttons) {
      button.priority = 0;
    }
  }

  /// Reset all buttons to default state
  void resetButtons() {
    for (final button in _buttons) {
      button.unhighlight(instant: true);
    }
  }

  /// Get button at index
  ColorButtonComponent? getButton(int index) {
    if (index >= 0 && index < _buttons.length) {
      return _buttons[index];
    }
    return null;
  }

  /// Get all buttons
  List<ColorButtonComponent> get buttons => List.unmodifiable(_buttons);

  bool get isInitialized => _isInitialized;
}
