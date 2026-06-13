import asyncio
import pandas as pd
from datetime import datetime, timedelta, timezone
from typing import Dict, Any, List
from backend.database.mongo import get_mongo_db
from backend.database.redis_client import get_redis_client

class SentimentAggregator:
    def __init__(self, config: Dict[str, Any]):
        self.config = config
        self.db = get_mongo_db()
        self.redis = get_redis_client()
        self.windows = {"1H": 1, "4H": 4, "24H": 24}
        self.currencies = ["USD", "EUR", "GBP", "JPY", "CHF", "AUD", "NZD", "CAD"]

    async def aggregate_all(self):
        """
        Aggregates sentiment for all currencies and windows.
        """
        now = datetime.now(timezone.utc)
        min_articles = self.config.get("thresholds", {}).get("min_articles_for_score", 3)
        
        for window_name, hours in self.windows.items():
            since_date = now - timedelta(hours=hours)
            
            # Fetch processed articles in window
            cursor = self.db.news_articles.find({
                "is_processed": True,
                "timestamp": {"$gte": since_date}
            })
            articles = await cursor.to_list(length=1000)
            
            # Aggregate per currency
            currency_scores = {}
            for curr in self.currencies:
                mentions = [a for a in articles if curr in a.get("currencies_mentioned", [])]
                
                if len(mentions) >= min_articles:
                    avg_score = sum(a["sentiment_score"] for a in mentions) / len(mentions)
                else:
                    avg_score = 0.0 # Neutral if not enough data
                
                currency_scores[curr] = avg_score
                
                # Cache in Redis
                await self.redis.set(f"sentiment:{curr}:{window_name}", avg_score, ex=600)
            
            # Save snapshot
            await self.db.sentiment_snapshots.insert_one({
                "timestamp": now,
                "window": window_name,
                "scores": currency_scores,
                "article_count": len(articles)
            })

    async def get_pair_score(self, pair: str, window: str = "4H") -> float:
        """
        Pair score = base_score - quote_score.
        """
        # pair format: EURUSD
        base = pair[:3]
        quote = pair[3:]
        
        base_score = await self.redis.get(f"sentiment:{base}:{window}")
        quote_score = await self.redis.get(f"sentiment:{quote}:{window}")
        
        return float(base_score or 0.0) - float(quote_score or 0.0)

    async def run_periodic(self, interval: int = 600):
        """Background task for aggregating sentiment snapshots."""
        while True:
            try:
                await self.aggregate_all()
                print("Sentiment aggregation complete.")
            except Exception as e:
                print(f"Error in sentiment aggregator: {e}")
            await asyncio.sleep(interval)
