from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
import logging
from contextlib import asynccontextmanager

from .routers import market, trades, risk, system, account
from backend.live_engine import get_engine

logger = logging.getLogger("API")

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup logic
    logger.info("ForexAI API Starting up...")
    
    # Verify DBs and start background workers
    from backend.database.postgres import check_postgres_health
    from backend.database.mongo import get_mongo_db
    from backend.database.redis_client import get_redis_client
    
    # 1. Postgres
    await check_postgres_health()
    
    # 2. Mongo & Redis (Graceful if failing)
    try:
        mongo = get_mongo_db()
        logger.info("MongoDB initialized.")
    except:
        logger.warning("MongoDB initialization failed.")
        
    try:
        redis = get_redis_client()
        await redis.ping()
        logger.info("Redis connection verified.")
    except:
        logger.warning("Redis connection failed.")

    # 3. Launch AI Engine
    engine = get_engine()
    await engine.start()
    logger.info("ForexAI Engine and background workers launched.")
    
    yield
    # Shutdown logic
    logger.info("ForexAI API Shutting down...")
    engine = get_engine()
    await engine.stop()
    logger.info("ForexAI background workers stopped.")

app = FastAPI(
    title="Intelli-Trader AI API",
    description="Institutional Forex AI Backend",
    version="1.0.0",
    lifespan=lifespan
)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Routes
app.include_router(market.router)
app.include_router(trades.router)
app.include_router(risk.router)
app.include_router(system.router)
app.include_router(account.router)

@app.get("/health")
async def health_check():
    return {"status": "healthy", "service": "ForexAI API"}
