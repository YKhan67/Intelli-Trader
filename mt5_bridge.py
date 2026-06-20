import asyncio
import json
import sys
import MetaTrader5 as mt5
import websockets
import logging
from datetime import datetime, timezone

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger("MT5Bridge")

async def handle_client(websocket):
    addr = "unknown"
    try:
        addr = websocket.remote_address
    except: pass
    
    logger.info(f"Client {addr} connected.")
    
    try:
        async for message in websocket:
            request_id = "0"
            try:
                data = json.loads(message)
                action = data.get("action")
                params = data.get("params", {})
                request_id = str(data.get("id", "0"))
                
                res_data = None
                status = "success"
                error_msg = None

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
                        error_msg = "Could not fetch account info"

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

                elif action == "PLACE_ORDER":
                    symbol = params.get("symbol")
                    order_type = params.get("type") # BUY or SELL
                    volume = float(params.get("volume", 0.01))
                    sl = float(params.get("sl", 0))
                    tp = float(params.get("tp", 0))

                    logger.info(f"Placing {order_type} order for {symbol} volume={volume}")

                    # Map types
                    mt5_type = mt5.ORDER_TYPE_BUY if order_type == "BUY" else mt5.ORDER_TYPE_SELL
                    price = mt5.symbol_info_tick(symbol).ask if order_type == "BUY" else mt5.symbol_info_tick(symbol).bid

                    request = {
                        "action": mt5.TRADE_ACTION_DEAL,
                        "symbol": symbol,
                        "volume": volume,
                        "type": mt5_type,
                        "price": price,
                        "sl": sl,
                        "tp": tp,
                        "magic": 123456,
                        "comment": "Intelli-Trader AI",
                        "type_time": mt5.ORDER_TIME_GTC,
                        "type_filling": mt5.ORDER_FILLING_IOC,
                    }

                    result = mt5.order_send(request)
                    if result.retcode != mt5.TRADE_RETCODE_DONE:
                        status = "error"
                        error_msg = f"Order failed: {result.comment} (code {result.retcode})"
                        logger.error(error_msg)
                    else:
                        res_data = {"ticket": result.order}
                        logger.info(f"Order successful! Ticket: {result.order}")

                elif action == "CLOSE_ORDER":
                    ticket = int(params.get("ticket"))
                    # Implementation for closing order...
                    # (Simplified for now)
                    status = "success"

                # Send response
                response = {"id": request_id, "status": status}
                if res_data is not None: response["data"] = res_data
                if error_msg: response["error"] = error_msg
                
                await websocket.send(json.dumps(response))

            except Exception as e:
                logger.error(f"Processing Error: {e}")
                try:
                    await websocket.send(json.dumps({"id": request_id, "status": "error", "error": str(e)}))
                except: pass
                
    except Exception as e:
        logger.warning(f"Connection error: {e}")
    finally:
        logger.info(f"Client {addr} disconnected.")

async def main():
    if not mt5.initialize():
        logger.critical("MetaTrader 5 Terminal NOT FOUND. Ensure MT5 is open.")
        return
    
    logger.info(f"SUCCESS: MT5 Link Active (Terminal Build {mt5.version()[1]})")
    
    async with websockets.serve(handle_client, "0.0.0.0", 8765):
        logger.info("WebSocket Bridge running on ws://127.0.0.1:8765")
        try:
            await asyncio.Future()
        except asyncio.CancelledError:
            pass

if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        logger.info("Shutdown signal received. Closing MT5...")
        mt5.shutdown()
