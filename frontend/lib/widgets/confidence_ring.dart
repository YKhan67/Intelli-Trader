import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../theme/colors.dart';

class ConfidenceRing extends StatelessWidget {
  final double confidence; // 0.0 to 1.0
  final double size;
  final double strokeWidth;

  const ConfidenceRing({
    super.key,
    required this.confidence,
    this.size = 40.0,
    this.strokeWidth = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    if (confidence >= 0.8) {
      color = AppColors.buyGreen;
    } else if (confidence >= 0.6) {
      color = Colors.yellow;
    } else {
      color = AppColors.sellRed;
    }

    return CircularPercentIndicator(
      radius: size / 2,
      lineWidth: strokeWidth,
      percent: confidence.clamp(0.0, 1.0),
      center: Text(
        "${(confidence * 100).toInt()}%",
        style: TextStyle(
          fontSize: size * 0.25,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
      progressColor: color,
      backgroundColor: AppColors.backgroundElevated,
      circularStrokeCap: CircularStrokeCap.round,
      animation: true,
      animateFromLastPercent: true,
    );
  }
}
