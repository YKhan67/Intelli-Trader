from fastapi import APIRouter, Depends, Body
from typing import List, Dict, Any
import json
import logging
from sqlalchemy import select

from backend.api.auth import get_api_key, rate_limiter
from backend.api.schemas import APIResponse
from backend.database.postgres import check_postgres_health, AsyncSessionLocal
from backend.database.mongo import get_mongo_db
from backend.database.redis_client import get_redis_client
from backend.database.models_db import ModelVersionDB

logger = logging.getLogger("API")
router = APIRouter(prefix="/system", tags=["system"], dependencies=[Depends(get_api_key), Depends(rate_limiter)])

@router.get("/status")
async def get_system_status():
    pg_ok = await check_postgres_health()
    
    mongo_ok = False
    try:
        mongo = get_mongo_db()
        mongo_ok = True
    except: pass
    
    redis_ok = False
    try:
        redis = get_redis_client()
        await redis.ping()
        redis_ok = True
    except: pass

    model_vers = {}
    try:
        async with AsyncSessionLocal() as session:
            stmt = select(ModelVersionDB).order_by(ModelVersionDB.module, ModelVersionDB.trained_at.desc())
            res = await session.execute(stmt)
            all_v = res.scalars().all()
            for v in all_v:
                if v.module not in model_vers:
                    model_vers[v.module] = v.version
    except Exception as e:
        logger.error(f"Error fetching model versions: {e}")

    return APIResponse(
        status="success",
        message="OK",
        data={
            "databases": {
                "postgres": "CONNECTED" if pg_ok else "DISCONNECTED",
                "mongodb": "CONNECTED" if mongo_ok else "DISCONNECTED",
                "redis": "CONNECTED" if redis_ok else "DISCONNECTED"
            },
            "engine": "RUNNING",
            "version": "1.0.0",
            "models": model_vers
        }
    )

@router.post("/settings")
async def update_settings(settings: Dict[str, Any] = Body(...)):
    try:
        redis = get_redis_client()
        await redis.set("system:settings", json.dumps(settings))
        return APIResponse(status="success", message="Settings updated successfully")
    except Exception as e:
        return APIResponse(status="error", message=str(e))

@router.post("/model/retrain")
async def trigger_retrain():
    try:
        redis = get_redis_client()
        await redis.set("system:retrain_needed", "true")
        return APIResponse(status="success", message="Retraining signal sent to Brain")
    except Exception as e:
        return APIResponse(status="error", message=str(e))
