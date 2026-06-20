import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:candlesticks/candlesticks.dart';
import '../../../models/models.dart';
import '../../../state/providers.dart';
import '../../../theme/colors.dart';
import '../../../theme/spacing.dart';

class ChartTab extends ConsumerStatefulWidget {
  final CurrencyPair pair;
  const ChartTab({super.key, required this.pair});

  @override
  ConsumerState<ChartTab> createState() => _ChartTabState();
}

class _ChartTabState extends ConsumerState<ChartTab> {
  Timeframe _selectedTf = Timeframe.h1;

  @override
  Widget build(BuildContext context) {
    final ohlcvAsync = ref.watch(ohlcvProvider(widget.pair, tf: _selectedTf));
    final signalsAsync = ref.watch(allSignalsProvider);
    final smcAsync = ref.watch(smcZonesProvider(widget.pair, tf: _selectedTf));
    
    return Column(
      children: [
        _buildTimeframeSelector(),
        Expanded(
          child: ohlcvAsync.when(
            data: (bars) {
              if (bars.length < 5) {
                return const Center(child: Text("Insufficient historical data for chart."));
              }
              
              try {
                final candles = bars
                    .where((b) => b.timestamp != null)
                    .map((b) => Candle(
                      date: b.timestamp!,
                      high: b.high,
                      low: b.low,
                      open: b.open,
                      close: b.close,
                      volume: b.volume,
                    )).toList();

                if (candles.isEmpty) return const Center(child: Text("Data rendering error."));

                final signal = signalsAsync.value?[widget.pair];
                final List<SMCZone> zones = smcAsync.value ?? [];
                
                return Stack(
                  children: [
                    Candlesticks(
                      candles: candles,
                    ),
                    _buildOverlayDetails(signal, zones),
                  ],
                );
              } catch (e) {
                return Center(child: Text("Chart Initialization Error: $e"));
              }
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text("Data Load Error: $e")),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeframeSelector() {
    final tfs = [Timeframe.m5, Timeframe.m15, Timeframe.m30, Timeframe.h1, Timeframe.h4];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: tfs.map((tf) {
          final isSelected = _selectedTf == tf;
          return ChoiceChip(
            label: Text(tf.name.toUpperCase()),
            selected: isSelected,
            onSelected: (val) {
              if (val) setState(() => _selectedTf = tf);
            },
            selectedColor: AppColors.accentBlue.withOpacity(0.2),
            labelStyle: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AppColors.accentBlue : AppColors.textMuted,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOverlayDetails(BackendSignal? signal, List<SMCZone> zones) {
    return Positioned(
      top: 10,
      left: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (signal != null && signal.action != SignalAction.hold)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.white24),
              ),
              child: Text(
                "SIGNAL: ${signal.action.name.toUpperCase()} @ ${signal.entryPrice?.toStringAsFixed(5)}",
                style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          const SizedBox(height: 4),
          ...zones.take(3).map((z) => Container(
            margin: const EdgeInsets.only(bottom: 2),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: z.zoneType.contains("OB") ? Colors.purple.withOpacity(0.6) : Colors.amber.withOpacity(0.6),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(
              "${z.zoneType}: ${z.priceLow.toStringAsFixed(5)}",
              style: const TextStyle(fontSize: 8, color: Colors.white),
            ),
          )),
        ],
      ),
    );
  }
}
