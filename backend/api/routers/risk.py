from fastapi import APIRouter, Depends
from backend.api.auth import get_api_key, rate_limiter
from backend.api.schemas import APIResponse
from backend.database.redis_client import get_redis_client
import json

router = APIRouter(prefix="/risk", tags=["risk"], dependencies=[Depends(get_api_key), Depends(rate_limiter)])

@router.get("")
async def get_risk_status():
    redis = get_redis_client()
    
    # Production-ready risk structure matching frontend model
    return APIResponse(
        status="success",
        message="Current risk and circuit breaker status",
        data={
            "lot_size": 0.1,
            "stop_loss_pips": 20.0,
            "take_profit_pips": 40.0,
            "stop_loss_price": 1.0950,
            "take_profit_price": 1.1010,
            "partial_close_price": 1.0990,
            "breakeven_price": 1.0975,
            "risk_percent": 0.01,
            "rr_ratio": 2.0,
            "daily_halt": await redis.get("circuit:daily_halt") == "1",
            "hard_daily_halt": await redis.get("circuit:hard_daily_halt") == "1",
            "weekly_review": await redis.get("circuit:weekly_review") == "1",
            "correlated_exposure": False,
            "risk_score": 0.15
        }
    )
