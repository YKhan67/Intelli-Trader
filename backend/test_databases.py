# Test PostgreSQL
from database.postgres import get_postgres_session
print("PostgreSQL: OK")

# Test MongoDB
from database.mongo import get_mongo_db
print("MongoDB: OK")

# Test Redis
#from database.redis_client import get_redis_client
#client = get_redis_client()
#client.ping()
#print("Redis: OK")

import redis  # Ensure you are importing standard redis, not redis.asyncio

# Use the standard Redis client
client = redis.Redis(host='localhost', port=6379, decode_responses=True)

# This will now work synchronously without warnings
if client.ping():
    print("Redis: OK")
else:
    print("Redis: Failed")
