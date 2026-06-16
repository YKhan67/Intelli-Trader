import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../widgets/status_bar.dart';
import '../../widgets/engine_controls.dart';
import '../../widgets/signals_grid.dart';
import '../../widgets/open_trades_panel.dart';
import '../../widgets/daily_summary.dart';
import '../../widgets/circuit_breaker_panel.dart';
import '../../widgets/news_ticker.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            const DashboardStatusBar(),
            const NewsTicker(),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final bool isWide = constraints.maxWidth >= 900;
                  
                  return CustomScrollView(
                    slivers: [
                      if (isWide)
                        _buildWideLayout()
                      else
                        _buildMobileLayout(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverList _buildMobileLayout() {
    return SliverList(
      delegate: SliverChildListDelegate([
        const DailySummaryBar(),
        const EngineControlPanel(),
        const CircuitBreakerPanel(),
        const _SectionHeader(title: "ACTIVE SIGNALS"),
        const SignalsGrid(),
        const SizedBox(height: AppSpacing.lg),
        const _SectionHeader(title: "LIVE POSITIONS"),
        const Card(
          margin: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: OpenTradesPanel(),
        ),
        const SizedBox(height: AppSpacing.xxl),
      ]),
    );
  }

  SliverList _buildWideLayout() {
    return SliverList(
      delegate: SliverChildListDelegate([
        const DailySummaryBar(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    const EngineControlPanel(),
                    const CircuitBreakerPanel(),
                    const _SectionHeader(title: "ACTIVE SIGNALS"),
                    const SignalsGrid(),
                  ],
                ),
              ),
              // Right Column
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    const _SectionHeader(title: "LIVE POSITIONS"),
                    const Card(
                      margin: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: OpenTradesPanel(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
      ]),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.lg, AppSpacing.md, AppSpacing.sm),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.textMuted,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
