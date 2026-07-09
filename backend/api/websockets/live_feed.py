import asyncio
import logging
import json
from typing import Dict, List, Set, Any
from fastapi import APIRouter, WebSocket, WebSocketDisconnect
from backend.database.redis_client import get_redis_client

logger = logging.getLogger("LiveFeedWS")
router = APIRouter(tags=["websockets"])

class ConnectionManager:
    def __init__(self):
        self.active_connections: List[WebSocket] = []

    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        self.active_connections.append(websocket)

    def disconnect(self, websocket: WebSocket):
        if websocket in self.active_connections:
            try:
                self.active_connections.remove(websocket)
            except: pass

    async def safe_send(self, websocket: WebSocket, data: Any):
        try:
            await websocket.send_json(data)
            return True
        except:
            return False

manager = ConnectionManager()

@router.websocket("/live/all")
async def global_signal_feed(websocket: WebSocket):
    """
    LOGICAL FIX: The Global Bridge.
    Streams ALL signals for ALL pairs through a single permanent pipe.
    """
    logger.info("Global WebSocket Request Received")
    
    try:
        await manager.connect(websocket)
    except Exception as e:
        logger.error(f"Global WebSocket Connection Rejected: {e}")
        return

    logger.info(">>> COMMUNICATION BRIDGE: ONLINE (Global Mode)")
    redis = get_redis_client()
    
    # 1. Initial State Sync
    try:
        keys = await redis.keys("signal:*:latest")
        if keys:
            for key in keys:
                # Handle bytes/string key differences
                k = key.decode() if isinstance(key, bytes) else key
                sig = await redis.get(k)
                if sig:
                    await manager.safe_send(websocket, {"type": "signal", "data": json.loads(sig)})
    except Exception as e:
        logger.warning(f"Initial state push failed: {e}")

    pubsub = None
    try:
        pubsub = redis.pubsub()
        await pubsub.psubscribe("channel:signals:*")
        
        while True:
            try:
                # Institutional 15s Heartbeat Logic
                message = await asyncio.wait_for(pubsub.get_message(ignore_subscribe_messages=True), timeout=15.0)
                
                if message and message['type'] == 'pmessage':
                    if not await manager.safe_send(websocket, {
                        "type": "signal", 
                        "data": json.loads(message['data'])
                    }):
                        break
                        
            except asyncio.TimeoutError:
                # KEEP-ALIVE: Prevent Windows/Router from dropping silent pipes
                if not await manager.safe_send(websocket, {
                    "type": "heartbeat", 
                    "status": "operational"
                }):
                    break
            except asyncio.CancelledError:
                raise
                
    except WebSocketDisconnect:
        logger.info("Client disconnected from Global Signal Bridge")
    except Exception as e:
        logger.error(f"Global Bridge error: {e}")
    finally:
        manager.disconnect(websocket)
        if pubsub:
            try:
                await pubsub.punsubscribe("channel:signals:*")
            except: pass

@router.websocket("/live/{pair}")
async def legacy_live_feed(websocket: WebSocket, pair: str):
    await websocket.accept()
    try:
        while True:
            await websocket.send_json({"type": "info", "message": "Redirecting to /live/all"})
            await asyncio.sleep(60)
    except:
        pass
