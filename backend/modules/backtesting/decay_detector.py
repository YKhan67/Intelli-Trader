import pandas as pd
from typing import List, Dict, Any
from backend.modules.models import TradeRecord

class StrategyDecayDetector:
    def __init__(self, config: Dict[str, Any]):
        self.threshold = config.get('backtesting', {}).get('decay_threshold', 0.40)
        self.window = config.get('backtesting', {}).get('decay_window_days', 30)

    def detect_decay(self, trades: List[TradeRecord]) -> List[Dict[str, Any]]:
        """
        Detects if a strategy's performance is degrading.
        """
        if not trades: return []

        df = pd.DataFrame([t.model_dump() for t in trades])
        df['exit_time'] = pd.to_datetime(df['exit_time'])
        df.set_index('exit_time', inplace=True)
        
        alerts = []
        strategies = df['strategy'].unique()
        
        for strat in strategies:
            strat_trades = df[df['strategy'] == strat]
            # Rolling win rate
            rolling_wr = strat_trades['pips_result'].apply(lambda x: 1 if x > 0 else 0).rolling('30D').mean()
            
            latest_wr = rolling_wr.iloc[-1]
            if latest_wr < self.threshold:
                alerts.append({
                    "strategy": strat,
                    "latest_win_rate": latest_wr,
                    "status": "DECAY_DETECTED",
                    "reason": f"Win rate {latest_wr:.2%} dropped below threshold {self.threshold:.2%}"
                })
                
        return alerts
