import asyncio
import feedparser
import hashlib
import time
from datetime import datetime, timezone
from typing import List, Dict, Any
from backend.database.mongo import get_mongo_db

class RSSPoller:
    def __init__(self, config: Dict[str, Any]):
        self.config = config
        self.db = get_mongo_db()
        self.feeds = config["rss_feeds"]
        self.interval = config["polling_interval_minutes"] * 60
        self.seen_hashes = set()

    async def start_polling(self):
        print(f"Starting RSS poller with {len(self.feeds)} feeds (Infinite Loop)...")
        while True:
            await self.poll_once()
            await asyncio.sleep(self.interval)

    async def poll_once(self):
        """Runs a single poll across all feeds."""
        print(f"  Polling {len(self.feeds)} news feeds...")
        tasks = [self.poll_feed(feed) for feed in self.feeds]
        await asyncio.gather(*tasks)
        print("  News polling complete.")

    async def poll_feed(self, feed_config: Dict[str, Any]):
        name = feed_config["name"]
        url = feed_config["url"]
        
        try:
            print(f"  Polling feed: {name}")
            # Run feedparser in thread to avoid blocking event loop
            feed = await asyncio.to_thread(feedparser.parse, url)
            
            new_articles = []
            for entry in feed.entries:
                content = entry.get("summary", entry.get("description", ""))
                headline = entry.title
                h = hashlib.md5(headline.encode()).hexdigest()
                
                if h not in self.seen_hashes:
                    # Check DB to be sure
                    exists = await self.db.news_articles.find_one({"article_uuid": h})
                    if not exists:
                        article = {
                            "article_uuid": h,
                            "timestamp": datetime.now(timezone.utc), # Ideally parse from entry
                            "received_at": datetime.now(timezone.utc),
                            "source": name,
                            "headline": headline,
                            "body": content,
                            "currencies_mentioned": self.extract_currencies(headline + " " + content),
                            "sentiment_score": 0.0,
                            "is_processed": False
                        }
                        new_articles.append(article)
                    self.seen_hashes.add(h)

            if new_articles:
                await self.db.news_articles.insert_many(new_articles)
                print(f"    Inserted {len(new_articles)} new articles from {name}.")
                
        except Exception as e:
            print(f"Error polling RSS feed {name}: {e}")

    def extract_currencies(self, text: str) -> List[str]:
        currencies = ["USD", "EUR", "GBP", "JPY", "CHF", "AUD", "NZD", "CAD"]
        found = []
        for c in currencies:
            if c in text.upper():
                found.append(c)
        return found
