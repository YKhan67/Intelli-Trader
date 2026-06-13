import uvicorn
import asyncio
import logging
import os
from datetime import datetime, timezone
from fastapi import FastAPI
from contextlib import asynccontextmanager

from backend.modules.ingestion import IngestionManager
from backend.modules.sentiment.article_processor import ArticleProcessor
from backend.modules.sentiment.aggregator import SentimentAggregator
from backend.live_engine import ForexAIEngine

from backend.database.postgres import check_postgres_health
from backend.database.mongo import check_mongo_health
from backend.database.redis_client import check_redis_health

# Setup Production Logging
if not os.path.exists("logs"): os.makedirs("logs")
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[logging.FileHandler("logs/system.log"), logging.StreamHandler()]
)
logger = logging.getLogger("ForexAI")

@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    Handles startup and shutdown of background workers.
    """
    logger.info("=== ForexAI System Starting ===")
    
    # 1. Verify Database Connections
    pg_ok = await check_postgres_health()
    mg_ok = await check_mongo_health()
    rd_ok = await check_redis_health()
    
    if not all([pg_ok, mg_ok, rd_ok]):
        logger.critical("DATABASE ERROR: System cannot start. Check .env and connections.")
        # We still start the API so status can be reported, but background tasks will fail
    else:
        logger.info("Database integrity verified.")

    # 2. Initialize Managers
    ingestion = IngestionManager()
    processor = ArticleProcessor()
    aggregator = SentimentAggregator(processor.config)
    engine = ForexAIEngine()

    # 3. Launch Background Pipelines
    logger.info("Launching Background Workers...")
    
    # - News Ingestion (RSS Poller)
    asyncio.create_task(ingestion.run_live())
    
    # - Sentiment NLP Processing
    asyncio.create_task(processor.run_continuous(interval=30)) # Every 30s
    
    # - Sentiment Score Aggregation
    asyncio.create_task(aggregator.run_periodic(interval=600)) # Every 10m
    
    # - The Live Trading Loop (The Brain)
    # This runs the cycle for all active pairs
    asyncio.create_task(run_trading_loop(engine))

    yield
    
    logger.info("=== ForexAI System Shutting Down ===")

async def run_trading_loop(engine: ForexAIEngine):
    """Infinite loop for the trading logic."""
    while True:
        try:
            # Cycle through all configured pairs
            for pair in engine.active_pairs:
                await engine.run_pair_cycle(pair, "H1")
            
            logger.info("Trading cycle complete. Resting for 60 seconds...")
            await asyncio.sleep(60)
        except Exception as e:
            logger.error(f"FATAL ERROR in Trading Loop: {e}")
            await asyncio.sleep(10) # Prevent rapid crash loops

app = FastAPI(title="ForexAI Backend", lifespan=lifespan)

@app.get("/")
async def status():
    return {
        "status": "online",
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "modules": ["ingestion", "sentiment", "regime", "strategy", "engine"]
    }

if __name__ == "__main__":
    # Start the server on port 8000
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=False)
