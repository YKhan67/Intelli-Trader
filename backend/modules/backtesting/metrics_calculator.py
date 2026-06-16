import pandas as pd
import numpy as np
from typing import List, Dict, Any
from backend.modules.models import TradeRecord

class MetricsCalculator:
    def calculate_metrics(self, trades: List[TradeRecord], starting_balance: float) -> Dict[str, Any]:
        """
        Calculates all performance metrics from trade list.
        """
        if not trades:
            return {"total_trades": 0, "net_pnl": 0}

        # Convert to DataFrame for easier calculation
        df = pd.DataFrame([t.model_dump() for t in trades])
        
        total_trades = len(df)
        wins = df[df['pips_result'] > 0]
        losses = df[df['pips_result'] <= 0]
        
        win_rate = len(wins) / total_trades if total_trades > 0 else 0
        
        gross_profit = wins['net_profit_loss'].sum()
        gross_loss = abs(losses['net_profit_loss'].sum())
        net_pnl = df['net_profit_loss'].sum()
        
        profit_factor = gross_profit / gross_loss if gross_loss > 0 else float('inf')
        
        # Drawdown calculation
        df['equity'] = starting_balance + df['net_profit_loss'].cumsum()
        df['peak'] = df['equity'].cummax()
        df['drawdown'] = (df['equity'] - df['peak']) / df['peak']
        max_drawdown = df['drawdown'].min()
        
        # Sharpe Ratio (Simplified Annualized)
        # We'll use daily returns if possible, but here we use per-trade returns as proxy
        daily_returns = df.set_index('exit_time')['net_profit_loss'].resample('D').sum() / starting_balance
        sharpe = (daily_returns.mean() / daily_returns.std() * np.sqrt(252)) if daily_returns.std() > 0 else 0

        return {
            "total_trades": total_trades,
            "win_rate": round(win_rate, 4),
            "gross_profit": round(gross_profit, 2),
            "gross_loss": round(gross_loss, 2),
            "net_pnl": round(net_pnl, 2),
            "profit_factor": round(profit_factor, 2),
            "max_drawdown_pct": round(max_drawdown * 100, 2),
            "sharpe_ratio": round(sharpe, 2),
            "avg_pips_win": round(wins['pips_result'].mean(), 2) if not wins.empty else 0,
            "avg_pips_loss": round(losses['pips_result'].mean(), 2) if not losses.empty else 0
        }
