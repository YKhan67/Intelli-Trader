import asyncio
import pandas as pd
import requests
from datetime import datetime, timezone, timedelta
from typing import List, Dict, Any
from sqlalchemy import select, func
from sqlalchemy.dialects.postgresql import insert as pg_insert
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import COTDataDB

class COTDownloader:
    def __init__(self, config: Dict[str, Any]):
        self.config = config
        self.dataset_id = "6dca-aqww"
        self.base_url = f"https://publicreporting.cftc.gov/resource/{self.dataset_id}.json"
        
        # Mapping of CFTC names to our symbols
        self.mapping = {
            "EURO FX - CHICAGO MERCANTILE EXCHANGE": "EUR",
            "BRITISH POUND - CHICAGO MERCANTILE EXCHANGE": "GBP",
            "JAPANESE YEN - CHICAGO MERCANTILE EXCHANGE": "JPY",
            "SWISS FRANC - CHICAGO MERCANTILE EXCHANGE": "CHF",
            "AUSTRALIAN DOLLAR - CHICAGO MERCANTILE EXCHANGE": "AUD",
            "NZ DOLLAR - CHICAGO MERCANTILE EXCHANGE": "NZD",
            "CANADIAN DOLLAR - CHICAGO MERCANTILE EXCHANGE": "CAD"
        }

    async def _get_latest_report_date(self) -> datetime:
        """Finds the most recent COT report date in our database."""
        async with AsyncSessionLocal() as session:
            stmt = select(func.max(COTDataDB.week_ending))
            result = await session.execute(stmt)
            latest = result.scalar()
            return latest if latest else datetime(1986, 1, 1, tzinfo=timezone.utc)

    async def download_historical(self):
        print("Starting Optimized COT (Institutional Bias) Sync...")
        
        latest_date = await self._get_latest_report_date()
        print(f"  Latest record in DB: {latest_date.strftime('%Y-%m-%d')}")

        # Optimization 1: Select only required columns (saves 90% bandwidth)
        columns = [
            "market_and_exchange_names",
            "report_date_as_yyyy_mm_dd",
            "noncomm_positions_long_all",
            "noncomm_positions_short_all"
        ]
        select_str = ",".join(columns)

        # Optimization 2: Filter by Markets AND Date (Incremental sync)
        market_list = "'" + "','".join(self.mapping.keys()) + "'"
        where_str = f"market_and_exchange_names IN ({market_list})"
        if latest_date:
            # Socrata date format for $where
            where_str += f" AND report_date_as_yyyy_mm_dd > '{latest_date.isoformat()}'"

        all_processed_data = []
        limit = 1000
        offset = 0

        # Optimization 3: Pagination (handles any amount of data)
        while True:
            params = {
                "$select": select_str,
                "$where": where_str,
                "$limit": limit,
                "$offset": offset,
                "$order": "report_date_as_yyyy_mm_dd ASC"
            }

            try:
                print(f"  Fetching batch (Offset: {offset})...")
                response = requests.get(self.base_url, params=params, timeout=30)
                if response.status_code == 200:
                    batch_data = response.json()
                    if not batch_data:
                        break # No more data
                    
                    processed = self._process_api_data(batch_data)
                    all_processed_data.extend(processed)
                    
                    if len(batch_data) < limit:
                        break # Last page
                    offset += limit
                else:
                    print(f"    API fetch failed (Status {response.status_code}).")
                    break
            except Exception as e:
                print(f"    Error during API sync: {e}.")
                break

        if all_processed_data:
            await self._store_cot_data(all_processed_data)
            print(f"    Successfully synced {len(all_processed_data)} new COT records.")
        else:
            print("    No new records found. System is up to date.")

    def _process_api_data(self, data: List[Dict]) -> List[Dict]:
        results = []
        for item in data:
            market = item.get('market_and_exchange_names')
            currency = self.mapping.get(market)
            
            try:
                dt_str = item.get('report_date_as_yyyy_mm_dd')
                dt = datetime.fromisoformat(dt_str.replace("Z", "+00:00"))
                
                longs = int(item.get('noncomm_positions_long_all', 0))
                shorts = int(item.get('noncomm_positions_short_all', 0))
                net = longs - shorts
                
                results.append({
                    "week_ending": dt,
                    "currency": currency,
                    "long_positions": longs,
                    "short_positions": shorts,
                    "net_position": net,
                    "institutional_bias": "LONG" if net > 0 else "SHORT",
                    "bias_strength": abs(net) / (longs + shorts) if (longs + shorts) > 0 else 0
                })
            except:
                continue
        return results

    async def _store_cot_data(self, data: List[Dict[str, Any]]):
        if not data: return
        async with AsyncSessionLocal() as session:
            chunk_size = 100
            for i in range(0, len(data), chunk_size):
                chunk = data[i : i + chunk_size]
                stmt = pg_insert(COTDataDB).values(chunk)
                stmt = stmt.on_conflict_do_nothing(index_elements=['week_ending', 'currency'])
                await session.execute(stmt)
            await session.commit()
