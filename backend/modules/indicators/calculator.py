import pandas as pd
import yaml
import os
import logging
from typing import Dict, Any, List
from sqlalchemy import select, and_
from sqlalchemy.dialects.postgresql import insert as pg_insert
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import OHLCVBarDB, IndicatorDB, CurrencyPairDB

from .trend import calculate_trend_indicators
from .momentum import calculate_momentum_indicators
from .volatility import calculate_volatility_indicators

logger = logging.getLogger("IndicatorCalculator")

class IndicatorCalculator:
    def __init__(self):
        config_path = os.path.join(os.path.dirname(__file__), "../../config/indicators.yaml")
        with open(config_path, "r") as f:
            self.config = yaml.safe_load(f)

    async def calculate_all(self, pair: str, timeframe: str, lookback_bars: int = 500):
        """
        Calculates all indicators for a given pair and timeframe.
        Used for Section 2 (Live).
        """
        async with AsyncSessionLocal() as session:
            stmt = select(CurrencyPairDB.id).where(CurrencyPairDB.symbol == pair)
            res = await session.execute(stmt)
            pair_id = res.scalar()
            if not pair_id: return None

            stmt = select(OHLCVBarDB).where(
                and_(OHLCVBarDB.pair_id == pair_id, OHLCVBarDB.timeframe == timeframe)
            ).order_by(OHLCVBarDB.timestamp.desc()).limit(lookback_bars)
            
            result = await session.execute(stmt)
            bars = result.scalars().all()
            if len(bars) < 100: return None

            bars = bars[::-1]
            df = pd.DataFrame([{
                'id': b.id, 'timestamp': b.timestamp, 'open': b.open, 'high': b.high, 
                'low': b.low, 'close': b.close, 'volume': b.volume
            } for b in bars])
            df.set_index('timestamp', inplace=True)

            t_df = calculate_trend_indicators(df, self.config.get('trend', {}))
            m_df = calculate_momentum_indicators(df, self.config.get('momentum', {}))
            v_df = calculate_volatility_indicators(df, self.config.get('volatility', {}))
            
            final_df = pd.concat([t_df, m_df, v_df], axis=1)
            final_df['bar_id'] = df['id']

            rows = []
            for _, row in final_df.iterrows():
                bid = row.pop('bar_id')
                clean = {k: (None if pd.isna(v) else float(v)) for k, v in row.items()}
                rows.append({"bar_id": int(bid), "data": clean})

            for chunk in self._chunk_list(rows, 100):
                stmt = pg_insert(IndicatorDB).values(chunk)
                stmt = stmt.on_conflict_do_update(index_elements=[IndicatorDB.bar_id], set_={"data": stmt.excluded.data})
                await session.execute(stmt)
            await session.commit()
            return True

    async def calculate_bulk(self, pair: str, timeframe: str, chunk_size: int = 10000):
        """
        Calculates all indicators for the entire historical range.
        Used for Section 1 (The Brain).
        """
        async with AsyncSessionLocal() as session:
            stmt = select(CurrencyPairDB.id).where(CurrencyPairDB.symbol == pair)
            pair_id = (await session.execute(stmt)).scalar()
            if not pair_id: return

            stmt = select(OHLCVBarDB).where(
                and_(OHLCVBarDB.pair_id == pair_id, OHLCVBarDB.timeframe == timeframe)
            ).order_by(OHLCVBarDB.timestamp.asc())
            
            res = await session.execute(stmt)
            all_bars = res.scalars().all()
            if not all_bars: return

            logger.info(f"    [INDICATORS] Processing {len(all_bars)} bars for {pair} {timeframe}...")
            
            warmup = 300
            for i in range(0, len(all_bars), chunk_size):
                s_idx = i - warmup if i >= warmup else 0
                e_idx = i + chunk_size
                chunk = all_bars[s_idx:e_idx]
                
                df = pd.DataFrame([{
                    'id': b.id, 'timestamp': b.timestamp, 'open': b.open, 
                    'high': b.high, 'low': b.low, 'close': b.close, 'volume': b.volume
                } for b in chunk])
                df.set_index('timestamp', inplace=True)

                t_df = calculate_trend_indicators(df, self.config.get('trend', {}))
                m_df = calculate_momentum_indicators(df, self.config.get('momentum', {}))
                v_df = calculate_volatility_indicators(df, self.config.get('volatility', {}))
                
                res_df = pd.concat([t_df, m_df, v_df], axis=1)
                res_df['bar_id'] = df['id']
                
                save_df = res_df.iloc[warmup:] if i >= warmup else res_df
                
                rows = []
                for _, row in save_df.iterrows():
                    bid = row.pop('bar_id')
                    clean = {k: (None if pd.isna(v) else float(v)) for k, v in row.items()}
                    rows.append({"bar_id": int(bid), "data": clean})

                if rows:
                    stmt = pg_insert(IndicatorDB).values(rows)
                    stmt = stmt.on_conflict_do_update(index_elements=[IndicatorDB.bar_id], set_={"data": stmt.excluded.data})
                    await session.execute(stmt)
                    await session.commit()
            
            logger.info(f"    [DONE] Indicators stored for {pair} {timeframe}.")

    def _chunk_list(self, lst, n):
        for i in range(0, len(lst), n):
            yield lst[i:i + n]
