import 'package:flutter/material.dart';
import '../config/colors.dart';

class CurrencyDisplay extends StatelessWidget {
  final int amount;
  final CurrencyType type;
  final bool showLabel;

  const CurrencyDisplay({
    super.key,
    required this.amount,
    required this.type,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: type == CurrencyType.coins
            ? AppColors.coin.withOpacity(0.2)
            : AppColors.gem.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: type == CurrencyType.coins ? AppColors.coin : AppColors.gem,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            type == CurrencyType.coins ? Icons.monetization_on : Icons.diamond,
            color: type == CurrencyType.coins ? AppColors.coin : AppColors.gem,
            size: 20,
          ),
          const SizedBox(width: 4),
          Text(
            amount.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color:
                  type == CurrencyType.coins ? AppColors.coin : AppColors.gem,
            ),
          ),
        ],
      ),
    );
  }
}

enum CurrencyType { coins, gems }
