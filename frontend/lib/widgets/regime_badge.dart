import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/colors.dart';

class RegimeBadge extends StatelessWidget {
  final Regime regime;
  final double? confidence;

  const RegimeBadge({
    super.key,
    required this.regime,
    this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData? icon;

    switch (regime) {
      case Regime.trendingUp:
        color = AppColors.buyGreen;
        icon = Icons.trending_up;
        break;
      case Regime.trendingDown:
        color = AppColors.sellRed;
        icon = Icons.trending_down;
        break;
      case Regime.ranging:
        color = Colors.blue;
        icon = Icons.trending_flat;
        break;
      case Regime.breakout:
        color = Colors.orange;
        icon = Icons.bolt;
        break;
      case Regime.reversal:
        color = Colors.purple;
        icon = Icons.cached;
        break;
      case Regime.volatile:
        color = Colors.yellow;
        icon = Icons.warning;
        break;
      case Regime.unknown:
      default:
        color = Colors.grey;
        icon = Icons.help_outline;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            regime.displayName.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          if (confidence != null) ...[
            const SizedBox(width: 4),
            Text(
              '${(confidence! * 100).toInt()}%',
              style: TextStyle(
                fontSize: 9,
                color: color.withOpacity(0.8),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
