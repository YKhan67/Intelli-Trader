import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'core_services.dart';
import 'connection_provider.dart';
import '../models/models.dart';

part 'account_provider.g.dart';

@Riverpod(keepAlive: true)
Future<AccountInfo?> accountInfo(AccountInfoRef ref) async {
  final brokerService = ref.watch(brokerServiceProvider);
  final brokerConn = ref.watch(brokerConnectionProvider);
  
  if (brokerService.activeBroker == null || brokerConn.status != ConnectionStatus.connected) {
    return null; // Return null instead of throwing
  }

  // Refresh every 5 seconds (Fast sync for balance/equity)
  final timer = Timer(const Duration(seconds: 5), () => ref.invalidateSelf());
  ref.onDispose(() => timer.cancel());

  try {
    return await brokerService.activeBroker!.getAccountInfo();
  } catch (e) {
    ref.read(brokerConnectionProvider.notifier).notifyFailure();
    return null;
  }
}

@riverpod
double balance(BalanceRef ref) => ref.watch(accountInfoProvider).value?.balance ?? 0.0;

@riverpod
double equity(EquityRef ref) => ref.watch(accountInfoProvider).value?.equity ?? 0.0;

@riverpod
double freeMargin(FreeMarginRef ref) => ref.watch(accountInfoProvider).value?.freeMargin ?? 0.0;
