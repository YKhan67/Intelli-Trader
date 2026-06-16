import asyncio
import logging
from typing import List
from fastapi import APIRouter, WebSocket, WebSocketDisconnect
from backend.database.redis_client import get_redis_client

logger = logging.getLogger("AlertsWS")

router = APIRouter(tags=["websockets"])

class AlertManager:
    def __init__(self):
        self.active_connections: List[WebSocket] = []

    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        self.active_connections.append(websocket)

    def disconnect(self, websocket: WebSocket):
        self.active_connections.remove(websocket)

    async def broadcast(self, message: str):
        for connection in self.active_connections:
            await connection.send_text(message)

manager = AlertManager()

@router.websocket("/alerts")
async def alerts_feed(websocket: WebSocket):
    await manager.connect(websocket)
    redis = get_redis_client()
    
    try:
        pubsub = redis.pubsub()
        await pubsub.subscribe("channel:alerts")
        
        while True:
            try:
                message = await asyncio.wait_for(pubsub.get_message(), timeout=30.0)
                if message and message['type'] == 'message':
                    await websocket.send_text(message['data'])
            except asyncio.TimeoutError:
                await websocket.send_json({"type": "ping"})
                
    except WebSocketDisconnect:
        manager.disconnect(websocket)
        logger.info("Client disconnected from alerts feed")
    except Exception as e:
        logger.error(f"Alerts WebSocket error: {e}")
        manager.disconnect(websocket)
