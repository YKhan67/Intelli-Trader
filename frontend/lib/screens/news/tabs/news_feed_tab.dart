import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shimmer/shimmer.dart';
import '../../../models/models.dart';
import '../../../state/providers.dart';
import '../../../theme/colors.dart';
import '../../../theme/spacing.dart';

class NewsFeedTab extends ConsumerStatefulWidget {
  const NewsFeedTab({super.key});

  @override
  ConsumerState<NewsFeedTab> createState() => _NewsFeedTabState();
}

class _NewsFeedTabState extends ConsumerState<NewsFeedTab> {
  final Set<String> _selectedCurrencies = {};
  ImpactLevel? _selectedImpact;
  String _selectedSource = 'All';
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _refreshTimer = Timer.periodic(const Duration(minutes: 10), (timer) {
      ref.invalidate(allNewsProvider);
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newsAsync = ref.watch(allNewsProvider);

    return Column(
      children: [
        _buildFilterBar(),
        const Divider(height: 1),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(allNewsProvider);
              await ref.read(allNewsProvider.future);
            },
            child: newsAsync.when(
              data: (items) {
                final filtered = _applyFilters(items);
                if (filtered.isEmpty) {
                  return const Center(child: Text("No news matching filters"));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) => _NewsArticleCard(article: filtered[index]),
                );
              },
              loading: () => _buildShimmer(),
              error: (e, _) => Center(child: Text("Error: $e")),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
    final majorCurrencies = ['USD', 'EUR', 'GBP', 'JPY', 'AUD', 'NZD', 'CAD', 'CHF'];
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      color: AppColors.backgroundCard,
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: majorCurrencies.map((c) {
                final isSelected = _selectedCurrencies.contains(c);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(c, style: const TextStyle(fontSize: 10)),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() {
                        if (val) {
                          _selectedCurrencies.add(c);
                        } else {
                          _selectedCurrencies.remove(c);
                        }
                      });
                    },
                    selectedColor: AppColors.accentBlue.withOpacity(0.2),
                    showCheckmark: false,
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                _buildImpactDropdown(),
                const SizedBox(width: AppSpacing.md),
                _buildSourceDropdown(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactDropdown() {
    return DropdownButton<ImpactLevel?>(
      value: _selectedImpact,
      hint: const Text("Impact", style: TextStyle(fontSize: 12)),
      underline: const SizedBox(),
      items: [
        const DropdownMenuItem(value: null, child: Text("All Impact", style: TextStyle(fontSize: 12))),
        ...ImpactLevel.values.map((i) => DropdownMenuItem(
          value: i,
          child: Text(i.name.toUpperCase(), style: const TextStyle(fontSize: 12)),
        )),
      ],
      onChanged: (val) => setState(() => _selectedImpact = val),
    );
  }

  Widget _buildSourceDropdown() {
    return DropdownButton<String>(
      value: _selectedSource,
      underline: const SizedBox(),
      items: const [
        DropdownMenuItem(value: 'All', child: Text("All Sources", style: TextStyle(fontSize: 12))),
        DropdownMenuItem(value: 'Reuters', child: Text("Reuters", style: TextStyle(fontSize: 12))),
        DropdownMenuItem(value: 'ForexLive', child: Text("ForexLive", style: TextStyle(fontSize: 12))),
        DropdownMenuItem(value: 'FXStreet', child: Text("FXStreet", style: TextStyle(fontSize: 12))),
      ],
      onChanged: (val) => setState(() => _selectedSource = val ?? 'All'),
    );
  }

  List<NewsItem> _applyFilters(List<NewsItem> items) {
    return items.where((item) {
      if (_selectedCurrencies.isNotEmpty) {
        if (!item.currenciesMentioned.any((c) => _selectedCurrencies.contains(c.toUpperCase()))) {
          return false;
        }
      }
      if (_selectedSource != 'All' && !item.source.contains(_selectedSource)) {
        return false;
      }
      // Note: Backend NewsItem currently doesn't have an impact field, 
      // but we could derive it or add it later.
      return true;
    }).toList();
  }

  Widget _buildShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.sm),
      itemCount: 5,
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: AppColors.backgroundElevated,
        highlightColor: AppColors.borderColor,
        child: Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Container(height: 100, width: double.infinity),
        ),
      ),
    );
  }
}

class _NewsArticleCard extends StatelessWidget {
  final NewsItem article;
  const _NewsArticleCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _launchURL(article.url),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundElevated,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.newspaper, size: 16, color: AppColors.textMuted),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.headline,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(article.source, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                            const SizedBox(width: 8),
                            Text(
                              timeAgo(article.timestamp ?? DateTime.now()),
                              style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Wrap(
                    spacing: 4,
                    children: article.currenciesMentioned.take(3).map((c) => _CurrencyChip(currency: c)).toList(),
                  ),
                  const Spacer(),
                  _SentimentBadge(score: article.sentimentScore),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  String timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'just now';
  }
}

class _CurrencyChip extends StatelessWidget {
  final String currency;
  const _CurrencyChip({required this.currency});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.accentBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.accentBlue.withOpacity(0.3)),
      ),
      child: Text(
        currency.toUpperCase(),
        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.accentBlue),
      ),
    );
  }
}

class _SentimentBadge extends StatelessWidget {
  final double score;
  const _SentimentBadge({required this.score});

  @override
  Widget build(BuildContext context) {
    final color = score > 0.3 ? AppColors.buyGreen : (score < -0.3 ? AppColors.sellRed : AppColors.textMuted);
    final label = score > 0.3 ? 'Bullish' : (score < -0.3 ? 'Bearish' : 'Neutral');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(width: 4),
          Text(
            score.toStringAsFixed(2),
            style: TextStyle(fontSize: 10, color: color),
          ),
        ],
      ),
    );
  }
}
