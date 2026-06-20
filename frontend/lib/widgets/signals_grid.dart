import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../state/providers.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../models/models.dart';

class SignalsGrid extends ConsumerWidget {
  const SignalsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rawPairs = ref.watch(activePairsStateProvider);
    final activePairs = rawPairs.where((p) => p != CurrencyPair.unknown).toList();
    final signalsAsync = ref.watch(allSignalsProvider);
    final selectedTf = ref.watch(selectedTimeframeProvider);

    return Column(
      children: [
        _buildTimeframeSelector(ref, selectedTf),
        const SizedBox(height: AppSpacing.md),
        signalsAsync.when(
          data: (signalsMap) => GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 300,
              childAspectRatio: 1.4,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
            ),
            itemCount: activePairs.length,
            itemBuilder: (context, index) {
              final pair = activePairs[index];
              final signal = signalsMap[pair];
              return _SignalCard(pair: pair, signal: signal);
            },
          ),
          loading: () => _buildShimmer(activePairs.length),
          error: (e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text("Signals Load Error: $e", textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ),
          ),
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

  Widget _buildShimmer(int count) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        childAspectRatio: 1.4,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemCount: count > 0 ? count : 4,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: AppColors.backgroundElevated,
        highlightColor: AppColors.borderColor,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
        ),
      ),
    );
  }
}

class _SignalCard extends StatefulWidget {
  final CurrencyPair pair;
  final BackendSignal? signal;

  const _SignalCard({required this.pair, this.signal});

  @override
  State<_SignalCard> createState() => _SignalCardState();
}

class _SignalCardState extends State<_SignalCard> with SingleTickerProviderStateMixin {
  late AnimationController _flashController;
  late Animation<Color?> _flashAnimation;
  SignalAction? _lastAction;

  @override
  void initState() {
    super.initState();
    _flashController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _flashAnimation = ColorTween(begin: Colors.transparent, end: Colors.transparent).animate(_flashController);
    _lastAction = widget.signal?.action;
  }

  @override
  void didUpdateWidget(_SignalCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.signal?.action != _lastAction && widget.signal != null) {
      final Color color = (widget.signal?.action ?? SignalAction.hold).color.withOpacity(0.3);
      _flashAnimation = ColorTween(begin: color, end: Colors.transparent).animate(_flashController);
      _flashController.forward(from: 0);
      _lastAction = widget.signal!.action;
    }
  }

  @override
  void dispose() {
    _flashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signal = widget.signal;
    
    return InkWell(
      onTap: () => context.push('/pair/${widget.pair.name}'),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      child: AnimatedBuilder(
        animation: _flashAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundCard,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              border: Border.all(
                color: signal != null ? signal.action.color.withOpacity(0.5) : AppColors.borderColor,
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
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.pair.displayName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  if (signal != null)
                    _CompactBadge(label: signal.timeframe.displayName, color: AppColors.primaryBlue),
                ],
              ),
              const Spacer(),
              if (signal != null) ...[
                Text(
                  signal.action.name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: signal.action.color,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        value: _getSafeConfidence(signal),
                        strokeWidth: 2,
                        backgroundColor: AppColors.backgroundElevated,
                        color: signal.action.color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${_getDisplayConfidence(signal)}% Confidence",
                      style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(signal.strategy.displayName, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                    Text(
                      _formatTimeAgo(signal.generatedAt),
                      style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ] else ...[
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text("WAITING", style: TextStyle(color: AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ],
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

  int _getDisplayConfidence(BackendSignal sig) {
    try {
      double val = sig.confidence;
      if (val <= 1.0) return (val * 100).toInt();
      return val.toInt();
    } catch (e) {
      return 0;
    }
  }

  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return "${diff.inSeconds}s";
    if (diff.inMinutes < 60) return "${diff.inMinutes}m";
    return "${diff.inHours}h";
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
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(label, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: color)),
    );
  }
}
