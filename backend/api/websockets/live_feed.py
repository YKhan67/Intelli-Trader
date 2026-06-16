import asyncio
import logging
import json
from typing import Dict, List
from fastapi import APIRouter, WebSocket, WebSocketDisconnect
from backend.database.redis_client import get_redis_client

logger = logging.getLogger("LiveFeedWS")

router = APIRouter(tags=["websockets"])

class ConnectionManager:
    def __init__(self):
        self.active_connections: Dict[str, List[WebSocket]] = {}

    async def connect(self, websocket: WebSocket, pair: str):
        await websocket.accept()
        if pair not in self.active_connections:
            self.active_connections[pair] = []
        self.active_connections[pair].append(websocket)

    def disconnect(self, websocket: WebSocket, pair: str):
        if pair in self.active_connections:
            self.active_connections[pair].remove(websocket)

    async def broadcast(self, pair: str, message: str):
        if pair in self.active_connections:
            for connection in self.active_connections[pair]:
                await connection.send_text(message)

manager = ConnectionManager()

@router.websocket("/live/{pair}")
async def live_signal_feed(websocket: WebSocket, pair: str):
    await manager.connect(websocket, pair)
    redis = get_redis_client()
    
    # 1. Send latest signal immediately on connect
    last_sig = await redis.get(f"signal:{pair}")
    if last_sig:
        await websocket.send_text(last_sig)

    try:
        # 2. Listen for new signals via Redis Pub/Sub
        pubsub = redis.pubsub()
        await pubsub.subscribe(f"channel:signals:{pair}")
        
        while True:
            # Heartbeat check
            try:
                # Wait for message with timeout for heartbeat
                message = await asyncio.wait_for(pubsub.get_message(), timeout=30.0)
                if message and message['type'] == 'message':
                    await websocket.send_text(message['data'])
            except asyncio.TimeoutError:
                # Send ping
                await websocket.send_json({"type": "ping", "timestamp": str(asyncio.get_event_loop().time())})
                
    except WebSocketDisconnect:
        manager.disconnect(websocket, pair)
        logger.info(f"Client disconnected from live feed for {pair}")
    except Exception as e:
        logger.error(f"WebSocket error for {pair}: {e}")
        manager.disconnect(websocket, pair)
