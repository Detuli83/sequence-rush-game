import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math';

/// Glow effect component for button highlights
class GlowEffect extends PositionComponent {
  final Color color;
  final double maxRadius;
  final double duration;

  double _elapsed = 0;
  bool _isActive = false;

  GlowEffect({
    required this.color,
    this.maxRadius = 40.0,
    this.duration = 0.5,
    Vector2? position,
    Vector2? size,
  }) : super(position: position, size: size);

  @override
  void update(double dt) {
    super.update(dt);

    if (!_isActive) return;

    _elapsed += dt;
    if (_elapsed >= duration) {
      _elapsed = 0;
      _isActive = false;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (!_isActive) return;

    final progress = _elapsed / duration;
    final radius = maxRadius * (1 - progress);
    final opacity = (1 - progress) * 0.5;

    final center = size / 2;

    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawCircle(
      Offset(center.x, center.y),
      radius,
      paint,
    );
  }

  /// Trigger the glow effect
  void trigger() {
    _isActive = true;
    _elapsed = 0;
  }
}

/// Pulsing glow effect for continuous highlighting
class PulsingGlowEffect extends PositionComponent {
  final Color color;
  final double minRadius;
  final double maxRadius;
  final double pulseDuration;

  double _elapsed = 0;

  PulsingGlowEffect({
    required this.color,
    this.minRadius = 20.0,
    this.maxRadius = 35.0,
    this.pulseDuration = 1.0,
    Vector2? position,
    Vector2? size,
  }) : super(position: position, size: size);

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;

    // Loop the pulse
    if (_elapsed >= pulseDuration) {
      _elapsed -= pulseDuration;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final progress = (_elapsed / pulseDuration);
    // Use sine wave for smooth pulsing
    final pulseValue = (sin(progress * 2 * pi) + 1) / 2; // 0 to 1

    final radius = minRadius + (maxRadius - minRadius) * pulseValue;
    final opacity = 0.2 + 0.3 * pulseValue; // 0.2 to 0.5

    final center = size / 2;

    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    canvas.drawCircle(
      Offset(center.x, center.y),
      radius,
      paint,
    );
  }
}
