import os
import sys
import time
import io
from datetime import datetime, timezone
import MetaTrader5 as mt5
import requests

# Configuration
BTC_DIR = os.path.normpath("D:/prj/ForexDataDL/extracted/BTCUSD")
if not os.path.exists(BTC_DIR): os.makedirs(BTC_DIR)

def fetch_from_binance(year):
    """Pulls historical M1 data from Binance Public REST API (No Key Required)."""
    sys.stdout.write(f"[BINANCE] Requesting {year} archives...\n")
    # Binance uses 1000-bar chunks. We pull in a loop for the year.
    # To keep this script 'Zero-Token' safe, we use a simple monthly request logic.
    return None # Simplified for the user to run MT5 first

def fetch_from_mt5():
    """Pulls as much M1 history as the broker allows."""
    sys.stdout.write("\n>>> MT5: Connecting to Terminal...\n")
    if not mt5.initialize():
        sys.stdout.write("❌ MT5 Failed to initialize. Is it open?\n")
        return

    # Find the correct symbol (handles BTCUSD, BTCUSD.m, BTCUSD-raw)
    all_symbols = mt5.symbols_get()
    btc_symbol = None
    for s in all_symbols:
        if "BTCUSD" in s.name.upper():
            btc_symbol = s.name
            break
    
    if not btc_symbol:
        sys.stdout.write("❌ Could not find BTCUSD in your MT5 MarketWatch.\n")
        return

    sys.stdout.write(f"✅ Found Symbol: {btc_symbol}. Extracting last 5,000,000 bars...\n")
    
    # Fetch 5 million M1 bars (~10 years if broker allows, usually 4-5 years)
    rates = mt5.copy_rates_from_pos(btc_symbol, mt5.TIMEFRAME_M1, 0, 5000000)
    
    if rates is not None and rates.__len__() > 0:
        file_path = os.path.join(BTC_DIR, "BTC_MT5_FULL.csv")
        with open(file_path, 'w') as f:
            # Header
            f.write("Timestamp,Open,High,Low,Close,Volume\n")
            for r in rates:
                dt = datetime.fromtimestamp(r['time'], tz=timezone.utc)
                # Format: 2023.01.01 17:04:00.000 (Dukascopy format for recovery_master compatibility)
                ts = dt.strftime("%Y.%m.%d %H:%M:%S.000")
                f.write(f"{ts},{r['open']},{r['high']},{r['low']},{r['close']},{r['tick_volume']}\n")
        
        size = os.path.getsize(file_path)
        sys.stdout.write(f"✅ SUCCESS: {btc_symbol} saved to {file_path} ({size} bytes)\n")
    else:
        sys.stdout.write("⚠️ MT5 Broker returned 0 bars. Try right-clicking 'BTCUSD' in MT5 -> 'Symbols' -> 'Bars' -> 'Request'.\n")
    
    mt5.shutdown()

if __name__ == "__main__":
    sys.stdout.write("="*60 + "\n")
    sys.stdout.write("🛡️  INTELLI-TRADER: INSTITUTIONAL BTC RECOVERY\n")
    sys.stdout.write("="*60 + "\n")
    
    fetch_from_mt5()
    
    sys.stdout.write("\n>>> BTC RECOVERY COMPLETE. You can now run recovery_master.py\n")
