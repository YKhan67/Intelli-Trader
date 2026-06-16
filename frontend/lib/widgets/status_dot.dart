import 'package:flutter/material.dart';
import '../theme/colors.dart';

class StatusDot extends StatelessWidget {
  final bool connected;
  final String label;

  const StatusDot({super.key, required this.connected, required this.label});

  @override
  Widget build(BuildContext context) {
    final color = connected ? AppColors.buyGreen : AppColors.sellRed;
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              if (connected)
                BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }
}
