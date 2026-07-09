import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forex_ai_frontend/screens/news/tabs/sentiment_tab.dart';
import 'package:forex_ai_frontend/screens/news/tabs/news_feed_tab.dart';
import 'package:forex_ai_frontend/theme/colors.dart';
import 'package:forex_ai_frontend/theme/spacing.dart';
import 'package:forex_ai_frontend/state/providers.dart';
import 'package:forex_ai_frontend/models/models.dart';

class NewsScreen extends ConsumerWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("News & Sentiment"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Sentiment Overview"),
              Tab(text: "News Feed"),
            ],
            indicatorColor: AppColors.accentBlue,
            labelColor: AppColors.accentBlue,
          ),
        ),
        body: Column(
          children: [
            _buildMarketDriverBar(ref),
            const Expanded(
              child: TabBarView(
                children: [
                  SentimentTab(),
                  NewsFeedTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketDriverBar(WidgetRef ref) {
    final driverAsync = ref.watch(marketDriversProvider);

    return driverAsync.when(
      data: (driver) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
        color: AppColors.backgroundElevated,
        child: Row(
          children: [
            Icon(
              Icons.campaign, 
              size: 18, 
              color: driver.impactLevel == ImpactLevel.high ? AppColors.sellRed : AppColors.accentBlue
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                driver.summary,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accentBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                driver.topCurrency,
                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.accentBlue),
              ),
            ),
          ],
        ),
      ),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
