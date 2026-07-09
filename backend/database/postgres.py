import os
import yaml
import asyncio
import logging
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession, async_sessionmaker
from sqlalchemy.orm import DeclarativeBase
from sqlalchemy import text
from dotenv import load_dotenv

logger = logging.getLogger("DB")

# Resolve absolute path to .env
env_path = os.path.join(os.path.dirname(__file__), "../config/.env")
load_dotenv(env_path)

# Load config from YAML
config_path = os.path.join(os.path.dirname(__file__), "../config/database.yaml")
with open(config_path, "r") as f:
    config = yaml.safe_load(f)["postgres"]

# Institutional Fix: Default to 127.0.0.1 for local grid stability on Windows
DATABASE_URL = os.getenv("POSTGRES_URL", "postgresql+asyncpg://postgres:12345678@127.0.0.1:5432/forexai")
# Ensure we use asyncpg driver
if DATABASE_URL.startswith("postgresql://"):
    DATABASE_URL = DATABASE_URL.replace("postgresql://", "postgresql+asyncpg://")

engine = create_async_engine(
    DATABASE_URL,
    pool_size=config.get("pool_size", 20),
    max_overflow=config.get("max_overflow", 10),
    pool_timeout=config.get("pool_timeout", 30),
    echo=False
)

AsyncSessionLocal = async_sessionmaker(
    bind=engine,
    class_=AsyncSession,
    expire_on_commit=False,
)

class Base(DeclarativeBase):
    pass

async def get_postgres_session():
    async with AsyncSessionLocal() as session:
        yield session

async def check_postgres_health():
    """
    Simplified, hardened health check to prevent race conditions.
    Uses the session maker directly to ensure proper lifecycle management.
    """
    try:
        async with AsyncSessionLocal() as session:
            # Use wait_for on the execution itself, not the connection open
            await asyncio.wait_for(session.execute(text("SELECT 1")), timeout=3.0)
            return True
    except asyncio.TimeoutError:
        logger.warning("Postgres Health Check: Timeout (3.0s)")
        return False
    except Exception as e:
        logger.warning(f"Postgres Health Check Failed: {e}")
        return False
