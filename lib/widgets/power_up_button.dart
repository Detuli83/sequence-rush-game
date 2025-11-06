import 'package:flutter/material.dart';
import '../models/power_up.dart';
import '../config/colors.dart';
import 'currency_display.dart';

class PowerUpButton extends StatelessWidget {
  final PowerUp powerUp;
  final bool canAfford;
  final VoidCallback onPressed;
  final VoidCallback? onWatchAd;

  const PowerUpButton({
    super.key,
    required this.powerUp,
    required this.canAfford,
    required this.onPressed,
    this.onWatchAd,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: canAfford ? onPressed : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    _getIconForPowerUp(powerUp.type),
                    color: canAfford ? AppColors.accent : Colors.grey,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      powerUp.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: canAfford ? null : Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                powerUp.description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: canAfford ? onPressed : null,
                    icon: const Icon(Icons.monetization_on, size: 16),
                    label: Text('${powerUp.coinCost}'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                  if (powerUp.canUseAd && onWatchAd != null) ...[
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: onWatchAd,
                      icon: const Icon(Icons.play_circle_outline, size: 16),
                      label: const Text('Watch Ad'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForPowerUp(PowerUpType type) {
    switch (type) {
      case PowerUpType.hint:
        return Icons.lightbulb_outline;
      case PowerUpType.extraTime:
        return Icons.access_time;
      case PowerUpType.slowMotion:
        return Icons.slow_motion_video;
      case PowerUpType.skipLevel:
        return Icons.skip_next;
    }
  }
}
