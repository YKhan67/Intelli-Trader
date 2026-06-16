import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/providers.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';

class CircuitBreakerPanel extends ConsumerWidget {
  const CircuitBreakerPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breakers = ref.watch(circuitBreakerProvider);
    final anyActive = ref.watch(anyHaltActiveProvider);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        children: [
          if (anyActive)
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: const BoxDecoration(
                color: AppColors.criticalRed,
                borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusMedium)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning, size: 16, color: Colors.white),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "TRADING LIMITS REACHED: Risk protection active. Check details below.",
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.sm,
              children: breakers.entries.map((e) => _BreakerStatus(label: e.key, active: e.value)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _BreakerStatus extends StatelessWidget {
  final String label;
  final bool active;

  const _BreakerStatus({required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          active ? Icons.error : Icons.verified_user,
          size: 14,
          color: active ? AppColors.sellRed : AppColors.buyGreen,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: active ? AppColors.sellRed : AppColors.textSecondary,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
