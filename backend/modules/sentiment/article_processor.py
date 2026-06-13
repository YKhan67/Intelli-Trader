import asyncio
import yaml
import os
from typing import List, Dict, Any
from backend.database.mongo import get_mongo_db
from .finbert_scorer import FinBERTScorer
from .vader_scorer import VaderScorer

class ArticleProcessor:
    def __init__(self):
        config_path = os.path.join(os.path.dirname(__file__), "../../config/sentiment.yaml")
        with open(config_path, "r") as f:
            self.config = yaml.safe_load(f)
            
        model_path = os.path.join(os.path.dirname(__file__), "../../", self.config.get("model_path", "models/finbert"))
        self.finbert = FinBERTScorer(model_path)
        self.vader = VaderScorer()
        self.db = get_mongo_db()
        
        self.thresholds = self.config.get("thresholds", {})
        self.currencies = ["USD", "EUR", "GBP", "JPY", "CHF", "AUD", "NZD", "CAD"]

    async def process_unscored_articles(self, limit: int = 100):
        """
        Fetches and processes articles with is_processed=False.
        """
        cursor = self.db.news_articles.find({"is_processed": False}).limit(limit)
        articles = await cursor.to_list(length=limit)
        
        if not articles:
            return 0

        # Process in batch for FinBERT
        headlines = [a.get("headline", "") + " " + a.get("body", "")[:200] for a in articles]
        finbert_results = self.finbert.score(headlines)
        
        for i, article in enumerate(articles):
            full_text = article.get("headline", "") + " " + article.get("body", "")
            
            # VADER score
            vader_score = self.vader.score(full_text)
            
            # Weighted Final Score
            f_res = finbert_results[i]
            fb_weight = self.thresholds.get("finbert_weight", 0.7)
            vd_weight = self.thresholds.get("vader_weight", 0.3)
            
            final_score = (f_res["score"] * fb_weight) + (vader_score * vd_weight)
            
            # Identify currencies mentioned
            mentions = self.extract_currencies(full_text)
            
            # Update in DB
            await self.db.news_articles.update_one(
                {"_id": article["_id"]},
                {
                    "$set": {
                        "sentiment_score": final_score,
                        "finbert_data": f_res,
                        "vader_score": vader_score,
                        "currencies_mentioned": mentions,
                        "is_processed": True
                    }
                }
            )
            
        return len(articles)

    def extract_currencies(self, text: str) -> List[str]:
        found = []
        for c in self.currencies:
            if c in text.upper():
                found.append(c)
        return found

    async def run_continuous(self, interval: int = 60):
        """Background task for processing news articles."""
        print("Starting continuous article processing...")
        while True:
            try:
                count = await self.process_unscored_articles()
                if count > 0:
                    print(f"Processed {count} new articles.")
            except Exception as e:
                print(f"Error in article processor: {e}")
            await asyncio.sleep(interval)
