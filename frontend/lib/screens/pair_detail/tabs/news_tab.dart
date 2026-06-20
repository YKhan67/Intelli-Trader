import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../../../models/models.dart';
import '../../../state/providers.dart';
import '../../../theme/colors.dart';
import '../../../theme/spacing.dart';

class NewsTab extends ConsumerStatefulWidget {
  final CurrencyPair pair;
  const NewsTab({super.key, required this.pair});

  @override
  ConsumerState<NewsTab> createState() => _NewsTabState();
}

class _NewsTabState extends ConsumerState<NewsTab> {
  Timer? _countdownTimer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newsAsync = ref.watch(newsProvider(widget.pair));
    final calendarAsync = ref.watch(calendarProvider);
    final sentiment = ref.watch(sentimentProvider(widget.pair));

    final String base = widget.pair.name.substring(0, 3).toUpperCase();
    final String quote = widget.pair.name.substring(3).toUpperCase();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInstitutionalHeader("CURRENCY SENTIMENT"),
          if (sentiment != null)
            _buildSentimentMeters(sentiment, base, quote)
          else
            const Center(child: Text("Loading Sentiment...", style: TextStyle(fontSize: 10, color: AppColors.textMuted))),
          
          const SizedBox(height: AppSpacing.lg),
          _buildInstitutionalHeader("UPCOMING CALENDAR"),
          _buildCalendarSection(calendarAsync, [base, quote]),

          const SizedBox(height: AppSpacing.lg),
          _buildInstitutionalHeader("MARKET HEADLINES"),
          _buildNewsSection(context, newsAsync),
          
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildInstitutionalHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(width: 4, height: 14, color: AppColors.accentBlue),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.2, color: AppColors.textMuted),
          ),
          const Spacer(),
          const Icon(Icons.flash_on, size: 12, color: AppColors.warningYellow),
        ],
      ),
    );
  }

  Widget _buildSentimentMeters(SentimentResult result, String base, String quote) {
    return Row(
      children: [
        Expanded(child: _buildInstitutionalMeter(base, result.currencyScores[base] ?? 0)),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: _buildInstitutionalMeter(quote, result.currencyScores[quote] ?? 0)),
      ],
    );
  }

  Widget _buildInstitutionalMeter(String currency, double score) {
    final color = score > 0.2 ? AppColors.buyGreen : (score < -0.2 ? AppColors.sellRed : Colors.grey);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(currency, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 8),
          Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: (score + 1) / 2,
                backgroundColor: AppColors.backgroundElevated,
                color: color,
                strokeWidth: 6,
              ),
              Text(
                "${score > 0 ? '+' : ''}${score.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarSection(AsyncValue<List<CalendarEvent>> calendarAsync, List<String> currencies) {
    return calendarAsync.when(
      data: (events) {
        final filtered = events.where((e) => currencies.contains(e.currency.toUpperCase())).toList();
        if (filtered.isEmpty) return const Text("No relevant upcoming events.", style: TextStyle(fontSize: 12, color: AppColors.textMuted));
        
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
    final DateTime eventTs = event.timestamp ?? DateTime.now();
    final Duration diff = eventTs.difference(_now);
    final bool isPast = diff.isNegative;

    String countdown;
    if (isPast) {
      countdown = "STARTED";
    } else {
      final hours = diff.inHours;
      final mins = diff.inMinutes % 60;
      final secs = diff.inSeconds % 60;
      countdown = hours > 0 ? "${hours}h ${mins}m" : "${mins}m ${secs}s";
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(4),
      ),
      child: ListTile(
        dense: true,
        visualDensity: VisualDensity.compact,
        leading: Container(
          width: 3,
          height: 30,
          color: isHigh ? AppColors.sellRed : AppColors.warningYellow,
        ),
        title: Text(event.eventName, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
        subtitle: Text(DateFormat('HH:mm').format(eventTs.toLocal()), style: const TextStyle(fontSize: 9)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(event.currency, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            Text(
              isPast ? countdown : "IN $countdown",
              style: TextStyle(
                fontSize: 9, 
                color: isPast ? Colors.grey : (isHigh ? AppColors.sellRed : AppColors.accentBlue),
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsSection(BuildContext context, AsyncValue<List<NewsItem>> newsAsync) {
    return newsAsync.when(
      data: (items) {
        if (items.isEmpty) return const Text("No relevant news found.", style: TextStyle(fontSize: 12, color: AppColors.textMuted));
        return Column(
          children: items.map((item) => _buildNewsTile(context, item)).toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text("Error: $e"),
    );
  }

  Widget _buildNewsTile(BuildContext context, NewsItem item) {
    return ListTile(
      onTap: () => _showNewsDetail(context, item),
      contentPadding: EdgeInsets.zero,
      title: Text(item.headline, style: const TextStyle(fontSize: 12, height: 1.2)),
      subtitle: Row(
        children: [
          Text(item.source, style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
          const SizedBox(width: 8),
          Text(_formatTimeAgo(item.timestamp ?? DateTime.now()), style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
        ],
      ),
      trailing: _SentimentIndicator(score: item.sentimentScore),
    );
  }

  String _formatTimeAgo(DateTime dt) {
    final diff = _now.difference(dt);
    if (diff.inHours > 24) return "${diff.inDays}d ago";
    if (diff.inHours > 0) return "${diff.inHours}h ago";
    if (diff.inMinutes > 0) return "${diff.inMinutes}m ago";
    return "just now";
  }

  void _showNewsDetail(BuildContext context, NewsItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundElevated,
        title: Text(item.headline, style: const TextStyle(fontSize: 16)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${item.source} • ${DateFormat('MMM d, HH:mm').format((item.timestamp ?? DateTime.now()).toLocal())}",
                   style: const TextStyle(fontSize: 11, color: Colors.grey)),
              const Divider(),
              const SizedBox(height: 8),
              Text(item.body, style: const TextStyle(fontSize: 13, height: 1.5)),
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

class _SentimentIndicator extends StatelessWidget {
  final double score;
  const _SentimentIndicator({required this.score});

  @override
  Widget build(BuildContext context) {
    final color = score > 0.1 ? AppColors.buyGreen : (score < -0.1 ? AppColors.sellRed : Colors.grey);
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.backgroundElevated,
        borderRadius: BorderRadius.circular(2),
      ),
      child: FractionallySizedBox(
        alignment: score >= 0 ? Alignment.centerLeft : Alignment.centerRight,
        widthFactor: score.abs().clamp(0.1, 1.0),
        child: Container(color: color),
      ),
    );
  }
}
