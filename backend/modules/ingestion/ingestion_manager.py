import asyncio
import yaml
import os
from typing import Dict, Any
from .price_downloader import PriceDownloader
from .gdelt_downloader import GDELTDownloader
from .calendar_scraper import CalendarScraper
from .cot_downloader import COTDownloader
from .rss_poller import RSSPoller

class IngestionManager:
    def __init__(self):
        self.config_dir = os.path.join(os.path.dirname(__file__), "../../config")
        self.data_config = self._load_config("data_sources.yaml")
        self.sentiment_config = self._load_config("sentiment.yaml")
        
        self.price_dl = PriceDownloader(self.data_config["price_data"])
        self.gdelt_dl = GDELTDownloader(self.data_config["gdelt"])
        self.calendar_sc = CalendarScraper(self.data_config["economic_calendar"])
        self.cot_dl = COTDownloader(self.data_config["cot_data"])
        self.rss_poller = RSSPoller(self.sentiment_config)

    def _load_config(self, filename: str) -> Dict[str, Any]:
        with open(os.path.join(self.config_dir, filename), "r") as f:
            return yaml.safe_load(f)

    async def run_historical(self):
        print("=== STARTING HISTORICAL DATA INGESTION ===")
        # Run sequentially to avoid overwhelming sources or DB
        await self.price_dl.download_historical()
        await self.calendar_sc.download_historical()
        await self.cot_dl.download_historical()
        await self.gdelt_dl.download_historical()
        print("=== HISTORICAL DATA INGESTION COMPLETE ===")

    async def run_live(self):
        print("=== STARTING LIVE DATA INGESTION ===")
        # Live mode runs RSS poller and periodic updates
        # RSS poller runs forever
        asyncio.create_task(self.rss_poller.start_polling())
        
        # Periodic calendar refresh could be another task
        # asyncio.create_task(self.calendar_sc.refresh_live())
        
        print("Live ingestion background tasks started.")

    async def report_freshness(self):
        # Implementation to check last entries in DB
        pass
