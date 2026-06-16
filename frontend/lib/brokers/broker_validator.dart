import '../models/models.dart';
import 'broker_factory.dart';

class ValidationResult {
  final bool passed;
  final List<String> errors;

  ValidationResult({required this.passed, required this.errors});
}

/// Validates broker connectivity and account state before any order.
class BrokerValidator {
  
  /// Checks if an order can be placed based on account state.
  static ValidationResult validate({
    required AccountInfo account,
    required double requiredMargin,
    double currentSpread = 0.0,
    double maxAllowedSpread = 5.0,
  }) {
    final List<String> errors = [];

    // 1. Check Connection
    final broker = BrokerFactory.instance;
    if (broker == null || !broker.isConnected) {
      errors.add("Broker is not connected.");
    }

    // 2. Check Sufficient Margin
    if (account.freeMargin < requiredMargin) {
      errors.add("Insuificient free margin. Required: \${requiredMargin.toStringAsFixed(2)}, Available: \${account.freeMargin.toStringAsFixed(2)}");
    }

    // 3. Check Margin Call State
    // Typically if margin level is below 100%, we are in trouble.
    if (account.marginLevel > 0 && account.marginLevel < 100) {
      errors.add("Account is in margin call state (Level: \${account.marginLevel.toStringAsFixed(2)}%).");
    }

    // 4. Check Spread
    if (currentSpread > maxAllowedSpread) {
      errors.add("Spread too high: \${currentSpread.toStringAsFixed(1)} pips (Max: \$maxAllowedSpread).");
    }

    return ValidationResult(
      passed: errors.isEmpty,
      errors: errors,
    );
  }
}
