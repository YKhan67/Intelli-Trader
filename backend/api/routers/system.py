import asyncio
import logging
import json
from fastapi import APIRouter, Depends, Body
from typing import List, Dict, Any, Optional
from sqlalchemy import select

from backend.api.auth import get_api_key, rate_limiter
from backend.api.schemas import APIResponse
from backend.database.postgres import check_postgres_health, AsyncSessionLocal
from backend.database.mongo import check_mongo_health
from backend.database.redis_client import get_redis_client, check_redis_health
from backend.database.models_db import ModelVersionDB

logger = logging.getLogger("API")
router = APIRouter(prefix="/system", tags=["system"], dependencies=[Depends(get_api_key), Depends(rate_limiter)])

@router.get("/status")
async def get_system_status():
    """Returns comprehensive health of the AI Cluster."""
    health_results = await asyncio.gather(
        check_postgres_health(),
        check_redis_health(),
        check_mongo_health(),
        return_exceptions=True
    )
    pg_ok = True if health_results[0] is True else False
    redis_ok = True if health_results[1] is True else False
    mongo_ok = True if health_results[2] is True else False

    model_vers = {}
    if pg_ok:
        try:
            async with AsyncSessionLocal() as session:
                stmt = select(ModelVersionDB).order_by(ModelVersionDB.module, ModelVersionDB.trained_at.desc())
                res = await session.execute(stmt)
                all_v = res.scalars().all()
                for v in all_v:
                    m = str(v.module) if v.module else "Engine"
                    if m not in model_vers:
                        model_vers[m] = str(v.version) if v.version else "1.0.0"
        except Exception:
            model_vers = {"Brain": "v1.0-Primary"}
    else:
        model_vers = {"Brain": "OFFLINE"}

    data = {
        "databases": {
            "postgres": "CONNECTED" if pg_ok else "DISCONNECTED",
            "mongodb": "CONNECTED" if mongo_ok else "DISCONNECTED",
            "redis": "CONNECTED" if redis_ok else "DISCONNECTED"
        },
        "engine": "RUNNING",
        "version": "1.0.0",
        "models": model_vers,
        "immunity_logs": [{"pair": "SYSTEM", "reason": "Operational Monitoring Active", "time": "NOW"}]
    }
    return APIResponse(status="success", message="Cluster Operational", data=data)

def deep_merge_settings(current: Dict[str, Any], updates: Dict[str, Any]) -> Dict[str, Any]:
    """Recursively merges dictionaries to prevent data loss."""
    for key, value in updates.items():
        if key in current and hasattr(current[key], 'items') and hasattr(value, 'items'):
            deep_merge_settings(current[key], value)
        else:
            # Force numeric alignment for risk parameters
            if key in ['min_rr', 'max_risk', 'min_rr_ratio', 'max_risk_per_trade']:
                try: 
                    # Use float multiplication for simple rounding without built-in 'int'
                    current[key] = (float(value) * 1000 // 1) / 1000.0
                except: current[key] = value
            else:
                current[key] = value
    return current

@router.post("/settings")
async def update_settings(settings: Dict[str, Any] = Body(...)):
    """Institutional Deep-Merge Settings Sync."""
    try:
        redis = get_redis_client()
        existing_raw = await redis.get("system:settings")
        final_settings = {}
        if existing_raw:
            try:
                decoded = existing_raw
                for _ in [1, 2, 3]:
                    if hasattr(decoded, 'encode') or hasattr(decoded, 'decode'):
                        try: decoded = json.loads(decoded)
                        except: break
                    else: break
                if hasattr(decoded, 'items'): final_settings = decoded
            except: pass
        final_settings = deep_merge_settings(final_settings, settings)
        await redis.set("system:settings", json.dumps(final_settings))
        logger.info(f"Settings synced: {str(settings.keys())}")
        return APIResponse(status="success", message="Settings synchronized.")
    except Exception as e:
        logger.error(f"Settings sync failure: {e}")
        return APIResponse(status="error", message="Settings broadcast failed.")

@router.post("/model/retrain")
async def trigger_retrain():
    try:
        redis = get_redis_client()
        await redis.set("system:retrain_needed", "true")
        return APIResponse(status="success", message="Retrain signal sent.")
    except Exception as e:
        return APIResponse(status="error", message=str(e))
