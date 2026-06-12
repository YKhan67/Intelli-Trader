import asyncio
import pandas as pd
import requests
import io
import gzip
from datetime import datetime, timedelta, timezone
from typing import List, Dict, Any
from backend.database.mongo import get_mongo_db

class GDELTDownloader:
    def __init__(self, config: Dict[str, Any]):
        self.config = config
        self.db = get_mongo_db()
        self.keywords = config["keywords"]
        self.batch_size = config["batch_size_days"]
        self.base_url = "http://data.gdeltproject.org/gdeltv2"

    async def download_historical(self):
        print("Starting GDELT historical download...")
        end_date = datetime.now(timezone.utc)
        start_date = end_date - timedelta(days=365 * self.config["years_history"])
        
        current_start = start_date
        while current_start < end_date:
            current_end = min(current_start + timedelta(days=self.batch_size), end_date)
            print(f"  Processing GDELT batch: {current_start.date()} to {current_end.date()}")
            
            try:
                await self.process_batch(current_start, current_end)
            except Exception as e:
                print(f"Error processing GDELT batch {current_start.date()}: {e}")
            
            current_start = current_end

    async def process_batch(self, start: datetime, end: datetime):
        # GDELT 2.0 files are every 15 minutes.
        # Format: YYYYMMDDHHMMSS.gkg.csv.gz
        # For historical, we might want to just sample or use the master file list.
        # This is a complex task. For the scaffold, we'll implement the logic 
        # to fetch the master file list and filter for the range.
        
        # 1. Fetch master file list (optional: cache it)
        # url = "http://data.gdeltproject.org/gdeltv2/masterfilelist.txt"
        
        # Since full GDELT download is massive, we will simulate the ingestion 
        # of filtered records for the keywords.
        
        articles = []
        # Mock logic for finding and downloading files...
        # In a real implementation, we'd loop through 15-min intervals.
        
        # Example of storing one dummy article if keywords found
        import uuid
        dummy_article = {
            "article_uuid": str(uuid.uuid4()),
            "timestamp": start,
            "received_at": datetime.now(timezone.utc),
            "source": "GDELT",
            "headline": "Fed signals potential rate hike",
            "body": "The Federal Reserve discussed inflation concerns...",
            "currencies_mentioned": ["USD"],
            "sentiment_score": 0.0,
            "is_processed": False
        }
        articles.append(dummy_article)

        if articles:
            await self.db.news_articles.insert_many(articles)
            print(f"    Inserted {len(articles)} articles into MongoDB.")

    async def live_poll(self):
        # Similar logic but for the last 15 minutes
        pass
