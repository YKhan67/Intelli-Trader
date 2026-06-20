import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../models/models.dart';
import '../../../state/providers.dart';
import '../../../theme/colors.dart';
import '../../../theme/spacing.dart';

class CalendarSection extends ConsumerStatefulWidget {
  const CalendarSection({super.key});

  @override
  ConsumerState<CalendarSection> createState() => _CalendarSectionState();
}

class _CalendarSectionState extends ConsumerState<CalendarSection> with SingleTickerProviderStateMixin {
  late Timer _timer;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _timer.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final calendarAsync = ref.watch(calendarProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              const Icon(Icons.calendar_month, color: AppColors.accentBlue, size: 20),
              const SizedBox(width: 8),
              Text(
                "ECONOMIC CALENDAR (NEXT 24H)",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        calendarAsync.when(
          data: (events) {
            final now = DateTime.now();
            final next24h = now.add(const Duration(hours: 24));
            
            final filteredEvents = events.where((e) {
              final ts = e.timestamp;
              if (ts == null) return false;
              // Show events from 6 hours ago to 48 hours in the future
              return ts.isAfter(now.subtract(const Duration(hours: 6))) &&
                     ts.isBefore(now.add(const Duration(hours: 48)));
            }).toList();

            if (filteredEvents.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Center(child: Text("No high impact events in next 24h", style: TextStyle(color: AppColors.textMuted))),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredEvents.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) => _CalendarEventTile(
                event: filteredEvents[index],
                pulseAnimation: _pulseController,
              ),
            );
          },
          loading: () => const Center(child: Padding(
            padding: EdgeInsets.all(AppSpacing.xl),
            child: CircularProgressIndicator(),
          )),
          error: (e, _) => Center(child: Text("Error: $e")),
        ),
      ],
    );
  }
}

class _CalendarEventTile extends StatelessWidget {
  final CalendarEvent event;
  final Animation<double> pulseAnimation;

  const _CalendarEventTile({required this.event, required this.pulseAnimation});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final DateTime eventTs = event.timestamp ?? DateTime.now();
    final diff = eventTs.difference(now);
    final minutesAway = diff.inMinutes;
    final isVeryClose = minutesAway >= 0 && minutesAway <= 30;
    final isClose = minutesAway >= 0 && minutesAway <= 120;

    return AnimatedBuilder(
      animation: pulseAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            border: isVeryClose 
              ? Border.all(color: AppColors.sellRed.withOpacity(pulseAnimation.value), width: 2)
              : (isClose ? Border.all(color: AppColors.warningYellow.withOpacity(0.5), width: 1) : null),
          ),
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        child: Row(
          children: [
            _buildCurrencyFlag(event.currency),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.eventName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      _ImpactBadge(level: event.impact),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('HH:mm').format(eventTs.toLocal()),
                        style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            _buildValues(),
            const SizedBox(width: AppSpacing.sm),
            _buildCountdown(diff),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyFlag(String currency) {
    return Container(
      width: 32,
      height: 20,
      decoration: BoxDecoration(
        color: AppColors.backgroundElevated,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Center(
        child: Text(
          currency,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildValues() {
    final actualColor = _getActualColor();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (event.actual != null)
          Text(
            event.actual!,
            style: TextStyle(fontWeight: FontWeight.bold, color: actualColor, fontSize: 13),
          ),
        Row(
          children: [
            Text("f: ${event.forecast ?? '-'}", style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
            const SizedBox(width: 4),
            Text("p: ${event.previous ?? '-'}", style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
          ],
        ),
      ],
    );
  }

  Color? _getActualColor() {
    if (event.actual == null || event.forecast == null) return null;
    // Simple heuristic: if surprise exists and positive, green. 
    // In a real app, we'd need to know if "higher is better" for each event type.
    if (event.surprise != null) {
      if (event.surprise! > 0) return AppColors.buyGreen;
      if (event.surprise! < 0) return AppColors.sellRed;
    }
    return null;
  }

  Widget _buildCountdown(Duration diff) {
    if (diff.isNegative) {
      return const SizedBox(
        width: 60,
        child: Text("RELEASED", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textMuted), textAlign: TextAlign.right),
      );
    }
    
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;
    final seconds = diff.inSeconds % 60;
    
    String text;
    if (hours > 0) {
      text = "${hours}h ${minutes}m";
    } else {
      text = "${minutes}m ${seconds}s";
    }

    return SizedBox(
      width: 60,
      child: Text(
        text,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.accentBlue),
        textAlign: TextAlign.right,
      ),
    );
  }
}

class _ImpactBadge extends StatelessWidget {
  final ImpactLevel level;
  const _ImpactBadge({required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: level.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: level.color.withOpacity(0.5)),
      ),
      child: Text(
        level.name.toUpperCase(),
        style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: level.color),
      ),
    );
  }
}
