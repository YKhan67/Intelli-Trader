import asyncio
from motor.motor_asyncio import AsyncIOMotorClient
import os
from dotenv import load_dotenv

load_dotenv(os.path.join(os.path.dirname(__file__), "../config/.env"))
MONGO_URL = os.getenv("MONGODB_URL", "mongodb://localhost:27017")

async def create_indexes():
    print("Creating MongoDB indexes...")
    client = AsyncIOMotorClient(MONGO_URL)
    db_name = MONGO_URL.split("/")[-1] if "/" in MONGO_URL.split("//")[-1] else "forexai"
    db = client[db_name]

    # news_articles: unique index on article_uuid, compound index on (currencies_mentioned, timestamp)
    await db.news_articles.create_index("article_uuid", unique=True)
    await db.news_articles.create_index([("currencies_mentioned", 1), ("timestamp", -1)])

    # sentiment_snapshots: unique index on (timestamp, window)
    await db.sentiment_snapshots.create_index([("timestamp", -1), ("window", 1)], unique=True)

    # central_bank_statements: index on (bank, timestamp)
    await db.central_bank_statements.create_index([("bank", 1), ("timestamp", -1)])

    # anomaly_logs: index on timestamp
    await db.anomaly_logs.create_index("timestamp")

    print("Done.")

if __name__ == "__main__":
    asyncio.run(create_indexes())
