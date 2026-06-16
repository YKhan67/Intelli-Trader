import asyncio
import os
import sys
import pandas as pd
from datetime import datetime, timezone
from sqlalchemy import select, insert, delete, and_

# Add project root to path
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if project_root not in sys.path:
    sys.path.append(project_root)

from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import OHLCVBarDB, CurrencyPairDB

async def resample_pair(symbol, target_tf, source_tf="M1"):
    print(f"Resampling {symbol} from {source_tf} to {target_tf}...")
    
    async with AsyncSessionLocal() as session:
        # Get Pair ID
        pair_id = (await session.execute(select(CurrencyPairDB.id).where(CurrencyPairDB.symbol == symbol))).scalar()
        if not pair_id: return

        # Fetch source data
        stmt = select(OHLCVBarDB).where(
            and_(OHLCVBarDB.pair_id == pair_id, OHLCVBarDB.timeframe == source_tf)
        ).order_by(OHLCVBarDB.timestamp.asc())
        
        result = await session.execute(stmt)
        rows = result.scalars().all()
        
        if not rows:
            print("No source data found.")
            return

        df = pd.DataFrame([{
            'timestamp': r.timestamp, 'open': r.open, 'high': r.high, 'low': r.low, 'close': r.close, 'volume': r.volume
        } for r in rows])
        df.set_index('timestamp', inplace=True)
        
        # Resample
        resample_map = {"M5": "5min", "M15": "15min", "M30": "30min", "H1": "1h", "H4": "4h"}
        rule = resample_map.get(target_tf)
        
        resampled = df.resample(rule).agg({
            'open': 'first', 'high': 'max', 'low': 'min', 'close': 'last', 'volume': 'sum'
        }).dropna()
        
        print(f"  Generated {len(resampled)} {target_tf} bars.")

        # Insert resampled data
        records = []
        for ts, row in resampled.iterrows():
            records.append({
                "pair_id": pair_id,
                "timeframe": target_tf,
                "timestamp": ts.to_pydatetime(),
                "open": float(row['open']),
                "high": float(row['high']),
                "low": float(row['low']),
                "close": float(row['close']),
                "volume": float(row['volume']),
                "spread_pips": 0.0
            })

        # 1. Clean existing target data to avoid duplicates
        # Must delete indicators first due to FK constraint
        from backend.database.models_db import IndicatorDB
        await session.execute(delete(IndicatorDB).where(
            IndicatorDB.bar_id.in_(
                select(OHLCVBarDB.id).where(
                    and_(OHLCVBarDB.pair_id == pair_id, OHLCVBarDB.timeframe == target_tf)
                )
            )
        ))
        await session.execute(delete(OHLCVBarDB).where(
            and_(OHLCVBarDB.pair_id == pair_id, OHLCVBarDB.timeframe == target_tf)
        ))
        await session.commit()

        # 2. Simple insert
        chunk_size = 1000
        for i in range(0, len(records), chunk_size):
            chunk = records[i:i + chunk_size]
            await session.execute(insert(OHLCVBarDB), chunk)
            print(f"    Inserted {min(i+chunk_size, len(records))}/{len(records)} bars...")
        
        await session.commit()
        print(f"SUCCESS: {symbol} {target_tf} data ready.")

if __name__ == "__main__":
    asyncio.run(resample_pair("EURUSD", "H1"))
