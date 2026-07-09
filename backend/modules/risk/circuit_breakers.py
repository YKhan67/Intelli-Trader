import logging
from typing import Dict, Any, Tuple
from datetime import datetime, timezone, timedelta
from backend.database.redis_client import get_redis_client
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import TradeDB
from sqlalchemy import select, func, and_

logger = logging.getLogger("CircuitBreakers")

class CircuitBreakers:
    def __init__(self, config: Dict[str, Any]):
        self.config = config.get('circuit_breakers', {})
        self.redis = get_redis_client()

    async def check_all(self, account_balance: float) -> Dict[str, bool]:
        daily_halt, hard_daily_halt = await self.check_daily_halt(account_balance)
        weekly_review = await self.check_weekly_halt(account_balance)
        pause, halt = await self.check_consecutive_losses()
        profit_locked = await self.check_profit_lock(account_balance)
        return {
            "daily_halt": daily_halt, "hard_daily_halt": hard_daily_halt,
            "weekly_review": weekly_review, "consecutive_pause": pause,
            "consecutive_halt": halt, "profit_locked": profit_locked,
            "any_halt": hard_daily_halt or halt or profit_locked
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
            logger.warning(f"DAILY LOSS LIMIT REACHED: {loss_pct*100:.2f}%")
        return is_daily, is_hard

    async def check_weekly_halt(self, account_balance: float) -> bool:
        try:
            async with AsyncSessionLocal() as session:
                one_week_ago = datetime.now(timezone.utc) - timedelta(days=7)
                stmt = select(func.sum(TradeDB.net_profit_loss)).where(
                    and_(TradeDB.exit_time >= one_week_ago, TradeDB.status == 'CLOSED')
                )
                res = await session.execute(stmt)
                weekly_pnl = res.scalar() or 0.0
                limit = self.config.get('weekly_loss_limit', 0.05)
                if weekly_pnl < 0 and abs(weekly_pnl) / account_balance >= limit:
                    logger.warning(f"WEEKLY LOSS LIMIT REACHED: {abs(weekly_pnl)/account_balance*100:.2f}%")
                    return True
        except: pass
        return False

    async def check_consecutive_losses(self) -> Tuple[bool, bool]:
        try:
            async with AsyncSessionLocal() as session:
                stmt = select(TradeDB.net_profit_loss).where(
                    TradeDB.status == 'CLOSED'
                ).order_by(TradeDB.exit_time.desc()).limit(5)
                res = await session.execute(stmt)
                last_results = res.scalars().all()
                if not last_results: return False, False
                losses = 0
                for r in last_results:
                    if r < 0: losses += 1
                    else: break
                pause_limit = self.config.get('consecutive_loss_pause', 3)
                halt_limit = self.config.get('consecutive_loss_halt', 5)
                return losses >= pause_limit, losses >= halt_limit
        except: pass
        return False, False

    async def check_profit_lock(self, account_balance: float) -> bool:
        """
        LOGICAL FIX: Institutional Profit Lock.
        If monthly profit exceeds 10%, locks trading to preserve gains.
        """
        try:
            async with AsyncSessionLocal() as session:
                one_month_ago = datetime.now(timezone.utc) - timedelta(days=30)
                stmt = select(func.sum(TradeDB.net_profit_loss)).where(
                    and_(TradeDB.exit_time >= one_month_ago, TradeDB.status == 'CLOSED')
                )
                res = await session.execute(stmt)
                monthly_pnl = res.scalar() or 0.0
                limit = self.config.get('monthly_profit_lock', 0.10)
                if monthly_pnl > 0 and (monthly_pnl / account_balance) >= limit:
                    logger.info(f"PROFIT LOCK ACTIVE: Monthly target (+{monthly_pnl/account_balance*100:.2f}%) reached.")
                    return True
        except: pass
        return False
