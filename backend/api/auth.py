import os
import time
import yaml
from fastapi import Request, HTTPException, Security, Depends
from fastapi.security.api_key import APIKeyHeader
from backend.database.redis_client import get_redis_client

# Config
config_path = os.path.join(os.path.dirname(__file__), "../config/api.yaml")
with open(config_path, "r") as f:
    api_config = yaml.safe_load(f)["api"]

API_KEY_NAME = "X-API-Key"
API_KEY = os.getenv(api_config["auth"]["api_key_env_var"], "dev_key")

if API_KEY == "dev_key":
    import logging
    logging.getLogger("auth").warning("Using default 'dev_key' for API authentication. Set FOREXAI_API_KEY in .env for production.")

api_key_header = APIKeyHeader(name=API_KEY_NAME, auto_error=False)

async def get_api_key(api_key_header: str = Security(api_key_header)):
    if api_key_header == API_KEY:
        return api_key_header
    raise HTTPException(status_code=401, detail="Invalid or missing API Key")

async def rate_limiter(request: Request):
    client_ip = request.client.host
    redis = get_redis_client()
    
    minute = int(time.time() / 60)
    key = f"rate_limit:{client_ip}:{minute}"
    
    count = await redis.incr(key)
    if count == 1:
        await redis.expire(key, 60)
        
    limit = api_config["rate_limit"]["requests_per_minute"]
    if count > limit:
        raise HTTPException(status_code=429, detail="Rate limit exceeded")
