import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/providers.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';

class VetoLogPanel extends ConsumerWidget {
  const VetoLogPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logsAsync = ref.watch(immunityLogsProvider);

    return Card(
      margin: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Icon(Icons.shield_outlined, color: AppColors.buyGreen, size: 18),
                SizedBox(width: 8),
                Text("IMMUNE SYSTEM VETO LOG", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
              ],
            ),
          ),
          const Divider(height: 1),
          logsAsync.when(
            data: (logs) {
              if (logs.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: Text("No threats blocked today.", style: TextStyle(color: Colors.grey, fontSize: 10))),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: logs.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final log = logs[index];
                  return ListTile(
                    dense: true,
                    leading: const Icon(Icons.block, color: AppColors.sellRed, size: 14),
                    title: Text(log['pair'] ?? "Unknown", style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(log['reason'] ?? "", style: const TextStyle(fontSize: 10)),
                    trailing: Text(log['time'] ?? "", style: const TextStyle(fontSize: 9, color: Colors.grey)),
                  );
                },
              );
            },
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
