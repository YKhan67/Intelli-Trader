import os
import yaml
import redis.asyncio as aioredis
import json
from typing import Any
from dotenv import load_dotenv

load_dotenv(os.path.join(os.path.dirname(__file__), "../config/.env"))

# Load config from YAML
config_path = os.path.join(os.path.dirname(__file__), "../config/database.yaml")
with open(config_path, "r") as f:
    config = yaml.safe_load(f)["redis"]

REDIS_URL = os.getenv("REDIS_URL", "redis://localhost:6379/0")

redis_client = aioredis.from_url(
    REDIS_URL,
    decode_responses=config.get("decode_responses", True)
)

def get_redis_client():
    return redis_client

async def set_value(key: str, value: Any, expire: int = None):
    val = json.dumps(value) if not isinstance(value, (str, int, float)) else value
    await redis_client.set(key, val, ex=expire)

async def get_value(key: str):
    val = await redis_client.get(key)
    if val:
        try:
            return json.loads(val)
        except:
            return val
    return None

async def delete_value(key: str):
    await redis_client.delete(key)

async def check_redis_health():
    try:
        await redis_client.ping()
        return True
    except Exception as e:
        print(f"Redis Health Check Failed: {e}")
        return False
