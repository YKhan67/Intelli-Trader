import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../models/models.dart';
import '../../../state/providers.dart';
import '../../../theme/colors.dart';
import '../../../theme/spacing.dart';
import '../widgets/calendar_section.dart';
import '../../../widgets/sentiment_bar.dart';

class SentimentTab extends ConsumerStatefulWidget {
  const SentimentTab({super.key});

  @override
  ConsumerState<SentimentTab> createState() => _SentimentTabState();
}

class _SentimentTabState extends ConsumerState<SentimentTab> {
  String _selectedHistoryCurrency = 'USD';

  @override
  Widget build(BuildContext context) {
    final overviewAsync = ref.watch(sentimentOverviewProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("CURRENCY SENTIMENT GAUGES"),
          overviewAsync.when(
            data: (ov) => _buildCurrencyGauges(ov.currencies),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text("Sentiment Load Error: $e", style: const TextStyle(fontSize: 10)),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildSectionHeader("PAIR SENTIMENT RANKING"),
          overviewAsync.when(
            data: (ov) => _buildPairRanking(ov.pairSentiment),
            loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
            error: (e, _) => const SizedBox.shrink(),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildSectionHeader("COT POSITIONING (NET)"),
          _buildCOTSection(),
          const SizedBox(height: AppSpacing.lg),
          _buildSectionHeader("SENTIMENT HISTORY (7D)"),
          _buildHistorySection(),
          const SizedBox(height: AppSpacing.lg),
          const CalendarSection(),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        title,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: AppColors.textMuted),
      ),
    );
  }

  Widget _buildCurrencyGauges(Map<String, CurrencySentiment> currencies) {
    if (currencies.isEmpty) return const Card(child: Padding(padding: EdgeInsets.all(16), child: Center(child: Text("No currency sentiment data"))));

    final sortedCurrencies = currencies.values.toList()
      ..sort((a, b) => b.score4h.abs().compareTo(a.score4h.abs()));
      
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: sortedCurrencies.map((c) => _buildCurrencyRow(c)).toList(),
        ),
      ),
    );
  }

  Widget _buildCurrencyRow(CurrencySentiment c) {
    final trendIcon = c.trend == 'improving' ? Icons.trending_up : (c.trend == 'deteriorating' ? Icons.trending_down : Icons.trending_flat);
    final trendColor = c.trend == 'improving' ? AppColors.buyGreen : (c.trend == 'deteriorating' ? AppColors.sellRed : Colors.grey);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(width: 40, child: Text(c.currency, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
          Icon(trendIcon, size: 14, color: trendColor),
          const SizedBox(width: 12),
          Expanded(
            child: SentimentBar(score: c.score4h),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("24H: ${c.score24h.toStringAsFixed(2)}", style: const TextStyle(fontSize: 8, color: AppColors.textMuted)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPairRanking(List<PairSentimentScore> pairs) {
    if (pairs.isEmpty) return const Center(child: Text("No pair ranking available", style: TextStyle(fontSize: 10)));
    
    final sorted = List<PairSentimentScore>.from(pairs)..sort((a, b) => b.score.compareTo(a.score));

    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sorted.length,
        itemBuilder: (context, index) {
          final p = sorted[index];
          final color = p.score > 0.1 ? AppColors.buyGreen : (p.score < -0.1 ? AppColors.sellRed : Colors.grey);
          return ListTile(
            dense: true,
            visualDensity: VisualDensity.compact,
            title: Text(p.pair, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            trailing: Text(
              p.score.toStringAsFixed(2),
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCOTSection() {
    final cotAsync = ref.watch(cotPositionsProvider);

    return cotAsync.when(
      data: (cotMap) {
        if (cotMap.isEmpty) return const Card(child: Padding(padding: EdgeInsets.all(16), child: Center(child: Text("No COT positioning data available"))));
        
        final currencies = cotMap.keys.toList();

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barGroups: currencies.asMap().entries.map((e) {
                    final data = cotMap[e.value]!;
                    return BarChartGroupData(
                      x: e.key,
                      barRods: [
                        BarChartRodData(
                          toY: data.net.toDouble(),
                          color: data.bias == Direction.long ? AppColors.buyGreen : AppColors.sellRed,
                          width: 12,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (val, _) {
                          if (val.toInt() < 0 || val.toInt() >= currencies.length) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(currencies[val.toInt()], style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                          );
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ),
        );
      },
      loading: () => const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
      error: (e, _) => Center(child: Text("COT Error: $e", style: const TextStyle(fontSize: 10))),
    );
  }

  Widget _buildHistorySection() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: ref.read(backendServiceProvider).getSentimentHistory(_selectedHistoryCurrency),
      builder: (context, snapshot) {
        final data = snapshot.data ?? [];
        final spots = data.asMap().entries.map((e) => FlSpot(e.key.toDouble(), (e.value['score'] as num).toDouble())).toList();
        
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                DropdownButton<String>(
                  value: _selectedHistoryCurrency,
                  isDense: true,
                  underline: const SizedBox(),
                  items: ['USD', 'EUR', 'GBP', 'JPY', 'AUD', 'NZD', 'CAD', 'CHF', 'XAU', 'BTC']
                      .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 12)))).toList(),
                  onChanged: (val) => setState(() => _selectedHistoryCurrency = val!),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 150,
                  child: spots.isEmpty 
                    ? const Center(child: Text("No historical data for this currency", style: TextStyle(fontSize: 10)))
                    : LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: false),
                          titlesData: const FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: spots,
                              isCurved: true,
                              color: AppColors.accentBlue,
                              barWidth: 2,
                              dotData: const FlDotData(show: false),
                              belowBarData: BarAreaData(show: true, color: AppColors.accentBlue.withOpacity(0.1)),
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
    );
  }
}
