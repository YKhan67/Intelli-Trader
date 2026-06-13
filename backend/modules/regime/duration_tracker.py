from typing import Dict, Any, Tuple
from sqlalchemy import select, func
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import RegimeHistoryDB, CurrencyPairDB
from backend.modules.models import Regime

async def track_regime_duration(pair: str, current_regime: Regime, config: Dict[str, Any]) -> Tuple[int, bool]:
    """
    Returns (bars_in_regime, duration_warning)
    """
    async with AsyncSessionLocal() as session:
        # Get pair ID
        pair_id = (await session.execute(select(CurrencyPairDB.id).where(CurrencyPairDB.symbol == pair))).scalar()
        if not pair_id: return 1, False

        # Find latest entries to see how long this regime has lasted
        stmt = select(RegimeHistoryDB).where(
            RegimeHistoryDB.pair_id == pair_id
        ).order_by(RegimeHistoryDB.timestamp.desc()).limit(100)
        
        history = (await session.execute(stmt)).scalars().all()
        
        bars_count = 1
        for entry in history:
            if entry.regime == current_regime:
                bars_count += 1
            else:
                break
        
        # Check against average
        avg_durations = config.get('historical_avg_duration', {})
        avg = avg_durations.get(current_regime, 48)
        
        warning = bars_count > (avg * config.get('max_regime_duration_multiplier', 0.8))
        
        return bars_count, warning
