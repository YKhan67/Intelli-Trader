import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/models.dart';
import '../../../state/providers.dart';
import '../../../theme/colors.dart';
import '../../../theme/spacing.dart';

class AnalysisTab extends ConsumerWidget {
  final CurrencyPair pair;
  const AnalysisTab({super.key, required this.pair});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signalAsync = ref.watch(allSignalsProvider);
    final signal = signalAsync.value?[pair];
    final smcAsync = ref.watch(smcZonesProvider(pair));

    if (signal == null) {
      return const Center(child: Text("No analysis data available."));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRegimeSection(signal),
          const SizedBox(height: AppSpacing.lg),
          _buildStrategySection(signal),
          const SizedBox(height: AppSpacing.lg),
          _buildTimeframeScoreSection(signal),
          const SizedBox(height: AppSpacing.lg),
          _buildSMCSection(smcAsync),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildRegimeSection(BackendSignal signal) {
    final regime = signal.regime;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Market Regime", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(regime.displayName, style: TextStyle(color: regime.color, fontWeight: FontWeight.bold, fontSize: 18)),
                Text("${(signal.regimeConfidence * 100).toInt()}% Confidence"),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: signal.regimeConfidence,
              backgroundColor: AppColors.backgroundElevated,
              color: regime.color,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSimpleBadge("H1 Regime", regime.name.toUpperCase()),
                _buildSimpleBadge("Bars in Regime", signal.barsInRegime.toString()),
              ],
            ),
            if (signal.durationWarning)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text("⚠️ Persisting longer than average", style: TextStyle(color: AppColors.sellRed, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStrategySection(BackendSignal signal) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Strategy Selection", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.sm),
            Text(signal.strategy.displayName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.accentBlue)),
            const SizedBox(height: 8),
            Text(signal.reason, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeframeScoreSection(BackendSignal signal) {
    final scores = signal.timeframeScores;
    if (scores.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Timeframe Score Breakdown", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.sm),
            ...scores.entries.map((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(e.key.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      Text("${(e.value * 100).toInt()}%", style: const TextStyle(fontSize: 10)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: e.value,
                    backgroundColor: AppColors.backgroundElevated,
                    color: e.value > 0.7 ? AppColors.buyGreen : (e.value > 0.4 ? Colors.orange : Colors.grey),
                    minHeight: 6,
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSMCSection(AsyncValue<List<SMCZone>> smcAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Smart Money Concepts (SMC)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: AppSpacing.sm),
        smcAsync.when(
          data: (zones) {
            if (zones.isEmpty) return const Text("No active SMC zones detected.", style: TextStyle(fontSize: 12, color: AppColors.textMuted));
            return Column(
              children: zones.map((z) => _buildZoneTile(z)).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text("Error: $e"),
        ),
      ],
    );
  }

  Widget _buildZoneTile(SMCZone zone) {
    final isOB = zone.zoneType.contains("OB") || zone.zoneType.contains("Order");
    return ListTile(
      dense: true,
      leading: Icon(isOB ? Icons.layers : Icons.reorder, color: isOB ? Colors.purple : Colors.amber, size: 16),
      title: Text(zone.zoneType, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      subtitle: Text("${zone.priceLow.toStringAsFixed(5)} - ${zone.priceHigh.toStringAsFixed(5)}", style: const TextStyle(fontSize: 10)),
      trailing: Text("Str: ${(zone.strength * 100).toInt()}%", style: const TextStyle(fontSize: 10)),
    );
  }

  Widget _buildSimpleBadge(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
