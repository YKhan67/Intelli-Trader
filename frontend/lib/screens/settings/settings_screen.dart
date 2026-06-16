import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/enums.dart';
import '../../state/providers.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../utils/logger.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tradingMode = ref.watch(tradingModeStateProvider);
    final activePairs = ref.watch(activePairsStateProvider);
    final systemStatus = ref.watch(systemStatusProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _buildSectionHeader(context, "Backend"),
          _buildBackendTile(context, ref),
          
          const SizedBox(height: AppSpacing.lg),
          _buildSectionHeader(context, "Broker"),
          _buildBrokerTile(context, ref),

          const SizedBox(height: AppSpacing.lg),
          _buildSectionHeader(context, "Trading Preferences"),
          _buildTradingModeSelector(context, ref, tradingMode),
          const SizedBox(height: AppSpacing.md),
          _buildActivePairsList(context, ref, activePairs),

          const SizedBox(height: AppSpacing.lg),
          _buildSectionHeader(context, "Notifications"),
          _buildNotificationToggles(context, ref),

          const SizedBox(height: AppSpacing.lg),
          _buildSectionHeader(context, "System"),
          systemStatus.when(
            data: (status) => _buildSystemInfo(context, ref, status),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text("Error loading system info: $e"),
          ),

          const SizedBox(height: AppSpacing.lg),
          _buildSectionHeader(context, "About"),
          systemStatus.when(
            data: (status) => _buildAboutInfo(context, status['model_version']?.toString() ?? 'Unknown'),
            loading: () => _buildAboutInfo(context, 'Loading...'),
            error: (_, __) => _buildAboutInfo(context, 'Error'),
          ),
          
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.accentBlue),
      ),
    );
  }

  Widget _buildBackendTile(BuildContext context, WidgetRef ref) {
    return FutureBuilder<Map<String, String?>>(
      future: ref.read(storageServiceProvider).getBackendConfig(),
      builder: (context, snapshot) {
        final url = snapshot.data?['url'] ?? "Not configured";
        final maskedUrl = url.length > 10 ? "${url.substring(0, 7)}***${url.substring(url.length - 3)}" : url;
        return Card(
          child: ListTile(
            title: Text(maskedUrl),
            subtitle: const Text("Backend Connection"),
            trailing: TextButton(
              onPressed: () => context.go('/login'),
              child: const Text("Edit"),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBrokerTile(BuildContext context, WidgetRef ref) {
    return FutureBuilder<Map<String, dynamic>>(
      future: ref.read(storageServiceProvider).getBrokerConfig(),
      builder: (context, snapshot) {
        final type = snapshot.data?['type'] as BrokerType?;
        final typeName = type?.name.toUpperCase() ?? "Not configured";
        return Card(
          child: ListTile(
            title: Text(typeName),
            subtitle: const Text("Trading Broker"),
            trailing: TextButton(
              onPressed: () => context.go('/login'),
              child: const Text("Change"),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTradingModeSelector(BuildContext context, WidgetRef ref, TradingMode currentMode) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Trading Mode", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.sm),
            DropdownButton<TradingMode>(
              value: currentMode,
              isExpanded: true,
              underline: const SizedBox(),
              items: TradingMode.values.map((mode) {
                return DropdownMenuItem(
                  value: mode,
                  child: Text(mode.name.toUpperCase()),
                );
              }).toList(),
              onChanged: (mode) async {
                if (mode != null) {
                  try {
                    await ref.read(tradingModeStateProvider.notifier).setMode(mode);
                    final pairs = ref.read(activePairsStateProvider);
                    await ref.read(backendServiceProvider).postSettings(mode, pairs);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Trading mode updated to ${mode.name.toUpperCase()}"), backgroundColor: AppColors.buyGreen),
                      );
                    }
                  } catch (e) {
                    logger.e("Failed to update trading mode: $e");
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Failed to sync with backend: $e"), backgroundColor: AppColors.sellRed),
                      );
                    }
                  }
                }
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              _getModeDescription(currentMode),
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  String _getModeDescription(TradingMode mode) {
    switch (mode) {
      case TradingMode.normal:
        return "Standard institutional risk (1% per trade). Balanced growth and protection.";
      case TradingMode.aggressive:
        return "High risk for fast growth (3-5% per trade). Higher potential drawdown.";
      case TradingMode.conservative:
        return "Capital preservation (0.25-0.5% per trade). Minimal risk, steady gains.";
    }
  }

  Widget _buildActivePairsList(BuildContext context, WidgetRef ref, List<CurrencyPair> activePairs) {
    return Card(
      child: Column(
        children: CurrencyPair.values.where((p) => p != CurrencyPair.unknown).map((pair) {
          final isActive = activePairs.contains(pair);
          return CheckboxListTile(
            title: Text(pair.displayName),
            value: isActive,
            activeColor: AppColors.accentBlue,
            onChanged: (val) async {
              try {
                final newPairs = List<CurrencyPair>.from(activePairs);
                if (val == true) {
                  newPairs.add(pair);
                } else {
                  if (newPairs.length <= 1) {
                     ScaffoldMessenger.of(context).showSnackBar(
                       const SnackBar(content: Text("At least one currency pair must be active"), backgroundColor: AppColors.closeOrange),
                     );
                     return;
                  }
                  newPairs.remove(pair);
                }
                await ref.read(activePairsStateProvider.notifier).setPairs(newPairs);
                final mode = ref.read(tradingModeStateProvider);
                await ref.read(backendServiceProvider).postSettings(mode, newPairs);
              } catch (e) {
                logger.e("Failed to update active pairs: $e");
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to sync with backend: $e"), backgroundColor: AppColors.sellRed),
                  );
                }
              }
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNotificationToggles(BuildContext context, WidgetRef ref) {
    return Card(
      child: Column(
        children: [
          _buildNotifySwitch("Circuit Breakers", true),
          _buildNotifySwitch("High Impact News", true),
          _buildNotifySwitch("Trade Opened", true),
          _buildNotifySwitch("Trade Closed", true),
          _buildNotifySwitch("Model Retrained", false),
        ],
      ),
    );
  }

  Widget _buildNotifySwitch(String title, bool value) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: (val) {},
      activeColor: AppColors.accentBlue,
    );
  }

  Widget _buildSystemInfo(BuildContext context, WidgetRef ref, Map<String, dynamic> status) {
    final freshness = status['data_freshness'] as Map<String, dynamic>? ?? {};
    
    return Card(
      child: Column(
        children: [
          ListTile(
            title: const Text("Model Version"),
            trailing: Text(status['model_version']?.toString() ?? "Unknown"),
          ),
          ListTile(
            title: const Text("Last Price Update"),
            trailing: Text(freshness['prices'] != null 
              ? freshness['prices'].toString().substring(11, 19) 
              : "Never"),
          ),
          ListTile(
            title: const Text("Last News Update"),
            trailing: Text(freshness['news'] != null 
              ? freshness['news'].toString().substring(11, 19)
              : "Never"),
          ),
          ListTile(
            title: const Text("Manual Retrain"),
            trailing: ElevatedButton(
              onPressed: () => _showRetrainDialog(context, ref),
              child: const Text("Trigger"),
            ),
          ),
          ListTile(
            title: const Text("Clear Local Data", style: TextStyle(color: AppColors.sellRed)),
            onTap: () => _showClearDataDialog(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutInfo(BuildContext context, String backendVersion) {
    return Card(
      child: Column(
        children: [
          const ListTile(
            title: Text("App Version"),
            trailing: Text("1.0.0"),
          ),
          ListTile(
            title: const Text("Backend Version"),
            trailing: Text(backendVersion),
          ),
          const ListTile(
            title: Text("Build Date"),
            trailing: Text("Oct 2023"),
          ),
        ],
      ),
    );
  }

  void _showRetrainDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Trigger Retrain?"),
        content: const Text("This will start a model retraining process in the background. It may take some time."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              ref.read(backendServiceProvider).postRetrain();
              Navigator.pop(context);
            }, 
            child: const Text("Trigger"),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("CLEAR ALL DATA?", style: TextStyle(color: AppColors.sellRed)),
        content: const Text("This will permanently delete all saved credentials and preferences. You will be logged out."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              await ref.read(storageServiceProvider).clearAll();
              if (context.mounted) {
                context.go('/login');
              }
            }, 
            child: const Text("CLEAR", style: TextStyle(color: AppColors.sellRed)),
          ),
        ],
      ),
    );
  }
}
