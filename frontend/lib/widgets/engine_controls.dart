import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forex_ai_frontend/state/providers.dart';
import 'package:forex_ai_frontend/theme/colors.dart';
import 'package:forex_ai_frontend/theme/spacing.dart';
import 'package:forex_ai_frontend/models/models.dart';
import 'package:forex_ai_frontend/utils/logger.dart';

class EngineControlPanel extends ConsumerWidget {
  const EngineControlPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRunning = ref.watch(engineStateProvider);
    final mode = ref.watch(tradingModeStateProvider);
    final anyHalt = ref.watch(anyHaltActiveProvider);
    final openTrades = ref.watch(openTradesProvider).value ?? [];

    return Card(
      margin: const EdgeInsets.all(AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Engine Control", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: (isRunning || anyHalt) ? null : () => ref.read(engineStateProvider.notifier).toggle(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buyGreen,
                      disabledBackgroundColor: AppColors.backgroundElevated,
                    ),
                    child: const Text("START ENGINE"),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ElevatedButton(
                    onPressed: !isRunning ? null : () => ref.read(engineStateProvider.notifier).toggle(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.sellRed,
                      disabledBackgroundColor: AppColors.backgroundElevated,
                    ),
                    child: const Text("STOP ENGINE"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                _ActionButton(
                  label: "CLOSE ALL",
                  color: AppColors.closeOrange,
                  onPressed: openTrades.isEmpty ? null : () => _confirmClose(context, ref, "All", openTrades.length),
                ),
                const SizedBox(width: AppSpacing.sm),
                _ActionButton(
                  label: "PROFIT",
                  color: AppColors.profitGreen,
                  onPressed: () {
                    final count = openTrades.where((t) => t.currentPnl > 0).length;
                    if (count > 0) _confirmClose(context, ref, "Profitable", count);
                  },
                ),
                const SizedBox(width: AppSpacing.sm),
                _ActionButton(
                  label: "LOSING",
                  color: AppColors.holdGrey,
                  onPressed: () {
                    final count = openTrades.where((t) => t.currentPnl < 0).length;
                    if (count > 0) _confirmClose(context, ref, "Losing", count);
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text("Trading Mode", style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
            const SizedBox(height: AppSpacing.xs),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.backgroundElevated,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              ),
              child: SegmentedButton<TradingMode>(
                segments: const [
                  ButtonSegment(value: TradingMode.conservative, label: Text("Cons", style: TextStyle(fontSize: 12))),
                  ButtonSegment(value: TradingMode.normal, label: Text("Norm", style: TextStyle(fontSize: 12))),
                  ButtonSegment(value: TradingMode.aggressive, label: Text("Aggr", style: TextStyle(fontSize: 12))),
                ],
                selected: {mode},
                onSelectionChanged: (val) async {
                  final newMode = val.first;
                  await ref.read(tradingModeStateProvider.notifier).setMode(newMode);
                  
                  // Sync to backend
                  try {
                    final pairs = ref.read(activePairsStateProvider);
                    final risk = ref.read(riskSettingsStateProvider);
                    await ref.read(backendServiceProvider).postSettings(newMode, pairs, risk);
                  } catch (e) {
                    logger.e("Failed to sync mode to backend: $e");
                  }
                },
                showSelectedIcon: false,
                style: SegmentedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  selectedBackgroundColor: AppColors.primaryBlue,
                  selectedForegroundColor: Colors.white,
                  side: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmClose(BuildContext context, WidgetRef ref, String type, int count) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Close $type Trades?"),
        content: Text("Are you sure you want to close $count $type trades immediately?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          TextButton(
            onPressed: () {
              // Implementation would call broker service
              Navigator.pop(context);
            },
            child: const Text("CONFIRM CLOSE", style: TextStyle(color: AppColors.sellRed)),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback? onPressed;

  const _ActionButton({required this.label, required this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 36,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: color,
            side: BorderSide(color: color.withOpacity(0.5)),
            padding: EdgeInsets.zero,
            textStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
          child: Text(label),
        ),
      ),
    );
  }
}
