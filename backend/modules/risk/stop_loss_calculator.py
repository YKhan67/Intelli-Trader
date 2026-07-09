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
                                  timeframe: str,
                                  pip_size: float = 0.0001) -> Tuple[float, float]:
        """
        Calculates ATR-based stop loss, refined by SMC zones.
        Returns (stop_loss_price, stop_loss_pips)
        """
        # 1. Base ATR Stop Loss
        multiplier = self.multipliers.get(strategy, 2.0)
        atr_distance = atr * multiplier
        
        if direction == Direction.LONG:
            sl_price = current_price - atr_distance
        else:
            sl_price = current_price + atr_distance

        # 2. Refine with SMC Zones
        # Look for the nearest active zone in the opposite direction
        refined_sl = await self._refine_with_smc(pair, direction, sl_price, timeframe, pip_size)
        if refined_sl:
            sl_price = refined_sl

        # 3. Calculate Pips
        sl_pips = abs(current_price - sl_price) / pip_size
        
        return sl_price, sl_pips

    async def _refine_with_smc(self, pair: str, direction: Direction, base_sl: float, timeframe: str, pip_size: float) -> Optional[float]:
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
                # Look for BULLISH zones BELOW current price
                stmt = stmt.where(SMCZoneDB.zone_type.like("BULLISH%"))
                result = await session.execute(stmt)
                zones = result.scalars().all()
                # Find zones acting as support near our base SL
                relevant_zones = [z for z in zones if z.price_low < base_sl * 1.05]
                if relevant_zones:
                    best_zone = min(relevant_zones, key=lambda z: abs(z.price_low - base_sl))
                    return best_zone.price_low - (5 * pip_size) # 5 pip buffer
            else:
                # Look for BEARISH zones ABOVE current price
                stmt = stmt.where(SMCZoneDB.zone_type.like("BEARISH%"))
                result = await session.execute(stmt)
                zones = result.scalars().all()
                relevant_zones = [z for z in zones if z.price_high > base_sl * 0.995]
                if relevant_zones:
                    best_zone = min(relevant_zones, key=lambda z: abs(z.price_high - base_sl))
                    return best_zone.price_high + (5 * pip_size)

        return None
