import 'package:flutter/material.dart';
import '../theme/colors.dart';

class SentimentBar extends StatelessWidget {
  final double score; // -1.0 to 1.0
  final double height;

  const SentimentBar({
    super.key,
    required this.score,
    this.height = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    // Normalize score from [-1, 1] to [0, 1] for positioning
    final double normalizedPosition = (score + 1) / 2;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("BEARISH", style: TextStyle(fontSize: 8, color: AppColors.sellRed, fontWeight: FontWeight.bold)),
            Text(
              score.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: score > 0 ? AppColors.buyGreen : (score < 0 ? AppColors.sellRed : Colors.grey),
              ),
            ),
            const Text("BULLISH", style: TextStyle(fontSize: 8, color: AppColors.buyGreen, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: height,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(height / 2),
                gradient: LinearGradient(
                  colors: [
                    AppColors.sellRed.withOpacity(0.8),
                    Colors.grey.shade800,
                    AppColors.buyGreen.withOpacity(0.8),
                  ],
                ),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return AnimatedAlign(
                  duration: const Duration(milliseconds: 500),
                  alignment: Alignment(score, 0),
                  child: Container(
                    width: 4,
                    height: height + 4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
