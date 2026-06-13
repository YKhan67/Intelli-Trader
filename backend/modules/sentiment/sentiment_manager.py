import os
import yaml
from datetime import datetime, timezone
from typing import Dict, Any, List, Optional
from backend.database.redis_client import get_redis_client
from backend.database.mongo import get_mongo_db
from backend.modules.models import SentimentResult, Direction

from .article_processor import ArticleProcessor
from .aggregator import SentimentAggregator
from .calendar_filter import CalendarFilter
from .cot_analyzer import COTAnalyzer

class SentimentManager:
    def __init__(self):
        config_path = os.path.join(os.path.dirname(__file__), "../../config/sentiment.yaml")
        with open(config_path, "r") as f:
            self.config = yaml.safe_load(f)
            
        self.processor = ArticleProcessor()
        self.aggregator = SentimentAggregator(self.config)
        self.calendar = CalendarFilter(self.config)
        self.cot = COTAnalyzer(self.config)
        self.redis = get_redis_client()
        self.db = get_mongo_db()

    async def get_sentiment(self, pair: str) -> SentimentResult:
        """
        Orchestrates all sentiment signals for a pair.
        """
        now = datetime.now(timezone.utc)
        
        # 1. Aggregated News Score (4H window)
        pair_score = await self.aggregator.get_pair_score(pair, "4H")
        
        # 2. Currency breakdown
        base = pair[:3]
        quote = pair[3:]
        base_score = await self.redis.get(f"sentiment:{base}:4H") or 0.0
        quote_score = await self.redis.get(f"sentiment:{quote}:4H") or 0.0
        
        # 3. Calendar Filters
        pre_block, hard_block, post_window = await self.calendar.check_pre_trade(pair, now)
        
        # 4. COT Bias
        cot_bias = await self.cot.get_pair_bias(pair)
        
        # 5. Top Headlines (limit 3)
        top_headlines = await self._get_top_headlines(pair)
        
        # 6. Trend Detection (Compare 1H vs 4H)
        trend = await self._detect_trend(pair)
        
        return SentimentResult(
            timestamp=now,
            pair=pair,
            currency_scores={base: float(base_score), quote: float(quote_score)},
            pair_score=pair_score,
            pre_news_block=pre_block,
            hard_block=hard_block,
            post_news_window=post_window,
            cot_bias=cot_bias,
            top_headlines=top_headlines,
            sentiment_trend=trend
        )

    async def _get_top_headlines(self, pair: str) -> List[str]:
        base = pair[:3]
        quote = pair[3:]
        cursor = self.db.news_articles.find({
            "currencies_mentioned": {"$in": [base, quote]},
            "is_processed": True
        }).sort("timestamp", -1).limit(3)
        
        articles = await cursor.to_list(length=3)
        return [a["headline"] for a in articles]

    async def _detect_trend(self, pair: str) -> str:
        s1h = await self.aggregator.get_pair_score(pair, "1H")
        s4h = await self.aggregator.get_pair_score(pair, "4H")
        
        diff = s1h - s4h
        if diff > 0.1: return "IMPROVING"
        if diff < -0.1: return "DETERIORATING"
        return "STABLE"
