# Redis Key Patterns
SIGNAL_KEY = "signal:{pair}"
REGIME_KEY = "regime:{pair}:{timeframe}"
SENTIMENT_KEY = "sentiment:{currency}:{window}"
CIRCUIT_KEY = "circuit:{type}"
SPREAD_KEY = "spread:{pair}"
SESSION_CURRENT_KEY = "session:current"
CALENDAR_UPCOMING_KEY = "calendar:upcoming"
PNL_DAILY_KEY = "pnl:daily:{date}"
RATELIMIT_KEY = "ratelimit:{source}:{window}"

from .redis_client import get_value, set_value, redis_client
import json
from typing import Optional, Any

async def set_signal(pair: str, signal_data: Any):
    key = SIGNAL_KEY.format(pair=pair)
    await set_value(key, signal_data, expire=300) # 5 mins

async def get_signal(pair: str) -> Optional[Any]:
    key = SIGNAL_KEY.format(pair=pair)
    return await get_value(key)

async def set_regime(pair: str, timeframe: str, regime_data: Any):
    key = REGIME_KEY.format(pair=pair, timeframe=timeframe)
    await set_value(key, regime_data, expire=3600) # 1 hour

async def get_regime(pair: str, timeframe: str) -> Optional[Any]:
    key = REGIME_KEY.format(pair=pair, timeframe=timeframe)
    return await get_value(key)

async def set_circuit_breaker(breaker_type: str, status: Any):
    key = CIRCUIT_KEY.format(type=breaker_type)
    await set_value(key, status, expire=86400) # 24 hours

async def get_circuit_breaker(breaker_type: str) -> Optional[Any]:
    key = CIRCUIT_KEY.format(type=breaker_type)
    return await get_value(key)

async def check_any_halt():
    # Example check for system-wide halt
    keys = await redis_client.keys("circuit:*")
    for key in keys:
        status = await get_value(key)
        if status and status.get("halted", False):
            return True
    return False
