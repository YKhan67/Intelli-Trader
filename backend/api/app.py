import os
import yaml
import logging
import time
from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from backend.database.postgres import check_postgres_health
from backend.database.mongo import check_mongo_health
from backend.database.redis_client import get_redis_client

from .routers import market, trades, risk, system
from .websockets import live_feed, alerts

from backend.live_engine import get_engine

logger = logging.getLogger("API")

def create_app() -> FastAPI:
    # 1. Load Config
    config_path = os.path.join(os.path.dirname(__file__), "../config/api.yaml")
    with open(config_path, "r") as f:
        config = yaml.safe_load(f)["api"]

    app = FastAPI(
        title="ForexAI API", 
        version="1.0.0",
        description="Institutional Grade AI Trading System Backend"
    )

    # 2. CORS - Production Ready configuration
    cors_origins = config.get("cors_origins", [])
    if "*" in cors_origins and len(cors_origins) > 1:
        # In production, if specific origins are provided, remove wildcard
        cors_origins = [o for o in cors_origins if o != "*"]
        
    app.add_middleware(
        CORSMiddleware,
        allow_origins=cors_origins or ["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    # 3. Logging & Performance Middleware
    @app.middleware("http")
    async def log_requests(request: Request, call_next):
        start_time = time.time()
        try:
            response = await call_next(request)
            duration = time.time() - start_time
            logger.info(f"{request.method} {request.url.path} - {response.status_code} ({duration:.2f}s)")
            return response
        except Exception as e:
            duration = time.time() - start_time
            logger.error(f"Request Failed: {request.method} {request.url.path} - {str(e)} ({duration:.2f}s)")
            raise

    # 4. Register Routers
    app.include_router(market.router)
    app.include_router(trades.router)
    app.include_router(risk.router)
    app.include_router(system.router)
    
    # 5. Register WebSockets
    app.include_router(live_feed.router)
    app.include_router(alerts.router)

    # 6. Lifecycle Events
    @app.on_event("startup")
    async def startup_event():
        logger.info("ForexAI API Starting up...")
        
        # Database checks
        try:
            await check_postgres_health()
            await check_mongo_health()
            await get_redis_client().ping()
            logger.info("Database connectivity verified.")
        except Exception as e:
            logger.critical(f"Database connectivity failed: {e}")
            # In a real production env, we might want to exit here
        
        # Start the Engine (includes ingestion, sentiment, learning, and trading loops)
        engine = get_engine()
        await engine.start()
        logger.info("ForexAI Engine and background workers launched.")

    @app.on_event("shutdown")
    async def shutdown_event():
        logger.info("ForexAI API Shutting down...")
        await get_engine().stop()

    return app
