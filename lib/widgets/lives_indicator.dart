import 'package:flutter/material.dart';
import '../config/colors.dart';

class LivesIndicator extends StatelessWidget {
  final int lives;
  final int maxLives;

  const LivesIndicator({
    super.key,
    required this.lives,
    this.maxLives = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        maxLives,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Icon(
            index < lives ? Icons.favorite : Icons.favorite_border,
            color: index < lives ? AppColors.error : Colors.grey,
            size: 24,
          ),
        ),
      ),
    );
  }
}
