from datetime import datetime, timedelta, timezone
from typing import Dict, Any, Tuple
from sqlalchemy import select, and_
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import EconomicCalendarDB

class CalendarFilter:
    def __init__(self, config: Dict[str, Any]):
        self.config = config.get("thresholds", {}).get("calendar", {})

    async def check_pre_trade(self, pair: str, current_time: datetime = None) -> Tuple[bool, bool, bool]:
        """
        Returns (pre_news_block, hard_block, post_news_window).
        """
        if current_time is None:
            current_time = datetime.now(timezone.utc)
            
        base = pair[:3]
        quote = pair[3:]
        
        pre_block_mins = self.config.get("pre_news_minutes", 120)
        hard_block_mins = self.config.get("hard_block_minutes", 30)
        post_block_mins = self.config.get("post_news_minutes", 15)
        
        async with AsyncSessionLocal() as session:
            # Look for events for base or quote currency
            stmt = select(EconomicCalendarDB).where(
                and_(
                    EconomicCalendarDB.currency.in_([base, quote]),
                    EconomicCalendarDB.impact == 'HIGH' if self.config.get("high_impact_only") else True,
                    EconomicCalendarDB.timestamp >= current_time - timedelta(minutes=post_block_mins),
                    EconomicCalendarDB.timestamp <= current_time + timedelta(minutes=pre_block_mins)
                )
            )
            result = await session.execute(stmt)
            events = result.scalars().all()
            
            pre_news_block = False
            hard_block = False
            post_news_window = False
            
            for event in events:
                diff_seconds = (event.timestamp - current_time).total_seconds()
                diff_mins = diff_seconds / 60
                
                # Case 1: Upcoming (Pre-block)
                if 0 < diff_mins <= pre_block_mins:
                    pre_news_block = True
                    
                # Case 2: Very close (Hard block)
                if 0 < diff_mins <= hard_block_mins:
                    hard_block = True
                    
                # Case 3: Just happened (Post window)
                if -post_block_mins <= diff_mins <= 0:
                    post_news_window = True
                    
            return pre_news_block, hard_block, post_news_window
