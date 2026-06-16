import 'package:flutter/material.dart';
import 'colors.dart';

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusCard = 16.0;

  static final cardDecoration = BoxDecoration(
    color: AppColors.backgroundCard,
    borderRadius: BorderRadius.circular(radiusCard),
    border: Border.all(color: AppColors.borderColor),
  );

  static final elevatedCardDecoration = BoxDecoration(
    color: AppColors.backgroundElevated,
    borderRadius: BorderRadius.circular(radiusCard),
    border: Border.all(color: AppColors.borderColor),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 8,
        offset: const Offset(0, 4),
      ),
    ],
  );
}
