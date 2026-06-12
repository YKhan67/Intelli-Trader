import os
import yaml
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession, async_sessionmaker
from sqlalchemy.orm import DeclarativeBase
from dotenv import load_dotenv

load_dotenv(os.path.join(os.path.dirname(__file__), "../config/.env"))

# Load config from YAML
config_path = os.path.join(os.path.dirname(__file__), "../config/database.yaml")
with open(config_path, "r") as f:
    config = yaml.safe_load(f)["postgres"]

DATABASE_URL = os.getenv("POSTGRES_URL", "postgresql+asyncpg://user:password@localhost:5432/forexai")
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
    try:
        async with engine.connect() as conn:
            await conn.execute("SELECT 1")
        return True
    except Exception as e:
        print(f"Postgres Health Check Failed: {e}")
        return False
