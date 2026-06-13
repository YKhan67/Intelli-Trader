import os
import sys
import asyncio

# Add the project root to path
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
if project_root not in sys.path:
    sys.path.append(project_root)

from backend.database.mongo import get_mongo_db

async def check():
    print("Connecting to MongoDB...")
    db = get_mongo_db()
    count = await db.news_articles.count_documents({})
    print(f"Total News Articles in MongoDB: {count}")
    
    # Show a few sample headlines if data exists
    if count > 0:
        print("\nLatest Headlines:")
        cursor = db.news_articles.find().sort("timestamp", -1).limit(3)
        async for doc in cursor:
            print(f"- [{doc.get('timestamp').strftime('%Y-%m-%d')}] {doc.get('headline')}")

if __name__ == "__main__":
    asyncio.run(check())
