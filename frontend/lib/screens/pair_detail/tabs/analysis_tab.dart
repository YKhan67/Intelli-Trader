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
    final ohlcvAsync = ref.watch(ohlcvProvider(pair));

    if (signal == null) {
      return const Center(child: Text("No analysis data available."));
    }

    final currentPrice = ohlcvAsync.value?.isNotEmpty == true ? ohlcvAsync.value!.first.close : (signal.entryPrice ?? 0.0);

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
          _buildSMCSection(smcAsync, currentPrice),
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
                _buildSimpleBadge("H4 BIAS", signal.h4Bias.name.toUpperCase(), color: signal.h4Bias == Direction.long ? AppColors.buyGreen : (signal.h4Bias == Direction.short ? AppColors.sellRed : Colors.grey)),
                _buildSimpleBadge("H1 REGIME", signal.h1Regime.displayName.toUpperCase(), color: signal.h1Regime.color),
                _buildSimpleBadge("BARS IN REGIME", signal.barsInRegime.toString()),
              ],
            ),
            if (signal.durationWarning)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.sellRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.sellRed.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: AppColors.sellRed, size: 16),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          "DURATION WARNING: Regime persisting longer than average. Potential exhaustion.",
                          style: TextStyle(color: AppColors.sellRed, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Strategy Selection", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("${(signal.strategyConfidence * 100).toInt()}% Conf", style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
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
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    child: Text(e.key.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppColors.backgroundElevated,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: e.value.clamp(0.0, 1.0),
                          child: Container(
                            height: 12,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.accentBlue.withOpacity(0.5), AppColors.accentBlue],
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text("${(e.value * 100).toInt()}%", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSMCSection(AsyncValue<List<SMCZone>> smcAsync, double currentPrice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Smart Money Concepts (SMC)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: AppSpacing.sm),
        smcAsync.when(
          data: (zones) {
            if (zones.isEmpty) return const Text("No active SMC zones detected.", style: TextStyle(fontSize: 12, color: AppColors.textMuted));
            
            final activeOBs = zones.where((z) => z.zoneType.contains("OB") || z.zoneType.contains("Order")).toList();
            final activeFVGs = zones.where((z) => z.zoneType.contains("FVG")).toList();
            
            // Liquidity Levels logic
            final liquidity = zones.where((z) => z.zoneType.contains("LQ") || z.zoneType.contains("Liquidity")).toList();
            final nearestAbove = liquidity.where((z) => z.priceLow > currentPrice).toList()
              ..sort((a, b) => a.priceLow.compareTo(b.priceLow));
            final nearestBelow = liquidity.where((z) => z.priceHigh < currentPrice).toList()
              ..sort((a, b) => b.priceHigh.compareTo(a.priceHigh));

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (nearestAbove.isNotEmpty) _buildLiquidityRow("Nearest Liquidity Above", nearestAbove.first, isAbove: true),
                if (nearestBelow.isNotEmpty) _buildLiquidityRow("Nearest Liquidity Below", nearestBelow.first, isAbove: false),
                const SizedBox(height: 12),
                const Text("Active Zones", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
                ...activeOBs.take(3).map((z) => _buildZoneTile(z)),
                ...activeFVGs.take(3).map((z) => _buildZoneTile(z)),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text("Error: $e"),
        ),
      ],
    );
  }

  Widget _buildLiquidityRow(String title, SMCZone zone, {required bool isAbove}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: isAbove ? AppColors.sellRed.withOpacity(0.1) : AppColors.buyGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: isAbove ? AppColors.sellRed.withOpacity(0.5) : AppColors.buyGreen.withOpacity(0.5)),
            ),
            child: Text(
              zone.priceLow.toStringAsFixed(5),
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isAbove ? AppColors.sellRed : AppColors.buyGreen),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZoneTile(SMCZone zone) {
    final isOB = zone.zoneType.contains("OB") || zone.zoneType.contains("Order");
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Icon(isOB ? Icons.layers : Icons.reorder, color: isOB ? Colors.purple : Colors.amber, size: 16),
      title: Text(zone.zoneType, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      subtitle: Text("${zone.priceLow.toStringAsFixed(5)} - ${zone.priceHigh.toStringAsFixed(5)}", style: const TextStyle(fontSize: 10)),
      trailing: Text("Str: ${(zone.strength * 100).toInt()}%", style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
    );
  }

  Widget _buildSimpleBadge(String label, String value, {Color? color}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 8, color: AppColors.textMuted)),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: (color ?? Colors.grey).withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: (color ?? Colors.grey).withOpacity(0.3)),
          ),
          child: Text(
            value,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color ?? AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
