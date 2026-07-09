import pandas as pd
import yaml
import os
import logging
import numpy as np
import asyncio
from typing import Dict, Any, List, Optional
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
        High-performance windowed calculation for live cycles.
        """
        async with AsyncSessionLocal() as session:
            # 1. Get Pair ID
            stmt = select(CurrencyPairDB.id).where(CurrencyPairDB.symbol == pair.upper())
            pair_id = (await session.execute(stmt)).scalar()
            if not pair_id: return

            # 2. Fetch bars in window
            stmt = select(OHLCVBarDB).where(
                and_(OHLCVBarDB.pair_id == pair_id, OHLCVBarDB.timeframe == timeframe.upper())
            ).order_by(OHLCVBarDB.timestamp.desc()).limit(lookback_bars)
            
            res = await session.execute(stmt)
            bars = res.scalars().all()
            if not bars: return
            
            # Reverse to ascending for indicator math
            bars = bars[::-1]
            
            # 3. Vectorized Math
            df = pd.DataFrame([{
                'id': b.id, 'timestamp': b.timestamp, 'open': b.open, 
                'high': b.high, 'low': b.low, 'close': b.close, 'volume': b.volume
            } for b in bars])
            df.set_index('timestamp', inplace=True)

            t_df = calculate_trend_indicators(df, self.config.get('trend', {}))
            m_df = calculate_momentum_indicators(df, self.config.get('momentum', {}))
            v_df = calculate_volatility_indicators(df, self.config.get('volatility', {}))
            
            res_df = pd.concat([t_df, m_df, v_df], axis=1)
            res_df['bar_id'] = df['id']

            # 4. Atomic Upsert for the latest bars
            rows = []
            # We only really care about updating the last few bars in live mode
            # but we calculate on window for EMA accuracy
            update_window = min(len(res_df), 10) 
            for _, row in res_df.tail(update_window).iterrows():
                bid = row.pop('bar_id')
                if pd.isna(bid): continue
                
                clean_data = {k: (None if pd.isna(v) else float(v)) for k, v in row.items()}
                rows.append({"bar_id": int(bid), "data": clean_data})

            if rows:
                stmt = pg_insert(IndicatorDB).values(rows)
                stmt = stmt.on_conflict_do_update(
                    index_elements=[IndicatorDB.bar_id],
                    set_={"data": stmt.excluded.data}
                )
                await session.execute(stmt)
                await session.commit()

    async def calculate_bulk(self, pair: str, timeframe: str, chunk_size: int = 25000):
        """
        Memory-efficient bulk calculation for 10-year datasets.
        """
        async with AsyncSessionLocal() as session:
            stmt = select(CurrencyPairDB.id).where(CurrencyPairDB.symbol == pair.upper())
            pair_id = (await session.execute(stmt)).scalar()
            if not pair_id: return

            stmt = select(OHLCVBarDB).where(
                and_(OHLCVBarDB.pair_id == pair_id, OHLCVBarDB.timeframe == timeframe.upper())
            ).order_by(OHLCVBarDB.timestamp.asc())
            
            res = await session.execute(stmt)
            all_bars = res.scalars().all()
            if not all_bars: return

            logger.info(f"    [INDICATORS] Bulk processing {len(all_bars)} bars for {pair} {timeframe}")
            
            df = pd.DataFrame([{
                'id': b.id, 'timestamp': b.timestamp, 'open': b.open, 
                'high': b.high, 'low': b.low, 'close': b.close, 'volume': b.volume
            } for b in all_bars])
            df.set_index('timestamp', inplace=True)

            t_df = calculate_trend_indicators(df, self.config.get('trend', {}))
            m_df = calculate_momentum_indicators(df, self.config.get('momentum', {}))
            v_df = calculate_volatility_indicators(df, self.config.get('volatility', {}))
            
            res_df = pd.concat([t_df, m_df, v_df], axis=1)
            res_df['bar_id'] = df['id']
            
            rows = []
            for _, row in res_df.iterrows():
                bid = row.pop('bar_id')
                if pd.isna(bid): continue
                clean = {k: (None if pd.isna(v) else float(v)) for k, v in row.items()}
                rows.append({"bar_id": int(bid), "data": clean})

            if rows:
                for i in range(0, len(rows), chunk_size):
                    chunk = rows[i:i + chunk_size]
                    stmt = pg_insert(IndicatorDB).values(chunk)
                    stmt = stmt.on_conflict_do_update(
                        index_elements=[IndicatorDB.bar_id], 
                        set_={"data": stmt.excluded.data}
                    )
                    await session.execute(stmt)
                    await session.commit()
            
            logger.info(f"    [DONE] {pair} {timeframe} indicators ready.")
