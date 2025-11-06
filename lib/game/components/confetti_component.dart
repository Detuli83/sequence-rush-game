import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

/// Confetti particle effect for level completion
class ConfettiComponent extends Component {
  final Random _random = Random();

  /// Create a burst of confetti particles
  Future<void> burst(Vector2 position, Vector2 gameSize) async {
    final particleCount = 50;
    final particles = List.generate(particleCount, (i) {
      return _createConfettiParticle(position, gameSize);
    });

    final particleComponent = ParticleSystemComponent(
      particle: Particle.generate(
        count: particleCount,
        lifespan: 2.0,
        generator: (i) => particles[i],
      ),
    );

    parent?.add(particleComponent);
  }

  Particle _createConfettiParticle(Vector2 position, Vector2 gameSize) {
    // Random colors for confetti
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.cyan,
    ];

    final color = colors[_random.nextInt(colors.length)];
    final size = 4.0 + _random.nextDouble() * 6.0; // 4-10 pixels

    // Random velocity (spread in all directions, slight upward bias)
    final angle = _random.nextDouble() * 2 * pi;
    final speed = 50.0 + _random.nextDouble() * 150.0; // 50-200 pixels/sec
    final velocity = Vector2(
      cos(angle) * speed,
      sin(angle) * speed - 50, // Upward bias
    );

    return AcceleratedParticle(
      lifespan: 1.5 + _random.nextDouble(),
      acceleration: Vector2(0, 200), // Gravity
      position: position.clone(),
      speed: velocity,
      child: RotatingParticle(
        lifespan: 2.0,
        from: 0,
        to: 2 * pi,
        child: CircleParticle(
          radius: size / 2,
          paint: Paint()..color = color,
        ),
      ),
    );
  }

  /// Create celebration confetti across the screen
  Future<void> celebrate(Vector2 gameSize) async {
    // Multiple bursts from different positions
    final positions = [
      Vector2(gameSize.x * 0.25, gameSize.y * 0.5),
      Vector2(gameSize.x * 0.5, gameSize.y * 0.5),
      Vector2(gameSize.x * 0.75, gameSize.y * 0.5),
    ];

    for (var position in positions) {
      await burst(position, gameSize);
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }
}
