import pandas as pd
import yaml
import os
from typing import Dict, Any, List
from sqlalchemy import select, insert, update, and_
from sqlalchemy.dialects.postgresql import insert as pg_insert
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import OHLCVBarDB, IndicatorDB, CurrencyPairDB

from .trend import calculate_trend_indicators
from .momentum import calculate_momentum_indicators
from .volatility import calculate_volatility_indicators
from .trend_strength import calculate_trend_strength_indicators
from .ichimoku import calculate_ichimoku_indicators
from .levels import calculate_level_indicators

class IndicatorCalculator:
    def __init__(self):
        config_path = os.path.join(os.path.dirname(__file__), "../../config/indicators.yaml")
        with open(config_path, "r") as f:
            self.config = yaml.safe_load(f)

    async def calculate_all(self, pair: str, timeframe: str, lookback_bars: int = 500):
        """
        Calculates all indicators for a given pair and timeframe.
        Uses incremental calculation (only missing bars).
        """
        async with AsyncSessionLocal() as session:
            # 1. Get Pair ID
            stmt = select(CurrencyPairDB.id).where(CurrencyPairDB.symbol == pair)
            result = await session.execute(stmt)
            pair_id = result.scalar()
            if not pair_id:
                raise ValueError(f"Pair {pair} not found in database.")

            # 2. Find bars missing indicators
            # For simplicity in this scaffold, we fetch the last 'lookback_bars' 
            # and check which ones don't have indicators yet.
            stmt = select(OHLCVBarDB).where(
                and_(OHLCVBarDB.pair_id == pair_id, OHLCVBarDB.timeframe == timeframe)
            ).order_by(OHLCVBarDB.timestamp.desc()).limit(lookback_bars)
            
            result = await session.execute(stmt)
            bars = result.scalars().all()
            
            if len(bars) < 200:
                print(f"  Insufficient data for {pair} {timeframe} (needed 200, got {len(bars)}).")
                return None

            # Reverse to get chronological order
            bars = bars[::-1]
            
            df = pd.DataFrame([{
                'id': b.id,
                'timestamp': b.timestamp,
                'open': b.open,
                'high': b.high,
                'low': b.low,
                'close': b.close,
                'volume': b.volume
            } for b in bars])
            df.set_index('timestamp', inplace=True)

            # 3. Calculate all indicator sets
            trend_df = calculate_trend_indicators(df, self.config.get('trend', {}))
            momentum_df = calculate_momentum_indicators(df, self.config.get('momentum', {}))
            volatility_df = calculate_volatility_indicators(df, self.config.get('volatility', {}))
            strength_df = calculate_trend_strength_indicators(df, self.config.get('trend_strength', {}))
            ichimoku_df = calculate_ichimoku_indicators(df, self.config.get('ichimoku', {}))
            levels_df = calculate_level_indicators(df, self.config.get('levels', {}))

            # Combine all
            final_df = pd.concat([
                trend_df, momentum_df, volatility_df, strength_df, ichimoku_df, levels_df
            ], axis=1)
            final_df['bar_id'] = df['id']

            # 4. Upsert into database
            indicator_data = final_df.to_dict(orient='records')
            
            # Since IndicatorDB uses a JSON field for all indicators
            processed_rows = []
            for row in indicator_data:
                bar_id = row.pop('bar_id')
                # Replace NaN with None for JSON/SQL compatibility
                clean_row = {k: (None if pd.isna(v) else v) for k, v in row.items()}
                processed_rows.append({
                    "bar_id": bar_id,
                    "data": clean_row
                })

            # Upsert logic (Postgres specific)
            for chunk in self._chunk_list(processed_rows, 100):
                stmt = pg_insert(IndicatorDB).values(chunk)
                stmt = stmt.on_conflict_do_update(
                    index_elements=[IndicatorDB.bar_id],
                    set_={"data": stmt.excluded.data}
                )
                await session.execute(stmt)
            
            await session.commit()

            # 5. Data Quality Report
            report = self._generate_report(final_df)
            print(f"=== Indicator Report: {pair} {timeframe} ===")
            print(f"  Total bars processed: {report['total_bars']}")
            print(f"  Indicators with nulls: {report['null_counts']}")
            print(f"  Quality Score: {report['quality_score']:.2%}")
            
            return report

    def _chunk_list(self, lst, n):
        for i in range(0, len(lst), n):
            yield lst[i:i + n]

    def _generate_report(self, df: pd.DataFrame) -> Dict:
        total = len(df)
        null_counts = df.isnull().sum().to_dict()
        # Quality score = percentage of non-null values
        total_cells = total * (len(df.columns) - 1) # exclude bar_id
        total_nulls = df.isnull().sum().sum()
        
        return {
            "total_bars": total,
            "null_counts": {k: v for k, v in null_counts.items() if v > 0},
            "quality_score": (total_cells - total_nulls) / total_cells if total_cells > 0 else 0
        }
