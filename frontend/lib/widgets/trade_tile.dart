import 'package:flutter/material.dart';
import 'package:forex_ai_frontend/models/models.dart';
import 'package:forex_ai_frontend/theme/colors.dart';

class TradeTile extends StatelessWidget {
  final TradeRecord trade;

  const TradeTile({super.key, required this.trade});

  @override
  Widget build(BuildContext context) {
    final profit = trade.netProfitLoss ?? 0;
    final isProfit = profit >= 0;
    final color = isProfit ? AppColors.buyGreen : AppColors.sellRed;
    final directionColor = trade.direction == Direction.long ? AppColors.buyGreen : AppColors.sellRed;

    return ListTile(
      leading: Container(
        width: 4,
        color: directionColor,
      ),
      title: Row(
        children: [
          Text(trade.pair.displayName, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Text(
            trade.direction.name.toUpperCase(), 
            style: TextStyle(fontSize: 12, color: directionColor),
          ),
        ],
      ),
      subtitle: Text("${trade.lotSize} Lots @ ${trade.entryPrice.toStringAsFixed(5)}"),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "${profit > 0 ? '+' : ''}${profit.toStringAsFixed(2)} USD",
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            "${trade.pipsResult?.toStringAsFixed(1) ?? '0.0'} Pips",
            style: TextStyle(color: color, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
