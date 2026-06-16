import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:forex_ai_frontend/state/providers.dart';

class PerformanceScreen extends ConsumerWidget {
  const PerformanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Performance Analysis")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const AspectRatio(
              aspectRatio: 1.7,
              child: Padding(
                padding: EdgeInsets.only(right: 18, left: 12, top: 24, bottom: 12),
                child: _EquityChart(),
              ),
            ),
            const SizedBox(height: 20),
            _buildMetricGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricGrid() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        _MetricCard("Total Return", "+12.4%"),
        _MetricCard("Sharpe Ratio", "1.85"),
        _MetricCard("Win Rate", "58%"),
        _MetricCard("Max DD", "4.2%"),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  const _MetricCard(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _EquityChart extends StatelessWidget {
  const _EquityChart();

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              const FlSpot(0, 10000),
              const FlSpot(1, 10200),
              const FlSpot(2, 10150),
              const FlSpot(3, 10400),
              const FlSpot(4, 10600),
            ],
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.2)),
          ),
        ],
      ),
    );
  }
}
