import os
import sys
import zipfile
import io
import pandas as pd
import asyncio
from datetime import datetime, timezone
import argparse
from sqlalchemy import select, and_, func, insert

# Add project root to path
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), "../.."))
if project_root not in sys.path:
    sys.path.append(project_root)

from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import CurrencyPairDB, OHLCVBarDB

async def get_pair_id(symbol):
    async with AsyncSessionLocal() as session:
        stmt = select(CurrencyPairDB.id).where(CurrencyPairDB.symbol == symbol)
        result = await session.execute(stmt)
        return result.scalar()

def parse_csv(file_content, filename):
    """
    Tries to parse the CSV with different settings common in Forex data.
    """
    # Try semicolon first (HistData style)
    try:
        df = pd.read_csv(io.BytesIO(file_content), sep=';', header=None, 
                         names=['timestamp', 'open', 'high', 'low', 'close', 'volume'])
        if len(df.columns) == 6 and isinstance(df.iloc[0, 1], (int, float)):
            print(f"  Detected HistData format (semicolon) in {filename}")
            return df
    except:
        pass

    # Try comma (Standard)
    try:
        df = pd.read_csv(io.BytesIO(file_content))
        # Normalize headers
        df.columns = [c.lower().strip() for c in df.columns]
        if 'timestamp' in df.columns or 'date' in df.columns:
            if 'date' in df.columns and 'timestamp' not in df.columns:
                df.rename(columns={'date': 'timestamp'}, inplace=True)
            print(f"  Detected standard CSV format in {filename}")
            return df
    except:
        pass

    return None

async def import_file(file_path, symbol, timeframe):
    pair_id = await get_pair_id(symbol)
    if not pair_id:
        print(f"ERROR: Symbol {symbol} not found in database. Run seed.py first.")
        return

    print(f"Importing {file_path} for {symbol} {timeframe}...")
    
    dataframes = []
    
    if file_path.endswith('.zip'):
        with zipfile.ZipFile(file_path, 'r') as z:
            for filename in z.namelist():
                if filename.endswith('.csv') or filename.endswith('.txt'):
                    with z.open(filename) as f:
                        df = parse_csv(f.read(), filename)
                        if df is not None:
                            dataframes.append(df)
    else:
        with open(file_path, 'rb') as f:
            df = parse_csv(f.read(), os.path.basename(file_path))
            if df is not None:
                dataframes.append(df)

    if not dataframes:
        print("ERROR: Could not parse any valid data from the file.")
        return

    full_df = pd.concat(dataframes)
    
    # Standardize timestamp
    try:
        sample_ts = str(full_df['timestamp'].iloc[0])
        if len(sample_ts) == 15 and ' ' in sample_ts: # 20220101 000000
            full_df['timestamp'] = pd.to_datetime(full_df['timestamp'], format='%Y%m%d %H%M%S')
        else:
            full_df['timestamp'] = pd.to_datetime(full_df['timestamp'])
    except Exception as e:
        print(f"ERROR parsing timestamps: {e}")
        return

    full_df['timestamp'] = full_df['timestamp'].dt.tz_localize('UTC') if full_df['timestamp'].dt.tz is None else full_df['timestamp'].dt.tz_convert('UTC')
    
    # Sort and drop duplicates in the file itself
    full_df.sort_values('timestamp', inplace=True)
    full_df.drop_duplicates('timestamp', inplace=True)

    # --- Verification Check ---
    start_ts = full_df['timestamp'].iloc[0]
    end_ts = full_df['timestamp'].iloc[-1]
    
    async with AsyncSessionLocal() as session:
        stmt = select(func.count(OHLCVBarDB.id)).where(
            and_(
                OHLCVBarDB.pair_id == pair_id,
                OHLCVBarDB.timeframe == timeframe,
                OHLCVBarDB.timestamp >= start_ts,
                OHLCVBarDB.timestamp <= end_ts
            )
        )
        result = await session.execute(stmt)
        existing_count = result.scalar()
        
        if existing_count > 0:
            print(f"ERROR: Found {existing_count} existing bars in database for this range ({start_ts.date()} to {end_ts.date()}).")
            print("Import aborted to prevent duplicates.")
            return

    records = []
    for _, row in full_df.iterrows():
        records.append({
            "pair_id": pair_id,
            "timeframe": timeframe,
            "timestamp": row['timestamp'].to_pydatetime(),
            "open": float(row['open']),
            "high": float(row['high']),
            "low": float(row['low']),
            "close": float(row['close']),
            "volume": float(row['volume']) if 'volume' in row else 0.0,
            "spread_pips": 0.0
        })

    print(f"  Preparing to insert {len(records)} bars...")

    async with AsyncSessionLocal() as session:
        chunk_size = 5000
        for i in range(0, len(records), chunk_size):
            chunk = records[i:i + chunk_size]
            try:
                # Use standard insert to avoid compilation errors (rvf5)
                await session.execute(insert(OHLCVBarDB), chunk)
                print(f"    Inserted chunk {i//chunk_size + 1} ({len(chunk)} rows)...")
            except Exception as e:
                print(f"    Error in chunk {i//chunk_size + 1}: {e}")
                await session.rollback()
                return
        
        await session.commit()
    
    print(f"SUCCESS: Imported data for {symbol}.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Import historical Forex data from ZIP or CSV.')
    parser.add_argument('--file', type=str, required=True, help='Path to .zip or .csv file')
    parser.add_argument('--pair', type=str, required=True, help='Currency pair (e.g. EURUSD)')
    parser.add_argument('--tf', type=str, default='M1', help='Timeframe (default M1)')

    args = parser.parse_args()
    
    if not os.path.exists(args.file):
        print(f"ERROR: File not found: {args.file}")
        sys.exit(1)

    asyncio.run(import_file(args.file, args.pair, args.tf))
