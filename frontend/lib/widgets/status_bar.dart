import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/providers.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import 'status_dot.dart';

class DashboardStatusBar extends ConsumerWidget {
  const DashboardStatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backendConn = ref.watch(backendConnectionProvider);
    final brokerConn = ref.watch(brokerConnectionProvider);
    final engineRunning = ref.watch(engineStateProvider);
    final signals = ref.watch(allSignalsProvider).value ?? {};
    final accountInfo = ref.watch(accountInfoProvider).value;
    
    String lastSignalText = "None";
    if (signals.isNotEmpty) {
      final latest = signals.values.map((s) => s.generatedAt).reduce((a, b) => a.isAfter(b) ? a : b);
      final diff = DateTime.now().difference(latest);
      lastSignalText = diff.inMinutes < 1 ? "Just now" : "${diff.inMinutes}m ago";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        border: Border(bottom: BorderSide(color: AppColors.borderColor)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _ConnectionDot(label: "API", status: backendConn.status),
            const SizedBox(width: AppSpacing.md),
            _ConnectionDot(label: "Broker", status: brokerConn.status),
            const SizedBox(width: AppSpacing.lg),
            if (accountInfo != null) ...[
              _MetricDisplay(label: "Balance", value: "\$${accountInfo.balance.toStringAsFixed(2)}"),
              const SizedBox(width: AppSpacing.md),
              _MetricDisplay(label: "Equity", value: "\$${accountInfo.equity.toStringAsFixed(2)}", color: AppColors.accentBlue),
            ],
            const SizedBox(width: AppSpacing.xl),
            _SessionBadge(),
            const SizedBox(width: AppSpacing.md),
            IconButton(
              icon: const Icon(Icons.refresh, size: 16, color: AppColors.textMuted),
              onPressed: () {
                ref.invalidate(allSignalsProvider);
                ref.invalidate(openTradesProvider);
                ref.invalidate(accountInfoProvider);
              },
              tooltip: "Force Sync",
            ),
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  engineRunning ? "RUNNING" : "STOPPED",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: engineRunning ? AppColors.buyGreen : AppColors.sellRed,
                  ),
                ),
                Text(
                  "Signals: $lastSignalText",
                  style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ConnectionDot extends StatefulWidget {
  final String label;
  final ConnectionStatus status;

  const _ConnectionDot({required this.label, required this.status});

  @override
  State<_ConnectionDot> createState() => _ConnectionDotState();
}

class _ConnectionDotState extends State<_ConnectionDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color color;
    bool pulse = false;
    
    switch (widget.status) {
      case ConnectionStatus.connected:
        color = AppColors.buyGreen;
        pulse = true;
        break;
      case ConnectionStatus.connecting:
        color = AppColors.warningYellow;
        pulse = true;
        break;
      case ConnectionStatus.error:
      case ConnectionStatus.disconnected:
        color = AppColors.sellRed;
        break;
    }

    return Row(
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(pulse ? _animation.value : 1.0),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    blurRadius: 4,
                    spreadRadius: pulse ? 2 : 0,
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(width: 6),
        Text(widget.label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _MetricDisplay extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  const _MetricDisplay({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color ?? AppColors.textPrimary)),
      ],
    );
  }
}

class _SessionBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // In a real app, this would be reactive to current time/session service
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.5)),
      ),
      child: const Text(
        "LONDON",
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.accentBlue),
      ),
    );
  }
}
