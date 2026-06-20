import asyncio
import os
import sys
from datetime import datetime, timedelta, timezone
import random

# Path resolution
current_script_dir = os.path.dirname(os.path.abspath(__file__))
project_base = os.path.dirname(current_script_dir)
if project_base not in sys.path:
    sys.path.insert(0, project_base)

from backend.database.postgres import AsyncSessionLocal
from backend.database.models_db import COTDataDB, EconomicCalendarDB
from sqlalchemy import insert, delete

async def seed_cot():
    print("Seeding COT Data...")
    currencies = ["USD", "EUR", "GBP", "JPY", "AUD", "NZD", "CAD", "CHF"]
    now = datetime.now(timezone.utc)
    
    async with AsyncSessionLocal() as session:
        # Clear old
        await session.execute(delete(COTDataDB))
        
        records = []
        for c in currencies:
            net = random.randint(-80000, 80000)
            records.append({
                "week_ending": now,
                "currency": c,
                "long_positions": 100000 + net if net > 0 else 50000,
                "short_positions": 100000 - net if net < 0 else 50000,
                "net_position": net,
                "institutional_bias": "LONG" if net > 20000 else "SHORT" if net < -20000 else "NEUTRAL",
                "bias_strength": abs(net) / 100000.0
            })
        
        await session.execute(insert(COTDataDB), records)
        await session.commit()
    print(f"  Done. Seeded {len(records)} COT records.")

async def seed_calendar():
    print("Seeding Economic Calendar...")
    currencies = ["USD", "EUR", "GBP", "JPY", "AUD", "CAD"]
    events = ["Interest Rate Decision", "CPI m/m", "Unemployment Rate", "Retail Sales", "GDP q/q", "PMI Manufacturing"]
    impacts = ["HIGH", "MEDIUM", "LOW"]
    
    now = datetime.now(timezone.utc)
    
    async with AsyncSessionLocal() as session:
        # Clear old
        await session.execute(delete(EconomicCalendarDB))
        
        records = []
        for i in range(-5, 20): # 5 past, 20 future
            curr = random.choice(currencies)
            records.append({
                "event_id": f"demo-event-{i}",
                "timestamp": now + timedelta(hours=i * 3 + random.randint(0, 60)),
                "currency": curr,
                "event_name": f"{curr} {random.choice(events)}",
                "impact": random.choice(impacts),
                "forecast": f"{random.uniform(0, 5):.1f}%",
                "previous": f"{random.uniform(0, 5):.1f}%",
                "actual": f"{random.uniform(0, 5):.1f}%" if i < 0 else "-",
                "surprise": random.uniform(-0.5, 0.5) if i < 0 else 0.0
            })
        
        await session.execute(insert(EconomicCalendarDB), records)
        await session.commit()
    print(f"  Done. Seeded {len(records)} calendar events.")

async def main():
    print("\n" + "="*50)
    print("INTELLI-TRADER DEMO DATA SEEDER")
    print("="*50)
    await seed_cot()
    await seed_calendar()
    print("\nSUCCESS: System now has rich demo data for testing.")
    print("="*50)

if __name__ == "__main__":
    asyncio.run(main())
