import asyncio
import json
import sys
import MetaTrader5 as mt5
import websockets
from datetime import datetime, timezone

async def handle_client(websocket):
    # Version-safe way to get remote address
    addr = "unknown"
    try:
        addr = websocket.remote_address
    except: pass
    
    print(f"DEBUG: Client {addr} connected.")
    
    try:
        async for message in websocket:
            request_id = "0"
            try:
                data = json.loads(message)
                action = data.get("action")
                request_id = str(data.get("id", "0"))
                
                res_data = None
                status = "success"

                if action == "PING":
                    pass
                elif action == "GET_ACCOUNT":
                    acc = mt5.account_info()
                    if acc:
                        res_data = {
                            "balance": float(acc.balance), "equity": float(acc.equity),
                            "margin": float(acc.margin), "free_margin": float(acc.margin_free),
                            "margin_level": float(acc.margin_level), "currency": str(acc.currency),
                            "leverage": float(acc.leverage), "account_number": str(acc.login),
                            "broker_name": "MetaTrader 5"
                        }
                    else:
                        status = "error"
                elif action == "GET_POSITIONS":
                    p = mt5.positions_get()
                    res_data = [{
                        "broker_ticket_id": str(x.ticket), "pair": str(x.symbol),
                        "direction": "LONG" if x.type == 0 else "SHORT",
                        "lot_size": float(x.volume), "entry_price": float(x.price_open),
                        "current_price": float(x.price_current), "stop_loss": float(x.sl),
                        "take_profit": float(x.tp),
                        "open_time": datetime.fromtimestamp(x.time, tz=timezone.utc).isoformat()
                    } for x in p] if p else []
                
                # Send response; outer try/except catches disconnections
                await websocket.send(json.dumps({
                    "id": request_id, 
                    "status": status, 
                    "data": res_data
                }))

            except Exception as e:
                print(f"DEBUG: Processing Error: {e}")
                try:
                    await websocket.send(json.dumps({"id": request_id, "status": "error"}))
                except: pass
                
    except Exception:
        # Silently handle disconnections
        pass
    finally:
        print(f"DEBUG: Client {addr} disconnected.")

async def main():
    if not mt5.initialize():
        print("CRITICAL: MetaTrader 5 Terminal NOT FOUND. Ensure MT5 is open.")
        return
    
    print(f"SUCCESS: MT5 Link Active (Terminal Build {mt5.version()[1]})")
    
    async with websockets.serve(handle_client, "0.0.0.0", 8765):
        print("WebSocket Bridge running on ws://127.0.0.1:8765")
        try:
            await asyncio.Future()
        except asyncio.CancelledError:
            pass

if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print("\nShutdown signal received. Closing MT5...")
        mt5.shutdown()
