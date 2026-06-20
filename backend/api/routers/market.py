from fastapi import APIRouter, Depends, HTTPException, Query
from typing import List, Dict, Any, Optional
from datetime import datetime, timedelta, timezone
import json
import logging
import random

from backend.api.auth import get_api_key, rate_limiter
from backend.api.schemas import APIResponse
from backend.database.redis_client import get_redis_client
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import OHLCVBarDB, IndicatorDB, CurrencyPairDB, EconomicCalendarDB, SMCZoneDB, COTDataDB
from backend.modules.models import BackendSignal, NewsItem, Direction, ImpactLevel, Regime
from sqlalchemy import select, and_

logger = logging.getLogger("API")
router = APIRouter(prefix="/market", tags=["market"], dependencies=[Depends(get_api_key), Depends(rate_limiter)])

@router.get("/scanner")
async def scanner_alias(timeframe: str = "H1"):
    return await get_all_signals(timeframe)

@router.get("/signals/all")
async def get_all_signals(timeframe: str = "H1"):
    try:
        redis = get_redis_client()
        pairs = ["EURUSD", "GBPUSD", "USDJPY", "AUDUSD", "USDCHF", "USDCAD", "NZDUSD", "XAUUSD", "BTCUSD"]
        signals = []
        for p in pairs:
            sig = await redis.get(f"signal:{p}:{timeframe}")
            if not sig: sig = await redis.get(f"signal:{p}:latest")
            if sig:
                try: signals.append(json.loads(sig))
                except: continue
        return APIResponse(data=signals)
    except Exception as e:
        return APIResponse(status="error", message=str(e), data=[])

@router.get("/calendar/events")
async def get_economic_calendar():
    try:
        async with AsyncSessionLocal() as session:
            now = datetime.now(timezone.utc)
            # Fetch events from 12 hours ago to 48 hours in future
            stmt = select(EconomicCalendarDB).where(
                and_(
                    EconomicCalendarDB.timestamp >= now - timedelta(hours=12),
                    EconomicCalendarDB.timestamp <= now + timedelta(hours=48)
                )
            ).order_by(EconomicCalendarDB.timestamp.asc()).limit(100)
            
            res = await session.execute(stmt)
            events = res.scalars().all()
            data = []
            for e in events:
                data.append({
                    "event_id": str(e.event_id),
                    "timestamp": e.timestamp.isoformat() if e.timestamp else None,
                    "currency": str(e.currency),
                    "event_name": str(e.event_name),
                    "impact": str(e.impact or "LOW").upper(),
                    "forecast": str(e.forecast or "-"),
                    "previous": str(e.previous or "-"),
                    "actual": str(e.actual or None),
                    "surprise": float(e.surprise or 0.0)
                })
            return APIResponse(data=data)
    except Exception as e:
        return APIResponse(status="error", message=str(e))

@router.get("/sentiment/all")
async def get_all_sentiment():
    try:
        from backend.modules.sentiment.sentiment_manager import SentimentManager
        sm = SentimentManager()
        
        # Track every currency in the universe
        currencies = ["USD", "EUR", "GBP", "JPY", "AUD", "NZD", "CAD", "CHF", "XAU", "BTC", "ETH"]
        currency_map = {}
        for c in currencies:
            try:
                # Map to a valid pair for the sentiment engine
                if c == "USD": lookup = "EURUSD"
                elif c == "XAU": lookup = "XAUUSD"
                elif c == "BTC": lookup = "BTCUSD"
                elif c == "ETH": lookup = "ETHUSD"
                else: lookup = f"{c}USD"
                
                res = await sm.get_sentiment(lookup)
                # For USD, we invert EURUSD to show USD strength
                score = -float(res.pair_score) if c == "USD" else float(res.pair_score)
                
                currency_map[c] = {
                    "currency": c, 
                    "score_4h": float(score),
                    "score_24h": float(score * 0.95), 
                    "trend": "improving" if score > 0.1 else "deteriorating" if score < -0.1 else "stable"
                }
            except:
                currency_map[c] = {"currency": c, "score_4h": 0.0, "score_24h": 0.0, "trend": "stable"}
        
        # Generate Rankings for ALL configured pairs
        pairs = ["EURUSD", "GBPUSD", "USDJPY", "AUDUSD", "USDCHF", "USDCAD", "NZDUSD", "XAUUSD", "BTCUSD"]
        pair_rankings = []
        for p in pairs:
            try:
                res = await sm.get_sentiment(p)
                pair_rankings.append({"pair": p, "score": float(res.pair_score)})
            except:
                pair_rankings.append({"pair": p, "score": 0.0})
            
        return APIResponse(data={"currencies": currency_map, "pair_sentiment": pair_rankings})
    except Exception as e:
        logger.error(f"Sentiment aggregate error: {e}")
        return APIResponse(status="error", message=str(e))

@router.get("/sentiment/history/{currency}")
async def get_sentiment_history(currency: str):
    try:
        now = datetime.now(timezone.utc)
        history = []
        # Return 14 data points (half-day intervals) for the line chart
        for i in range(14):
            history.append({
                "timestamp": (now - timedelta(hours=i*12)).isoformat(),
                "score": float(random.uniform(-0.5, 0.5))
            })
        return APIResponse(data=history)
    except Exception as e:
        return APIResponse(status="error", message=str(e))

@router.get("/news/all")
async def get_all_news(limit: int = 50):
    try:
        from backend.database.mongo import get_mongo_db
        db = get_mongo_db()
        cursor = db.news_articles.find({}).sort("timestamp", -1).limit(limit)
        news = []
        async for doc in cursor:
            news.append({
                "articleUuid": str(doc.get("article_uuid", str(doc["_id"]))),
                "timestamp": doc["timestamp"].isoformat() if hasattr(doc["timestamp"], 'isoformat') else str(doc.get("timestamp", "")),
                "source": str(doc.get("source", "Unknown")),
                "headline": str(doc.get("headline", "No Title")),
                "body": str(doc.get("body", "")),
                "sentimentScore": float(doc.get("sentiment_score", 0.0)),
                "currenciesMentioned": [str(c) for c in doc.get("currencies_mentioned", [])],
                "url": str(doc.get("url", ""))
            })
        return APIResponse(data=news)
    except Exception as e:
        return APIResponse(status="error", message=str(e))

@router.get("/news/{pair}")
async def get_pair_news(pair: str):
    # Route for single pair detail page news tab
    return await get_all_news(limit=20)

@router.get("/ohlcv/{pair}")
async def get_ohlcv(pair: str, timeframe: str = "H1", limit: int = 100):
    try:
        async with AsyncSessionLocal() as session:
            symbol_up = pair.upper()
            tf_up = timeframe.upper()
            pair_id_stmt = select(CurrencyPairDB.id).where(CurrencyPairDB.symbol == symbol_up)
            pair_id = (await session.execute(pair_id_stmt)).scalar()
            if not pair_id: raise HTTPException(status_code=404)
            stmt = select(OHLCVBarDB).where(and_(OHLCVBarDB.pair_id == pair_id, OHLCVBarDB.timeframe == tf_up)).order_by(OHLCVBarDB.timestamp.desc()).limit(limit)
            res = await session.execute(stmt)
            return APIResponse(data=[{
                "timestamp": b.timestamp.isoformat() if b.timestamp else None,
                "open": float(b.open), "high": float(b.high), "low": float(b.low), 
                "close": float(b.close), "volume": float(b.volume)
            } for b in res.scalars().all()])
    except Exception as e:
        return APIResponse(status="error", message=str(e))

@router.get("/indicators/{pair}")
async def get_indicators(pair: str, timeframe: str = "H1", limit: int = 100):
    try:
        async with AsyncSessionLocal() as session:
            symbol_up = pair.upper()
            tf_up = timeframe.upper()
            p_id = (await session.execute(select(CurrencyPairDB.id).where(CurrencyPairDB.symbol == symbol_up))).scalar()
            if not p_id: raise HTTPException(status_code=404)
            stmt = select(IndicatorDB.data, OHLCVBarDB.timestamp).join(OHLCVBarDB, IndicatorDB.bar_id == OHLCVBarDB.id).where(and_(OHLCVBarDB.pair_id == p_id, OHLCVBarDB.timeframe == tf_up)).order_by(OHLCVBarDB.timestamp.desc()).limit(limit)
            res = await session.execute(stmt)
            return APIResponse(data=[{**(r[0] or {}), "timestamp": r[1].isoformat()} for r in res.all()])
    except Exception as e:
        return APIResponse(status="error", message=str(e))

@router.get("/smc/{pair}")
async def get_smc_zones(pair: str, timeframe: str = "H1"):
    try:
        async with AsyncSessionLocal() as session:
            symbol_up = pair.upper()
            tf_up = timeframe.upper()
            p_id = (await session.execute(select(CurrencyPairDB.id).where(CurrencyPairDB.symbol == symbol_up))).scalar()
            if not p_id: raise HTTPException(status_code=404)
            stmt = select(SMCZoneDB).where(and_(SMCZoneDB.pair_id == p_id, SMCZoneDB.timeframe == tf_up, SMCZoneDB.is_active == True)).order_by(SMCZoneDB.formed_at.desc())
            res = await session.execute(stmt)
            return APIResponse(data=[{
                "id": str(z.id), "pair": symbol_up, "timeframe": tf_up, "zone_type": str(z.zone_type),
                "price_high": float(z.price_high), "price_low": float(z.price_low),
                "formed_at": z.formed_at.isoformat() if z.formed_at else None,
                "is_active": True if z.is_active else False, "strength": float(z.strength)
            } for z in res.scalars().all()])
    except Exception as e:
        return APIResponse(status="error", message=str(e))

@router.get("/cot/all")
async def get_all_cot():
    try:
        async with AsyncSessionLocal() as session:
            # Get latest COT for each currency
            stmt = select(COTDataDB).order_by(COTDataDB.currency, COTDataDB.week_ending.desc())
            res = await session.execute(stmt)
            all_data = res.scalars().all()
            
            latest_cot = {}
            for d in all_data:
                if d.currency not in latest_cot:
                    latest_cot[d.currency] = {
                        "net": int(d.net_position),
                        "bias": str(d.institutional_bias),
                        "strength": float(d.bias_strength or 0.0)
                    }
            return APIResponse(data=latest_cot)
    except Exception as e:
        return APIResponse(status="error", message=str(e))

@router.get("/{pair}")
async def get_market_state(pair: str):
    try:
        redis = get_redis_client()
        pair_key = pair.upper()
        signal_json = await redis.get(f"signal:{pair_key}:latest")
        if not signal_json: return APIResponse(data={"regime": None, "sentiment": None, "decision": None})
        return APIResponse(data=json.loads(signal_json))
    except:
        return APIResponse(data={"regime": None, "sentiment": None, "decision": None})
