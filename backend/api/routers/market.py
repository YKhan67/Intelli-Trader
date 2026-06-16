from fastapi import APIRouter, Depends, HTTPException, Query
from typing import List, Dict, Any, Optional
from datetime import datetime, timedelta, timezone
import json
import logging

from backend.api.auth import get_api_key, rate_limiter
from backend.api.schemas import APIResponse
from backend.database.redis_client import get_redis_client
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import OHLCVBarDB, IndicatorDB, CurrencyPairDB, EconomicCalendarDB, SMCZoneDB
from backend.modules.models import BackendSignal, NewsItem
from sqlalchemy import select, and_

logger = logging.getLogger("API")

router = APIRouter(prefix="/market", tags=["market"], dependencies=[Depends(get_api_key), Depends(rate_limiter)])

@router.get("/signals/all")
async def get_all_signals(timeframe: str = "H1"):
    try:
        redis = get_redis_client()
        pairs = ["EURUSD", "GBPUSD", "USDJPY", "AUDUSD", "USDCHF", "USDCAD", "NZDUSD", "XAUUSD", "BTCUSD"]
        signals = []
        for p in pairs:
            sig = await redis.get(f"signal:{p}:{timeframe}")
            if not sig:
                sig = await redis.get(f"signal:{p}:latest")
            if sig:
                try:
                    signals.append(json.loads(sig))
                except: continue
        return APIResponse(status="success", message="Latest signals retrieved", data=signals)
    except Exception as e:
        return APIResponse(status="error", message=str(e), data=[])

@router.get("/calendar/events")
async def get_economic_calendar():
    try:
        async with AsyncSessionLocal() as session:
            now = datetime.now(timezone.utc)
            stmt = select(EconomicCalendarDB).where(
                EconomicCalendarDB.timestamp >= now
            ).order_by(EconomicCalendarDB.timestamp.asc()).limit(50)
            res = await session.execute(stmt)
            events = res.scalars().all()
            data = []
            for e in events:
                data.append({
                    "event_id": str(e.event_id),
                    "timestamp": e.timestamp.isoformat() if e.timestamp else None,
                    "currency": str(e.currency),
                    "event_name": str(e.event_name),
                    "impact": str(e.impact),
                    "forecast": str(e.forecast or "-"),
                    "previous": str(e.previous or "-"),
                    "actual": str(e.actual or "-"),
                    "surprise": float(e.surprise or 0.0),
                    "surprise_direction": str(e.surprise_direction or "NEUTRAL")
                })
            return APIResponse(status="success", message="Economic events retrieved", data=data)
    except Exception as e:
        return APIResponse(status="error", message=str(e), data=[])

@router.get("/ohlcv/{pair}")
async def get_ohlcv(pair: str, timeframe: str = "H1", limit: int = 100):
    try:
        async with AsyncSessionLocal() as session:
            symbol_up = pair.upper()
            tf_up = timeframe.upper()
            pair_id_stmt = select(CurrencyPairDB.id).where(CurrencyPairDB.symbol == symbol_up)
            pair_id = (await session.execute(pair_id_stmt)).scalar()
            if not pair_id:
                raise HTTPException(status_code=404, detail=f"Pair {pair} not found")
            
            stmt = select(OHLCVBarDB).where(
                and_(OHLCVBarDB.pair_id == pair_id, OHLCVBarDB.timeframe == tf_up)
            ).order_by(OHLCVBarDB.timestamp.desc()).limit(limit)
            
            res = await session.execute(stmt)
            bars = res.scalars().all()
            return APIResponse(status="success", message="OHLCV retrieved", data=[{
                "timestamp": b.timestamp.isoformat() if b.timestamp else None,
                "open": float(b.open), "high": float(b.high), "low": float(b.low), 
                "close": float(b.close), "volume": float(b.volume)
            } for b in bars])
    except Exception as e:
        return APIResponse(status="error", message=str(e), data=[])

@router.get("/indicators/{pair}")
async def get_indicators(pair: str, timeframe: str = "H1", limit: int = 100):
    try:
        async with AsyncSessionLocal() as session:
            symbol_up = pair.upper()
            tf_up = timeframe.upper()
            pair_id_stmt = select(CurrencyPairDB.id).where(CurrencyPairDB.symbol == symbol_up)
            pair_id = (await session.execute(pair_id_stmt)).scalar()
            if not pair_id:
                raise HTTPException(status_code=404, detail="Pair not found")
                
            stmt = select(IndicatorDB.data, OHLCVBarDB.timestamp).join(
                OHLCVBarDB, IndicatorDB.bar_id == OHLCVBarDB.id
            ).where(
                and_(OHLCVBarDB.pair_id == pair_id, OHLCVBarDB.timeframe == tf_up)
            ).order_by(OHLCVBarDB.timestamp.desc()).limit(limit)
            
            res = await session.execute(stmt)
            rows = res.all()
            data = []
            for r in rows:
                ind = r[0] if r[0] is not None else {}
                ts_str = r[1].isoformat() if r[1] else None
                data.append({
                    **ind,
                    "timestamp": ts_str,
                    "pair": symbol_up, 
                    "timeframe": tf_up
                })
            return APIResponse(status="success", message="Indicators retrieved", data=data)
    except Exception as e:
        return APIResponse(status="error", message=str(e), data=[])

@router.get("/smc/{pair}")
async def get_smc_zones(pair: str, timeframe: str = "H1"):
    try:
        async with AsyncSessionLocal() as session:
            symbol_up = pair.upper()
            tf_up = timeframe.upper()
            pair_id_stmt = select(CurrencyPairDB.id).where(CurrencyPairDB.symbol == symbol_up)
            pair_id = (await session.execute(pair_id_stmt)).scalar()
            if not pair_id:
                raise HTTPException(status_code=404, detail="Pair not found")
                
            stmt = select(SMCZoneDB).where(
                and_(SMCZoneDB.pair_id == pair_id, SMCZoneDB.timeframe == tf_up, SMCZoneDB.is_active == True)
            ).order_by(SMCZoneDB.formed_at.desc())
            
            res = await session.execute(stmt)
            zones = res.scalars().all()
            
            return APIResponse(status="success", message="SMC zones retrieved", data=[{
                "id": str(z.id), 
                "pair": symbol_up, 
                "timeframe": tf_up, 
                "zone_type": str(z.zone_type),
                "price_high": float(z.price_high), 
                "price_low": float(z.price_low),
                "formed_at": z.formed_at.isoformat() if z.formed_at else None,
                "is_active": bool(z.is_active), 
                "is_mitigated": bool(z.is_mitigated), 
                "strength": float(z.strength)
            } for z in zones])
    except Exception as e:
        return APIResponse(status="error", message=str(e), data=[])

@router.get("/news/{pair}")
async def get_pair_news(pair: str):
    try:
        from backend.database.mongo import get_mongo_db
        db = get_mongo_db()
        symbol = pair.upper()
        # Look for base or quote
        base = symbol[:3]
        
        # News articles in Mongo have 'article_uuid', 'headline', 'body', 'source', 'timestamp', 'sentiment_score', 'currencies_mentioned'
        cursor = db.news_articles.find({
            "currencies_mentioned": {"$in": [base]}
        }).sort("timestamp", -1).limit(20)
        
        news = []
        async for doc in cursor:
            # Map explicitly to NewsItem model
            # Use safe get and standard types to ensure JSON serialization
            news.append({
                "article_uuid": str(doc.get("article_uuid", str(doc["_id"]))),
                "timestamp": doc["timestamp"].isoformat() if hasattr(doc["timestamp"], 'isoformat') else str(doc.get("timestamp", "")),
                "source": str(doc.get("source", "Unknown")),
                "headline": str(doc.get("headline", "No Title")),
                "body": str(doc.get("body", "No content available.")),
                "sentiment_score": float(doc.get("sentiment_score", 0.0)),
                "currencies_mentioned": [str(c) for c in doc.get("currencies_mentioned", [])]
            })
        return APIResponse(status="success", message="News retrieved", data=news)
    except Exception as e:
        return APIResponse(status="error", message=str(e), data=[])

@router.get("/{pair}")
async def get_market_state(pair: str):
    try:
        redis = get_redis_client()
        pair_key = pair.upper()
        signal_json = await redis.get(f"signal:{pair_key}:latest")
        if not signal_json:
            return APIResponse(status="success", message="No signal found", data={"regime": None, "sentiment": None, "decision": None})
        
        signal = json.loads(signal_json)
        return APIResponse(status="success", message="Market state retrieved", data={
            "regime": signal.get("regime_result"),
            "sentiment": signal.get("sentiment_result"),
            "decision": signal.get("trade_decision")
        })
    except Exception as e:
        return APIResponse(status="success", data={"regime": None, "sentiment": None, "decision": None})
