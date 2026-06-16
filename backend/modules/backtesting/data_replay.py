import pandas as pd
import asyncio
import logging
from datetime import datetime, timedelta
from typing import List, Dict, Any, Optional
from backend.modules.decision.decision_engine import DecisionEngine
from backend.modules.models import BackendSignal, Timeframe

logger = logging.getLogger("DataReplay")

class DataReplay:
    def __init__(self, config: Dict[str, Any], engine: DecisionEngine):
        self.config = config.get('backtesting', {})
        self.engine = engine
        self.slippage_map = self.config.get('slippage_pips', {})

    async def replay(self, 
                    pair: str, 
                    timeframe: str, 
                    ohlcv_df: pd.DataFrame, 
                    indicator_df: pd.DataFrame,
                    active_zones_history: List[Any],
                    account_balance: float) -> List[BackendSignal]:
        """
        Replays historical bars and generates signals.
        Enforces no-lookahead by slicing data.
        """
        signals = []
        total_bars = len(ohlcv_df)
        
        # We start from bar 200 to allow indicators to warm up
        start_idx = 200
        
        for i in range(start_idx, total_bars):
            # 1. Slice data up to current bar (inclusive)
            current_ohlcv = ohlcv_df.iloc[:i+1]
            current_indicators = indicator_df.iloc[i].to_dict()
            
            # Current timestamp for logging
            current_ts = ohlcv_df.index[i]
            
            if i % 500 == 0:
                logger.info(f"Processing {pair} {timeframe}: {current_ts.date()} | Bars: {i}/{total_bars}")

            # 2. Extract active zones as they were at this timestamp
            current_zones = [z for z in active_zones_history if z.formed_at <= current_ts and (not z.is_mitigated or z.mitigated_at > current_ts)]

            # 3. Call Decision Engine
            try:
                signal = await self.engine.run_pipeline(
                    pair=pair,
                    df=current_ohlcv,
                    indicators=current_indicators,
                    active_zones=current_zones,
                    account_balance=account_balance,
                    open_trades=[], 
                    trading_mode="backtest"
                )
                
                # 4. Filter Signals
                if signal.trade_decision.action != "HOLD":
                    logger.debug(f"Signal generated at {current_ts}: {signal.trade_decision.action}")
                    signals.append(signal)
                    
            except Exception as e:
                logger.error(f"Error at bar {i} ({current_ts}): {e}")
                continue

        return signals
