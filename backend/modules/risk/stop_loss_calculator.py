from typing import Dict, Any, Tuple, Optional
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import SMCZoneDB, CurrencyPairDB
from backend.modules.models import Strategy, Direction
from sqlalchemy import select, and_

class StopLossCalculator:
    def __init__(self, config: Dict[str, Any]):
        self.multipliers = config.get('atr_sl_multipliers', {})

    async def calculate_stop_loss(self, 
                                  pair: str, 
                                  direction: Direction,
                                  strategy: Strategy, 
                                  current_price: float, 
                                  atr: float,
                                  timeframe: str) -> Tuple[float, float]:
        """
        Calculates ATR-based stop loss, refined by SMC zones.
        Returns (stop_loss_price, stop_loss_pips)
        """
        # 1. Base ATR Stop Loss
        # Strategy inherits from str, so we can use it directly as a dict key
        multiplier = self.multipliers.get(strategy, 2.0)
        atr_distance = atr * multiplier
        
        if direction == Direction.LONG:
            sl_price = current_price - atr_distance
        else:
            sl_price = current_price + atr_distance

        # 2. Refine with SMC Zones
        # Look for the nearest active zone in the opposite direction
        refined_sl = await self._refine_with_smc(pair, direction, sl_price, timeframe)
        if refined_sl:
            sl_price = refined_sl

        # 3. Calculate Pips
        # Need pip size for the pair
        pip_size = 0.0001 # Default
        async with AsyncSessionLocal() as session:
            stmt = select(CurrencyPairDB.pip_size).where(CurrencyPairDB.symbol == pair)
            res = await session.execute(stmt)
            val = res.scalar()
            if val: pip_size = val

        sl_pips = abs(current_price - sl_price) / pip_size
        
        return sl_price, sl_pips

    async def _refine_with_smc(self, pair: str, direction: Direction, base_sl: float, timeframe: str) -> Optional[float]:
        """
        Places stop loss just beyond the nearest relevant SMC zone.
        """
        async with AsyncSessionLocal() as session:
            # Find active zones
            stmt = select(SMCZoneDB).join(
                CurrencyPairDB, SMCZoneDB.pair_id == CurrencyPairDB.id
            ).where(
                and_(
                    CurrencyPairDB.symbol == pair,
                    SMCZoneDB.timeframe == timeframe,
                    SMCZoneDB.is_active == True
                )
            )
            
            if direction == Direction.LONG:
                # Look for BULLISH zones BELOW current price but ABOVE base_sl
                # We want to put SL just below the zone
                stmt = stmt.where(SMCZoneDB.zone_type.like("BULLISH%"))
                result = await session.execute(stmt)
                zones = result.scalars().all()
                # Find highest low that is below current price? No, usually we want the zone price_low
                relevant_zones = [z for z in zones if z.price_low < base_sl * 1.05] # Heuristic
                if relevant_zones:
                    # Pick the one closest to current price but acting as support
                    best_zone = min(relevant_zones, key=lambda z: abs(z.price_low - base_sl))
                    return best_zone.price_low - (5 * 0.0001) # 5 pip buffer
            else:
                # Look for BEARISH zones ABOVE current price
                stmt = stmt.where(SMCZoneDB.zone_type.like("BEARISH%"))
                result = await session.execute(stmt)
                zones = result.scalars().all()
                relevant_zones = [z for z in zones if z.price_high > base_sl * 0.995]
                if relevant_zones:
                    best_zone = min(relevant_zones, key=lambda z: abs(z.price_high - base_sl))
                    return best_zone.price_high + (5 * 0.0001)

        return None
