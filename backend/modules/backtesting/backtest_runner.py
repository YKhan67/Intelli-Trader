import asyncio
import pandas as pd
import yaml
import os
import logging
from datetime import datetime, timezone
from typing import List, Dict, Any, Optional

from backend.modules.decision.decision_engine import DecisionEngine
from .data_replay import DataReplay
from .trade_simulator import TradeSimulator
from .metrics_calculator import MetricsCalculator
from .walk_forward import WalkForwardOptimizer
from .monte_carlo import MonteCarloSimulator
from .decay_detector import StrategyDecayDetector

logger = logging.getLogger("BacktestRunner")

class BacktestRunner:
    def __init__(self):
        config_path = os.path.join(os.path.dirname(__file__), "../../config/learning.yaml")
        with open(config_path, "r") as f:
            self.config = yaml.safe_load(f)
            
        self.decision_engine = DecisionEngine()
        self.replay = DataReplay(self.config, self.decision_engine)
        self.simulator = TradeSimulator(self.config)
        self.metrics_calc = MetricsCalculator()
        self.wfo = WalkForwardOptimizer(self.config)
        self.mc = MonteCarloSimulator(self.config)
        self.decay = StrategyDecayDetector(self.config)

    async def run_full_backtest(self, 
                                start_date: datetime, 
                                end_date: datetime, 
                                pairs: List[str], 
                                timeframe: str = "H1",
                                starting_balance: float = 10000.0) -> Dict[str, Any]:
        """
        Runs complete backtest suite including WFO, MC, and Decay.
        """
        logger.info(f"Starting Backtest: {start_date.date()} to {end_date.date()} for {pairs} ({timeframe})")
        
        # 1. Fetch data from DB
        from backend.database.postgres import AsyncSessionLocal
        from backend.database.models_db import OHLCVBarDB, IndicatorDB, CurrencyPairDB
        from sqlalchemy import select, and_

        all_trades = []
        
        async with AsyncSessionLocal() as session:
            for pair in pairs:
                logger.info(f"Fetching history for {pair}...")
                # Get Pair Info
                pair_rec = (await session.execute(select(CurrencyPairDB).where(CurrencyPairDB.symbol == pair))).scalar()
                if not pair_rec: 
                    logger.error(f"Pair {pair} not found in database.")
                    continue

                # Fetch OHLCV + Indicators
                stmt = select(OHLCVBarDB, IndicatorDB.data).join(
                    IndicatorDB, OHLCVBarDB.id == IndicatorDB.bar_id
                ).where(
                    and_(
                        OHLCVBarDB.pair_id == pair_rec.id,
                        OHLCVBarDB.timeframe == timeframe,
                        OHLCVBarDB.timestamp >= start_date,
                        OHLCVBarDB.timestamp <= end_date
                    )
                ).order_by(OHLCVBarDB.timestamp.asc())
                
                result = await session.execute(stmt)
                rows = result.all()
                
                if not rows:
                    logger.warning(f"No data found for {pair} {timeframe} in requested range.")
                    continue

                ohlcv_df = pd.DataFrame([{
                    'close': r[0].close, 'high': r[0].high, 'low': r[0].low, 
                    'open': r[0].open, 'volume': r[0].volume, 'timestamp': r[0].timestamp,
                    'spread_pips': r[0].spread_pips
                } for r in rows])
                ohlcv_df.set_index('timestamp', inplace=True)
                
                indicator_df = pd.DataFrame([r[1] for r in rows])
                indicator_df.index = ohlcv_df.index
                
                # Fetch SMC zones
                from backend.modules.models import SMCZone
                from backend.database.models_db import SMCZoneDB
                
                zone_stmt = select(SMCZoneDB).where(
                    and_(
                        SMCZoneDB.pair_id == pair_rec.id,
                        SMCZoneDB.timeframe == timeframe
                    )
                )
                zones_res = await session.execute(zone_stmt)
                active_zones = [SMCZone(
                    id=z.id, pair=pair, timeframe=z.timeframe, zone_type=z.zone_type,
                    price_high=z.price_high, price_low=z.price_low, formed_at=z.formed_at,
                    is_active=z.is_active, is_mitigated=z.is_mitigated, strength=z.strength
                ) for z in zones_res.scalars().all()]
                
                logger.info(f"Replaying {len(ohlcv_df)} bars for {pair}...")
                # Replay and generate signals
                signals = await self.replay.replay(pair, timeframe, ohlcv_df, indicator_df, active_zones, starting_balance)
                
                # Simulate trading
                self.simulator.pip_value = pair_rec.pip_value
                self.simulator.pip_size = pair_rec.pip_size

                pair_trades = self.simulator.simulate(ohlcv_df, signals)
                all_trades.extend(pair_trades)

        # 2. Calculate Overall Metrics
        metrics = self.metrics_calc.calculate_metrics(all_trades, starting_balance)
        
        # 3. Monte Carlo
        mc_results = self.mc.run_simulation(all_trades, starting_balance)
        
        # 4. Decay Detection
        decay_alerts = self.decay.detect_decay(all_trades)
        
        # 5. Recommendation Logic
        recommendation = "READY_FOR_LIVE"
        reasons = []
        
        metrics_cfg = self.config.get('backtesting', {})
        min_wr = metrics_cfg.get('recommendation_thresholds', {}).get('min_win_rate', 0.45)
        max_dd = metrics_cfg.get('recommendation_thresholds', {}).get('max_drawdown', 20.0)
        min_sharpe = metrics_cfg.get('recommendation_thresholds', {}).get('min_sharpe', 1.0)
        
        if metrics.get('win_rate', 0) < min_wr:
            recommendation = "NEEDS_RETRAINING"
            reasons.append(f"Overall win rate {metrics.get('win_rate', 0):.2%} below threshold {min_wr:.2%}.")
        if abs(metrics.get('max_drawdown_pct', 0)) > max_dd:
            recommendation = "NEEDS_RETRAINING"
            reasons.append(f"Max drawdown {metrics.get('max_drawdown_pct', 0)}% exceeds limit {max_dd}%.")
        if metrics.get('sharpe_ratio', 0) < min_sharpe:
            recommendation = "NEEDS_RETRAINING"
            reasons.append(f"Sharpe ratio {metrics.get('sharpe_ratio', 0)} below target {min_sharpe}.")
        if mc_results.get('worst_case_drawdown_95', 0) > max_dd:
             # Already covered by drawdown check usually but MC is more conservative
             if recommendation == "READY_FOR_LIVE":
                recommendation = "NEEDS_RETRAINING"
                reasons.append("Risk of ruin too high in Monte Carlo simulation.")

        results = {
            "metrics": metrics,
            "monte_carlo": mc_results,
            "decay_alerts": decay_alerts,
            "recommendation": recommendation,
            "reasons": reasons,
            "trade_count": len(all_trades)
        }
        
        # 6. Export Results
        self._export_results(results, all_trades)
        
        return results

    def _export_results(self, results: Dict, trades: List):
        export_dir = "data/backtest"
        if not os.path.exists(export_dir): os.makedirs(export_dir)
        
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        # Save as JSON
        import json
        
        def default_serializer(obj):
            if isinstance(obj, datetime):
                return obj.isoformat()
            if hasattr(obj, 'model_dump'):
                return obj.model_dump()
            return str(obj)

        with open(f"{export_dir}/backtest_{timestamp}.json", "w") as f:
            json.dump(results, f, indent=4, default=default_serializer)
            
        # Also save CSV of trades
        if trades:
            df = pd.DataFrame([t.model_dump() if hasattr(t, 'model_dump') else t for t in trades])
            df.to_csv(f"{export_dir}/trades_{timestamp}.csv", index=False)
            
        logger.info(f"Results exported to {export_dir}")
