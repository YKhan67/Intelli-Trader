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
          _buildSectionHeader(context, "Risk Management"),
          _buildRiskControls(context, ref),

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
            loading: () => const Center(child: LinearProgressIndicator()),
            error: (e, _) => Text("System Status Error: $e", style: const TextStyle(fontSize: 10, color: Colors.grey)),
          ),

          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _buildRiskControls(BuildContext context, WidgetRef ref) {
    final riskSettings = ref.watch(riskSettingsStateProvider);
    final minRR = riskSettings['min_rr_ratio'] ?? 1.5;
    final maxRisk = riskSettings['max_risk_per_trade'] ?? 0.01;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            _buildSliderRow(
              "Min R:R Ratio",
              minRR,
              1.0,
              5.0,
              (val) => _updateRisk(ref, 'min_rr_ratio', val),
              displayVal: minRR.toStringAsFixed(1),
            ),
            const Divider(),
            _buildSliderRow(
              "Max Risk %",
              maxRisk * 100,
              0.1,
              5.0,
              (val) => _updateRisk(ref, 'max_risk_per_trade', val / 100),
              displayVal: "${(maxRisk * 100).toStringAsFixed(1)}%",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderRow(String label, double val, double min, double max, Function(double) onChanged, {required String displayVal}) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              Text(displayVal, style: const TextStyle(fontSize: 12, color: AppColors.accentBlue)),
            ],
          ),
        ),
        Expanded(
          flex: 4,
          child: Slider(
            value: val,
            min: min,
            max: max,
            activeColor: AppColors.accentBlue,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  void _updateRisk(WidgetRef ref, String key, double value) async {
    ref.read(riskSettingsStateProvider.notifier).update(key, value);
    
    // Sync to backend
    try {
      final mode = ref.read(tradingModeStateProvider);
      final pairs = ref.read(activePairsStateProvider);
      final risk = ref.read(riskSettingsStateProvider);
      await ref.read(backendServiceProvider).postSettings(mode, pairs, risk);
    } catch (e) {
      logger.e("Risk sync failed: $e");
    }
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
        final config = snapshot.data;
        final url = config?['url'] ?? "Not configured";
        
        return Card(
          child: ListTile(
            leading: const Icon(Icons.dns, color: AppColors.accentBlue),
            title: Text(url, style: const TextStyle(fontSize: 14)),
            subtitle: const Text("Backend Connection"),
            trailing: TextButton(
              onPressed: () => context.push('/login'),
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
        final typeName = type?.name.toUpperCase() ?? "NOT CONNECTED";
        return Card(
          child: ListTile(
            leading: const Icon(Icons.account_balance, color: AppColors.accentBlue),
            title: Text(typeName, style: const TextStyle(fontSize: 14)),
            subtitle: const Text("Trading Broker"),
            trailing: TextButton(
              onPressed: () => context.push('/login'),
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
                    final risk = ref.read(riskSettingsStateProvider);
                    await ref.read(backendServiceProvider).postSettings(mode, pairs, risk);
                  } catch (e) {
                    logger.e("Failed to update trading mode: $e");
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
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
                  if (newPairs.length > 1) newPairs.remove(pair);
                }
                await ref.read(activePairsStateProvider.notifier).setPairs(newPairs);
                final mode = ref.read(tradingModeStateProvider);
                final risk = ref.read(riskSettingsStateProvider);
                await ref.read(backendServiceProvider).postSettings(mode, newPairs, risk);
              } catch (e) {
                logger.e("Failed to update active pairs: $e");
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
        ],
      ),
    );
  }

  Widget _buildNotifySwitch(String title, bool value) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontSize: 14)),
      value: value,
      onChanged: (val) {},
      activeColor: AppColors.accentBlue,
    );
  }

  Widget _buildSystemInfo(BuildContext context, WidgetRef ref, Map<String, dynamic> status) {
    final models = status['models'] as Map<String, dynamic>? ?? {};
    
    return Card(
      child: Column(
        children: [
          ...models.entries.map((e) => ListTile(
            dense: true,
            title: Text(e.key, style: const TextStyle(fontSize: 11)),
            trailing: Text(e.value.toString(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.accentBlue)),
          )),
          const Divider(),
          ListTile(
            title: const Text("Retrain AI Brain", style: TextStyle(fontSize: 13)),
            trailing: ElevatedButton(
              onPressed: () => ref.read(backendServiceProvider).postRetrain(),
              child: const Text("TRIGGER"),
            ),
          ),
          ListTile(
            title: const Text("Reset App Configuration", style: TextStyle(color: AppColors.sellRed, fontSize: 13)),
            onTap: () async {
              await ref.read(storageServiceProvider).clearAll();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}
