import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../../config/colors.dart';
import '../../config/constants.dart';

/// A colored button component in the game grid
/// Handles rendering, animations, and tap detection
class ColorButtonComponent extends PositionComponent with TapCallbacks {
  final int colorIndex;
  final Color color;
  final Function(int colorIndex) onTap;

  // Animation states
  bool _isHighlighted = false;
  bool _isPressed = false;
  double _scale = 1.0;
  double _targetScale = 1.0;
  double _highlightIntensity = 0.0;
  Color? _flashColor;
  double _flashOpacity = 0.0;

  ColorButtonComponent({
    required this.colorIndex,
    required this.color,
    required this.onTap,
    required Vector2 position,
    required Vector2 size,
  }) : super(
          position: position,
          size: size,
          anchor: Anchor.center,
        );

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Calculate current size with scale
    final scaledSize = size * _scale;
    final rect = Rect.fromCenter(
      center: Offset.zero,
      width: scaledSize.x,
      height: scaledSize.y,
    );

    // Create rounded rectangle path
    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(GameConstants.buttonBorderRadius),
    );

    // Draw shadow (only when not pressed)
    if (!_isPressed) {
      final shadowPaint = Paint()
        ..color = Colors.black.withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawRRect(
        rrect.shift(const Offset(0, 2)),
        shadowPaint,
      );
    }

    // Draw button background
    final buttonPaint = Paint()
      ..color = _isHighlighted
          ? _blendColors(color, Colors.white, _highlightIntensity)
          : color
      ..style = PaintingStyle.fill;

    canvas.drawRRect(rrect, buttonPaint);

    // Draw flash overlay (for correct/wrong feedback)
    if (_flashOpacity > 0 && _flashColor != null) {
      final flashPaint = Paint()
        ..color = _flashColor!.withOpacity(_flashOpacity)
        ..style = PaintingStyle.fill;
      canvas.drawRRect(rrect, flashPaint);
    }

    // Draw subtle border
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(rrect, borderPaint);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Smooth scale animation
    if (_scale != _targetScale) {
      _scale += (_targetScale - _scale) * 10 * dt;
      if ((_targetScale - _scale).abs() < 0.01) {
        _scale = _targetScale;
      }
    }

    // Fade out highlight
    if (_highlightIntensity > 0) {
      _highlightIntensity -= dt * 2.5;
      if (_highlightIntensity < 0) _highlightIntensity = 0;
    }

    // Fade out flash
    if (_flashOpacity > 0) {
      _flashOpacity -= dt * 4;
      if (_flashOpacity < 0) {
        _flashOpacity = 0;
        _flashColor = null;
      }
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    _isPressed = true;
    _targetScale = 0.9;
  }

  @override
  void onTapUp(TapUpEvent event) {
    _isPressed = false;
    _targetScale = 1.0;
    onTap(colorIndex);
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    _isPressed = false;
    _targetScale = 1.0;
  }

  /// Highlight this button (during sequence playback)
  void highlight({bool instant = false}) {
    _isHighlighted = true;
    _highlightIntensity = 1.0;
    _targetScale = 1.1;
  }

  /// Remove highlight
  void unhighlight({bool instant = false}) {
    _isHighlighted = false;
    _targetScale = 1.0;
    if (instant) {
      _highlightIntensity = 0;
    }
  }

  /// Flash the button with color feedback (correct = green, wrong = red)
  void flash(bool isCorrect) {
    _flashColor = isCorrect ? AppColors.success : AppColors.error;
    _flashOpacity = 0.7;

    // Quick scale pulse
    _targetScale = 1.15;
    Future.delayed(const Duration(milliseconds: 100), () {
      _targetScale = 1.0;
    });
  }

  /// Blend two colors
  Color _blendColors(Color color1, Color color2, double amount) {
    final r = ui.lerpDouble(color1.red, color2.red, amount)!.toInt();
    final g = ui.lerpDouble(color1.green, color2.green, amount)!.toInt();
    final b = ui.lerpDouble(color1.blue, color2.blue, amount)!.toInt();
    final a = ui.lerpDouble(color1.alpha, color2.alpha, amount)!.toInt();
    return Color.fromARGB(a, r, g, b);
  }
}
