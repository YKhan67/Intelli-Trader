from fastapi import APIRouter, Depends, Query, HTTPException
from typing import List, Optional
from datetime import datetime, date
import logging

from backend.api.auth import get_api_key, rate_limiter
from backend.api.schemas import APIResponse
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import TradeDB, CurrencyPairDB
from sqlalchemy import select, and_

logger = logging.getLogger("API")

router = APIRouter(prefix="/trades", tags=["trades"], dependencies=[Depends(get_api_key), Depends(rate_limiter)])

def trade_to_dict(t: TradeDB):
    # Ensure all values are primitives for JSON serialization
    # Use built-in functions without shadowing or complex expressions if possible
    
    entry_p = 0.0
    if t.entry_price is not None:
        entry_p = float(t.entry_price)
        
    lot = 0.0
    if t.lot_size is not None:
        lot = float(t.lot_size)
        
    sl = 0.0
    if t.stop_loss is not None:
        sl = float(t.stop_loss)
        
    tp = 0.0
    if t.take_profit is not None:
        tp = float(t.take_profit)

    res = {
        "trade_uuid": str(t.trade_uuid),
        "broker_order_id": str(t.broker_order_id) if t.broker_order_id else None,
        "pair_id": int(t.pair_id) if t.pair_id is not None else None,
        "strategy": str(t.strategy) if t.strategy else None,
        "regime": str(t.regime) if t.regime else None,
        "trade_type": str(t.trade_type) if t.trade_type else "PAPER",
        "direction": str(t.direction) if t.direction else None,
        "timeframe": str(t.timeframe) if t.timeframe else None,
        "session": str(t.session) if t.session else None,
        "entry_price": entry_p,
        "entry_time": t.entry_time.isoformat() if t.entry_time else None,
        "lot_size": lot,
        "stop_loss": sl,
        "take_profit": tp,
        "exit_price": float(t.exit_price) if t.exit_price is not None else None,
        "exit_time": t.exit_time.isoformat() if t.exit_time else None,
        "exit_reason": str(t.exit_reason) if t.exit_reason else None,
        "pips_result": float(t.pips_result) if t.pips_result is not None else None,
        "profit_loss": float(t.profit_loss) if t.profit_loss is not None else None,
        "net_profit_loss": float(t.net_profit_loss) if t.net_profit_loss is not None else None,
        "confidence_at_entry": float(t.confidence_at_entry) if t.confidence_at_entry is not None else 0.0,
        "status": str(t.status) if t.status else "CLOSED"
    }
    return res

@router.get("/open")
async def get_open_trades():
    try:
        async with AsyncSessionLocal() as session:
            stmt = select(TradeDB).where(TradeDB.status == 'OPEN')
            res = await session.execute(stmt)
            trades = res.scalars().all()
            return APIResponse(status="success", message="Open trades", data=[trade_to_dict(t) for t in trades])
    except Exception as e:
        logger.error(f"Error fetching open trades: {e}")
        return APIResponse(status="error", message=str(e), data=[])

@router.get("/history")
async def get_trade_history(
    pair: Optional[str] = Query(None),
    strategy: Optional[str] = Query(None),
    date_from: Optional[date] = Query(None),
    date_to: Optional[date] = Query(None),
    page: int = Query(1, ge=1),
    size: int = Query(50, ge=1, le=100)
):
    try:
        async with AsyncSessionLocal() as session:
            stmt = select(TradeDB).where(TradeDB.status == 'CLOSED')
            if pair:
                pair_id_stmt = select(CurrencyPairDB.id).where(CurrencyPairDB.symbol == pair.upper())
                pair_id = (await session.execute(pair_id_stmt)).scalar()
                if pair_id: 
                    stmt = stmt.where(TradeDB.pair_id == pair_id)
                else: 
                    return APIResponse(status="success", message="No history", data=[])
            
            if strategy: 
                stmt = stmt.where(TradeDB.strategy == strategy)
            if date_from: 
                stmt = stmt.where(TradeDB.entry_time >= datetime.combine(date_from, datetime.min.time()))
            if date_to: 
                stmt = stmt.where(TradeDB.exit_time <= datetime.combine(date_to, datetime.max.time()))
                
            stmt = stmt.order_by(TradeDB.exit_time.desc()).offset((page - 1) * size).limit(size)
            res = await session.execute(stmt)
            trades = res.scalars().all()
            return APIResponse(status="success", message="Trade history", data=[trade_to_dict(t) for t in trades])
    except Exception as e:
        logger.error(f"Error fetching trade history: {e}")
        return APIResponse(status="error", message=str(e), data=[])

@router.get("/performance")
async def get_performance():
    return APIResponse(status="success", message="Performance", data={
        "total_trades": 0, "win_rate": 0.0, "gross_profit": 0.0, "gross_loss": 0.0,
        "net_pnl": 0.0, "max_drawdown": 0.0, "sharpe_ratio": 0.0, "profit_factor": 0.0,
        "avg_rr": 0.0, "best_trade_pips": 0.0, "worst_trade_pips": 0.0
    })
