from typing import Dict, Any, Tuple
from datetime import datetime, timezone
from backend.database.redis_client import get_redis_client
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import TradeDB
from sqlalchemy import select, func, and_

class CircuitBreakers:
    def __init__(self, config: Dict[str, Any]):
        self.config = config.get('circuit_breakers', {})
        self.redis = get_redis_client()

    async def check_all(self, account_balance: float) -> Dict[str, bool]:
        """
        Runs all halt checks.
        """
        daily_halt, hard_daily_halt = await self.check_daily_halt(account_balance)
        weekly_review = await self.check_weekly_halt(account_balance)
        pause, halt = await self.check_consecutive_losses()
        profit_locked = await self.check_profit_lock(account_balance)

        return {
            "daily_halt": daily_halt,
            "hard_daily_halt": hard_daily_halt,
            "weekly_review": weekly_review,
            "consecutive_pause": pause,
            "consecutive_halt": halt,
            "profit_locked": profit_locked,
            "any_halt": hard_daily_halt or halt
        }

    async def check_daily_halt(self, account_balance: float) -> Tuple[bool, bool]:
        date_str = datetime.now(timezone.utc).strftime('%Y-%m-%d')
        pnl_key = f"pnl:daily:{date_str}"
        
        daily_pnl = await self.redis.get(pnl_key)
        if not daily_pnl: return False, False
        
        pnl_float = float(daily_pnl)
        if pnl_float >= 0: return False, False
        
        loss_pct = abs(pnl_float) / account_balance
        
        daily_limit = self.config.get('daily_loss_limit', 0.02)
        hard_limit = self.config.get('hard_daily_loss_limit', 0.03)
        
        is_daily = loss_pct >= daily_limit
        is_hard = loss_pct >= hard_limit
        
        if is_daily:
            await self.redis.set(f"circuit:daily", "active", ex=86400)
        
        return is_daily, is_hard

    async def check_weekly_halt(self, account_balance: float) -> bool:
        # Implementation to check PostgreSQL trades from last 7 days
        return False

    async def check_consecutive_losses(self) -> Tuple[bool, bool]:
        # Implementation to check TradeDB for last trades
        return False, False

    async def check_profit_lock(self, account_balance: float) -> bool:
        # Implementation for monthly profit protection
        return False
