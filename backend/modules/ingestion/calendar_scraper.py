import asyncio
import requests
from datetime import datetime, timedelta, timezone
from typing import List, Dict, Any
from sqlalchemy.dialects.postgresql import insert as pg_insert
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import EconomicCalendarDB

class CalendarScraper:
    def __init__(self, config: Dict[str, Any]):
        self.config = config

    async def download_historical(self):
        """Production Calendar sync: Fetches real events from public API."""
        print("Starting Economic Calendar download...")
        
        # Public URL for major economic events
        url = "https://nfp.today/api/calendar" 
        
        try:
            response = requests.get(url, timeout=10)
            if response.status_code == 200:
                events = self._parse_api_response(response.json())
                if events:
                    await self._store_events(events)
                    print(f"    Successfully stored {len(events)} real calendar events.")
                    return
            
            print(f"    API fetch failed (Status {response.status_code}).")
        except Exception as e:
            print(f"    Calendar fetch failed: {e}.")

    def _parse_api_response(self, data: List[Dict]) -> List[Dict]:
        results = []
        for item in data:
            try:
                results.append({
                    "event_id": str(item.get('id')),
                    "timestamp": datetime.fromisoformat(item['date'].replace("Z", "+00:00")),
                    "currency": item.get('currency', 'USD'),
                    "event_name": item.get('event', 'Economic Event'),
                    "impact": item.get('impact', 'MEDIUM'),
                    "forecast": item.get('forecast'),
                    "previous": item.get('previous'),
                    "actual": item.get('actual')
                })
            except: continue
        return results

    async def _store_events(self, events: List[Dict]):
        async with AsyncSessionLocal() as session:
            stmt = pg_insert(EconomicCalendarDB).values(events)
            stmt = stmt.on_conflict_do_nothing(index_elements=['event_id'])
            await session.execute(stmt)
            await session.commit()
