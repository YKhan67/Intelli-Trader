import asyncio
import pandas as pd
import requests
import logging
from datetime import datetime, timezone, timedelta
from typing import List, Dict, Any
from sqlalchemy import select, func
from sqlalchemy.dialects.postgresql import insert as pg_insert
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import COTDataDB

logger = logging.getLogger("COTDownloader")

class COTDownloader:
    def __init__(self, config: Dict[str, Any]):
        self.config = config
        self.dataset_id = "6dca-aqww"
        self.base_url = f"https://publicreporting.cftc.gov/resource/{self.dataset_id}.json"
        
        # Mapping of CFTC names to our symbols
        self.mapping = {
            "EURO FX": "EUR",
            "BRITISH POUND STERLING": "GBP",
            "JAPANESE YEN": "JPY",
            "SWISS FRANC": "CHF",
            "AUSTRALIAN DOLLAR": "AUD",
            "NEW ZEALAND DOLLAR": "NZD",
            "CANADIAN DOLLAR": "CAD",
            "BITCOIN": "BTC",
            "GOLD": "XAU"
        }

    async def _get_latest_report_date(self) -> datetime:
        """Finds the most recent COT report date in our database."""
        async with AsyncSessionLocal() as session:
            stmt = select(func.max(COTDataDB.week_ending))
            result = await session.execute(stmt)
            latest = result.scalar()
            return latest if latest else datetime(1986, 1, 1, tzinfo=timezone.utc)

    async def download_historical(self):
        print("Starting Robust COT (Institutional Bias) Sync...")
        
        latest_date = await self._get_latest_report_date()
        print(f"  Latest record in DB: {latest_date.strftime('%Y-%m-%d')}")

        all_processed_data = []
        
        for cftc_name, symbol in self.mapping.items():
            print(f"  Syncing {symbol} ({cftc_name})...")
            
            # Socrata SOQL: Date comparison with raw ISO string works best.
            # Fixed the operator error: removed complex LIKE in favor of strict search
            where_str = f"report_date_as_yyyy_mm_dd > '{latest_date.strftime('%Y-%m-%dT%H:%M:%S')}'"
            
            params = {
                "$select": "market_and_exchange_names,report_date_as_yyyy_mm_dd,noncomm_positions_long_all,noncomm_positions_short_all",
                "$where": where_str,
                "$q": cftc_name, # Use global search instead of LIKE to avoid type errors
                "$limit": 500
            }

            try:
                response = requests.get(self.base_url, params=params, timeout=30)
                if response.status_code == 200:
                    batch_data = response.json()
                    if batch_data:
                        processed = self._process_api_data(batch_data, symbol, cftc_name)
                        all_processed_data.extend(processed)
                        print(f"    Found {len(processed)} relevant records.")
                else:
                    print(f"    API Error {response.status_code} for {symbol}")
            except Exception as e:
                print(f"    Error during COT sync for {symbol}: {e}")

        if all_processed_data:
            await self._store_cot_data(all_processed_data)
            print(f"    Successfully synced {len(all_processed_data)} new COT records.")
        else:
            print("    No new records found. System is up to date.")

    def _process_api_data(self, data: List[Dict], currency: str, match_key: str) -> List[Dict]:
        results = []
        for item in data:
            # Verify the record is actually the one we want (since $q is a broad search)
            market_name = item.get('market_and_exchange_names', '').upper()
            if match_key not in market_name:
                continue

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
