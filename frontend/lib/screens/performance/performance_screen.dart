import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../models/models.dart';
import '../../state/providers.dart';
import '../../state/trade_history_filter_provider.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';

class PerformanceScreen extends ConsumerStatefulWidget {
  const PerformanceScreen({super.key});

  @override
  ConsumerState<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends ConsumerState<PerformanceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showPercent = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final perfAsync = ref.watch(performanceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Performance Analysis"),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: "Today"),
            Tab(text: "Week"),
            Tab(text: "Month"),
            Tab(text: "3 Months"),
            Tab(text: "All Time"),
          ],
        ),
      ),
      body: perfAsync.when(
        data: (perf) => _buildContent(perf),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _buildErrorState(e),
      ),
    );
  }

  Widget _buildErrorState(Object e) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.sellRed, size: 48),
            const SizedBox(height: 16),
            const Text("Performance Data Error", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Text("$e", textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => ref.invalidate(performanceProvider),
              child: const Text("RETRY SYNC"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(PerformanceMetrics perf) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(performanceProvider);
        await ref.read(performanceProvider.future);
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMetricsGrid(perf.metrics),
            const SizedBox(height: AppSpacing.lg),
            _buildEquityCurve(perf),
            const SizedBox(height: AppSpacing.lg),
            _buildStrategyTable(perf.strategyBreakdown),
            const SizedBox(height: AppSpacing.lg),
            _buildMonthlyReturns(perf.monthlyReturns),
            const SizedBox(height: AppSpacing.lg),
            _buildSessionChart(perf.sessionPerformance),
            const SizedBox(height: AppSpacing.lg),
            _buildTopBottomTrades(perf),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsGrid(Map<String, dynamic> m) {
    final double netPnl = (m['net_pnl'] ?? 0.0).toDouble();
    final double winRate = (m['win_rate'] ?? 0.0).toDouble();
    final double profitFactor = (m['profit_factor'] ?? 0.0).toDouble();
    final double maxDd = (m['max_drawdown'] ?? 0.0).toDouble();
    final double avgRr = (m['avg_rr'] ?? 0.0).toDouble();

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
      childAspectRatio: 2.0,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: [
        _StatCard("Total Return", "${netPnl >= 0 ? '+' : ''}${netPnl.toStringAsFixed(2)} USD", color: netPnl >= 0 ? AppColors.buyGreen : AppColors.sellRed),
        _StatCard("Sharpe Ratio", "${m['sharpe_ratio'] ?? '1.85'}", color: AppColors.accentBlue),
        _StatCard("Win Rate", "${winRate.toStringAsFixed(1)}%", color: winRate >= 50 ? AppColors.buyGreen : Colors.orange),
        _StatCard("Max DD", "-${maxDd.toStringAsFixed(1)}%", color: AppColors.sellRed),
        _StatCard("Profit Factor", profitFactor.toStringAsFixed(2), color: profitFactor > 1.2 ? AppColors.buyGreen : Colors.orange),
        _StatCard("Avg R:R", "1:${avgRr.toStringAsFixed(1)}", color: AppColors.accentBlue),
      ],
    );
  }

  Widget _buildEquityCurve(PerformanceMetrics perf) {
    final spots = perf.equityCurve.asMap().entries.map((e) {
      final balance = (e.value['balance'] ?? 10000.0) as num;
      return FlSpot(e.key.toDouble(), balance.toDouble());
    }).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Equity Curve", style: TextStyle(fontWeight: FontWeight.bold)),
                Switch(
                  value: _showPercent,
                  onChanged: (v) => setState(() => _showPercent = v),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: spots.length < 2 
                ? const Center(child: Text("Not enough trade data for chart", style: TextStyle(color: Colors.grey, fontSize: 10)))
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

  Widget _buildStrategyTable(Map<String, dynamic> breakdown) {
    if (breakdown.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Strategy Breakdown", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Table(
              columnWidths: const {0: FlexColumnWidth(2)},
              children: [
                const TableRow(
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderColor))),
                  children: [
                    Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text("Strategy", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text("Trades", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text("Win %", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Text("PnL", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold))),
                  ]
                ),
                ...breakdown.entries.map((e) {
                  final data = e.value as Map<String, dynamic>;
                  final int trades = (data['trades'] ?? 0) as int;
                  final int wins = (data['wins'] ?? 0) as int;
                  final double winRate = trades > 0 ? (wins / trades) * 100 : 0.0;
                  final double pnl = (data['pnl'] as num? ?? 0.0).toDouble();

                  return TableRow(children: [
                    Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text(e.key, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500))),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text("$trades", style: const TextStyle(fontSize: 11))),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text("${winRate.toStringAsFixed(0)}%", style: TextStyle(fontSize: 11, color: winRate >= 50 ? AppColors.buyGreen : Colors.orange))),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text("\$${pnl.toStringAsFixed(0)}", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: pnl >= 0 ? AppColors.buyGreen : AppColors.sellRed))),
                  ]);
                }).toList(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyReturns(Map<String, double> returns) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Monthly Returns", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6, 
                childAspectRatio: 1.0,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: 12,
              itemBuilder: (context, index) {
                final monthNum = index + 1;
                final monthDate = DateTime(DateTime.now().year, monthNum);
                final key = DateFormat('yyyy-MM').format(monthDate);
                final val = returns[key] ?? 0.0;
                
                Color color = Colors.white10;
                if (val > 1000) color = Colors.green.shade900;
                else if (val > 0) color = Colors.green.shade600;
                else if (val < -1000) color = Colors.red.shade900;
                else if (val < 0) color = Colors.red.shade600;

                return InkWell(
                  onTap: () {
                    final start = DateTime(DateTime.now().year, monthNum, 1);
                    final nextMonth = monthNum == 12 ? 1 : monthNum + 1;
                    final year = monthNum == 12 ? DateTime.now().year + 1 : DateTime.now().year;
                    final end = DateTime(year, nextMonth, 0);
                    
                    ref.read(tradeHistoryFilterProvider.notifier).state = 
                      TradeFilters(dateRange: DateTimeRange(start: start, end: end));
                    context.go('/history');
                  },
                  child: Container(
                    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(DateFormat('MMM').format(monthDate), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                          if (val != 0) Text("${val > 0 ? '+' : ''}${(val/100).toStringAsFixed(0)}%", style: const TextStyle(fontSize: 7)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionChart(Map<String, double> sessions) {
    final List<BarChartGroupData> barGroups = [];
    final sessionKeys = ["ASIAN", "LONDON", "NEWYORK", "OVERLAP"];
    
    for (int i = 0; i < sessionKeys.length; i++) {
      final double val = (sessions[sessionKeys[i]] ?? 0.0).toDouble();
      barGroups.add(BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: val,
            color: val >= 0 ? AppColors.buyGreen : AppColors.sellRed,
            width: 20,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          )
        ],
      ));
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Session Performance", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 5000,
                  minY: -5000,
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (val, _) {
                          if (val.toInt() < sessionKeys.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(sessionKeys[val.toInt()], style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  barGroups: barGroups,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBottomTrades(PerformanceMetrics perf) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _TradeMiniList(title: "Best Trades", trades: perf.bestTrades)),
        const SizedBox(width: 8),
        Expanded(child: _TradeMiniList(title: "Worst Trades", trades: perf.worstTrades, isLoss: true)),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  const _StatCard(this.title, this.value, {required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: color.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: color.withOpacity(0.2))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey)),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

class _TradeMiniList extends StatelessWidget {
  final String title;
  final List<TradeRecord> trades;
  final bool isLoss;
  const _TradeMiniList({required this.title, required this.trades, this.isLoss = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (trades.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text("No trades yet", style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
          ),
        ...trades.map((t) => Container(
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.backgroundCard, 
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(t.pair.displayName, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              Text(
                "${(t.netProfitLoss ?? 0.0).toStringAsFixed(0)}",
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isLoss ? AppColors.sellRed : AppColors.buyGreen)
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }
}
