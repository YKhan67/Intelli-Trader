import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../models/models.dart';
import '../../../state/providers.dart';
import '../../../theme/colors.dart';
import '../../../theme/spacing.dart';

class NewsTab extends ConsumerWidget {
  final CurrencyPair pair;
  const NewsTab({super.key, required this.pair});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(newsProvider(pair));
    final calendarAsync = ref.watch(calendarProvider);
    final sentiment = ref.watch(sentimentProvider(pair));

    final String base = pair.name.substring(0, 3).toUpperCase();
    final String quote = pair.name.substring(3).toUpperCase();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (sentiment != null)
            _buildSentimentGauges(sentiment, base, quote),
          
          const SizedBox(height: AppSpacing.lg),
          const Text("Upcoming Events", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Divider(),
          _buildCalendarSection(calendarAsync, [base, quote]),

          const SizedBox(height: AppSpacing.lg),
          const Text("Latest News", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Divider(),
          _buildNewsSection(context, newsAsync),
          
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildSentimentGauges(SentimentResult result, String base, String quote) {
    return Row(
      children: [
        Expanded(child: _buildGauge(base, result.currencyScores[base] ?? 0)),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: _buildGauge(quote, result.currencyScores[quote] ?? 0)),
      ],
    );
  }

  Widget _buildGauge(String currency, double score) {
    final color = score > 0 ? Colors.green : (score < 0 ? Colors.red : Colors.grey);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          children: [
            Text(currency, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: (score + 1) / 2, // Map -1..1 to 0..1
              backgroundColor: AppColors.backgroundElevated,
              color: color,
            ),
            const SizedBox(height: 4),
            Text(score.toStringAsFixed(2), style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarSection(AsyncValue<List<CalendarEvent>> calendarAsync, List<String> currencies) {
    return calendarAsync.when(
      data: (events) {
        final filtered = events.where((e) => currencies.contains(e.currency.toUpperCase())).toList();
        if (filtered.isEmpty) return const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Text("No relevant upcoming events.", style: TextStyle(fontSize: 12, color: AppColors.textMuted)));
        
        return Column(
          children: filtered.take(5).map((e) => _buildCalendarTile(e)).toList(),
        );
      },
      loading: () => const LinearProgressIndicator(),
      error: (e, _) => Text("Error: $e"),
    );
  }

  Widget _buildCalendarTile(CalendarEvent event) {
    final bool isHigh = event.impact == ImpactLevel.high;
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 4,
        color: isHigh ? Colors.red : Colors.orange,
      ),
      title: Text(event.eventName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      subtitle: Text(DateFormat('MMM d, HH:mm').format(event.timestamp.toLocal()), style: const TextStyle(fontSize: 10)),
      trailing: Text(event.currency, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildNewsSection(BuildContext context, AsyncValue<List<NewsItem>> newsAsync) {
    return newsAsync.when(
      data: (items) {
        if (items.isEmpty) return const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Text("No relevant news found.", style: TextStyle(fontSize: 12, color: AppColors.textMuted)));
        return Column(
          children: items.map((item) => _buildNewsTile(context, item)).toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text("Error: $e"),
    );
  }

  Widget _buildNewsTile(BuildContext context, NewsItem item) {
    final color = item.sentimentScore > 0.1 ? Colors.green : (item.sentimentScore < -0.1 ? Colors.red : Colors.grey);
    return ListTile(
      onTap: () => _showNewsDetail(context, item),
      contentPadding: EdgeInsets.zero,
      title: Text(item.headline, style: const TextStyle(fontSize: 13, height: 1.2)),
      subtitle: Text("${item.source} • ${DateFormat('HH:mm').format(item.timestamp.toLocal())}", style: const TextStyle(fontSize: 10)),
      trailing: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }

  void _showNewsDetail(BuildContext context, NewsItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.headline),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${item.source} • ${DateFormat('MMM d, HH:mm').format(item.timestamp.toLocal())}", 
                   style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const Divider(),
              const SizedBox(height: 8),
              Text(item.body, style: const TextStyle(fontSize: 14, height: 1.4)),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CLOSE")),
        ],
      ),
    );
  }
}
