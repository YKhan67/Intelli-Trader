from typing import Dict, Any
from sqlalchemy import select, and_, func
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import COTDataDB
from backend.modules.models import Direction

class COTAnalyzer:
    def __init__(self, config: Dict[str, Any]):
        self.threshold = config.get("thresholds", {}).get("cot_strong_bias_threshold", 25000)

    async def get_currency_bias(self, currency: str) -> Direction:
        """
        Calculates bias for a specific currency based on latest COT report.
        """
        async with AsyncSessionLocal() as session:
            # Get latest report for this currency
            stmt = select(COTDataDB).where(
                COTDataDB.currency == currency
            ).order_by(COTDataDB.week_ending.desc()).limit(1)
            
            result = await session.execute(stmt)
            latest = result.scalar_one_or_none()
            
            if not latest:
                return Direction.NEUTRAL
                
            # Strong bias check
            if latest.net_position > self.threshold:
                return Direction.LONG
            elif latest.net_position < -self.threshold:
                return Direction.SHORT
                
            return Direction.NEUTRAL

    async def get_pair_bias(self, pair: str) -> Direction:
        """
        Calculates pair bias = base_bias vs quote_bias.
        """
        base = pair[:3]
        quote = pair[3:]
        
        base_bias = await self.get_currency_bias(base)
        quote_bias = await self.get_currency_bias(quote)
        
        # If both agree on a direction for the pair
        if base_bias == Direction.LONG and quote_bias == Direction.SHORT:
            return Direction.LONG
        if base_bias == Direction.SHORT and quote_bias == Direction.LONG:
            return Direction.SHORT
            
        return Direction.NEUTRAL
