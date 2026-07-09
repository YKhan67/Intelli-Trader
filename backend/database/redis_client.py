import os
import yaml
import redis.asyncio as aioredis
import asyncio
import json
import logging
from typing import Any
from dotenv import load_dotenv

# Path resolution for institutional loading
env_path = os.path.join(os.path.dirname(__file__), "../config/.env")
load_dotenv(env_path)

logger = logging.getLogger("RedisClient")

# Load config from YAML
config_path = os.path.join(os.path.dirname(__file__), "../config/database.yaml")
try:
    with open(config_path, "r") as f:
        config = yaml.safe_load(f).get("redis", {})
except:
    config = {"decode_responses": True}

# Institutional Fix: Use 127.0.0.1 instead of localhost
# This bypasses Windows/WSL2 IPv6 resolution conflicts that cause 'Connection Refused'
REDIS_URL = os.getenv("REDIS_URL", "redis://127.0.0.1:6379/0")

# Initialize client with institutional retry logic
redis_client = aioredis.from_url(
    REDIS_URL,
    decode_responses=config.get("decode_responses", True),
    socket_timeout=5.0,
    socket_connect_timeout=5.0,
    retry_on_timeout=True,
    health_check_interval=30
)

def get_redis_client():
    return redis_client

async def set_value(key: str, value: Any, expire: int = None):
    try:
        val = json.dumps(value) if not isinstance(value, (str, int, float)) else value
        await redis_client.set(key, val, ex=expire)
    except Exception as e:
        logger.error(f"Redis SET error for {key}: {e}")

async def get_value(key: str):
    try:
        val = await redis_client.get(key)
        if val:
            try:
                return json.loads(val)
            except:
                return val
        return None
    except Exception as e:
        logger.error(f"Redis GET error for {key}: {e}")
        return None

async def delete_value(key: str):
    try:
        await redis_client.delete(key)
    except Exception as e:
        logger.error(f"Redis DELETE error for {key}: {e}")

async def check_redis_health():
    """
    Verifies connection to the Redis Cluster (WSL).
    """
    try:
        # Use a short timeout for the health check to avoid blocking the API
        await asyncio.wait_for(redis_client.ping(), timeout=2.0)
        return True
    except Exception as e:
        logger.warning(f"Redis Cluster Unreachable (127.0.0.1:6379): {e}")
        return False
