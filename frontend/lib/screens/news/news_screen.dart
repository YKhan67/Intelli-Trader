import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'tabs/sentiment_tab.dart';
import 'tabs/news_feed_tab.dart';
import '../../theme/colors.dart';

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
        body: const TabBarView(
          children: [
            SentimentTab(),
            NewsFeedTab(),
          ],
        ),
      ),
    );
  }
}
