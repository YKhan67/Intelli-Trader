import asyncio
import json
from backend.database.redis_client import get_redis_client

async def check():
    redis = get_redis_client()
    raw = await redis.get("system:settings")
    print(f"RAW SETTINGS IN REDIS: {raw}")
    if raw:
        try:
            data = json.loads(raw)
            print(f"DECODED ACTIVE PAIRS: {data.get('active_pairs')}")
        except:
            print("FAILED TO DECODE")

if __name__ == "__main__":
    asyncio.run(check())
