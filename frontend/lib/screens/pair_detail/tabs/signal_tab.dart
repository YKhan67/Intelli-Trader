import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../../models/models.dart';
import '../../../state/providers.dart';
import '../../../theme/colors.dart';
import '../../../theme/spacing.dart';

class SignalTab extends ConsumerStatefulWidget {
  final CurrencyPair pair;
  const SignalTab({super.key, required this.pair});

  @override
  ConsumerState<SignalTab> createState() => _SignalTabState();
}

class _SignalTabState extends ConsumerState<SignalTab> {
  Timer? _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signalAsync = ref.watch(allSignalsProvider);
    final signal = signalAsync.value?[widget.pair];

    if (signal == null) {
      return const Center(child: Text("No signal available for this pair."));
    }

    final bool isExpired = signal.expiresAt.isBefore(_now);
    final Duration remaining = signal.expiresAt.difference(_now);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isExpired)
            _buildExpiredBanner()
          else
            _buildValidityCountdown(remaining),
          
          const SizedBox(height: AppSpacing.md),
          _buildActionHeader(signal),
          
          const SizedBox(height: AppSpacing.lg),
          _buildRiskRewardVisualizer(signal),
          
          const SizedBox(height: AppSpacing.lg),
          _buildDetailsGrid(signal),
          
          const SizedBox(height: AppSpacing.lg),
          const Text("Reasoning", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.xs),
          Text(signal.reason, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildExpiredBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm),
      color: AppColors.sellRed.withOpacity(0.8),
      child: const Center(
        child: Text(
          "SIGNAL EXPIRED",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
      ),
    );
  }

  Widget _buildValidityCountdown(Duration remaining) {
    final minutes = remaining.inMinutes;
    final seconds = remaining.inSeconds % 60;
    return Text(
      "Expires in: ${minutes}m ${seconds}s",
      style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
    );
  }

  Widget _buildActionHeader(BackendSignal signal) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: signal.action.color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            border: Border.all(color: signal.action.color, width: 2),
          ),
          child: Text(
            signal.action.name.toUpperCase(),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: signal.action.color,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${(signal.confidence * 100).toInt()}% Confidence",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "Strategy: ${signal.strategy.displayName}",
              style: const TextStyle(color: AppColors.textMuted),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRiskRewardVisualizer(BackendSignal signal) {
    // Simplified R/R diagram
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            _buildPriceRow("TAKE PROFIT", signal.takeProfit ?? 0.0, AppColors.profitGreen),
            const SizedBox(height: 8),
            _buildPriceRow("ENTRY PRICE", signal.entryPrice ?? 0.0, AppColors.accentBlue),
            const SizedBox(height: 8),
            _buildPriceRow("STOP LOSS", signal.stopLoss ?? 0.0, AppColors.lossRed),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double price, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        Text(price.toStringAsFixed(5), style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildDetailsGrid(BackendSignal signal) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 3,
      children: [
        _buildDetailItem("LOT SIZE", signal.lotSize.toString()),
        _buildDetailItem("TIMEFRAME", signal.timeframe.name.toUpperCase()),
        _buildDetailItem("SESSION", signal.session.name.toUpperCase()),
        _buildDetailItem("RISK SCORE", signal.riskScore.toStringAsFixed(2)),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
