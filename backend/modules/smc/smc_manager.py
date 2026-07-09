import pandas as pd
import yaml
import os
import logging
from typing import List, Dict, Any
from sqlalchemy import select, insert, update, and_
from sqlalchemy.dialects.postgresql import insert as pg_insert
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import CurrencyPairDB, OHLCVBarDB, SMCZoneDB, IndicatorDB
from backend.modules.models import SMCZone

from .order_blocks import detect_order_blocks
from .fair_value_gaps import detect_fvgs
from .structure import detect_structure
from .liquidity import detect_liquidity

logger = logging.getLogger("SMCManager")

class SMCManager:
    def __init__(self):
        config_path = os.path.join(os.path.dirname(__file__), "../../config/indicators.yaml")
        with open(config_path, "r") as f:
            self.config = yaml.safe_load(f).get('smc', {})

    async def update_zones(self, pair: str, timeframe: str, lookback_bars: int = 200):
        """
        Detects and updates all SMC zones. 
        Optimized for large historical data processing.
        """
        async with AsyncSessionLocal() as session:
            # 1. Fetch Pair ID
            stmt_pair = select(CurrencyPairDB.id).where(CurrencyPairDB.symbol == pair)
            pair_id = (await session.execute(stmt_pair)).scalar()
            if not pair_id: return []

            # 2. Fetch Data (Price + Indicators)
            stmt = select(OHLCVBarDB, IndicatorDB.data).join(
                IndicatorDB, OHLCVBarDB.id == IndicatorDB.bar_id
            ).where(
                and_(OHLCVBarDB.pair_id == pair_id, OHLCVBarDB.timeframe == timeframe)
            ).order_by(OHLCVBarDB.timestamp.desc()).limit(lookback_bars)
            
            result = await session.execute(stmt)
            rows = result.all()
            if len(rows) < 50: return []

            # Prepare DataFrames
            rows = rows[::-1] # Chronological
            df = pd.DataFrame([{
                "id": r[0].id, "timestamp": r[0].timestamp, "open": r[0].open,
                "high": r[0].high, "low": r[0].low, "close": r[0].close, "volume": r[0].volume
            } for r in rows])
            df.set_index('timestamp', inplace=True)
            
            indicators = pd.DataFrame([r[1] for r in rows])
            indicators.index = df.index

            # 3. Detect Zones (Pattern Matching)
            ob_zones = detect_order_blocks(df, indicators, self.config.get('order_blocks', {}))
            fvg_zones = detect_fvgs(df, self.config.get('fair_value_gaps', {}))
            structure_zones = detect_structure(df, self.config.get('structure', {}))
            liq_zones = detect_liquidity(df, self.config.get('liquidity', {}))

            all_detected = ob_zones + fvg_zones + structure_zones + liq_zones
            
            # 4. Mitigation Logic (Fast Batch Update)
            current_price = df['close'].iloc[-1]
            stmt_mitigate = update(SMCZoneDB).where(
                and_(
                    SMCZoneDB.pair_id == pair_id,
                    SMCZoneDB.timeframe == timeframe,
                    SMCZoneDB.is_active == True,
                    SMCZoneDB.price_low <= current_price,
                    SMCZoneDB.price_high >= current_price
                )
            ).values(is_active=False, is_mitigated=True)
            await session.execute(stmt_mitigate)
            
            # 5. Save New Zones (Bulk)
            if all_detected:
                db_ready = []
                for z in all_detected:
                    z['pair_id'] = pair_id
                    z['timeframe'] = timeframe
                    z['is_active'] = True
                    z['is_mitigated'] = False
                    db_ready.append(z)
                
                # Use insert(..).values(..) for async bulk performance
                await session.execute(insert(SMCZoneDB), db_ready)

            await session.commit()
            return await self.get_active_zones(pair, timeframe)

    async def get_active_zones(self, pair: str, timeframe: str) -> List[SMCZone]:
        async with AsyncSessionLocal() as session:
            stmt = select(SMCZoneDB).join(
                CurrencyPairDB, SMCZoneDB.pair_id == CurrencyPairDB.id
            ).where(
                and_(CurrencyPairDB.symbol == pair, SMCZoneDB.timeframe == timeframe, SMCZoneDB.is_active == True)
            )
            result = await session.execute(stmt)
            db_zones = result.scalars().all()
            
            return [SMCZone(
                id=str(z.id), pair=pair, timeframe=timeframe, zone_type=z.zone_type,
                price_high=z.price_high, price_low=z.price_low, formed_at=z.formed_at,
                is_active=z.is_active, is_mitigated=z.is_mitigated, strength=z.strength
            ) for z in db_zones]
