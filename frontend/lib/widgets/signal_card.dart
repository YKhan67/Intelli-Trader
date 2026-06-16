import 'package:flutter/material.dart';
import '../models/signal.dart';
import '../models/enums.dart';
import '../theme/app_theme.dart';

class SignalCard extends StatelessWidget {
  final BackendSignal signal;
  final VoidCallback onTap;

  const SignalCard({super.key, required this.signal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final decision = signal.tradeDecision;
    final action = decision.action;
    final Color color = action == SignalAction.buy 
        ? Colors.green 
        : action == SignalAction.sell 
            ? Colors.red 
            : Colors.grey;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(signal.pair, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                    child: Text(action.name.toUpperCase(), style: TextStyle(color: color, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text("${(decision.confidence * 100).toInt()}% Confidence", style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(decision.strategy.name.toUpperCase(), style: const TextStyle(fontSize: 10, color: Colors.blueGrey)),
                  Text(decision.timeframe.name.toUpperCase(), style: const TextStyle(fontSize: 10, color: Colors.blueGrey)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
