import asyncio
import pandas as pd
import logging
from datetime import datetime, timedelta, timezone
from typing import Dict, Any, List
from backend.database.mongo import get_mongo_db
from backend.database.redis_client import get_redis_client

# Explicitly ensure logging is available
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("SentimentAggregator")

class SentimentAggregator:
    def __init__(self, config: Dict[str, Any]):
        self.config = config
        self.db = get_mongo_db()
        self.redis = get_redis_client()
        self.windows = {"1H": 1, "4H": 4, "24H": 24}
        # Institutional currency coverage
        self.currencies = ["USD", "EUR", "GBP", "JPY", "CHF", "AUD", "NZD", "CAD", "XAU", "BTC", "ETH"]

    async def aggregate_all(self):
        """
        Aggregates sentiment for all currencies using a waterfall fallback logic.
        """
        now = datetime.now(timezone.utc)
        min_articles = self.config.get("thresholds", {}).get("min_articles_for_score", 1)
        
        # Pull last 10 days of news to ensure we always have data for the UI
        global_cursor = self.db.news_articles.find({
            "is_processed": True,
            "timestamp": {"$gte": now - timedelta(days=10)}
        })
        global_articles = await global_cursor.to_list(length=2000)

        for window_name, hours in self.windows.items():
            since_date = now - timedelta(hours=hours)
            
            # Pool articles in the specific window
            window_articles = [a for a in global_articles if a['timestamp'].replace(tzinfo=timezone.utc) >= since_date]
            
            currency_scores = {}
            for curr in self.currencies:
                # 1. Try Specific Window
                mentions = [a for a in window_articles if curr in a.get("currencies_mentioned", [])]
                
                if len(mentions) >= min_articles:
                    avg_score = sum(a["sentiment_score"] for a in mentions) / len(mentions)
                else:
                    # 2. Fallback to Global pool (last 10 days) to keep gauges active
                    global_mentions = [a for a in global_articles if curr in a.get("currencies_mentioned", [])]
                    if global_mentions:
                        avg_score = sum(a["sentiment_score"] for a in global_mentions) / len(global_mentions)
                    else:
                        # 3. Last Resort: Random small bias for visual consistency in demo
                        avg_score = 0.0
                
                currency_scores[curr] = float(avg_score)
                
                # Cache in Redis for fast API retrieval
                await self.redis.set(f"sentiment:{curr}:{window_name}", float(avg_score), ex=3600)
            
            # Save historical snapshot for the chart
            await self.db.sentiment_snapshots.insert_one({
                "timestamp": now,
                "window": window_name,
                "scores": currency_scores,
                "article_count": len(window_articles)
            })

    async def get_pair_score(self, pair: str, window: str = "4H") -> float:
        """
        Pair score = base_score - quote_score.
        """
        base = pair[:3].upper()
        quote = pair[3:].upper()
        
        base_score = await self.redis.get(f"sentiment:{base}:{window}")
        quote_score = await self.redis.get(f"sentiment:{quote}:{window}")
        
        return float(base_score or 0.0) - float(quote_score or 0.0)

    async def run_periodic(self, interval: int = 600):
        """Main background loop."""
        logger.info(f"Sentiment Aggregator operational. Loop interval: {interval}s")
        while True:
            try:
                await self.aggregate_all()
                logger.info("Sentiment aggregation matrix updated.")
            except Exception as e:
                logger.error(f"Critical error in sentiment aggregator: {e}")
            await asyncio.sleep(interval)
