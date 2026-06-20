from fastapi import APIRouter, Query
from typing import Optional
from datetime import date
from .trades import get_trade_history

# Alias router for old frontend versions - made public for convenience
router = APIRouter(prefix="/account", tags=["account"])

@router.get("/history")
async def account_history_alias(
    pair: Optional[str] = Query(None),
    strategy: Optional[str] = Query(None),
    date_from: Optional[date] = Query(None),
    date_to: Optional[date] = Query(None),
    page: int = Query(1, ge=1),
    size: int = Query(50, ge=1, le=100)
):
    """Public alias for /trades/history to support older frontend versions."""
    # We call the main logic directly
    return await get_trade_history(pair, strategy, date_from, date_to, page, size)
