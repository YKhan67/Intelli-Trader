import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/colors.dart';

class PairFlag extends StatelessWidget {
  final CurrencyPair pair;
  final SignalAction? currentAction;
  final double fontSize;

  const PairFlag({
    super.key,
    required this.pair,
    this.currentAction,
    this.fontSize = 14.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (currentAction != null) ...[
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentAction!.color,
              boxShadow: [
                BoxShadow(
                  color: currentAction!.color.withOpacity(0.5),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
        Text(
          pair.displayName,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
