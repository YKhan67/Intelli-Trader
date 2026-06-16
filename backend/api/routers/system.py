from fastapi import APIRouter, Depends
from backend.api.auth import get_api_key, rate_limiter
from backend.api.schemas import APIResponse
from backend.database.postgres import check_postgres_health
from backend.database.mongo import get_mongo_db
from backend.database.redis_client import get_redis_client

router = APIRouter(prefix="/system", tags=["system"], dependencies=[Depends(get_api_key), Depends(rate_limiter)])

@router.get("/status")
async def get_system_status():
    pg_ok = await check_postgres_health()
    
    mongo_ok = False
    try:
        mongo = get_mongo_db()
        await mongo.command("ping")
        mongo_ok = True
    except: pass
    
    redis_ok = False
    try:
        redis = get_redis_client()
        await redis.ping()
        redis_ok = True
    except: pass

    return APIResponse(
        status="success",
        message="System health status",
        data={
            "databases": {
                "postgres": "CONNECTED" if pg_ok else "DISCONNECTED",
                "mongodb": "CONNECTED" if mongo_ok else "DISCONNECTED",
                "redis": "CONNECTED" if redis_ok else "DISCONNECTED"
            },
            "engine": "RUNNING",
            "version": "1.0.0"
        }
    )
