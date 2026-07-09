import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../state/providers.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../models/models.dart';
import 'confidence_ring.dart';
import 'regime_badge.dart';
import 'pair_flag.dart';

class SignalsGrid extends ConsumerWidget {
  const SignalsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activePairs = ref.watch(activePairsStateProvider.select(
      (pairs) => pairs.where((p) => p != CurrencyPair.unknown).toList()
    ));
    final selectedTf = ref.watch(selectedTimeframeProvider);

    // LOGICAL CALCULATION: 4 Columns per row
    const int crossAxisCount = 4;

    return Column(
      children: [
        _buildTimeframeSelector(ref, selectedTf),
        const SizedBox(height: AppSpacing.sm),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            // LOGICAL RATIO 2.4: This forces the boxes to be significantly SHORTER
            // allowing 3-4 rows to fit on a 1080p screen without scrolling.
            childAspectRatio: 2.4, 
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: activePairs.length,
          itemBuilder: (context, index) {
            final pair = activePairs[index];
            return _SignalCard(pair: pair);
          },
        ),
      ],
    );
  }

  Widget _buildTimeframeSelector(WidgetRef ref, Timeframe current) {
    final tfs = [Timeframe.m15, Timeframe.m30, Timeframe.h1, Timeframe.h4];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: tfs.map((tf) {
          final isSelected = tf == current;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(tf.name.toUpperCase()),
              selected: isSelected,
              onSelected: (val) {
                if (val) ref.read(selectedTimeframeProvider.notifier).set(tf);
              },
              selectedColor: AppColors.accentBlue.withOpacity(0.2),
              labelStyle: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.accentBlue : AppColors.textMuted,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SignalCard extends ConsumerStatefulWidget {
  final CurrencyPair pair;
  const _SignalCard({required this.pair});

  @override
  ConsumerState<_SignalCard> createState() => _SignalCardState();
}

class _SignalCardState extends ConsumerState<_SignalCard> with SingleTickerProviderStateMixin {
  late AnimationController _flashController;
  late Animation<Color?> _flashAnimation;
  SignalAction? _lastAction;

  @override
  void initState() {
    super.initState();
    _flashController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _flashAnimation = ColorTween(begin: Colors.transparent, end: Colors.transparent).animate(_flashController);
  }

  @override
  void dispose() {
    _flashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signal = ref.watch(allSignalsProvider.select((map) => map.value?[widget.pair]));
    
    if (signal != null && signal.action != _lastAction) {
      final Color color = signal.action.color.withOpacity(0.3);
      _flashAnimation = ColorTween(begin: color, end: Colors.transparent).animate(_flashController);
      _flashController.forward(from: 0);
      _lastAction = signal.action;
    }

    return InkWell(
      onTap: () => context.push('/pair/${widget.pair.name}'),
      borderRadius: BorderRadius.circular(8),
      child: AnimatedBuilder(
        animation: _flashAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundCard,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: signal != null ? signal.action.color.withOpacity(0.5) : AppColors.borderColor,
                width: 1,
              ),
              boxShadow: [
                if (_flashAnimation.value != Colors.transparent && _flashAnimation.value != null)
                  BoxShadow(color: _flashAnimation.value!, blurRadius: 10, spreadRadius: 2),
              ],
            ),
            child: child,
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), // Compressed padding
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: SizedBox(
              // LOGICAL CANVAS: Wider than it is tall (200x80) to maximize density
              width: 200,
              height: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row 1: Pair and TF
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PairFlag(pair: widget.pair, currentAction: signal?.action, fontSize: 18),
                      if (signal != null)
                        _CompactBadge(label: signal.timeframe.displayName, color: AppColors.primaryBlue),
                    ],
                  ),
                  
                  // Row 2: Signal Action & Confidence (Compressed)
                  if (signal != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              signal.action.name.toUpperCase(),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: signal.action.color,
                                height: 1.0,
                              ),
                            ),
                            const SizedBox(height: 2),
                            RegimeBadge(regime: signal.regime),
                          ],
                        ),
                        const SizedBox(width: 20),
                        ConfidenceRing(confidence: _getSafeConfidence(signal), size: 44),
                      ],
                    ),
                    
                    // Row 3: Footer (Strategy + Time)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          signal.strategy.displayName.toUpperCase(), 
                          style: const TextStyle(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.w900)
                        ),
                        Text(
                          _formatTimeAgo(signal.generatedAt),
                          style: const TextStyle(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ] else ...[
                    const Expanded(
                      child: Center(
                        child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5)),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _getSafeConfidence(BackendSignal sig) {
    try {
      double val = sig.confidence;
      if (val > 1.0) val = val / 100.0;
      return val.clamp(0.0, 1.0);
    } catch (e) {
      return 0.0;
    }
  }

  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return "${diff.inSeconds} SEC";
    if (diff.inMinutes < 60) return "${diff.inMinutes} MIN";
    return "${diff.inHours} HR";
  }
}

class _CompactBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _CompactBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label.toUpperCase(), 
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.textPrimary, letterSpacing: 0.5)
      ),
    );
  }
}
