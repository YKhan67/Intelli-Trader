import asyncio
import pandas as pd
import requests
import io
import zipfile
from datetime import datetime, timezone
from typing import List, Dict, Any
from sqlalchemy import insert, select, and_
from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import COTDataDB, DataDownloadLogDB

class COTDownloader:
    def __init__(self, config: Dict[str, Any]):
        self.config = config
        self.base_url = "https://www.cftc.gov/files/dea/history"

    async def download_historical(self):
        print("Starting COT historical download...")
        current_year = datetime.now().year
        
        async with AsyncSessionLocal() as session:
            for year in range(current_year - 5, current_year + 1):
                # Check log
                start_date = datetime(year, 1, 1, tzinfo=timezone.utc)
                end_date = datetime(year, 12, 31, 23, 59, tzinfo=timezone.utc)
                
                stmt = select(DataDownloadLogDB).where(
                    and_(
                        DataDownloadLogDB.timeframe == "COT",
                        DataDownloadLogDB.start_time <= start_date,
                        DataDownloadLogDB.end_time >= end_date,
                        DataDownloadLogDB.status == "SUCCESS"
                    )
                )
                result = await session.execute(stmt)
                if result.first():
                    print(f"  COT data for {year} already exists. Skipping.")
                    continue

                print(f"  Downloading COT data for {year}...")
                try:
                    data = await self.fetch_cot_year(year)
                    if data:
                        await self.store_cot_data(session, data)
                        log = DataDownloadLogDB(
                            timeframe="COT",
                            start_time=start_date,
                            end_time=end_date,
                            status="SUCCESS",
                            bars_count=len(data)
                        )
                        session.add(log)
                        await session.commit()
                except Exception as e:
                    print(f"Error downloading COT {year}: {e}")

    async def fetch_cot_year(self, year: int) -> List[Dict[str, Any]]:
        url = f"{self.base_url}/deafut{year}.zip"
        response = requests.get(url)
        if response.status_code != 200:
            return []

        with zipfile.ZipFile(io.BytesIO(response.content)) as z:
            with z.open(z.namelist()[0]) as f:
                # COT data columns for legacy futures
                # Marketplace, Report_Date_as_MM_DD_YYYY, NonComm_Positions_Long_All, NonComm_Positions_Short_All...
                df = pd.read_csv(f)
                
                # Filter for relevant currency pairs
                relevant_markets = [
                    "EURO CURRENCY - CHICAGO MERCANTILE EXCHANGE",
                    "BRITISH POUND STERLING - CHICAGO MERCANTILE EXCHANGE",
                    "JAPANESE YEN - CHICAGO MERCANTILE EXCHANGE",
                    "SWISS FRANC - CHICAGO MERCANTILE EXCHANGE",
                    "AUSTRALIAN DOLLAR - CHICAGO MERCANTILE EXCHANGE",
                    "NEW ZEALAND DOLLAR - CHICAGO MERCANTILE EXCHANGE",
                    "CANADIAN DOLLAR - CHICAGO MERCANTILE EXCHANGE"
                ]
                
                filtered = df[df['Market_and_Exchange_Names'].isin(relevant_markets)]
                
                results = []
                for _, row in filtered.iterrows():
                    market = row['Market_and_Exchange_Names']
                    currency = market.split(" ")[0]
                    
                    longs = int(row['NonComm_Positions_Long_All'])
                    shorts = int(row['NonComm_Positions_Short_All'])
                    net = longs - shorts
                    bias = "LONG" if net > 0 else "SHORT"
                    
                    results.append({
                        "week_ending": pd.to_datetime(row['As_of_Date_In_Form_YYMMDD'], format='%y%m%d').to_pydatetime().replace(tzinfo=timezone.utc),
                        "currency": currency,
                        "long_positions": longs,
                        "short_positions": shorts,
                        "net_position": net,
                        "institutional_bias": bias,
                        "bias_strength": abs(net) / (longs + shorts) if (longs + shorts) > 0 else 0
                    })
                return results

    async def store_cot_data(self, session, data: List[Dict[str, Any]]):
        if not data:
            return
        
        await session.execute(insert(COTDataDB), data)
        await session.commit()
