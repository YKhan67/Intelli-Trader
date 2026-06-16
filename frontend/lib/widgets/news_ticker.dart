import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import '../state/providers.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../models/models.dart';

class NewsTicker extends ConsumerStatefulWidget {
  const NewsTicker({super.key});

  @override
  ConsumerState<NewsTicker> createState() => _NewsTickerState();
}

class _NewsTickerState extends ConsumerState<NewsTicker> {
  late ScrollController _scrollController;
  Timer? _timer;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());
  }

  void _startScrolling() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_scrollController.hasClients && !_isPaused) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.offset;
        
        if (currentScroll >= maxScroll) {
          _scrollController.jumpTo(0);
        } else {
          _scrollController.jumpTo(currentScroll + 1);
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // For ticker, we poll from general news or use a placeholder
    final activePairs = ref.watch(activePairsStateProvider);
    final firstPair = activePairs.isNotEmpty ? activePairs.first : CurrencyPair.eurusd;
    final newsAsync = ref.watch(newsProvider(firstPair));

    return newsAsync.when(
      data: (news) {
        if (news.isEmpty) return const SizedBox.shrink();
        
        return GestureDetector(
          onTapDown: (_) => setState(() => _isPaused = true),
          onTapUp: (_) => setState(() => _isPaused = false),
          onTapCancel: () => setState(() => _isPaused = false),
          child: Container(
            height: 30,
            color: Colors.black26,
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: news.length * 10, // Infinite-like effect
              itemBuilder: (context, index) {
                final item = news[index % news.length];
                return _TickerItem(item: item);
              },
            ),
          ),
        );
      },
      loading: () => const SizedBox(height: 30),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _TickerItem extends StatelessWidget {
  final NewsItem item;
  const _TickerItem({required this.item});

  @override
  Widget build(BuildContext context) {
    Color textColor = AppColors.textSecondary;
    if (item.sentimentScore > 0.3) textColor = AppColors.buyGreen;
    if (item.sentimentScore < -0.3) textColor = AppColors.sellRed;

    return InkWell(
      onTap: () => context.go('/news'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Center(
          child: Text(
            "${item.source.toUpperCase()}: ${item.headline}",
            style: TextStyle(fontSize: 11, color: textColor),
          ),
        ),
      ),
    );
  }
}
