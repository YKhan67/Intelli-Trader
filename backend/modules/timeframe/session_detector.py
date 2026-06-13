from datetime import datetime, timezone
import json
from backend.modules.models import Session
from backend.database.redis_client import get_redis_client

class SessionDetector:
    def __init__(self):
        self.redis = get_redis_client()
        self.cache_key = "session:current"

    async def get_current_session(self, dt: datetime = None) -> Session:
        """
        Detects current trading session from UTC timestamp.
        Priority: OVERLAP > LONDON > NEW_YORK > ASIAN.
        """
        if dt is None:
            # Try cache first
            cached = await self.redis.get(self.cache_key)
            if cached:
                return Session(cached)
            now = datetime.now(timezone.utc)
        else:
            now = dt

        hour = now.hour

        session = Session.DEAD_ZONE

        # Logic for sessions (UTC)
        # London: 08:00 - 16:00
        # New York: 13:00 - 21:00
        # Tokyo: 00:00 - 08:00
        
        is_london = 8 <= hour < 16
        is_new_york = 13 <= hour < 21
        is_asian = 0 <= hour < 8

        if is_london and is_new_york:
            session = Session.OVERLAP
        elif is_london:
            session = Session.LONDON
        elif is_new_york:
            session = Session.NEW_YORK
        elif is_asian:
            session = Session.ASIAN
        else:
            session = Session.DEAD_ZONE

        # Cache for 60 seconds
        await self.redis.set(self.cache_key, session.value, ex=60)
        
        return session
