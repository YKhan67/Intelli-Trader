import pandas as pd
from typing import List, Dict, Any, Optional
from datetime import datetime
import uuid
from backend.modules.models import TradeRecord, BackendSignal, SignalAction, OrderStatus, ExitReason

class TradeSimulator:
    def __init__(self, config: Dict[str, Any]):
        self.config = config.get('backtesting', {})
        self.commission = self.config.get('commission_per_lot_round_trip', 7.0)
        self.open_trades = []
        self.closed_trades = []
        self.pip_value = 10.0 # Default
        self.pip_size = 0.0001 # Default

    def simulate(self, ohlcv_df: pd.DataFrame, signals: List[BackendSignal]):
        """
        Simulates trading based on signals and OHLCV data.
        """
        # Map signals by timestamp for easy lookup during bar iteration
        signal_map = {s.generated_at: s for s in signals}
        
        for ts, bar in ohlcv_df.iterrows():
            # 1. Update Open Trades (Check SL/TP/Partial)
            self._update_trades(ts, bar)
            
            # 2. Check for New Signal
            signal = signal_map.get(ts)
            if signal and signal.trade_decision.action != SignalAction.HOLD:
                self._open_trade(ts, bar, signal)

        return self.closed_trades

    def _update_trades(self, ts: datetime, bar: pd.Series):
        for trade in self.open_trades[:]:
            # Simple simulation: check if high/low touched SL/TP
            exit_price = None
            exit_reason = None
            
            # Partial Close Check (Simplified)
            if not trade.get('partial_closed') and trade.get('partial_price'):
                if (trade['direction'] == 'LONG' and bar['high'] >= trade['partial_price']) or \
                   (trade['direction'] == 'SHORT' and bar['low'] <= trade['partial_price']):
                    # Simulate closing 50%
                    trade['partial_closed'] = True
                    trade['stop_loss'] = trade['entry_price'] # Move to breakeven
            
            # Stop Loss Check
            if (trade['direction'] == 'LONG' and bar['low'] <= trade['stop_loss']) or \
               (trade['direction'] == 'SHORT' and bar['high'] >= trade['stop_loss']):
                exit_price = trade['stop_loss']
                exit_reason = ExitReason.STOP_LOSS
                
            # Take Profit Check
            elif (trade['direction'] == 'LONG' and bar['high'] >= trade['take_profit']) or \
                 (trade['direction'] == 'SHORT' and bar['low'] <= trade['take_profit']):
                exit_price = trade['take_profit']
                exit_reason = ExitReason.TAKE_PROFIT

            if exit_price:
                self._close_trade(trade, ts, exit_price, exit_reason)

    def _open_trade(self, ts: datetime, bar: pd.Series, signal: BackendSignal):
        # Prevent multiple trades if one is already open (simplified)
        if any(t['pair'] == signal.pair for t in self.open_trades):
            return

        decision = signal.trade_decision
        
        # Apply Slippage from config
        slippage_pips = self.config.get('slippage_pips', {}).get(decision.timeframe, 0.5)
        slippage_price = slippage_pips * self.pip_size
        
        entry_price = decision.entry_price
        if decision.action == SignalAction.BUY:
            entry_price += slippage_price
        else:
            entry_price -= slippage_price

        trade = {
            "trade_uuid": uuid.uuid4(),
            "pair": signal.pair,
            "direction": "LONG" if decision.action == SignalAction.BUY else "SHORT",
            "entry_price": entry_price,
            "entry_time": ts,
            "lot_size": decision.lot_size,
            "stop_loss": decision.stop_loss,
            "take_profit": decision.take_profit,
            "partial_price": getattr(signal.risk_params, 'partial_close_price', None),
            "partial_closed": False,
            "strategy": decision.strategy,
            "regime": signal.regime_result.regime if signal.regime_result else "UNKNOWN",
            "timeframe": decision.timeframe,
            "session": decision.session
        }
        self.open_trades.append(trade)

    def _close_trade(self, trade: Dict, ts: datetime, exit_price: float, reason: ExitReason):
        # Calculate P&L
        pip_factor = 1.0 / self.pip_size
        pips = (exit_price - trade['entry_price']) * pip_factor if trade['direction'] == 'LONG' else (trade['entry_price'] - exit_price) * pip_factor
        
        # Dollar Profit (lot_size * pips * pip_value_at_1_lot)
        profit = trade['lot_size'] * pips * self.pip_value
        
        # Deduct Commission
        commission_cost = trade['lot_size'] * self.commission
        net_profit = profit - commission_cost
        
        record = TradeRecord(
            trade_uuid=trade['trade_uuid'],
            broker_order_id="BT-SIM",
            pair=trade['pair'],
            strategy=trade['strategy'],
            regime=trade['regime'],
            trade_type="PAPER",
            direction=trade['direction'],
            timeframe=trade['timeframe'],
            session=trade['session'],
            entry_price=trade['entry_price'],
            entry_time=trade['entry_time'],
            lot_size=trade['lot_size'],
            stop_loss=trade['stop_loss'],
            take_profit=trade['take_profit'],
            exit_price=exit_price,
            exit_time=ts,
            exit_reason=reason,
            pips_result=pips,
            profit_loss=profit,
            net_profit_loss=net_profit,
            confidence_at_entry=0.8, # Placeholder
            status=OrderStatus.CLOSED
        )
        
        self.closed_trades.append(record)
        self.open_trades.remove(trade)
