from fastapi import FastAPI, Depends, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
import logging
import traceback
import sys
import asyncio
from contextlib import asynccontextmanager

from .routers import market, trades, risk, system, account
from .websockets import live_feed, alerts
from backend.live_engine import get_engine

# Path and Logging
logger = logging.getLogger("API")

@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    Orchestrates the lifecycle of the AI Cluster.
    Includes Fail-Fast logic for institutional stability.
    """
    logger.info(">>> CORE: AI Cluster Initializing...")
    
    from backend.database.postgres import check_postgres_health
    from backend.database.redis_client import check_redis_health
    
    # Fail-Fast: Block startup if primary infra is unreachable
    pg_ok = await check_postgres_health()
    if not pg_ok:
        logger.critical("FAIL-FAST: PostgreSQL Unreachable. Cluster shutdown initiated.")
        sys.exit(1)
        
    redis_ok = await check_redis_health()
    if not redis_ok:
        logger.critical("FAIL-FAST: Redis Unreachable. Cluster shutdown initiated.")
        sys.exit(1)

    try:
        engine = get_engine()
        await engine.start()
        logger.info(">>> ENGINE: Intelligence Decision Grid ONLINE.")
        print("\n" + "*"*60)
        print("🚀  ALL SYSTEMS OPERATIONAL - READY FOR TRADING")
        print("*"*60 + "\n")
    except Exception as e:
        logger.error(f"CRITICAL: Intelligence Engine failed: {e}")
        logger.error(traceback.format_exc())
    
    yield
    
    logger.info(">>> CORE: Intelli-Trader API Cluster Shutting down...")
    try:
        engine = get_engine()
        await engine.stop()
        logger.info(">>> ENGINE: Intelligence Decision Grid OFFLINE.")
        await asyncio.sleep(0.5)
    except Exception as e:
        logger.error(f"Shutdown sequence error: {e}")

app = FastAPI(
    title="Intelli-Trader AI API",
    description="High-Performance Institutional Trading Cluster",
    version="1.0.0",
    lifespan=lifespan
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
    expose_headers=["*"]
)

@app.exception_handler(Exception)
async def global_fault_handler(request: Request, exc: Exception):
    logger.error(f"CLUSTER FAULT: {exc}")
    logger.error(traceback.format_exc())
    return JSONResponse(
        status_code=500,
        content={"status": "error", "message": "Institutional System Fault", "dna": str(exc)}
    )

app.include_router(live_feed.router)
app.include_router(alerts.router)
app.include_router(market.router)
app.include_router(trades.router)
app.include_router(risk.router)
app.include_router(system.router)
app.include_router(account.router)

@app.get("/health")
async def health():
    return {"cluster": "operational"}
