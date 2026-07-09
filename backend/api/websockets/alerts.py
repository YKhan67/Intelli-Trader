import asyncio
import logging
import json
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
        try:
            self.active_connections.remove(websocket)
        except: pass

    async def safe_send(self, websocket: WebSocket, message: str):
        try:
            await websocket.send_text(message)
            return True
        except:
            return False

manager = AlertManager()

@router.websocket("/alerts")
async def alerts_feed(websocket: WebSocket):
    origin = websocket.headers.get("origin")
    logger.info(f"Alerts WebSocket Request | Origin: {origin}")
    
    try:
        await manager.connect(websocket)
    except Exception as e:
        logger.error(f"Alerts WebSocket Rejected: {e}")
        return

    logger.info("Accepted alerts feed connection")
    redis = get_redis_client()
    
    pubsub = None
    try:
        pubsub = redis.pubsub()
        await pubsub.subscribe("channel:alerts")
        
        while True:
            try:
                message = await asyncio.wait_for(pubsub.get_message(ignore_subscribe_messages=True), timeout=45.0)
                if message and message['type'] == 'message':
                    if not await manager.safe_send(websocket, message['data']):
                        break
            except asyncio.TimeoutError:
                if not await manager.safe_send(websocket, json.dumps({"type": "ping", "status": "active"})):
                    break
            except asyncio.CancelledError:
                raise
                
    except WebSocketDisconnect:
        logger.info("Client disconnected from alerts feed")
    except asyncio.CancelledError:
        pass
    except Exception as e:
        logger.error(f"Alerts WebSocket unexpected error: {e}")
    finally:
        manager.disconnect(websocket)
        if pubsub:
            try:
                await pubsub.unsubscribe("channel:alerts")
            except: pass
