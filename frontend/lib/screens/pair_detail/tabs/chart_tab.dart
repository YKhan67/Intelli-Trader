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
    final indicatorAsync = ref.watch(indicatorsProvider(widget.pair, tf: _selectedTf));
    
    return Column(
      children: [
        _buildTimeframeSelector(),
        Expanded(
          child: ohlcvAsync.when(
            data: (bars) {
              if (bars.isEmpty) return const Center(child: Text("No data available"));
              
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

              // Get current signal for horizontal lines
              final signal = signalsAsync.asData?.value[widget.pair];
              
              return smcAsync.maybeWhen(
                data: (zones) => Stack(
                  children: [
                    Candlesticks(
                      candles: candles,
                    ),
                    _buildOverlayDetails(signal, zones),
                  ],
                ),
                orElse: () => Stack(
                  children: [
                    Candlesticks(
                      candles: candles,
                    ),
                    _buildOverlayDetails(signal, []),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text("Error: $e")),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeframeSelector() {
    final tfs = [
      Timeframe.m5,
      Timeframe.m15,
      Timeframe.m30,
      Timeframe.h1,
      Timeframe.h4
    ];
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
              padding: const EdgeInsets.all(4),
              color: Colors.black54,
              child: Text(
                "TP: ${signal.takeProfit.toStringAsFixed(5)} | SL: ${signal.stopLoss.toStringAsFixed(5)}",
                style: const TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),
          const SizedBox(height: 4),
          if (zones.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(4),
              color: Colors.black54,
              child: Text(
                "SMC: ${zones.length} Active Zones",
                style: const TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
