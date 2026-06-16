import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:forex_ai_frontend/models/models.dart';
import 'package:forex_ai_frontend/state/providers.dart';

class NewsScreen extends ConsumerWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // For now, default to EURUSD news or implement a generalized news provider
    final news = ref.watch(newsProvider(CurrencyPair.eurusd));
    final calendar = ref.watch(calendarProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("News & Sentiment"),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                ref.invalidate(newsProvider(CurrencyPair.eurusd));
                ref.invalidate(calendarProvider);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Refreshing news and calendar..."), duration: Duration(seconds: 1)),
                );
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: "Live News"),
              Tab(text: "Economic Calendar"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildNewsList(news),
            _buildCalendarList(calendar),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsList(AsyncValue<List<NewsItem>> news) {
    return news.when(
      data: (items) {
        if (items.isEmpty) return const Center(child: Text("No live news available."));
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                onTap: () => _showNewsDetail(context, item),
                title: Text(item.headline, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: Text("${item.source} • ${DateFormat('HH:mm').format(item.timestamp.toLocal())}"),
                trailing: _buildSentimentBadge(item.sentimentScore),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text("Error loading news: $e")),
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

  Widget _buildCalendarList(AsyncValue<List<CalendarEvent>> calendar) {
    return calendar.when(
      data: (events) {
        if (events.isEmpty) return const Center(child: Text("No upcoming economic events."));
        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final e = events[index];
            final color = e.impact == ImpactLevel.high ? Colors.red : (e.impact == ImpactLevel.medium ? Colors.orange : Colors.grey);
            final timeStr = DateFormat('HH:mm').format(e.timestamp.toLocal());
            return ListTile(
              leading: Text(timeStr, style: const TextStyle(fontWeight: FontWeight.bold)),
              title: Text(e.eventName),
              subtitle: Text(e.currency),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                child: Text(e.impact.name.toUpperCase(), style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text("Error loading calendar: $e")),
    );
  }

  Widget _buildSentimentBadge(double score) {
    // Backend score is -1.0 to 1.0. Map to visual color.
    final color = score > 0.2 ? Colors.green : (score < -0.2 ? Colors.red : Colors.grey);
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        border: Border.all(color: color.withOpacity(0.5)),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          score.toStringAsFixed(1),
          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 10),
        ),
      ),
    );
  }
}
