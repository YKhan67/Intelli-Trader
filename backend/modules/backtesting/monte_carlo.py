import numpy as np
from typing import List, Dict, Any
from backend.modules.models import TradeRecord

class MonteCarloSimulator:
    def __init__(self, config: Dict[str, Any]):
        self.BT_CFG = config.get('backtesting', {}).get('monte_carlo', {})
        self.simulations = self.BT_CFG.get('simulations', 1000)
        self.confidence = self.BT_CFG.get('confidence_level', 0.95)

    def run_simulation(self, trades: List[TradeRecord], starting_balance: float) -> Dict[str, Any]:
        """
        Runs Monte Carlo simulation by shuffling trade order.
        """
        if not trades: return {}

        results = [t.net_profit_loss for t in trades]
        max_drawdowns = []

        for _ in range(self.simulations):
            # Shuffle results
            shuffled = np.random.permutation(results)
            
            # Calculate equity curve
            equity = starting_balance + np.cumsum(shuffled)
            
            # Calculate DD
            peak = np.maximum.accumulate(equity)
            drawdown = (equity - peak) / peak
            max_drawdowns.append(np.min(drawdown))

        # 95th Percentile DD
        worst_case_dd = np.percentile(max_drawdowns, (1 - self.confidence) * 100)

        return {
            "simulations_run": self.simulations,
            "median_max_drawdown": round(np.median(max_drawdowns) * 100, 2),
            "worst_case_drawdown_95": round(worst_case_dd * 100, 2),
            "profitable_sims_pct": round(len([d for d in max_drawdowns if d > -0.20]) / self.simulations * 100, 2)
        }
