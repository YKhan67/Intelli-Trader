import os
import yaml
from motor.motor_asyncio import AsyncIOMotorClient
from dotenv import load_dotenv

load_dotenv(os.path.join(os.path.dirname(__file__), "../config/.env"))

# Load config from YAML
config_path = os.path.join(os.path.dirname(__file__), "../config/database.yaml")
with open(config_path, "r") as f:
    config = yaml.safe_load(f)["mongo"]

MONGO_URL = os.getenv("MONGODB_URL", "mongodb://localhost:27017")
client = AsyncIOMotorClient(
    MONGO_URL,
    maxPoolSize=config.get("max_pool_size", 100),
    minPoolSize=config.get("min_pool_size", 10)
)

db_name = MONGO_URL.split("/")[-1] if "/" in MONGO_URL.split("//")[-1] else "forexai"
db = client[db_name]

def get_mongo_db():
    return db

async def check_mongo_health():
    try:
        await client.admin.command('ping')
        return True
    except Exception as e:
        print(f"MongoDB Health Check Failed: {e}")
        return False
