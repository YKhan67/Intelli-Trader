import os
import yaml
import asyncio
import logging
from motor.motor_asyncio import AsyncIOMotorClient
from dotenv import load_dotenv

logger = logging.getLogger("Mongo")

# Resolve absolute path to .env
env_path = os.path.join(os.path.dirname(__file__), "../config/.env")
load_dotenv(env_path)

# Load config from YAML
config_path = os.path.join(os.path.dirname(__file__), "../config/database.yaml")
with open(config_path, "r") as f:
    config = yaml.safe_load(f)["mongo"]

# Institutional Fix: Default to 127.0.0.1 for local grid stability
MONGO_URL = os.getenv("MONGODB_URL", "mongodb://127.0.0.1:27017/forexai")
client = AsyncIOMotorClient(
    MONGO_URL,
    maxPoolSize=config.get("max_pool_size", 100),
    minPoolSize=config.get("min_pool_size", 10),
    serverSelectionTimeoutMS=5000 # 5s timeout for initial connection
)

db_name = MONGO_URL.split("/")[-1] if "/" in MONGO_URL.split("//")[-1] else "forexai"
db = client[db_name]

def get_mongo_db():
    return db

async def check_mongo_health():
    """Hardened health check for MongoDB."""
    try:
        # Use asyncio.wait_for to ensure the ping doesn't hang indefinitely
        await asyncio.wait_for(client.admin.command('ping'), timeout=3.0)
        return True
    except asyncio.TimeoutError:
        logger.warning("MongoDB Health Check: Connection Timeout (3.0s)")
        return False
    except Exception as e:
        logger.warning(f"MongoDB Health Check Failed: {e}")
        return False
